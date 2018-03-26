 CREATE FUNCTION questionnaire.[getPrefillAnswer]
(
	@bvd_id varchar(25)
	, @question_id int
)
RETURNS @returntable TABLE
(
	id_answer INT NULL
	, text_answer nvarchar(max) null
	, reference nvarchar(1000) null
	, answer_metadata nvarchar(500) null
	, answer_status smallint null -- -1: couldn't find data for company/question, 0: successfully retrieved, 1: error
)
AS
BEGIN
	declare @score_name nvarchar(50)
	set @score_name = (select [score_name] from [questionnaire].[question] where id=@question_id)

	if(@score_name = 'Q101 Trade description')
	BEGIN
		INSERT INTO @returntable (text_answer, reference, answer_metadata, answer_status)
		select
			text_answer, reference, isnull(a.answer_metadata,b.answer_metadata), isnull(a.answer_status,b.answer_status)
		from
			(select
				text_content as text_answer
				, concat('Orbis: ',dataset) as reference
				, 'Successfully found question' as answer_metadata
				, 0 as answer_status
				, row_number() over (order by case when [text_type]='TRADDESCEN' then 0 when [text_type]='TRADDESCOR' then 1 else 2 end asc) as rr
			from
				scd_v2017_002.dbo.orbis_text
			where
				bvd_id=@bvd_id
			) a full outer join
			(select -1 as answer_status, 'No data for company' as answer_metadata) b on 1=1
		where isnull(rr,1) = 1
		RETURN
	END

	declare @last_available_period nvarchar(32)
	declare @sdi_score real;
	declare @calculated_score real;
	declare @mappings table(mapping_label nvarchar(500), mapping_share real, mapping_score real)
			
	if(@score_name = 'Q020a SDI score')
	BEGIN
		set @last_available_period = (select period_id from (select period_id, rank() over (order by period_year desc) as r from [bacmap].[getEntityMappingStatus](@bvd_id) where mapping_status > 0) a where r=1)
		set @sdi_score = (select sdi_score from [score].[calculate_sdi_score](@bvd_id,@last_available_period))

		IF(@sdi_score IS NULL)
		BEGIN
			INSERT INTO @returntable (answer_metadata, answer_status) VALUES('No data for company',-1)
		END
		ELSE
			declare @answer_id int
			set @answer_id = (select id from questionnaire.answer where question_id=@question_id and [value] = cast(cast(@sdi_score as int) as char(2)))
			INSERT INTO @returntable (id_answer, reference, answer_metadata, answer_status) VALUES(@answer_id,@last_available_period,'Retrieved from function',0)
		RETURN
	END

	if(@score_name = 'Q020a# SDI rationale')
	BEGIN
		set @last_available_period = (select period_id from (select period_id, rank() over (order by period_year desc) as r from [bacmap].[getEntityMappingStatus](@bvd_id) where mapping_status > 0) a where r=1)
		set @calculated_score = (select calculated_score from [score].[calculate_sdi_score](@bvd_id,@last_available_period))

		insert into @mappings(mapping_label,mapping_score)
		select
			mapping_label
			, m.[custom_mapping_score]
		from
			[bacmap].[getEntityMapping](@bvd_id,@last_available_period) em JOIN
			[bacmap].[custom_mapping] m ON m.custom_mapping_id=em.mapping_id
		where
			mapping_label not like 'Irrelevant%'

		IF(@calculated_score IS NULL)
		BEGIN
			INSERT INTO @returntable (answer_metadata, answer_status) VALUES('No data for company',-1)
		END
		ELSE
			declare @groups nvarchar(max)
			set @groups = (SELECT distinct STUFF((SELECT concat('*', mapping_label,' with a score of ',mapping_score) FROM @mappings FOR XML PATH ('')), 1, 0, '')  FROM @mappings)

			declare @sdi_rationale nvarchar(max)
			set @sdi_rationale = concat('Based on the company’s products/services only, the score would be an ',cast(@calculated_score as char(2)),'. This is based on the following:<ul>',replace(@groups,'*','<li>'),'</ul>')

			INSERT INTO @returntable (text_answer, reference, answer_metadata, answer_status) VALUES(@sdi_rationale,@last_available_period,'Retrieved from function',0)
		RETURN
	END

	INSERT INTO @returntable (answer_metadata, answer_status) VALUES('No logic for prefilling this question',-1)

	RETURN
END
GO
/*

select * from questionnaire.getPrefillAnswer('AD*A0035323797',6)
select * from questionnaire.getPrefillAnswer('AD*A0035323797',7)
select * from questionnaire.getPrefillAnswer('AD*A0035323797',6000)
select * from questionnaire.getPrefillAnswer('AD*A00',7)
select * from questionnaire.getPrefillAnswer('AD*A0035323797',4)
select * from questionnaire.getPrefillAnswer('AU000721380',4)
select * from questionnaire.getPrefillAnswer('AU000721380',25)

select *, rank() over (order by period_year desc) as r from [bacmap].[getEntityMappingStatus]('AU000721380')



declare @t table(mapping_label varchar(100), score int) insert into @t
select
	mapping_label
	, m.[custom_mapping_score]
from
	[bacmap].[getEntityMapping]('AU000721380','6A9744F679A74509AD55C7491D78A060') em JOIN
	[bacmap].[custom_mapping] m ON m.custom_mapping_id=em.mapping_id

select * from @t
SELECT distinct abc = STUFF((SELECT concat('* ', mapping_label,' (base score: ',score,')') FROM @t FOR XML PATH ('')), 1, 0, '')  FROM @t
*/
CREATE FUNCTION scaramanga.[ufn_company_text_topic]
(
	@topic_name nvarchar(4000)
)
RETURNS @returntable TABLE
(
	company_id varchar(25),
	score_value real,
	es_task_id int
)
AS
BEGIN
	--set @topic_name ='Biosensor'
	declare @es_task_id int
	SET @es_task_id = (
			SELECT TOP 1 -- Pick the most recent store & score action.
				ts.id
			FROM
				[$(TOpicDbServer)].[$(TopicDb)].dbo.topic t JOIN
				[$(TOpicDbServer)].[$(TopicDb)].dbo.es_taskSet ts ON ts.topic_id=t.id  JOIN
				[$(TOpicDbServer)].[$(TopicDb)].dbo.es_runSet r ON ts.run_id=r.id JOIN
				[$(TOpicDbServer)].[$(TopicDb)].dbo.es_source_descriptionSet s ON s.id=ts.source_id
			WHERE
				t.name=@topic_name -- Select by name; that seems the most obvious input in JSON configurations.
				AND
				r.comment = 'storescores'
				AND
				s.es_index='bvd' -- Arrange here that the used index is aligned with the rest of the data handler (i.e. that the inpadoc_family_id's correspond to the version of pw and pwc)
			ORDER BY
				r.[start] DESC
		)

	INSERT @returntable
	SELECT
		cast(lb.bb_ticker as nvarchar(50)) as company_id
		, s.score
		, @es_task_id
	FROM
		[$(TOpicDbServer)].[$(TopicDb)].dbo.es_score_orbis_textSet s JOIN
		[$(idr_linktables_v2017_004)].dbo.linktable_Bloomberg2Orbis_top5 lb ON lb.bvd_id=cast(s.[key] as varchar(25))
	where
		lb.[rank]=1
		and
		es_task_id=@es_task_id
	RETURN
END

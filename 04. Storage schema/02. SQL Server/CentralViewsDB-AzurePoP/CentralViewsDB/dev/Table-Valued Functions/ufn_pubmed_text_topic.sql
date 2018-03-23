CREATE FUNCTION [dev].[ufn_pubmed_text_topic]
(
	@topic_name nvarchar(4000)
)
RETURNS @returntable TABLE
(
	pmid int,
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
				and
				ts.success=1
				AND
				r.comment = 'storescores'
				AND
				s.es_index='science_v2017_001.1' -- Arrange here that the used index is aligned with the rest of the data handler (i.e. that the inpadoc_family_id's correspond to the version of pw and pwc)
			ORDER BY
				r.[start] DESC
		)

	INSERT @returntable
	SELECT
		cast([key] as int) as patent_family_id
		, score
		, es_task_id
	FROM
		[$(TOpicDbServer)].[$(TopicDb)].dbo.es_score_pubmedSet 
	where
		es_task_id=@es_task_id
/*	-- Alternative code to use the average score over the members in the patent family.
	SELECT
		cast([key] as int) as patent_family_id
		, p.[sum] / cast(fm.family_size as real) as score_value
	FROM
		[$(TopicDbServer)].[$(TopicDb)].dbo.es_score_patstatSet p JOIN
		[$(pw_v2017a_001)].patstat.family_metric fm ON fm.inpadoc_family_id=cast([key] as int)
	where
		es_task_id=@es_task_id*/
	RETURN
END
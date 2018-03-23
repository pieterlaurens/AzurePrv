CREATE FUNCTION drax.[ufn_patent_text_topic]
(
	@topic_name nvarchar(4000)
)
RETURNS @returntable TABLE
(
	patent_family_id int,
	score_value real
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
				s.es_index='pw2016a_001_001' -- Arrange here that the used index is aligned with the rest of the data handler (i.e. that the inpadoc_family_id's correspond to the version of pw and pwc)
			ORDER BY
				r.[start] DESC
		)

	INSERT @returntable
	SELECT
		cast([key] as int) as patent_family_id
		, score
	FROM
		[$(TOpicDbServer)].[$(TopicDb)].dbo.es_score_patstatSet
	where
		es_task_id=@es_task_id
	RETURN
END

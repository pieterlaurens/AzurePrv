CREATE FUNCTION [dev].[ufn_web_text_topic]
(
	@topic_name nvarchar(4000)
)
RETURNS @returntable TABLE
(
	website nvarchar(200),
	score_value real,
	es_task_id int
)
AS
BEGIN
	--set @topic_name ='Biosensor'
	declare @es_task_id table(es_task_id int, ts_rank int)
	INSERT INTO @es_task_id 
			SELECT -- Pick the most recent store & score action.
				ts.id
				, rank() OVER (ORDER BY r.[start] DESC) as ts_rank
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
				s.es_index IN ('test_web_asia.1','web_extract','web.3','web.6') -- Arrange here that the used index is aligned with the rest of the data handler (i.e. that the inpadoc_family_id's correspond to the version of pw and pwc)

	INSERT @returntable
	SELECT
		website, score
		, es_task_id
	FROM
		(SELECT
			cast([key] as nvarchar(200)) as website
			, i.es_task_id
			, isnull(isnull(tfidf,[avg]),score) as score
			, ROW_NUMBER() OVER (PARTITION BY [key] ORDER BY i.ts_rank ASC) as score_rank
		FROM
			@es_task_id i JOIN
			[$(TopicDbServer)].[$(TopicDb)].dbo.es_score_company_websiteSet w ON w.es_task_id=i.es_task_id
		) a
	WHERE
		score_rank=1

	RETURN
END

CREATE TYPE [score].[score_table_for_entity] AS TABLE
(
	[custom_mapping_id] VARCHAR(32)
	, [mapping_share] REAL
	, [custom_mapping_score] REAL
	, [custom_mapping_relevancy] int NULL
)


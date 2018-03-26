CREATE TYPE [score].[score_table] AS TABLE
(
	[custom_mapping_value] NVARCHAR(450)
	, [custom_mapping_label] NVARCHAR(1000)
	, [custom_mapping_display_order] INT
	, [custom_mapping_score] REAL
	, [custom_mapping_relevancy] int NULL
	, [comment] NVARCHAR(max) NULL
)

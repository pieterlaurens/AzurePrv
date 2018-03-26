CREATE TABLE [report].[custom_mapping_history]
(
	[Id] INT NOT NULL IDENTITY PRIMARY KEY
	, [load_date] AS getdate()
	, [custom_mapping_id] VARCHAR(32)
	, [custom_mapping_value] NVARCHAR(450)
	, [custom_mapping_label] NVARCHAR(450)
	, [custom_mapping_relevancy] INT
	, [custom_mapping_display_order] INT
	, [custom_mapping_score] REAL
	, [comment] NVARCHAR(max)
	, [modified_by] NVARCHAR(100) NULL
	, [modified_on] DATETIME NULL
	, [is_active] BIT
)
--ON DATA;

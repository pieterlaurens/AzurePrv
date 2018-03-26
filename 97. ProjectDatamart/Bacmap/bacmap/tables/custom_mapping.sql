CREATE TABLE [bacmap].[custom_mapping]
(
	[id] INT NOT NULL IDENTITY PRIMARY KEY
	, [custom_mapping_id] AS convert(varchar(32), hashbytes('md5', [custom_mapping_value]), 2) PERSISTED
	, [custom_mapping_value] NVARCHAR(450)
	, [custom_mapping_label] NVARCHAR(450)
	, [custom_mapping_relevancy] INT
	, [custom_mapping_display_order] INT
	, [custom_mapping_score] REAL
	, [comment] NVARCHAR(max)
	, [modified_by] NVARCHAR(100) NULL
	, [modified_on] DATETIME NULL
	, [is_active] BIT
	, CONSTRAINT custom_mapping_ux_id UNIQUE CLUSTERED (custom_mapping_id)
)
--ON DATA;
GO;
CREATE INDEX custom_mapping_ux_label ON [bacmap].[custom_mapping]([custom_mapping_label]) --ON DATA;

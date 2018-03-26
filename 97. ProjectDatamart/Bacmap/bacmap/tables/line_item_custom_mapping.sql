CREATE TABLE [bacmap].[line_item_custom_mapping]
(
	[id] INT NOT NULL IDENTITY(1,1) PRIMARY KEY
	, [line_item_id] VARCHAR(32) NOT NULL
	, [period_id] VARCHAR(32) NOT NULL
	, [custom_mapping_id] VARCHAR(32) NOT NULL
	, [revenue_fraction] REAL
	, [comment] NVARCHAR(max)
	, [comment_product] NVARCHAR(max)
	, [latest_mapping_action_id] INT
	, [is_active] bit
	, [certainty] real
	, CONSTRAINT line_item_custom_mapping_ux_lineid_customid UNIQUE CLUSTERED (line_item_id, custom_mapping_id, period_id)
	, CONSTRAINT custom_mapping_id_fk FOREIGN KEY (custom_mapping_id) REFERENCES [bacmap].[custom_mapping]([custom_mapping_id])
)
--ON DATA;

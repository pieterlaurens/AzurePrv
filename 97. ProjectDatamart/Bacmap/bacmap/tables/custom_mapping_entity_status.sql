CREATE TABLE [bacmap].[custom_mapping_entity_status]
(
	[Id] INT NOT NULL IDENTITY PRIMARY KEY
	, [entity_id] VARCHAR(32)
	, [period_id] VARCHAR(32)
	, [is_finished] BIT
	, [modified_by] NVARCHAR(100) NULL
	, [modified_on] DATETIME DEFAULT(getdate())
	, [is_active] BIT
)
--ON DATA;
GO;
CREATE INDEX custom_mapping_entity_status_ux_entity ON [bacmap].[custom_mapping_entity_status]([entity_id]) --ON DATA;

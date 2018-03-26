CREATE TABLE [score].[entity_sdi_score]
(
	[Id] INT NOT NULL IDENTITY(1,1) PRIMARY KEY
	, [entity_id] varchar(32)
	, [period_id] varchar(32)
	, [score] real
	, [comment] NVARCHAR(max)
	, [is_active] bit
	, [modified_by] nvarchar(250)
	, [modified_on]	DATETIME NOT NULL DEFAULT(GETDATE())
)

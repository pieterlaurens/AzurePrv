CREATE TABLE [report].[strategic_source_db]
(
	[Id] INT NOT NULL IDENTITY (1,1) PRIMARY KEY
	, [strategic_source] NVARCHAR(512)
	, [source_server_name] NVARCHAR(512)
	, [source_db_name] NVARCHAR(512)
)

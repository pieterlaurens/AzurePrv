CREATE TABLE [bacmap].[custom_mapping_score]
(
	[Id] INT NOT NULL IDENTITY(1,1) PRIMARY KEY
	, [custom_mapping_id] VARCHAR(32)
	, score REAL  
)

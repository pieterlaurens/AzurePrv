CREATE TABLE [report].[deployment_parameters]
(
	[Id] INT IDENTITY(1,1) NOT NULL PRIMARY KEY
	, parameter NVARCHAR(100)
	, parameter_value NVARCHAR(500)
)

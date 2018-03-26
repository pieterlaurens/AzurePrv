CREATE TABLE [temp].[sdi_categories]
(
	[Id] INT IDENTITY(1,1) NOT NULL PRIMARY KEY
	, [Theme] nvarchar(250)
	, [category_label] nvarchar(250)
	, [category_desc] nvarchar(500)
	, [product and services] nvarchar(max)
	, [baseline_score] int
	, [theme_contribution] nvarchar(25)
)

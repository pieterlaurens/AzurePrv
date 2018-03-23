CREATE VIEW [lechiffre].[industry_code]
	AS
--select * from [$(NaceServer)].[$(Nace)].dbo.nace_codes

SELECT
	cast([code] as nchar(4)) as industry_code
	, [level] as industry_code_level
	, [label] as industry_code_description
	, [description] as industry_code_description_long
FROM
	[$(nace_code_v2016_002)].dbo.code

/*SELECT
	nc.nace_code as industry_code
	, nc.nace_level as industry_code_level
	, nd.nace_label as industry_code_description
	, nd.nace_description as industry_code_description_long
FROM
	[$(NaceServer)].[$(Nace)].dbo.nace_codes nc JOIN
	[$(NaceServer)].[$(Nace)].dbo.nace_descriptions nd ON nd.id=nc.id*/
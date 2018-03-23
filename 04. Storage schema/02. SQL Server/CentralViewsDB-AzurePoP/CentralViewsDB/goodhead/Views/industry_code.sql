CREATE VIEW [goodhead].[industry_code]
	AS
--select * from [$(NaceServer)].[$(Nace)].dbo.nace_codes

SELECT
	cast([code] as nchar(4)) as industry_code
	, [level] as industry_code_level
	, [label] as industry_code_description
	, [description] as industry_code_description_long
FROM
	[$(nace_code_v2016_002)].dbo.code
CREATE VIEW [dbo].[industry_code]
	AS
--select * from [$(NaceServer)].[$(Nace)].dbo.nace_codes

SELECT
	nc.nace_code as industry_code
	, nc.nace_level as industry_code_level
	, nd.nace_label as industry_code_description
	, nd.nace_description as industry_code_description_long
FROM
	[$(NaceServer)].[$(Nace)].dbo.nace_codes nc JOIN
	[$(NaceServer)].[$(Nace)].dbo.nace_descriptions nd ON nd.id=nc.id
--	[$(scdr_15_1_server)].[$(scdr_15_1)].dbo.orbis_basic

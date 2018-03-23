CREATE VIEW [dev].[company_text]
	AS
SELECT
	cast(bvd_id as nvarchar(50)) as bvd_id
	, text_type
	, text_content
FROM
	[$(scd_v2017_004)].dbo.orbis_text

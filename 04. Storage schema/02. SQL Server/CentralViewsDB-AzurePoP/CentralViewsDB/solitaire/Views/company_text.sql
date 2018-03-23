CREATE VIEW [solitaire].[company_text]
	AS
SELECT
	cast(bvd_id as nvarchar(50)) as bvd_id
	, text_type
	, text_content
FROM
	[$(scd_v2016_007)].dbo.orbis_text

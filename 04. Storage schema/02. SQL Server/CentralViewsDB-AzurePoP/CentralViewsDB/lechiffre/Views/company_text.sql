CREATE VIEW [lechiffre].[company_text]
	AS
SELECT
	cast(current_bvd_id as nvarchar(50)) as bvd_id
	, text_type
	, text_content
FROM
	[$(scd_v2016_005)].dbo.orbis_text

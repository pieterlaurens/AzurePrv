CREATE VIEW [scaramanga].[company_text]
	AS
SELECT
	cast(lb.bb_ticker as nvarchar(50)) as bvd_id
	, text_type
	, text_content
FROM
	[$(idr_linktables_v2017_004)].dbo.linktable_Bloomberg2Orbis_top5 lb JOIN
	[$(scd_v2017_003)].dbo.orbis_text t ON t.bvd_id=lb.bvd_id
where
	lb.[rank]=1
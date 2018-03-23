CREATE VIEW [james].[company_text]
	AS
SELECT
	ticker as bvd_id
	, text_type
	, text_content
FROM
	[$(idr_linktables_v2017_002)].dbo.linktable_ticker_to_bvd lb JOIN
	[$(scd_v2017_002)].dbo.orbis_text t ON t.bvd_id=lb.bvd_id

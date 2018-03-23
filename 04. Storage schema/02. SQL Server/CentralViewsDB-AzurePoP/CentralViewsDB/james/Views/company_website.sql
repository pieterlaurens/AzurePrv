CREATE VIEW [james].[company_website]
	AS SELECT
		ticker as company_id
		, website
	FROM
		[$(idr_linktables_v2017_002)].dbo.linktable_ticker_to_bvd lb JOIN
		[$(idr_linktables_v2017_002)].dbo.linktable_Orbis_company_website w ON w.bvd_id=lb.bvd_id

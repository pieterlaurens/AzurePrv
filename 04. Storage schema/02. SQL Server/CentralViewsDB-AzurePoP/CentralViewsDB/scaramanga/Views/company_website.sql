CREATE VIEW [scaramanga].[company_website]
	AS SELECT
		cast(lb.bb_ticker as nvarchar(50)) as company_id
		, website
	FROM
		[$(idr_linktables_v2017_004)].dbo.linktable_Bloomberg2Orbis_top5 lb JOIN
		[$(idr_linktables_v2017_004)].dbo.linktable_Orbis2Website_top5 w ON w.bvd_id=lb.bvd_id
	WHERE
		lb.[rank]=1 and w.[rank]=1
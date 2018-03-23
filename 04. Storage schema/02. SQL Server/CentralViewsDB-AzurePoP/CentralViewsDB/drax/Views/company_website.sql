CREATE VIEW drax.[company_website]
	AS SELECT bvd_id as company_id, website FROM [$(idr_linktables_v2016_006)].dbo.linktable_Orbis_company_website

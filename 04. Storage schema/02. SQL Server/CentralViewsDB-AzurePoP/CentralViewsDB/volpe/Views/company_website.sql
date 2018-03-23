CREATE VIEW [volpe].[company_website]
	AS SELECT bvd_id as company_id, website FROM [$(idr_linktables_v2017_004)].dbo.linktable_Orbis2Website_top5 where [rank]=1

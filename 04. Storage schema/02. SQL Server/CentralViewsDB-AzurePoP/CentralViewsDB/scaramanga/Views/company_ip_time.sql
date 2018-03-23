CREATE VIEW [scaramanga].[company_ip_time] AS
SELECT
	cast(lb.bb_ticker as nvarchar(50)) as bvd_id
	, y
	, number_of_families as number_of_patents
	, number_of_citations
	, number_of_new_families as number_of_new_patents
	, number_of_new_citations
	, citations_per_age_year
	, company_hotness
	, technology_hotness
FROM
	[$(idr_linktables_v2017_004)].dbo.linktable_Bloomberg2Orbis_top5 lb JOIN
	[$(pwc_v2017a_001)].[aggregate].company_ip_metric_year cimy ON cimy.bvd_id=lb.bvd_id
where
	lb.[rank]=1

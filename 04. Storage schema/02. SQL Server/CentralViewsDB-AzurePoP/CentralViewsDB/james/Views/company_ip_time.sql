CREATE VIEW [james].[company_ip_time] AS
SELECT
	ticker
	, y
	, number_of_families as number_of_patents
	, number_of_citations
	, number_of_new_families as number_of_new_patents
	, number_of_new_citations
	, citations_per_age_year
	, company_hotness
	, technology_hotness
FROM
	[$(idr_linktables_v2017_002)].dbo.linktable_ticker_to_bvd lb JOIN
	[$(pwc_v2016b_002)].[aggregate].company_ip_metric_year cimy ON cimy.bvd_id=lb.bvd_id

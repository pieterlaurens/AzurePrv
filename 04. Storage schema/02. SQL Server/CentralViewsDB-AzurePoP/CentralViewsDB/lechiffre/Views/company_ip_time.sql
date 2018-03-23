CREATE VIEW lechiffre.[company_ip_time] AS
SELECT
	bvd_id
	, y
	, number_of_families as number_of_patents
	, number_of_citations
	, number_of_new_families as number_of_new_patents
	, number_of_new_citations
	, citations_per_age_year
	, company_hotness
	, technology_hotness
FROM
	[$(pw_v2015b_002)].company.company_ip_metric_year

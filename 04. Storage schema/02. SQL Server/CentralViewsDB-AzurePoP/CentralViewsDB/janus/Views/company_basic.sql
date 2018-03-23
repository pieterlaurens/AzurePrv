CREATE VIEW [janus].[company_basic] AS
SELECT
	cast(current_bvd_id as nvarchar(50)) as bvd_id
	, company_name
	, postal_code
	, city
	, cast(country as nvarchar(2)) as country
	, cast(guo_current_bvd_id as nvarchar(50)) as guo_bvd_id
	, guo_name
	, cast(independence_indicator as nvarchar(5)) as independence_indicator
	, cast(legal_form as nvarchaR(75)) as legal_form
	, cast(listed as nvarchar(10)) as listed
	, cast(company_status as nvarchar(50)) as company_status
	, cast(nace_code as nvarchar(10)) as industry_code
	--, patent_no as number_of_patents
	, cast(category as nvarchar(50)) as company_category
	, website
	, yoi
	, year(getdate()) - yoi as age
	, historic_status_year
	, cim.number_of_families as number_of_patents
	, cim.number_of_citations
	, cim.citations_per_age_year
FROM
	[$(scd_16_1)].dbo.orbis_basic ob LEFT OUTER JOIN
	[$(pw15b_cpc_dev)].company.company_ip_metric cim ON cim.bvd_id=ob.current_bvd_id

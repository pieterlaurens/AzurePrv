CREATE VIEW honeyrider.[company_basic]
	AS
SELECT
	bvd_id
	, company_name
	, postal_code
	, city
	, country
	, guo_bvd_id
	, guo_name
	, independence_indicator
	, legal_form
	, listed
	, company_status
	, cast(nace_code as nvarchar(10)) as industry_code
	, patent_no as number_of_patents
	, category as company_category
	, website
	, yoi
	, year(getdate()) - yoi as age
	, historic_status_year
FROM
	[$(scdr_15_1_server)].[$(scdr_15_1)].dbo.orbis_basic
WHERE
	[org_bvd_pk_rnk]=1

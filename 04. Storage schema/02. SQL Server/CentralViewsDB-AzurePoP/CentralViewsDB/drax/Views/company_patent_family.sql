CREATE VIEW drax.[company_patent_family]
	AS
SELECT
	bvd_id
	, inpadoc_family_id as patent_family_id
FROM
	[$(pwc_v2016a_005)].[aggregate].company_family

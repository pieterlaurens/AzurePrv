CREATE VIEW [volpe].[company_patent_family]
	AS
SELECT
	bvd_id
	, inpadoc_family_id as patent_family_id
FROM
	[$(pwc_v2017a_001)].[aggregate].company_family

CREATE VIEW honeyrider.[applicant_bvd_id]
	AS
SELECT
	doc_std_name_id as applicant_id
	, bvd_id
FROM
	[$(pw15b_cpc)].dbo.dsn_bvd_candidates
WHERE
	rnk=1
CREATE VIEW lechiffre.[applicant_bvd_id]
	AS
SELECT
	person_id as applicant_id
	, bvd_id
FROM
	[$(pw_v2015b_002)].idr.person_to_bvd_id
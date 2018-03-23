CREATE VIEW jaws.[applicant_bvd_id]
	AS
SELECT
	person_id as applicant_id
	, bvd_id
FROM
	[$(pw_v2016a_001)].idr.person_to_bvd_id
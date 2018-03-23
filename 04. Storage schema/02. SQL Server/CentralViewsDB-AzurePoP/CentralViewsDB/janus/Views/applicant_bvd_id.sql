CREATE VIEW [janus].[applicant_bvd_id]
	AS
SELECT
	person_id as applicant_id
	, bvd_id
FROM
	[$(pw15b_cpc_dev)].idr.person_to_bvd_id
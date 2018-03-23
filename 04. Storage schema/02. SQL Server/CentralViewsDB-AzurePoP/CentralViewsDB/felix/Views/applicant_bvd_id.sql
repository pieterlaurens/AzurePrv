CREATE VIEW felix.[applicant_bvd_id]
	AS
SELECT
	person_id as applicant_id
	, bvd_id
FROM
	[$(scdr_16_1_server)].[$(scdr_16_1)].dbo.patstat_orbis_matches
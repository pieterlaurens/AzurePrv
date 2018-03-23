CREATE VIEW [goodhead].[applicant_bvd_id]
	AS
SELECT
	person_id as applicant_id
	, bvd_id
FROM
	[$(idr_linktables_v2016_005)].dbo.linktable_best_match_Patstat2Orbis
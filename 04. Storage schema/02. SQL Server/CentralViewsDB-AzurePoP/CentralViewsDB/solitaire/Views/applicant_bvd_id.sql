CREATE VIEW [solitaire].[applicant_bvd_id]
	AS
SELECT
	person_id as applicant_id
	, isnull(bg.guo_bvd_id,pb.bvd_id) as bvd_id
FROM
	[$(idr_linktables_v2016_005)].dbo.linktable_best_match_Patstat2Orbis pb LEFT OUTER JOIN
	[$(idr_linktables_v2016_005)].dbo.linktable_Orbis_Orbis_GUO bg ON bg.bvd_id=pb.bvd_id
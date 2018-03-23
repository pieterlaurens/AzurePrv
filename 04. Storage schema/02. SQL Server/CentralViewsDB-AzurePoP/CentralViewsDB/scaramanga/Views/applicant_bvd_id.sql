CREATE VIEW [scaramanga].[applicant_bvd_id]
	AS
SELECT
	person_id as applicant_id
	, cast(lb.bb_ticker as nvarchar(50)) as bvd_id
FROM
	[$(pwc_v2017a_001)].idr.person_to_bvd_id p JOIN
	[$(idr_linktables_v2017_004)].dbo.linktable_Bloomberg2Orbis_top5 lb ON lb.bvd_id=p.bvd_id
where
	lb.[rank]=1
CREATE VIEW [scaramanga].[company_patent_family]
	AS
SELECT
	cast(lb.bb_ticker as nvarchar(50)) as bvd_id
	, inpadoc_family_id as patent_family_id
FROM
	[$(idr_linktables_v2017_004)].dbo.linktable_Bloomberg2Orbis_top5 lb JOIN
	[$(pwc_v2017a_001)].[aggregate].company_family cf ON cf.bvd_id=lb.bvd_id
where
	lb.[rank]=1

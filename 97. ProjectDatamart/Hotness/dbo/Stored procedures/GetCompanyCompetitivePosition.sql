CREATE PROCEDURE [dbo].[GetCompanyCompetitivePosition]
	@bvd_id varchar(25)
	, @in_filter_pool bit = 0
AS
	; with citingCompany AS (
		SELECT
			cfc.bvd_id as citing_bvd_id
			, count(distinct cf.inpadoc_family_id) as [# Company cited patents]
			, count(distinct cfc.inpadoc_family_id) as [# Others citing patents]
		FROM
			[$(pwc_v2016a_005)].aggregate.company_family cf JOIN
			[$(pw_v2016a_001)].patstat.family_citation fc ON fc.cited_family_id=cf.inpadoc_family_id JOIN
			[$(pwc_v2016a_005)].aggregate.company_family cfc ON cfc.inpadoc_family_id=fc.citing_family_id
		WHERE
			cf.bvd_id=@bvd_id
		GROUP BY
			cfc.bvd_id
	) , citedByCompany AS(
		SELECT
			cfc.bvd_id as citing_bvd_id
			, count(distinct cf.inpadoc_family_id) as [# Company citing patents]
			, count(distinct cfc.inpadoc_family_id) as [# Others cited patents]
		FROM
			[$(pwc_v2016a_005)].aggregate.company_family cf JOIN
			[$(pw_v2016a_001)].patstat.family_citation fc ON fc.citing_family_id=cf.inpadoc_family_id JOIN
			[$(pwc_v2016a_005)].aggregate.company_family cfc ON cfc.inpadoc_family_id=fc.cited_family_id
		WHERE
			cf.bvd_id=@bvd_id
		group by
			cfc.bvd_id
	) 
	SELECT TOP 50
		ob.bvd_id
		, ob.company_name
		, cim.number_of_families
		, cim.number_of_citations
		, isnull(cc.[# Company cited patents],0) as [# Company cited patents]
		, isnull(cc.[# Others citing patents],0) as [# Others citing patents]
		, isnull(cbc.[# Company citing patents],0) as [# Company citing patents]
		, isnull(cbc.[# Others cited patents],0) as [# Others cited patents]
	FROM
		citingCompany cc FULL OUTER JOIN
		citedByCompany cbc ON cc.citing_bvd_id=cbc.citing_bvd_id JOIN
		[$(scd_v2017_002)].dbo.orbis_basic ob ON ob.bvd_id=isnull(cc.citing_bvd_id,cbc.citing_bvd_id) JOIN
		[$(pwc_v2016a_005)].aggregate.company_ip_metric cim ON cim.bvd_id=ob.bvd_id
	WHERE
		ob.bvd_id IN (select child_bvd_id from pwc_v2016a_005.idr.linktable_guo_lineage group by child_bvd_id having count(*) =1 ) -- only top level companies!
		and
		ob.bvd_id <> @bvd_id
	ORDER BY
		[# Company cited patents]+[# Company citing patents] desc

RETURN 0

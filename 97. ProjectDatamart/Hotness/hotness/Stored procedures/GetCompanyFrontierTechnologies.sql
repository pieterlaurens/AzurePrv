CREATE PROCEDURE hotness.[GetCompanyFrontierTechnologies]
	@bvd_id varchar(25)
AS
	SELECT
		t.technology_id
		, t.label
		, t.technology_group
		, count(distinct cf.inpadoc_family_id) as [# families in frontier technologies]
		, count(tf.is_top_in_technology) as [# top cited within technology]
	FROM
		[$(pwc_v2016a_005)].aggregate.company_family cf JOIN
		hotness.technology_family tf ON tf.inpadoc_family_id=cf.inpadoc_family_id JOIN
		hotness.technology t ON t.technology_id=tf.technology_id
	WHERE
		cf.bvd_id = @bvd_id
		and
		t.label <> 'Cloud narrow'
	GROUP BY
		t.technology_id
		, t.label
		, t.technology_group
	order by
		[# families in frontier technologies] desc

RETURN 0

CREATE PROCEDURE [dbo].[GetCompanyInvestorPreference]
	@bvd_id varchar(25)
AS
	SELECT
		t.preference_id
		, t.area_label
		, t.preference_group
		, count(distinct cf.inpadoc_family_id) as [# families in preference area]
		, count(tf.is_top_in_preference) as [# top cited within preference area]
	FROM
		[$(pwc_v2016a_005)].aggregate.company_family cf JOIN
		hotness.investor_preference_family tf ON tf.inpadoc_family_id=cf.inpadoc_family_id JOIN
		hotness.investor_preference t ON t.preference_id=tf.preference_id
	WHERE
		cf.bvd_id = @bvd_id
	GROUP BY
		t.preference_id
		, t.area_label
		, t.preference_group
	order by
		[# families in preference area]

RETURN 0

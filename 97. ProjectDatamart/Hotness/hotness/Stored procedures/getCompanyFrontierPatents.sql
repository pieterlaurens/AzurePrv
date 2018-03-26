CREATE FUNCTION hotness.[getCompanyFrontierPatents]
(
	@bvd_id varchar(25)
)
RETURNS @returntable TABLE
(
	technology_label nvarchar(500) -- The label of the technology
	, in_focus tinyint -- Whether or not it's in the investor's interest area
	, [rank] smallint -- The ranking of the patent; used to select the top patents
	, inpadoc_family_id int
	, representative_publication varchar(25) -- For access to Espacenet/Google Patents
	, representative_title nvarchar(max)
	, priority_year smallint
)
AS
BEGIN
	
	INSERT @returntable
	SELECT
		t.label
		, case when ipf.inpadoc_family_id is null then 0 else 1 end as in_focus
		, ROW_NUMBER() OVER (PARTITION BY t.technology_id ORDER BY tf.number_of_citations DESC) as [rank]
		, tf.inpadoc_family_id
		, frt.representative_publication
		, fat.application_title
		, tf.priority_year
	FROM
		[$(pwc_v2016a_005)].[aggregate].company_family cf JOIN
		hotness.technology_family tf ON tf.inpadoc_family_id=cf.inpadoc_family_id JOIN
		hotness.technology t ON t.technology_id=tf.technology_id JOIN
		[$(pw_v2016a_001)].patstat.family_metric fm ON fm.inpadoc_family_id=tf.inpadoc_family_id JOIN
		[$(pw_v2016a_001)].patstat.family_representative_text frt ON frt.inpadoc_family_id=tf.inpadoc_family_id JOIN
		[$(pw_v2016a_001)].patstat.family_application_text fat ON fat.appln_id=frt.representative_title_application_id LEFT OUTER JOIN
		(select distinct inpadoc_family_id from hotness.investor_preference_family) ipf ON ipf.inpadoc_family_id=cf.inpadoc_family_id
	where
		cf.bvd_id=@bvd_id


	RETURN
END

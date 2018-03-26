CREATE PROCEDURE hotness.[GetCompanyHotness]
	@bvd_id varchar(25)
AS

	SELECT
		c.y
		, c.citations_per_age_year as [Citations over Age]
		, b.cpy_25 as [CoA Negative range]
		, b.cpy_75 as [CoA Positive range]

		, c.company_hotness as [Y3 Citations]
		, b.ch_25 as [Y3C Negative range]
		, b.ch_75 as [Y3C Positive range]
	FROM
		(SELECT
			cimy.y
			, cimy.citations_per_age_year
			, cimy.company_hotness
		FROM
			[$(pwc_v2016a_005)].company.company_ip_metric_year cimy
		WHERE 
			cimy.bvd_id=@bvd_id
		) c JOIN
		(SELECT DISTINCT
			cimy.y
			, PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY cimy.citations_per_age_year ASC) OVER (PARTITION BY y) as cpy_25
			, PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY cimy.citations_per_age_year ASC) OVER (PARTITION BY y) as cpy_75
			, PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY cimy.company_hotness ASC) OVER (PARTITION BY y) as ch_25
			, PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY cimy.company_hotness ASC) OVER (PARTITION BY y) as ch_75
		FROM
			hotness.company c JOIN
			[$(pwc_v2016a_005)].company.company_ip_metric_year cimy ON c.bvd_id=cimy.bvd_id
		) b ON b.y=c.y
	ORDER BY c.y ASC
		
RETURN 0

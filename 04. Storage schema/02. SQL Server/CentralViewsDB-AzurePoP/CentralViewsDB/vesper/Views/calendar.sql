

CREATE VIEW [vesper].[calendar]
	AS SELECT
		id
		, period_id as bloomberg_period_id
		, period_label
		, period_type
		, period_year
		, period_quarter
		, period_month
		, case when period_type='M' then datefromparts(period_year, period_month, 1)
			   when period_type='Y' then datefromparts(period_year, 1, 1)
			   else null end as period_date
		, next_period_id
	FROM (SELECT
		c.id, c.period_id, c.period_label, c.period_type,c.period_year,c.period_quarter,c.period_month
		, c2.id as next_period_id
		, CASE WHEN c.period_type='Y' AND c2.period_type='Y' AND c2.period_year=c.period_year+1 THEN 1
			   WHEN c.period_type='Q' AND c2.period_type='Q' AND c2.period_year=c.period_year AND c2.period_quarter=c.period_quarter+1 THEN 1
			   WHEN c.period_type='Q' AND c2.period_type='Q' AND c2.period_year=c.period_year+1 AND c.period_quarter=4 AND c2.period_quarter=1 THEN 1
			   WHEN c.period_type='M' AND c2.period_type='M' AND c2.period_year=c.period_year AND c2.period_month=c.period_month+1 THEN 1
			   WHEN c.period_type='M' AND c2.period_type='M' AND c2.period_year=c.period_year+1 AND c.period_month=12 AND c2.period_month=1 THEN 1
			   ELSE 0 END AS is_next
	FROM
		[$(bloomberg_v2017_001)].bloomberg.[period] c CROSS JOIN
		[$(bloomberg_v2017_001)].bloomberg.[period] c2) a
	WHERE
		is_next = 1
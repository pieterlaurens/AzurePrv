

CREATE VIEW [james].[calendar]
	AS
	
	select
		p_this.pk_int as [id]
		, CONVERT([varchar](32),hashbytes('md5',
			case when p_this.[type]='D' then cast(p_this.[date] as varchar(15))
				 when p_this.[type]='M' then concat(right(p_this.period_id,2),'_',left(p_this.period_id,4))
				 when p_this.[type]='Y' then concat('FY_',p_this.period_id) end),(2)) as bloomberg_period_id
		, cast(p_this.period_id as nvarchar(500)) as period_label
		, cast(p_this.[type] as nvarchar(1)) as period_type
		, p_this.[year] as period_year
		, p_this.[quarter] as period_quarter
		, p_this.[month] as period_month
		, p_this.first_day_of_period as period_date
		, p_this.next_pk_int as next_period_id
	from
		[$(calendar_v2017_001)].dbo.[period] p_this /*JOIN
		[$(calendar_v2017_001)].dbo.[period] p_next ON p_next.period_id=p_this.next_period_id*/
	where
		p_this.first_day_of_period between DATEFROMPARTS(1999,1,1) and getdate()

	/*SELECT
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
		[$(bloomberg_v2017_000)].bloomberg.[period] c CROSS JOIN
		[$(bloomberg_v2017_000)].bloomberg.[period] c2) a
	WHERE
		is_next = 1*/
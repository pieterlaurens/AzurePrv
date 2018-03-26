CREATE VIEW [bacmap].[period]
as 
select row_number() over(order by [period_year]) as id
		, concat(period_year, '-01-01') as period_id
		, concat(period_year, '-01-01') as period_label
		, 'Y' as period_type
		, period_year
		, NULL as period_quarter
		, 0 as [is_custom_definition]
		, 1 as period_month
		, 1 as period_day
		, cast(concat(period_year, '-01-01')as datetime) as [period_date]
	from 
		(
			select distinct 
					year(
						cast([period_id_start] as datetime)) as period_year
				from 
					[$(bb_db)].[bloomberg].[line_item_period_metric]
		) t
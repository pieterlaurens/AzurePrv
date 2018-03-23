CREATE VIEW [janus].[company_aggregate_attribute] AS
SELECT
	cast(ob.bvd_id as nvarchar(50)) as bvd_id
	, y as last_available_year
	,[employees]
	,[revenue]
	,case when isnull(revenue,0) = 0
		then null
		else cast(net_income as real) / 
				cast(revenue as real) end as [profit_margin]
	,total_assets
	,EBITDA
	,EBIT
	,net_debt
	,net_current_assets
	,working_capital
	,[loans]
	,long_term_debt
	,cash_and_cash_equivalent
	,da.number_of_acquisitions
	,da.total_acquisition_value
FROM
	[$(scd_16_1)].dbo.orbis_basic ob LEFT OUTER JOIN
	(SELECT
		*
	FROM
		(select
			bvd_id
			,y
			,[type]
			,[value]
		from	
			(select
				bvd_id
				,y
				,[type]
				,[value]
				, rank() over (partition by bvd_id order by y desc) as rnk
			from
				[$(scd_16_1)].dbo.orbis_financials
			) a
		WHERE
			rnk=1
		) f
		PIVOT(
			max(value) for [type] in ([employees]
									,revenue
									,total_assets
									,net_income
									,net_current_assets
									,working_capital
									,EBITDA
									,EBIT
									,net_debt
									,loans
									,long_term_debt
									,cash_and_cash_equivalent)
		) pvt
	) f ON ob.bvd_id=f.bvd_id LEFT OUTER JOIN
	(select
		acquirer_bvd_id as bvd_id
		, sum(do.[deal_value]) as total_acquisition_value
		, count(distinct da.deal_id) as number_of_acquisitions
	from
		[$(sdd_16_1)].dbo.deal_acquirer da JOIN
		[$(sdd_16_1)].dbo.deal_overview do ON do.deal_id=da.deal_id
	WHERE
		DATEDIFF(yy, do.[announced_date], GETDATE()) <= 5
	group by
		acquirer_bvd_id
	) da ON da.bvd_id=ob.bvd_id
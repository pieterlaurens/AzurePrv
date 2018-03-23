﻿CREATE VIEW [scaramanga].[company_aggregate_attribute] AS
SELECT
	cast(lb.bb_ticker as nvarchar(50)) as bvd_id
	,last_available_year
	,[employees]
	,[revenue]
	,[profit_margin]
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
	[$(idr_linktables_v2017_004)].dbo.linktable_Bloomberg2Orbis_top5 lb JOIN
	[$(scd_v2017_003)].dbo.orbis_basic ob ON lb.bvd_id=ob.bvd_id LEFT OUTER JOIN
	[$(scd_v2017_003)].dbo.financials_lay f ON ob.bvd_id=f.bvd_id LEFT OUTER JOIN
	(select
		acquirer_bvd_id as bvd_id
		, sum(do.[deal_value]) as total_acquisition_value
		, count(distinct da.deal_id) as number_of_acquisitions
	from
		[$(sdd_v2017_002)].dbo.deal_acquirer da JOIN
		[$(sdd_v2017_002)].dbo.deal_overview do ON do.deal_id=da.deal_id
	WHERE
		DATEDIFF(yy, do.[announced_date], GETDATE()) <= 5
	group by
		acquirer_bvd_id
	) da ON da.bvd_id=ob.bvd_id
where
	lb.[rank]=1
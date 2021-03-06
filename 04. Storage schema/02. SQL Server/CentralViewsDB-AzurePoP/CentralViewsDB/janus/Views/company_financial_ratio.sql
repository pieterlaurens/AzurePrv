﻿CREATE VIEW [janus].[company_financial_ratio] AS

SELECT
	cast(current_bvd_id as nvarchar(50)) as bvd_id
	, y
	, [type]
	, [value]
from
	[$(scd_16_1)].dbo.orbis_financial_ratios

/*SELECT
	bvd_id, y
	,[employees]
	,total_assets as [totalAssets]
	,[revenue]
	,case when isnull(revenue,0) = 0
		then null
		else cast(net_income as real) / 
				cast(revenue as real) end as [profitMargin]
	,net_current_assets as [netAssets]
	,working_capital as [netWorkingCapital]
	,EBITDA as [ebitdaVal]
	,EBIT as [ebitVal]
	,[loans]
	,long_term_debt as [longTermDebt]
	,cash_and_cash_equivalent as [cashVal]
FROM
	(select bvd_id,y,[type],[value] from [$(ScdServer)].[$(StrategicCompanyData)].dbo.orbis_financials) a
PIVOT(
	max(value) for [type] in ([employees]
							,total_assets
							,net_income
							,revenue
							,net_current_assets
							,working_capital
							,EBITDA
							,EBIT
							,loans
							,long_term_debt
							,cash_and_cash_equivalent)
) pvt*/


CREATE VIEW [scaramanga].[company_basic] AS
SELECT
	cast(lb.bb_ticker as nvarchar(50)) as bvd_id
	, isnull(company_name,lb.bb_ticker) as company_name
	, postal_code
	, city
	, cast(country as nvarchar(2)) as country
	, cast(guo_bvd_id as nvarchar(50)) as guo_bvd_id
	, guo_name
	, cast(independence_indicator as nvarchar(5)) as independence_indicator
	, cast(legal_form as nvarchar(75)) as legal_form
	, cast(listed as nvarchar(10)) as listed
	, cast(company_status as nvarchar(50)) as company_status
	, cast(nace_code as nvarchar(10)) as industry_code
	--, patent_no as number_of_patents
	, cast(category as nvarchar(50)) as company_category
	, website
	, yoi
	, year(getdate()) - yoi as age
	, historic_status_year
	, cim.number_of_families as number_of_patents
	, cim.number_of_citations
	, cim.citations_per_age_year
	, NULL as segment
	, layf.last_available_year
	, cast(layf.cash_and_cash_equivalent as real) as cash_and_cash_equivalent
	, cast(layf.EBIT as real) as EBIT
	, cast(layf.EBITDA as real) as EBITDA
	, cast(layf.employees as real) as employees
	, cast(layf.intangible_assets as real) as intangible_assets
	, cast(layf.loans as real) as loans
	, cast(layf.long_term_debt as real) as long_term_debt
	, cast(layf.net_current_assets as real) as net_current_assets
	, cast(layf.net_debt as real) as net_debt
	, cast(layf.profit_margin as real) as profit_margin
	, cast(layf.R_D_expenditure as real) as R_D_expenditure
	, cast(layf.revenue as real) as revenue
	, cast(layf.total_assets as real) as total_assets
	, cast(layf.working_capital as real) working_capital
	,os.[isin]
	,os.[ticker]
	,isnull(os.[main_exchange],'Bloomberg Screen') as [main_exchange]
	,os.[cik]
	,os.[no_of_outstanding_shares]
	,os.[current_market_capitalisation_th]
	,cast(case when os.[current_market_capitalisation_th]  < 2000000 then 'Small cap'
		  when os.[current_market_capitalisation_th]  < 10000000 then 'Mid cap'
		  when os.[current_market_capitalisation_th] >= 10000000 then 'Large cap'
		  else 'n/a' end as nvarchar(15)) as market_cap_basket
	,os.[ipo_date]
	,os.[date_of_current_beta_calculation]
	,os.[ref_index_1_beta_1_month]
	,os.[ref_index_1_beta_1_year]
	,os.[ref_index_1_beta_3_months]
	,os.[ref_index_1_beta_3_years]
	,os.[ref_index_1_beta_5_years]
	,os.[ref_index_1_correlation_coefficient_1_month]
	,os.[ref_index_1_correlation_coefficient_1_year]
	,os.[ref_index_1_correlation_coefficient_3_months]
	,os.[ref_index_1_correlation_coefficient_3_years]
	,os.[ref_index_1_correlation_coefficient_5_years]
	,os.[ref_index_2_beta_1_month]
	,os.[ref_index_2_beta_1_year]
	,os.[ref_index_2_beta_3_months]
	,os.[ref_index_2_beta_3_years]
	,os.[ref_index_2_beta_5_years]
	,os.[ref_index_2_correlation_coefficient_1_month]
	,os.[ref_index_2_correlation_coefficient_1_year]
	,os.[ref_index_2_correlation_coefficient_3_months]
	,os.[ref_index_2_correlation_coefficient_3_years]
	,os.[ref_index_2_correlation_coefficient_5_years]
	,os.[ref_index_3_beta_1_month]
	,os.[ref_index_3_beta_1_year]
	,os.[ref_index_3_beta_3_months]
	,os.[ref_index_3_beta_3_years]
	,os.[ref_index_3_beta_5_years]
	,os.[ref_index_3_correlation_coefficient_1_month]
	,os.[ref_index_3_correlation_coefficient_1_year]
	,os.[ref_index_3_correlation_coefficient_3_months]
	,os.[ref_index_3_correlation_coefficient_3_years]
	,os.[ref_index_3_correlation_coefficient_5_years]
	,os.[ref_index_4_beta_1_month]
	,os.[ref_index_4_beta_1_year]
	,os.[ref_index_4_beta_3_months]
	,os.[ref_index_4_beta_3_years]
	,os.[ref_index_4_beta_5_years]
	,os.[ref_index_4_correlation_coefficient_1_month]
	,os.[ref_index_4_correlation_coefficient_1_year]
	,os.[ref_index_4_correlation_coefficient_3_months]
	,os.[ref_index_4_correlation_coefficient_3_years]
	,os.[ref_index_4_correlation_coefficient_5_years]
	,os.[ref_index_5_beta_1_month]
	,os.[ref_index_5_beta_1_year]
	,os.[ref_index_5_beta_3_months]
	,os.[ref_index_5_beta_3_years]
	,os.[ref_index_5_beta_5_years]
	,os.[ref_index_5_correlation_coefficient_1_month]
	,os.[ref_index_5_correlation_coefficient_1_year]
	,os.[ref_index_5_correlation_coefficient_3_months]
	,os.[ref_index_5_correlation_coefficient_3_years]
	,os.[ref_index_5_correlation_coefficient_5_years]
	,os.[reference_index_1]
	,os.[reference_index_2]
	,os.[reference_index_3]
	,os.[reference_index_4]
	,os.[reference_index_5]
FROM
	[$(idr_linktables_v2017_004)].dbo.linktable_Bloomberg2Orbis_top5 lb LEFT OUTER JOIN
	[$(scd_v2017_003)].dbo.orbis_basic ob ON lb.bvd_id=ob.bvd_id LEFT OUTER JOIN
	[$(pwc_v2017a_001)].[aggregate].company_ip_metric cim ON cim.bvd_id=lb.bvd_id LEFT OUTER JOIN
	[$(scd_v2017_003)].dbo.financials_lay layf ON layf.bvd_id=lb.bvd_id LEFT OUTER JOIN
	[$(scd_v2017_003)].dbo.orbis_stock os ON os.bvd_id=lb.bvd_id
where
	lb.[rank]=1

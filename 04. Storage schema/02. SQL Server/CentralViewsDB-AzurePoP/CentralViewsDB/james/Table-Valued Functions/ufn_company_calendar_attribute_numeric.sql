﻿



CREATE FUNCTION [james].[ufn_company_calendar_attribute_numeric]
(
	@metric_type nvarchar(100)
	, @period_type char(1)
)
RETURNS @returntable TABLE
(
	calendar_id INT
	, period_type CHAR(1)
	, period_label VARCHAR(10)
	, bvd_id NVARCHAR(50)
	, metric_type NVARCHAR(100)
	, metric_value REAL
)
AS
BEGIN


/*
Bloomberg: BS_SH_OUT
BS_TOT_ASSET
CUR_MKT_CAP
GROSS_PROFIT
HIST_TRR_MONTHLY
PX_LAST
TOT_COMMON_EQY

*/

	IF @metric_type IN ('BS_SH_OUT','BS_TOT_ASSET','CUR_MKT_CAP','GROSS_PROFIT','HIST_TRR_MONTHLY','PX_LAST','TOT_COMMON_EQY','DAY_TO_DAY_TOT_RETURN_NET_DVDS','NUMBER_OF_EXECUTIVES', 
  '#_OF_NON_EXECUTIVE_DIR_ON_BRD')
	BEGIN
		IF @period_type='M'
		BEGIN
			-- metrics themselves
			INSERT @returntable
			SELECT
				c.id as calendar_id
				, c.period_type
				, c.period_label
				, cast(replace(e.entity_label,' Equity','') as nvarchar(50)) as bvd_id
				, cast(epm.metric_type as nvarchar(100)) as metric_type
				, cast(epm.metric_value as real) as metric_value
			FROM
				[$(bloomberg_v2017_001)].[bloomberg].[entity] e JOIN
				[$(bloomberg_v2017_001)].bloomberg.entity_period_metric epm ON e.[entity_id]=epm.[entity_id] JOIN
				[$(bloomberg_v2017_001)].[bloomberg].[period] p ON p.period_id=epm.period_id JOIN
				james.calendar c ON c.period_year=p.period_year AND c.period_month=p.period_month
			WHERE
				c.period_type=@period_type
				AND
				epm.metric_type=@metric_type

			-- any derived metrics
			INSERT @returntable
			SELECT
				c.id as calendar_id
				, c.period_type
				, c.period_label
				, cast(replace(e.entity_label,' Equity','') as nvarchar(50)) as bvd_id
				, cast(replace(epm.metric_type,'_DERIV','') as nvarchar(100)) as metric_type
				, cast(epm.metric_value as real) as metric_value
			FROM
				[$(bloomberg_v2017_001)].[bloomberg].[entity] e JOIN
				[$(bloomberg_v2017_001)].bloomberg.entity_period_metric_derived epm ON e.[entity_id]=epm.[entity_id] JOIN
				[$(bloomberg_v2017_001)].[bloomberg].[period] p ON p.period_id=epm.period_id JOIN
				james.calendar c ON c.period_year=p.period_year AND c.period_month=p.period_month
			WHERE
				c.period_type=@period_type
				AND
				replace(epm.metric_type,'_DERIV','')=@metric_type

		END
	END

	IF @metric_type IN ('BiographyDiversity','CompanyTeamSize','AvgBiographLength')
	BEGIN
		INSERT @returntable
		select
			[id], [period_type], [period_label], [bvd_id], [metric_type], [metric_value]
		from
			(select
				c.id
				, c.period_type
				, c.period_label
				, cast(tc.ticker as nvarchar(50)) as bvd_id
				, cast(ft.name as nvarchar(100)) as metric_type
				, cast(fts.factor_value as real) as metric_value
				, rank() over (partition by tc.ticker, c.id order by ei.filing_date desc ) as rr
			from
				[$(AlphaFactorsDB)].[dbo].[factor_time_series] fts JOIN
				[$(AlphaFactorsDB)].[dbo].factor_type ft ON ft.id=fts.factor_type_id JOIN
				[$(AlphaFactorsDB)].[dbo].[sec_entity_info] ei ON fts.entity_key=ei.entity_key AND fts.period_key=ei.period_key JOIN
				(select
					fr.id
					, rank() over (partition by factor_type_id order by [end] desc) as r
				from
					[$(AlphaFactorsDB)].[dbo].[factor_run] fr JOIN
					[$(AlphaFactorsDB)].[dbo].factor_type ft1 ON fr.factor_type_id=ft1.id
				where
					success=1
					and
					ft1.name=@metric_type
					and
					implementation_method = 'Paper'
				) r ON r.id=fts.run_id JOIN
				-- the join condition for the calendar means that a filing is valid for one year. the outer selection, based on the recency rank
				-- of the filing ensures that the most recent one is used.
				james.calendar c ON c.period_date between ei.filing_date and DATEFROMPARTS(year(ei.filing_date)+1,month(ei.filing_date),case when day(ei.filing_date)=29 and month(ei.filing_date)=2 then 28 else day(ei.filing_date) end) JOIN
				[$(idr_linktables_v2017_002)].dbo.[linktable_ticker_to_cik] tc ON tc.cik=fts.entity_key
			where
				ft.name=@metric_type
				and
				r.r=1 --order by ticker,y
				and
				c.period_type=@period_type
			) a
		where
			rr = 1 -- when there's multiple filings for a period, take the most recent one.
	END

	IF @metric_type IN ('revenue','employees','loans_LOAN','non_current_liabilities_NCLI','intangible_fixed_assets','stock','debtors','creditors','other_fixed_assets_OFAS','capital','fixed_assets_FIAS','long_term_debt','EBIT')
	BEGIN
		--declare @fi smallint
		--set @fi = (select id from [$(scd_v2017_002_hotfix20170627)].dbo.financial_type where financial_type=@metric_type)
		INSERT @returntable
		select
			c.id as calendar_id
			, c.period_type
			, c.period_label
			, cast(lb.ticker as nvarchar(50)) as bvd_id
			, @metric_type as metric_type
			, cast(f.[value] as real) as metric_value
		from
			[$(scd_v2017_002)].dbo.orbis_financials f JOIN
			james.calendar c ON c.period_year=f.y JOIN
			[$(idr_linktables_v2017_002)].dbo.linktable_ticker_to_bvd lb ON lb.bvd_id=f.bvd_id
		where
			c.period_type=@period_type
			and
			f.[type]=@metric_type
			--f.[financial_type_id]=@fi
	END

	RETURN
END
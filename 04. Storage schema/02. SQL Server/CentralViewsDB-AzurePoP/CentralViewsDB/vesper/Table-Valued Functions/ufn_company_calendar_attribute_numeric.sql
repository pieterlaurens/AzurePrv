



CREATE FUNCTION vesper.[ufn_company_calendar_attribute_numeric]
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

	/*IF @metric_type IN ('BS_SH_OUT','BS_TOT_ASSET','CUR_MKT_CAP','GROSS_PROFIT','HIST_TRR_MONTHLY','PX_LAST','TOT_COMMON_EQY')
	BEGIN
		IF @period_type='M'
			INSERT @returntable
			SELECT
				c.id as calendar_id
				, c.period_type
				, c.period_label
				, cast(replace(e.entity_label,' Equity','') as nvarchar(50)) as bvd_id
				, cast(epm.metric_type as nvarchar(100)) as metric_type
				, cast(epm.metric_value as real) as metric_value
			FROM
				[$(bloomberg_v2017_000)].[bloomberg].[entity] e JOIN
				[$(bloomberg_v2017_000)].bloomberg.entity_period_metric epm ON e.[entity_id]=epm.[entity_id] JOIN
				[$(bloomberg_v2017_000)].[bloomberg].[period] p ON p.period_id=epm.period_id JOIN
				factordevelopment.calendar c ON c.period_year=p.period_year AND c.period_month=p.period_month
			WHERE
				c.period_type=@period_type
				AND
				epm.metric_type=@metric_type
	END

	IF @metric_type IN ('BiographyDiversity','CompanyTeamSize','AvgBiographLength')
	BEGIN
		INSERT @returntable
		select
			p.calendar_id
			, p.period_type
			, p.period_label
			, cast(tc.ticker as nvarchar(50)) as bvd_id
			, cast(ft.name as nvarchar(100)) as metric_type
			, cast(fts.factor_value as real) as metric_value
		from
			[$(AlphaFactorsDB)].[dbo].[factor_time_series] fts JOIN
			[$(AlphaFactorsDB)].[dbo].factor_type ft ON ft.id=fts.factor_type_id JOIN
			(select
				id
				, rank() over (partition by factor_type_id order by [end] desc) as r
			from
				[$(AlphaFactorsDB)].[dbo].[factor_run]
			where
				success=1
				and
				factor_type_id IN (1,7,8)
			) r ON r.id=fts.run_id JOIN
			(select
				p.id as alpha_period_key
				, c.id as calendar_id
				, c.period_label
				, c.period_type
			from
				[$(AlphaFactorsDB)].[dbo].[period] p JOIN
				[$(AlphaFactorsDB)].[dbo].[period_type] pt ON pt.id=p.period_type_id JOIN
				factordevelopment.calendar c ON c.period_year=cast(left(p.[value],4) as smallint)
			where
				c.period_type=@period_type
			) p ON p.alpha_period_key=fts.period_key JOIN
			[$(idr_linktables_v2017_002)].dbo.[linktable_ticker_to_cik] tc ON tc.cik=fts.entity_key
		where
			ft.name=@metric_type
			and
			fts.[factor_type_id] IN (1,7,8)
			and
			r.r=1 --order by ticker,y
	END*/

	IF @metric_type IN ('revenue','employees','loans_LOAN','non_current_liabilities_NCLI','intangible_fixed_assets','stock','debtors','creditors','other_fixed_assets_OFAS','capital','fixed_assets_FIAS','long_term_debt','EBIT')
	BEGIN
		--declare @fi smallint
		--set @fi = (select id from [$(scd_v2017_002_hotfix20170627)].dbo.financial_type where financial_type=@metric_type)
		INSERT @returntable
		select
			c.id as calendar_id
			, c.period_type
			, c.period_label
			, cast(f.bvd_id as nvarchar(50)) as bvd_id
			, @metric_type as metric_type
			, cast(f.[value] as real) as metric_value
		from
			[$(scd_v2017_002)].dbo.orbis_financials f JOIN
			vesper.calendar c ON c.period_year=f.y
		where
			c.period_type=@period_type
			and
			f.[type]=@metric_type
			--f.[financial_type_id]=@fi
	END

	RETURN
END


/*
USE [prv_dev_dth]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




ALTER FUNCTION [factordevelopment].[ufn_company_calendar_attribute_numeric]
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



--Bloomberg: BS_SH_OUT
--BS_TOT_ASSET
--CUR_MKT_CAP
--GROSS_PROFIT
--HIST_TRR_MONTHLY
--PX_LAST
--TOT_COMMON_EQY



	IF @metric_type IN ('BS_SH_OUT','BS_TOT_ASSET','CUR_MKT_CAP','GROSS_PROFIT','HIST_TRR_MONTHLY','PX_LAST','TOT_COMMON_EQY')
	BEGIN
		IF @period_type='M'
			INSERT @returntable
			SELECT
				c.id as calendar_id
				, c.period_type
				, c.period_label
				, cast(replace(e.entity_label,' Equity','') as nvarchar(50)) as bvd_id
				, cast(epm.metric_type as nvarchar(100)) as metric_type
				, cast(epm.metric_value as real) as metric_value
			FROM
				[$(bloomberg_v2017_000)].[bloomberg].[entity] e JOIN
				[$(bloomberg_v2017_000)].bloomberg.entity_period_metric epm ON e.[entity_id]=epm.[entity_id] JOIN
				[$(bloomberg_v2017_000)].[bloomberg].[period] p ON p.period_id=epm.period_id JOIN
				factordevelopment.calendar c ON c.period_year=p.period_year AND c.period_month=p.period_month
			WHERE
				c.period_type=@period_type
				AND
				epm.metric_type=@metric_type
	END

	IF @metric_type IN ('BiographyDiversity','CompanyTeamSize','AvgBiographLength')
	BEGIN
		INSERT @returntable
		select
			p.calendar_id
			, p.period_type
			, p.period_label
			, cast(tc.ticker as nvarchar(50)) as bvd_id
			, cast(ft.name as nvarchar(100)) as metric_type
			, cast(fts.factor_value as real) as metric_value
		from
			[$(AlphaFactorsDB)].[dbo].[factor_time_series] fts JOIN
			[$(AlphaFactorsDB)].[dbo].factor_type ft ON ft.id=fts.factor_type_id JOIN
			(select
				id
				, rank() over (partition by factor_type_id order by [end] desc) as r
			from
				[$(AlphaFactorsDB)].[dbo].[factor_run]
			where
				success=1
				and
				factor_type_id IN (1,7,8)
			) r ON r.id=fts.run_id JOIN
			(select
				p.id as alpha_period_key
				, c.id as calendar_id
				, c.period_label
				, c.period_type
			from
				[$(AlphaFactorsDB)].[dbo].[period] p JOIN
				[$(AlphaFactorsDB)].[dbo].[period_type] pt ON pt.id=p.period_type_id JOIN
				factordevelopment.calendar c ON c.period_year=cast(left(p.[value],4) as smallint)
			where
				c.period_type=@period_type
			) p ON p.alpha_period_key=fts.period_key JOIN
			[$(idr_linktables_v2017_002)].dbo.[linktable_ticker_to_cik] tc ON tc.cik=fts.entity_key
		where
			ft.name=@metric_type
			and
			fts.[factor_type_id] IN (1,7,8)
			and
			r.r=1 --order by ticker,y
	END

	IF @metric_type IN ('revenue','employees','loans_LOAN','non_current_liabilities_NCLI','intangible_fixed_assets','stock','debtors','creditors','other_fixed_assets_OFAS','capital','fixed_assets_FIAS','long_term_debt','EBIT')
	BEGIN
		INSERT @returntable
		select
			c.id as calendar_id
			, c.period_type
			, c.period_label
			, lb.ticker as bvd_id
			--, cast(f.[type] as nvarchar(100)) as metric_type
			, @metric_type as metric_type
			, cast(f.[value] as real) as metric_value
		from
			[$(idr_linktables_v2017_002)].dbo.linktable_ticker_to_bvd lb JOIN
			(select bvd_id, y, [value] from [$(scd_v2017_002)].dbo.orbis_financials where [type]=@metric_type) f ON lb.bvd_id=f.bvd_id JOIN
			(select id, period_type, period_label, period_year from factordevelopment.calendar where period_type=@period_type) c ON c.period_year=f.y 
			
		--where
--			c.period_type=@period_type
			--and
			--f.[type]=@metric_type
	END

	RETURN
END



GO



*/

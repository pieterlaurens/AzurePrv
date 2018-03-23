/* -- Implemented in a TVF
CREATE VIEW james.[company_calendar_attribute_numeric]
	AS
	SELECT
		c.id as calendar_id
		, c.period_type
		, c.period_label
		, cast(replace(e.entity_label,' Equity','') as nvarchar(50)) as bvd_id
		, epm.metric_type
		, epm.metric_value
	FROM
		[$(bloomberg_v2017_000)].[bloomberg].[entity] e JOIN
		[$(bloomberg_v2017_000)].bloomberg.entity_period_metric epm ON e.[entity_id]=epm.[entity_id] JOIN
		james.calendar c ON c.bloomberg_period_id=epm.period_id
	UNION
	select
		p.calendar_id
		, p.period_type
		, p.period_label
		, cast(tc.ticker as nvarchar(50)) as bvd_id
		, ft.name as metric_type
		, fts.factor_value as metric_value
	from
		[$(AlphaFactorsDB)].[dbo].[factor_time_series] fts JOIN
		[$(AlphaFactorsDB)].[dbo].factor_type ft ON ft.id=fts.factor_type_id JOIN
		(select
			id
			, rank() over (order by [end] desc) as r
		from
			[$(AlphaFactorsDB)].[dbo].[factor_run]
		where
			success=1
			and
			factor_type_id=1
		) r ON r.id=fts.run_id JOIN
		(select
			p.id as alpha_period_key
			, c.id as calendar_id
			, c.period_label
			, c.period_type
		from
			[$(AlphaFactorsDB)].[dbo].[period] p JOIN
			[$(AlphaFactorsDB)].[dbo].[period_type] pt ON pt.id=p.period_type_id JOIN
			james.calendar c ON c.period_year=p.[value]
		) p ON p.alpha_period_key=fts.period_key JOIN
		[$(idr_linktables_v2017_002)].dbo.[linktable_ticker_to_cik] tc ON tc.cik=fts.entity_key
	where
		fts.[factor_type_id]=1
		and
		r.r=1 --order by ticker,y
	UNION
	select
		c.id as calendar_id
		, c.period_type
		, c.period_label
		, cast(f.bvd_id as nvarchar(50)) as bvd_id
		, f.[type] as metric_type
		, f.[value] as metric_value
	from
		[$(scd_v2017_002)].dbo.orbis_financials f JOIN
		james.calendar c ON c.period_year=f.y JOIN
		[$(idr_linktables_v2017_002)].dbo.linktable_ticker_to_bvd lb ON lb.bvd_id=f.bvd_id*/
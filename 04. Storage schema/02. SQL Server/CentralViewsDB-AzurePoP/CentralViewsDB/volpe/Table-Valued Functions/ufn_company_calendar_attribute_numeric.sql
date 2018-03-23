



CREATE FUNCTION volpe.[ufn_company_calendar_attribute_numeric]
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

	IF @metric_type IN ('revenue','employees','loans_LOAN','non_current_liabilities_NCLI','intangible_fixed_assets','stock','debtors','creditors','other_fixed_assets_OFAS','capital','fixed_assets_FIAS','long_term_debt','EBIT')
	BEGIN
		INSERT @returntable
		select
			c.id as calendar_id
			, c.period_type
			, c.period_label
			, cast(f.bvd_id as nvarchar(50)) as bvd_id
			, @metric_type as metric_type
			, cast(f.[value] as real) as metric_value
		from
			[$(scd_v2017_005)].dbo.orbis_financials f JOIN
			volpe.calendar c ON c.period_year=f.y
		where
			c.period_type=@period_type
			and
			f.[type]=@metric_type
	END

	IF @metric_type = 'dummy' -- for high performance testing purposes
	BEGIN
		INSERT @returntable
		SELECT
			c.id AS calendar_id
			, c.period_type
			, c.period_label
			, CAST(f.bvd_id AS NVARCHAR(50)) AS bvd_id
			, @metric_type AS metric_type
			, cast(1.0 as real) AS metric_value
		FROM
			[$(scd_v2017_005)].dbo.orbis_basic f CROSS JOIN
			(SELECT TOP 10 * FROM volpe.calendar WHERE period_type=@period_type ORDER BY period_date DESC) c
	END

	RETURN
END
CREATE VIEW scaramanga.[calendar_attribute_numeric]
	AS
	SELECT c.id as calendar_id
	  , c.period_label
	  , na3fm.HML
	  , na3fm.MktRF
	  , na3fm.RF
	  , na3fm.sml
	  , na3fm.umd
	FROM 
		[$(french_data_library_v2017_003)].dbo.[us_4_factors]  na3fm JOIN
		scaramanga.calendar c ON c.period_month=cast(right(period,2) as int) and c.period_year=cast(left(period,4) as int)
	WHERE
		c.period_type='M' and na3fm.period_type='M'

CREATE VIEW [bacmap].[entity_links]
	AS 
	select distinct t0.[entity_id]
		, t0.bb_ticker
		, t.company_id as bvd_id
		, ob.company_name as company_name
	from 
		[$(bb_db)].[bloomberg].[entity] t0 left outer join
		[$(DataHandlerDb)].latest.company_ticker t ON t.bb_ticker=t0.bb_ticker LEFT OUTER JOIN
		[$(DataHandlerDb)].latest.company_basic ob ON ob.bvd_id=t.company_id

/*	left outer join
		[$(idr_db)].input.[linktable_Orbis_Bloomberg_ticker] t1
			on t0.entity_label = t1.[BB_ticker_exchange]

	left outer join 
		[$(scd_v2017_002)].[dbo].[orbis_basic] t2
			on t1.bvd_id = t2.bvd_id
*/
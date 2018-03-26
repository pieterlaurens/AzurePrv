

---------------------------------------------------------
--Check the log:
--  select * From report.event_log order by id desc
---------------------------------------------------------

--select * from report.mapping_action
--select * from [bloomberg].[line_item_custom_mapping]


--exec [BloombergRevenue_strategic].[bloomberg].[loadLineItemFullLineage]
--select * from [BloombergRevenue_strategic].[bloomberg].[line_item_lineage]

---------------------------------------------------------


--scrap: 

select * from [bacmap].[getEntityMapping]('US270756180', '2016-01-01')


select * from [bloomberg_development].[custom].[getCustomEntitySegmentationStatus]('US221024240', '2016-01-01', DEFAULT, DEFAULT)

select * from [prv_prj_momentumsdi].[bacmap].[getEntitySegmentation]('US221024240', '2016-01-01')

exec score.newScoreTable_load @debug = 1

select * from [bacmap].[custom_mapping] order by custom_mapping_display_order

select * from [report].[custom_mapping_history] where is_active = 1 order by custom_mapping_display_order



select * from bacmap.getEntitySegmentation('US221024240', '2015-01-01')

select * from [bacmap].getEntityMapping('US221024240', '2015-01-01')
select * from [bacmap].getEntityMapping('US221024240', '2016-01-01')

select * from [bacmap].[line_item_custom_mapping]


exec [bloomberg_development].[custom].[segmentationBloomberg_import] @bvd_id = 'US221024240', @target_period_id = '2016-01-01', @source_period_id = '2016-01-01'

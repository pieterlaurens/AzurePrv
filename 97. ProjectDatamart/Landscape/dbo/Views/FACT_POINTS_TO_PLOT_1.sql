CREATE VIEW [dbo].[FACT_POINTS_TO_PLOT_1] AS
SELECT NEWID() AS UniqueKey_FK, * FROM
	(SELECT DISTINCT
		dense_rank() over (order by node_score_series_group) AS LandscapeOverlay_ID
		, node_score_series_key AS SeriesToPlot_NAME
		, node_score_series_group AS SeriesToPlot_TYPE
		, n.node_key AS PointsToPlot_ID
		, np.node_x AS PointX
		, np.node_y AS PointY
		, npn.Size AS PointsToPlot_Value1
		, nsn.[Weight] AS PointsToPlot_Value2
		, nsn.[Relevance] AS PointsToPlot_Value3
		, isnull(npn.[Trend value],1) AS PointsToPlot_Value5
		
		, nps.[High Level Label] AS PointsToPlot_Label1
		, nps.[Extended label] AS PointsToPlot_Label2
		, nps.[Technology Class] AS PointsToPlot_Label3
		--, nps.[Label] AS PointsToPlot_Label4
		, nsn.[Prose] as PointsToPlot_Label4
		, nps.[High Level Label] AS PointsToPlot_Attribute1
		, nps.[Extended label] AS PointsToPlot_Attribute2
		, nps.[Trend] AS PointsToPlot_Attribute3
		, 1 AS DummyMeasure
	FROM
		ls_node AS n LEFT OUTER JOIN
		ls_node_position np ON np.node_key=n.node_key LEFT OUTER JOIN
		-----------------------------------------
		-- Numeric properties
		(select
			node_key
			, [Size],[Trend value]
		from	
			[dbo].[ls_node_property_numeric]
		pivot(
			max(node_property_value) for [node_property_type] in ([Size],[Trend value])
			) pvt
		) npn on npn.node_key=n.node_key LEFT OUTER JOIN
		-----------------------------------------
		-- String properties
		(select
			node_key
			, [Label],[Extended Label], [High Level Label],[Technology Class],[Trend]
		from	
			[dbo].[ls_node_property_str]
		pivot(
			max(node_property_value) for [node_property_type] in ([Label],[Extended Label], [High Level Label],[Technology Class],[Trend])
			) pvt
		) nps on nps.node_key=n.node_key LEFT OUTER JOIN
		-----------------------------------------
		-- Numeric scores
		(select
			node_key
			, 'All Classes' as node_score_series_group
			, 'All types' as node_score_series_key
			, 0.001 as [Weight]
			,1.0 as [Relevance]
			, '' as [Prose]
		from
			ls_node
		union all
		select n.node_key, n.node_score_series_group, n.node_score_series_key
			, n.[Weight],n.[Relevance], s.[Prose]
		from
			(select
				node_key, node_score_series_group, node_score_series_key
				, [Weight],[Relevance]
			from	
				[dbo].[ls_node_score_numeric]
			pivot(
				max(node_score_value) for [node_score_group] in ([Weight],[Relevance])
				) pvt
			) n LEFT OUTER JOIN
			(select
				node_key, node_score_series_group, node_score_series_key
				, node_score_value as [Prose]
			from	
				[dbo].[ls_node_score_str]
			) s ON s.node_key=n.node_key and s.[node_score_series_key]=n.[node_score_series_key]
		-----------------------------------------
		-- Custom metric profiles:
		union all
		select
			node_key, node_score_series_group, node_score_series_key
			, [Weight],[Relevance], CONCAT(node_score_series_key,' accounts for ',cast([Relevance] as int),' patents.') as [Prose]
		from	
			[custom].[ls_node_score_numeric]
		pivot(
			max(node_score_value) for [node_score_group] in ([Weight],[Relevance])
			) pvt
		--order by node_key, node_score_series_group
		) nsn on nsn.node_key=n.node_key
	) a
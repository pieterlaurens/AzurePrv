CREATE VIEW dbo.[CONFIG_TABLE_1] AS
SELECT        Table_Name, Column_Name_Generic, Column_Name_Custom, UseAsAndFilter
FROM            (         SELECT  'FACT_POINTS_TO_PLOT_1' AS Table_Name, 'PointsToPlot_Label1' AS Column_Name_Generic, 'Category' AS Column_Name_Custom, 1 AS UseAsAndFilter
                          UNION ALL
                          SELECT        'FACT_POINTS_TO_PLOT_1' AS Table_Name, 'PointsToPlot_Label2' AS Column_Name_Generic, 'Label' AS Column_Name_Custom, 0 AS UseAsAndFilter
                          UNION ALL
                          SELECT        'FACT_POINTS_TO_PLOT_1' AS Table_Name, 'PointsToPlot_Label3' AS Column_Name_Generic, 'Technology Class' AS Column_Name_Custom, 0 AS UseAsAndFilter
                          UNION ALL
                          SELECT        'FACT_POINTS_TO_PLOT_1' AS Table_Name, 'PointsToPlot_Label4' AS Column_Name_Generic, 'Description' AS Column_Name_Custom, 0 AS UseAsAndFilter
                          UNION ALL
                          SELECT  'FACT_POINTS_TO_PLOT_1' AS Table_Name, 'PointsToPlot_Attribute1' AS Column_Name_Generic, 'Label' AS Column_Name_Custom, 0 AS UseAsAndFilter
                          UNION ALL
                          SELECT        'FACT_POINTS_TO_PLOT_1' AS Table_Name, 'PointsToPlot_Attribute2' AS Column_Name_Generic, 'Label' AS Column_Name_Custom, 0 AS UseAsAndFilter
                          UNION ALL
                          SELECT        'FACT_POINTS_TO_PLOT_1' AS Table_Name, 'PointsToPlot_Attribute3' AS Column_Name_Generic, 'Trend' AS Column_Name_Custom, 1 AS UseAsAndFilter
                          UNION ALL
                          SELECT        'FACT_POINTS_TO_PLOT_1' AS Table_Name, 'PointsToPlot_Value1' AS Column_Name_Generic, 'Size' AS Column_Name_Custom, 0 AS UseAsAndFilter
                          UNION ALL
                          SELECT        'FACT_POINTS_TO_PLOT_1' AS Table_Name, 'PointsToPlot_Value2' AS Column_Name_Generic, 'Weight' AS Column_Name_Custom, 0 AS UseAsAndFilter
                          UNION ALL
                          SELECT        'FACT_POINTS_TO_PLOT_1' AS Table_Name, 'PointsToPlot_Value3' AS Column_Name_Generic, 'Relevance' AS Column_Name_Custom, 0 AS UseAsAndFilter
	          UNION ALL
SELECT DISTINCT 'FACT_POINTS_TO_PLOT_1'
	, CONCAT('PointsToPlot_Value',CAST(5+DENSE_RANK() OVER (ORDER BY node_property_type ASC) AS NVARCHAR(5)))
	, node_property_type
	, 0 AS UseAsAndFilter
FROM
	[custom].[ls_node_property_numeric]) AS a
CREATE VIEW dbo.FACT_POINTS_TO_DOWNLOAD AS
SELECT DISTINCT
  dense_rank() over (order by node_score_series_group) AS LandscapeOverlay_ID
  , node_score_series_key AS [Series Name]
  , node_score_series_group AS [Series Type]
  , n.node_key AS [Node Key]
  --, np.node_x AS PointX
  --, np.node_y AS PointY
  , npn.Size AS [Size]
  , nsn.[Weight] AS [Weight]
  , nsn.[Relevance] AS [Relevance]
  , npn.[Trend value] AS [Relative growthrate]
  , nps.[High Level Label] AS [High level label]
  , nps.[Extended label] AS [Long label]
  , nps.[Technology Class] AS [Class code]
  , nps.[Label] AS [Label]
  --, nps.[High Level Label] AS PointsToPlot_Attribute1
  --, nps.[Extended label] AS PointsToPlot_Attribute2
  , nps.[Trend] AS [Relative trend]
  --, 1 AS DummyMeasure
 FROM
  dbo.ls_node AS n LEFT OUTER JOIN
  dbo.ls_node_position np ON np.node_key=n.node_key LEFT OUTER JOIN
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
   , 0.01 as [Weight]
   ,1.0 as [Relevance]
  from
   dbo.ls_node
  union all
  select
   node_key, node_score_series_group, node_score_series_key
   , [Weight],[Relevance]
  from 
   [dbo].[ls_node_score_numeric]
  pivot(
   max(node_score_value) for [node_score_group] in ([Weight],[Relevance])
   ) pvt
  --order by node_key, node_score_series_group
  ) nsn on nsn.node_key=n.node_key
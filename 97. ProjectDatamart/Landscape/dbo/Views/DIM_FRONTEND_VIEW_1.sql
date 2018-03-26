CREATE VIEW dbo.[DIM_FRONTEND_VIEW_1] AS
SELECT        distinct LandscapeOverlay_ID, cast(LandscapeOverlay_ID as nvarchar(10)) + '. ' + [SeriesToPlot_TYPE] as [LandscapeOverlay_NAME]
FROM
dbo.FACT_POINTS_TO_PLOT_1
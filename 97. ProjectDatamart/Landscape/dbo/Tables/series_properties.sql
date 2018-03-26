CREATE TABLE [dbo].[series_properties] (
    [series_id]         INT            IDENTITY (1, 1) NOT NULL,
    [SeriesToPlot_NAME] NVARCHAR (100) NOT NULL,
    [stroke_color]      NVARCHAR (15)  NULL,
    [fill_color]        NVARCHAR (15)  NULL,
    [fill_override]     TINYINT        NULL,
    PRIMARY KEY CLUSTERED ([series_id] ASC)
);


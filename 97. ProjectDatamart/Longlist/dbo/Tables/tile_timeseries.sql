CREATE TABLE [dbo].[tile_timeseries] (
    [id]           INT             IDENTITY (1, 1) NOT NULL,
    [tile_id]      SMALLINT        NOT NULL,
    [tile_name]    NVARCHAR (50)   NULL,
    [bvd_id]       VARCHAR (50)    NOT NULL,
    [company_name] NVARCHAR (150)  NULL,
    [series_name]  NVARCHAR (100)  NOT NULL,
    [series_x]     NUMERIC (30)    NOT NULL,
    [series_y]     NUMERIC (30, 3) NULL,
    [series_seq]   SMALLINT        NULL,
    PRIMARY KEY CLUSTERED ([tile_id] ASC, [bvd_id] ASC, [series_name] ASC, [series_x] ASC)
);


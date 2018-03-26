CREATE TABLE [dbo].[tile_profile] (
    [id]             INT             IDENTITY (1, 1) NOT NULL,
    [tile_id]        SMALLINT        NOT NULL,
    [tile_name]      NVARCHAR (50)   NULL,
    [bvd_id]         VARCHAR (50)    NOT NULL,
    [company_name]   NVARCHAR (150)  NULL,
    [series_name]    NVARCHAR (100)  NOT NULL,
    [category]       NVARCHAR (100)  NOT NULL,
    [category_short] NVARCHAR (25)   NULL,
    [category_seq]   SMALLINT        NOT NULL,
    [series_value]   NUMERIC (30, 3) NULL,
    PRIMARY KEY CLUSTERED ([tile_id] ASC, [bvd_id] ASC, [series_name] ASC, [category_seq] ASC)
);


CREATE TABLE [dbo].[tile_attribute] (
    [id]                        INT            IDENTITY (1, 1) NOT NULL,
    [tile_id]                   SMALLINT       NOT NULL,
    [tile_name]                 NVARCHAR (50)  NULL,
    [bvd_id]                    VARCHAR (50)   NOT NULL,
    [company_name]              NVARCHAR (150) NULL,
    [attribute_name]            NVARCHAR (500) NOT NULL,
    [attribute_seq]             SMALLINT       NOT NULL,
    [attribute_value]           NVARCHAR (MAX) NULL,
    [attribute_benchmark_value] NVARCHAR (MAX) NULL,
    [attribute_link]            NVARCHAR (500) NULL,
    PRIMARY KEY CLUSTERED ([tile_id] ASC, [bvd_id] ASC, [attribute_seq] ASC)
);


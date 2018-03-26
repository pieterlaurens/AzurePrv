CREATE TABLE [dbo].[tile_event_stream] (
    [id]                  INT            IDENTITY (1, 1) NOT NULL,
    [tile_id]             SMALLINT       NOT NULL,
    [tile_name]           NVARCHAR (50)  NULL,
    [bvd_id]              VARCHAR (50)   NOT NULL,
    [company_name]        NVARCHAR (150) NULL,
    [event_id]            NVARCHAR (100) NOT NULL,
    [event_seq]           SMALLINT       NULL,
    [event_attribute]     NVARCHAR (25)  NOT NULL,
    [event_attribute_seq] SMALLINT       NOT NULL,
    [event_value]         NVARCHAR (MAX) NULL,
    [event_date]          DATE           NULL,
    [event_type]          NVARCHAR (25)  NULL,
    PRIMARY KEY CLUSTERED ([tile_id] ASC, [bvd_id] ASC, [event_id] ASC, [event_attribute_seq] ASC)
);




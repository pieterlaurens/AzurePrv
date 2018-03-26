CREATE TABLE [dbo].[company_score] (
    [score_id]           INT            IDENTITY (1, 1) NOT NULL,
    [score_generic_name] AS             (concat('a',right('00000'+CONVERT([varchar](5),[score_id]),(5)))),
    [score_label]        NVARCHAR (100) NULL,
    [is_numeric]         BIT            NULL,
    [display_in_fe]      BIT            DEFAULT ((1)) NULL,
    [column_order]       SMALLINT       NULL,
    [data_type]          NVARCHAR (25)  NULL,
    [flex_width]         SMALLINT       DEFAULT ((4)) NULL,
    [default_scale]      INT            DEFAULT ((3)) NULL,
    [precision]          INT            DEFAULT ((2)) NULL,
    [unit]               NVARCHAR (10)  NULL,
    [uni_polar]          BIT            DEFAULT ((1)) NULL, 
    [is_temporal] BIT NULL DEFAULT ((0)), 
    [score_version] NVARCHAR(50) NULL
);


CREATE TABLE [dbo].[longlist_column_groups] (
    [score_label]       NVARCHAR (100) NOT NULL,
    [column_group_name] NVARCHAR (50)  NOT NULL,
    [default_visible]   TINYINT        DEFAULT ((1)) NOT NULL,
    PRIMARY KEY CLUSTERED ([score_label] ASC, [column_group_name] ASC)
);


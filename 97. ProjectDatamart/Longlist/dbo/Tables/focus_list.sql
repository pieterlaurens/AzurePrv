CREATE TABLE [dbo].[focus_list] (
    [focuslist_id] INT            IDENTITY (1, 1) NOT NULL,
    [label]        NVARCHAR (255) NOT NULL,
    [created_by]   NVARCHAR (50)  NOT NULL,
    [created_on]   DATETIME       NOT NULL,
    [status]       NVARCHAR (15)  DEFAULT ('open') NOT NULL,
    [comment]      NVARCHAR (500) NULL,
    PRIMARY KEY CLUSTERED ([focuslist_id] ASC)
);


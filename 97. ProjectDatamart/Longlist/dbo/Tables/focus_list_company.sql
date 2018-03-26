CREATE TABLE [dbo].[focus_list_company] (
    [id]           INT           IDENTITY (1, 1) NOT NULL,
    [focuslist_id] INT           NULL,
    [company_id]   NVARCHAR (50) NULL,
    PRIMARY KEY CLUSTERED ([id] ASC)
);


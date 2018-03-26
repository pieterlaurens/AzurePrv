CREATE TABLE [dbo].[manual_scoring_action] (
    [id]             INT            IDENTITY (1, 1) NOT NULL,
    [score_label]    NVARCHAR (100) NOT NULL,
    [scoring_string] NVARCHAR (MAX) NULL,
    [executed_on]    DATETIME       DEFAULT (getdate()) NOT NULL,
    [executed_by]    NVARCHAR (100) NULL,
    [status]         NVARCHAR (10)  NULL,
    [modified_on]    DATETIME       NULL,
    PRIMARY KEY CLUSTERED ([id] ASC)
);


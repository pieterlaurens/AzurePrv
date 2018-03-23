CREATE TABLE [ivh].[resource] (
    [id]          SMALLINT       IDENTITY (1, 1) NOT NULL,
    [name]        NVARCHAR (64)  NOT NULL,
    [description] NVARCHAR (256) NOT NULL,
    [version]     NVARCHAR (16)  NOT NULL,
    PRIMARY KEY CLUSTERED ([id] ASC)
);


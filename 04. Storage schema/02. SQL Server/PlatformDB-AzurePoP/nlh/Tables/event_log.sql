CREATE TABLE [nlh].[event_log] (
    [id]          SMALLINT       IDENTITY (1, 1) NOT NULL,
    [name]        NVARCHAR (64)  NOT NULL,
    [description] NVARCHAR (128) NOT NULL,
    PRIMARY KEY CLUSTERED ([id] ASC)
);


CREATE TABLE [nlh].[log] (
    [id]          BIGINT           IDENTITY (1, 1) NOT NULL,
    [component]   NVARCHAR (50)    NOT NULL,
    [source_type] NVARCHAR (10)    NULL,
    [source_name] NVARCHAR (50)    NULL,
    [source_id]   UNIQUEIDENTIFIER NULL,
    [message]     NVARCHAR (1024)  NULL,
    [action]      NVARCHAR (10)    NULL,
    [status]      NVARCHAR (10)    NULL,
    [rowcount]    INT              DEFAULT ((0)) NOT NULL,
    [added_on]    DATETIME2 (7)    DEFAULT (getdate()) NOT NULL,
    [added_by]    [sysname]        DEFAULT (user_name()) NOT NULL,
    PRIMARY KEY CLUSTERED ([id] ASC)
);




CREATE TABLE [ivh].[run_execvalue] (
    [run_id]      INT              NOT NULL,
    [exectree_id] UNIQUEIDENTIFIER NOT NULL,
    [key]         SYSNAME        NOT NULL,
    [datatype]    SYSNAME        NOT NULL,
    [value]       NVARCHAR (MAX)   NULL,
    [created_on]  DATETIME2 (7)    DEFAULT (getdate()) NOT NULL,
    [created_by]  SYSNAME        DEFAULT (user_name()) NOT NULL,
    CONSTRAINT [PK_ivh_run_execvalue] PRIMARY KEY CLUSTERED ([run_id] ASC, [exectree_id] ASC, [key] ASC)
);


CREATE TABLE [ivh].[run_exectree] (
    [id]            UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [run_id]        INT              NOT NULL,
    [caller_api_id] INT              NOT NULL,
    [callee_api_id] INT              NOT NULL,
    [sequence]      NVARCHAR (512)   NOT NULL,
    [server]        [sysname]        NOT NULL,
    [entry_point]   NVARCHAR (255)   NOT NULL,
    [type]          NVARCHAR (50)    NOT NULL,
    [dependent_on]  NVARCHAR (512)   NULL,
    [created_on]    DATETIME2 (7)    DEFAULT (getdate()) NOT NULL,
    [created_by]    [sysname]        DEFAULT (user_name()) NOT NULL,
    CONSTRAINT [PK_ivh_run_exectree] PRIMARY KEY CLUSTERED ([id] ASC)
);






CREATE TABLE [ivh].[run_paramvalue] (
    [run_id]     INT            NOT NULL,
    [parameter]  SYSNAME  NOT NULL,
    [value]      NVARCHAR (MAX) NOT NULL,
    [created_on] DATETIME2 (7)  DEFAULT (getdate()) NOT NULL,
    [created_by] SYSNAME      DEFAULT (user_name()) NOT NULL,
    CONSTRAINT [PK_ivh_run_paramvalue] PRIMARY KEY CLUSTERED ([run_id] ASC, [parameter] ASC)
);




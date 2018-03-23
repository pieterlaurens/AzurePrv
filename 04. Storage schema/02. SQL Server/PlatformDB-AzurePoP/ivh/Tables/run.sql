CREATE TABLE [ivh].[run] (
    [id]          INT           IDENTITY (1, 1) NOT NULL,
    [api]         SYSNAME		NOT NULL,
    [status]      SYSNAME		NOT NULL,
	[caller_type] SYSNAME		NOT NULL,
	[caller_id]	  NVARCHAR (50)	NOT NULL,
    [created_on]  DATETIME2 (7) DEFAULT (getdate()) NOT NULL,
    [created_by]  SYSNAME     DEFAULT (user_name()) NOT NULL,
    [modified_on] DATETIME2 (7) DEFAULT (getdate()) NOT NULL,
    [modified_by] SYSNAME     DEFAULT (user_name()) NOT NULL,
    CONSTRAINT [PK_ivh_run] PRIMARY KEY CLUSTERED ([id] ASC)
);




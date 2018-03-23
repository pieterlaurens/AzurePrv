CREATE TABLE [ivh].[api] (
    [id]                  INT            IDENTITY (1, 1) NOT NULL,
    [solution]            SYSNAME		 NOT NULL,
    [api]                 SYSNAME		 NOT NULL,
    [public]              BIT            NOT NULL,
    [server]              SYSNAME		 NOT NULL,
    [entry_point]         NVARCHAR (255) NOT NULL,
    [parameters]          NVARCHAR (512) NULL,
    [type]                NVARCHAR (50)  NOT NULL,
    [run_as]              SYSNAME	     NULL,
    [runtime_mode]        NCHAR (6)      DEFAULT ('64-bit') NULL,
    [wait_for_completion] BIT            DEFAULT ((0)) NOT NULL,
    PRIMARY KEY CLUSTERED ([id] ASC),
    CHECK ([runtime_mode]='64-bit' OR [runtime_mode]='32-bit')
);






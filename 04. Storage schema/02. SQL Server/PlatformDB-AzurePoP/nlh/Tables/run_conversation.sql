CREATE TABLE [nlh].[run_conversation] (
    [id]            UNIQUEIDENTIFIER NOT NULL,
    [run_id]        INT              NOT NULL,
    [from_service]  [sysname]        NOT NULL,
    [to_service]    [sysname]        NOT NULL,
    [on_contract]   [sysname]        NOT NULL,
    [handle_init]   UNIQUEIDENTIFIER NOT NULL,
    [group_init]    UNIQUEIDENTIFIER NOT NULL,
    [handle_target] UNIQUEIDENTIFIER NOT NULL,
    [group_target]  UNIQUEIDENTIFIER NOT NULL,
    [state_desc]    NVARCHAR (60)    NULL,
    PRIMARY KEY CLUSTERED ([run_id] ASC, [from_service] ASC, [to_service] ASC, [on_contract] ASC)
);






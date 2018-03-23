CREATE TABLE [ivh].[api_configitem] (
    [id]           INT            IDENTITY (1, 1) NOT NULL,
    [api_id]       INT            NOT NULL,
    [item_type]    [sysname]      NOT NULL,
    [item_key]     [sysname]      NOT NULL,
    [item_default] NVARCHAR (MAX) NULL,
    [description]  NVARCHAR (512) NULL,
    CONSTRAINT [PK_ivh_api_configitem] PRIMARY KEY CLUSTERED ([id] ASC)
);




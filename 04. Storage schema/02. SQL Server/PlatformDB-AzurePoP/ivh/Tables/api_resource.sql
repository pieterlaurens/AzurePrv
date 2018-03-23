CREATE TABLE [ivh].[api_resource] (
    [api_id]      INT NOT NULL,
    [resource_id] INT NOT NULL,
    CONSTRAINT [PK_ivh_api_resource] PRIMARY KEY CLUSTERED ([api_id] ASC, [resource_id] ASC)
);


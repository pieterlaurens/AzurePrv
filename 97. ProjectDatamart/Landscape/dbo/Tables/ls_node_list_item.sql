CREATE TABLE [dbo].[ls_node_list_item] (
    [node_key]       INT            NOT NULL,
    [item_type]      NVARCHAR (50)  NOT NULL,
    [item_rank]      SMALLINT       NOT NULL,
    [item_id]        NVARCHAR (100) NULL,
    [item_attribute] NVARCHAR (100) NOT NULL,
    [item_value]     NVARCHAR (MAX) NULL,
    PRIMARY KEY CLUSTERED ([node_key] ASC, [item_type] ASC, [item_rank] ASC, [item_attribute] ASC)
);


CREATE TABLE [dbo].[ls_node_distance] (
    [class1_id]   INT  NOT NULL,
    [class2_id]   INT  NOT NULL,
    [sim]         REAL NULL,
    [n_intersect] INT  NULL,
    [n_union]     INT  NULL,
    [class1_size] INT  NOT NULL,
    [class2_size] INT  NOT NULL,
    PRIMARY KEY CLUSTERED ([class1_id] ASC, [class2_id] ASC)
);


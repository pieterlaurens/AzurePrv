CREATE TABLE [dbo].[ls_node_score_str] (
    [node_key]                INT            NOT NULL,
    [node_score_group]        NVARCHAR (100) NOT NULL,
    [node_score_series_group] NVARCHAR (100) NULL,
    [node_score_series_key]   NVARCHAR (100) NOT NULL,
    [node_score_view]         NVARCHAR (100) NULL,
    [node_score_value]        NVARCHAR (MAX) NOT NULL
);


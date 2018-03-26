CREATE TABLE [dbo].[company_time_score_int] (
    [company_id]  NVARCHAR (50) NOT NULL,
    [score_name]  NVARCHAR (50) NOT NULL,
    [score_time]  INT           NOT NULL,
    [score_value] BIGINT        NULL
);

GO
CREATE NONCLUSTERED INDEX nix_ctsi
    ON [dbo].[company_time_score_int]([score_name] ASC);


GO
CREATE CLUSTERED INDEX ix_ctsi
    ON [dbo].[company_time_score_int]([company_id] ASC, [score_name] ASC, score_time ASC);

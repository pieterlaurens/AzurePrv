CREATE TABLE [dbo].[company_time_score_real] (
    [company_id]  NVARCHAR (50) NOT NULL,
    [score_name]  NVARCHAR (50) NOT NULL,
    [score_time]  INT           NOT NULL,
    [score_value] REAL          NULL
);

GO
CREATE NONCLUSTERED INDEX nix_ctsr
    ON [dbo].[company_time_score_real]([score_name] ASC);


GO
CREATE CLUSTERED INDEX ix_ctsr
    ON [dbo].[company_time_score_real]([company_id] ASC, [score_name] ASC, score_time ASC);
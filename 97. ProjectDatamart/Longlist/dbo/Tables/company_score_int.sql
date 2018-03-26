CREATE TABLE [dbo].[company_score_int] (
    [company_id]  NVARCHAR (50) NOT NULL,
    [score_name]  NVARCHAR (50) NOT NULL,
    [score_value] BIGINT        NULL
);




GO
CREATE CLUSTERED INDEX ix_csi
    ON [dbo].[company_score_int]([company_id] ASC, [score_name] ASC);

GO
CREATE NONCLUSTERED INDEX nix_csi
    ON [dbo].[company_score_int]([score_name] ASC);

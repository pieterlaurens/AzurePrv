CREATE TABLE [dbo].[company_score_real] (
    [company_id]  NVARCHAR (50) NOT NULL,
    [score_name]  NVARCHAR (50) NOT NULL,
    [score_value] REAL          NULL
);




GO
CREATE NONCLUSTERED INDEX nix_csr
    ON [dbo].[company_score_real]([score_name] ASC);


GO
CREATE CLUSTERED INDEX ix_csr
    ON [dbo].[company_score_real]([company_id] ASC, [score_name] ASC);


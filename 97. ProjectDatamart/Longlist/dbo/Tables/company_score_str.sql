CREATE TABLE [dbo].[company_score_str] (
    [company_id]  NVARCHAR (50)  NOT NULL,
    [score_name]  NVARCHAR (50)  NOT NULL,
    [score_value] NVARCHAR (MAX) NULL
);




GO
CREATE CLUSTERED INDEX ix_css
    ON [dbo].[company_score_str]([company_id] ASC, [score_name] ASC);
	
GO
CREATE NONCLUSTERED INDEX nix_css
    ON [dbo].[company_score_str]([score_name] ASC);



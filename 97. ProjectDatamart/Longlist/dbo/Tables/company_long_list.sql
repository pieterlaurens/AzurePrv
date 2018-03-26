CREATE TABLE [dbo].[company_long_list] (
    [row_i]         INT            IDENTITY (1, 1) NOT NULL,
    [company_id]    NVARCHAR (50)  NOT NULL PRIMARY KEY,
    [match]         REAL           NULL,
    [company_name]  NVARCHAR (255) NULL,
    [retrieval_key] NVARCHAR (50)  NULL
);


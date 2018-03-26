CREATE TABLE [questionnaire].[user_answer] (
    [id]          INT             IDENTITY (1, 1) NOT NULL,
    [bvd_id]      VARCHAR (25)    NOT NULL,
    [id_question] INT             NOT NULL,
    [is_latest]   BIT             DEFAULT ((1)) NOT NULL,
    [text_answer] NVARCHAR (MAX)  NULL,
    [added_on]    DATETIME2 (7)   DEFAULT (getdate()) NOT NULL,
    [added_by]    NVARCHAR (100)  NULL,
    [status]      NVARCHAR (10)   NULL,
    [reference]   NVARCHAR (1000) NULL,
    [comment]     NVARCHAR (MAX)  NULL,
	[valid_fiscal_year_at_answering] varchar(25) NULL, -- temporary fix, to ensure reporting is available in the future.
    PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [fk_question_constraint] FOREIGN KEY ([id_question]) REFERENCES [questionnaire].[question] ([id]) ON DELETE CASCADE ON UPDATE CASCADE
);


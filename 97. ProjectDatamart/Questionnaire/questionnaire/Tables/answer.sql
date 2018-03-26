CREATE TABLE [questionnaire].[answer] (
    [id]               INT            IDENTITY (1, 1) NOT NULL,
    [question_id]      INT            NOT NULL,
    [text]             NVARCHAR (500) NOT NULL,
    [value]            NVARCHAR (150) NOT NULL,
    [order]            SMALLINT       NOT NULL,
    [linked_questions] NVARCHAR (200) NULL,
    [report_text]      NVARCHAR (500) NULL,
    [show_reference]   BIT            CONSTRAINT [DF_answer_show_reference] DEFAULT ((0)) NOT NULL,
    [show_comment]     BIT            CONSTRAINT [DF_answer_show_comment] DEFAULT ((0)) NOT NULL,
    CONSTRAINT pk_answer PRIMARY KEY CLUSTERED ([id] ASC)
);


CREATE TABLE [questionnaire].[question_tab] (
    [id]          INT IDENTITY (1, 1) NOT NULL,
    [question_id] INT NOT NULL,
    [tab_id]      INT NOT NULL,
    [sequence]    INT CONSTRAINT [DF_question_tab_sequence] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_question_tab] PRIMARY KEY CLUSTERED ([id] ASC)
);


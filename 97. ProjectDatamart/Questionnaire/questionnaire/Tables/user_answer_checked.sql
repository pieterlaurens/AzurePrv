CREATE TABLE [questionnaire].[user_answer_checked] (
    [id]             INT             IDENTITY (1, 1) NOT NULL,
    [id_answer]      INT             NOT NULL,
    [id_user_answer] INT             NOT NULL,
    [reference]      NVARCHAR (1000) NULL,
    [comment]        NVARCHAR (MAX)  NULL,
    PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [fk_answer_constraint] FOREIGN KEY ([id_answer]) REFERENCES [questionnaire].[answer] ([id]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [fk_user_answer_constraint] FOREIGN KEY ([id_user_answer]) REFERENCES [questionnaire].[user_answer] ([id]) ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE [questionnaire].[faq] (
    [id]          INT            IDENTITY (1, 1) NOT NULL,
    [tab_ids]     VARCHAR (50)   NULL,
    [question]    NVARCHAR (250) NOT NULL,
    [answer_html] NVARCHAR (MAX) NOT NULL,
    CONSTRAINT [PK_questionnaire_faq] PRIMARY KEY CLUSTERED ([id] ASC)
);


CREATE TABLE [questionnaire].[question] (
    [id]                  INT            IDENTITY (1, 1) NOT NULL,
    [input_type]          VARCHAR (15)   NOT NULL,
    [data_type]           VARCHAR (15)   NOT NULL,
    [label]               NVARCHAR (500) NOT NULL,
    [sidenote]            NVARCHAR (MAX) NULL,
    [score_name]          NVARCHAR (50)  NOT NULL,
    [default_value]       NVARCHAR (150) NULL,
    [order]               SMALLINT       NOT NULL,
    [is_linked]           BIT            NOT NULL,
    [required]            BIT            CONSTRAINT [DF_company_question_required] DEFAULT ((1)) NOT NULL,
    [show_reference]      BIT            CONSTRAINT [DF_question_show_reference] DEFAULT ((0)) NOT NULL,
    [show_comment]        BIT            CONSTRAINT [DF_question_show_comment] DEFAULT ((0)) NOT NULL,
    [show_in_longlist]    BIT            CONSTRAINT [DF_question_show_in_longlist] DEFAULT ((0)) NOT NULL,
    [show_prefill_button] BIT            CONSTRAINT [DF_question_show_prefill_button] DEFAULT ((0)) NOT NULL,
    CONSTRAINT pk_question PRIMARY KEY CLUSTERED ([id] ASC)
);


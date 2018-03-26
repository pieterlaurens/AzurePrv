CREATE TABLE [questionnaire].[report_map] (
    [id]               INT           IDENTITY (1, 1) NOT NULL,
    [question_id]      INT           NOT NULL,
    [part]             VARCHAR (100) NOT NULL,
    [url_to_reference] BIT           CONSTRAINT [DF_report_map_url_to_reference] DEFAULT ((1)) NOT NULL,
    PRIMARY KEY CLUSTERED ([id] ASC)
);


CREATE TABLE [questionnaire].[company_tab] (
    [id]     INT           IDENTITY (1, 1) NOT NULL,
    [bvd_id] NVARCHAR (25) NOT NULL,
    [tab_id] INT           NOT NULL,
    [state]  INT           CONSTRAINT [DF_company_tab_state] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_company_tab] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'bitarray: editable = 1,started_edit = 2, finished = 4, active = 8,', @level0type = N'SCHEMA', @level0name = N'questionnaire', @level1type = N'TABLE', @level1name = N'company_tab', @level2type = N'COLUMN', @level2name = N'state';


CREATE TABLE [questionnaire].[tab] (
    [id]                     INT           IDENTITY (1, 1) NOT NULL,
    [label]                  NVARCHAR (25) NOT NULL,
    [default_state]          INT           CONSTRAINT [DF_tab_default_state] DEFAULT ((0)) NOT NULL,
    [editable_on_tab_finish] NVARCHAR (50) NULL,
    CONSTRAINT [PK_tab] PRIMARY KEY CLUSTERED ([id] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'bitarray: editable = 1,started_edit = 2, finished = 4, active = 8,', @level0type = N'SCHEMA', @level0name = N'questionnaire', @level1type = N'TABLE', @level1name = N'tab', @level2type = N'COLUMN', @level2name = N'default_state';


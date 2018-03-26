CREATE TABLE [report].[mapping_action]
(
    [id]                 INT            IDENTITY (1, 1) NOT NULL,
    [executed_on]		 DATETIME		 NOT NULL DEFAULT(GETDATE()) ,
    [executed_by]        VARCHAR (50)    NOT NULL,
    [action_type_id]     TINYINT         NOT NULL,
	[line_item_custom_mapping_id] INT	 NULL,
    [row_count]          BIGINT          NULL,
    [description]        NVARCHAR (500)  NULL
) --ON DATA;


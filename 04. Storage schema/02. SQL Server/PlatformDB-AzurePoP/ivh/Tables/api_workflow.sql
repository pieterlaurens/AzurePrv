CREATE TABLE [ivh].[api_workflow] (
    [caller_api_id]		INT NOT NULL,
    [callee_api_id]		INT  NOT NULL,
	[sequence]			SMALLINT NOT NULL,
    [dependent_on]      NVARCHAR (512) NULL
);


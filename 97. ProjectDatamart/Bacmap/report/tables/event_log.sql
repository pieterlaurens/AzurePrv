CREATE TABLE report.event_log (
    [id]          INT            IDENTITY (1, 1) NOT NULL,
    [component]   NVARCHAR (50)  NOT NULL,
    [source_type] NVARCHAR (10)  NULL,
    [source_name] NVARCHAR (50)  NULL,
    [message]     NVARCHAR (4000) NULL,
    [action]      NVARCHAR (10)  NULL,
    [status]      NVARCHAR (10)  NULL,
    [rowcount]    INT            DEFAULT ((0)) NOT NULL,
    [added_on]    DATETIME       DEFAULT (getdate()) NOT NULL,
    [added_by]    NVARCHAR (50)  DEFAULT (user_name()) NOT NULL,
    CONSTRAINT [PK_log] PRIMARY KEY CLUSTERED ([id] ASC)
			) --ON DATA
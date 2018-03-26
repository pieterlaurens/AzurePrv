CREATE TABLE [report].[test_report](
	[api] [varchar](100) NULL,
	[test_result] [varchar](10) NULL,
	[test_name] [varchar](50) NULL,
	[test_comment] [varchar](1000) NULL,
	[executed_on] [datetime] NULL DEFAULT getdate(),
	[run_id] [int] NULL,
	[component_id] [nvarchar](50) NULL
) ON [PRIMARY]
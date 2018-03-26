CREATE TABLE report.dq_stats(
	[id] [int] IDENTITY(1,1) NOT NULL,
	[dq_metric] [nvarchar](max) NULL,
	[dq_value1] [nvarchar](max) NULL,
	[dq_value2] [nvarchar](max) NULL,
	[section] [nvarchar](500) NULL,
	[type] [nvarchar](500) NULL,
	[version] [smallint] NULL,
)
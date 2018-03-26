CREATE TABLE [report].[requested_profile](
	[run_id] [int] NULL,
	[bag_of_words] [nvarchar](1000) NULL,
	[minimal_class_size] [int] NULL,
	[number_of_classes] [int] NULL,
	[profile_criterion] [nvarchar](100) NULL,
	[profile_type] [nvarchar](100) NULL,
	[scope_to_project] [bit] NULL,
	[class_code] [nvarchar](50) NULL,
	[keyword_count] [int] NULL,
	[keyword_weight] [real] NULL
)
CREATE TABLE hotness.[investor_preference]
(
	[preference_id] INT IDENTITY(1,1) NOT NULL,
	topic_id	INT NOT NULL,
	workspace_id INT NOT NULL,
	area_label varchar(150) not null,
	[preference_group]			nvarchar(500) NULL,
	[citations_top10pct] real null
	, constraint pk_ip primary key (preference_id)
)

CREATE TABLE hotness.[technology] (
    [technology_id]             INT            IDENTITY (1, 1) NOT NULL,
	topic_id	INT NOT NULL,
	workspace_id INT NOT NULL,
    [label]                     NVARCHAR (500) NULL,
	[technology_group]			nvarchar(500) NULL,
    [citations_top10pct] real null,
    CONSTRAINT pk_technology PRIMARY KEY CLUSTERED ([technology_id] ASC)
);


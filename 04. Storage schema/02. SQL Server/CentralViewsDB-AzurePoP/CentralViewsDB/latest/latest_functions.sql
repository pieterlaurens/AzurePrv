CREATE FUNCTION latest.ufn_company_calendar_attribute_numeric
(
	@metric_type nvarchar(100)
	, @period_type char(1)
)
RETURNS @returntable TABLE
(
	calendar_id INT
	, period_type CHAR(1)
	, period_label VARCHAR(10)
	, bvd_id NVARCHAR(50)
	, metric_type NVARCHAR(100)
	, metric_value REAL
)
AS
BEGIN
	insert @returntable select * from volpe.ufn_company_calendar_attribute_numeric(@metric_type, @period_type)
	RETURN
END
GO

CREATE FUNCTION latest.[ufn_company_text]
(
	@contains_clause nvarchar(4000),
	@add_double_quotes bit = 1
)
RETURNS @returntable TABLE
(
	company_id nvarchar(50)
)
AS
BEGIN
	insert @returntable select * from volpe.ufn_company_text(@contains_clause, @add_double_quotes)
	RETURN
END

GO
CREATE FUNCTION latest.ufn_patent_text
(
	@contains_clause nvarchar(4000),
	@add_double_quotes bit = 1
)
RETURNS @returntable TABLE
(
	patent_family_id int,
	patent_application_id int
)
AS
BEGIN
	insert @returntable select * from volpe.ufn_patent_text(@contains_clause, @add_double_quotes)
	RETURN
END

GO
CREATE FUNCTION latest.[ufn_keyword_patent_class_profile]
(
	@contains_clause nvarchar(4000),
	@add_double_quotes bit = 1
)
RETURNS @returntable TABLE
(
	class_id int,
	keyword_count int,
	keyword_weight real,
	class_label nvarchar(500),
	class_size int,
	class_code nvarchar(16)
)
AS
BEGIN
	insert @returntable select * from volpe.[ufn_keyword_patent_class_profile](@contains_clause, @add_double_quotes)
	RETURN
END

GO
CREATE FUNCTION latest.[ufn_company_text_topic]
(
	@topic_name nvarchar(4000)
)
RETURNS @returntable TABLE
(
	company_id varchar(25),
	score_value real,
	es_task_id int
)
AS
BEGIN
	insert @returntable select * from volpe.ufn_company_text_topic(@topic_name)
	RETURN
END

GO
CREATE FUNCTION latest.[ufn_sec_text_topic]
(
	@topic_name nvarchar(4000)
)
RETURNS @returntable TABLE
(
	company_id varchar(25),
	score_value real,
	es_task_id int
)
AS
BEGIN
	insert @returntable select * from volpe.ufn_sec_text_topic(@topic_name)
	RETURN
END

GO
CREATE FUNCTION latest.ufn_patent_text_topic
(
	@topic_name nvarchar(4000)
)
RETURNS @returntable TABLE
(
	patent_family_id int,
	score_value real,
	es_task_id int
)
AS
BEGIN
	insert @returntable select * from volpe.ufn_patent_text_topic(@topic_name)
	RETURN
END

GO
CREATE FUNCTION latest.ufn_web_text_topic
(
	@topic_name nvarchar(4000)
)
RETURNS @returntable TABLE
(
	website nvarchar(200),
	score_value real,
	es_task_id int
)
AS
BEGIN
	insert @returntable select * from volpe.ufn_web_text_topic(@topic_name)
	RETURN
END

GO
CREATE FUNCTION latest.[ufn_pubmed_text_topic]
(
	@topic_name nvarchar(4000)
)
RETURNS @returntable TABLE
(
	pmid int,
	score_value real,
	es_task_id int
)
AS
BEGIN
	insert @returntable select * from volpe.[ufn_pubmed_text_topic](@topic_name)
	RETURN
END

GO
CREATE FUNCTION [latest].[get_source_version]
(
	@source_type varchar(25)
)
RETURNS VARCHAR(50)
AS
BEGIN
	RETURN volpe.get_source_version(@source_type)
END

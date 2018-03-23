CREATE FUNCTION [felix].[ufn_keyword_patent_class_profile]
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
	INSERT @returntable
	SELECT * FROM [$(pw15b_cpc)].dbo.keywordCpcProfile(@contains_clause,@add_double_quotes)
	RETURN
END

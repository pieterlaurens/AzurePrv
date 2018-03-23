CREATE FUNCTION [james].[ufn_patent_text]
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
	if(@add_double_quotes=1)
		set @contains_clause = '"'+@contains_clause+'"'
	
	INSERT @returntable
	SELECT --top 100000
		fat.inpadoc_family_id as patent_family_id
		, fat.appln_id as patent_application_id
	FROM
		[$(pw_v2016b_001)].patstat.family_application_text fat JOIN
		[$(pw_v2016b_001)].patstat.family_metric fm ON fm.inpadoc_family_id=fat.inpadoc_family_id
	where
		fm.priority_year < 9000
		and
		contains((application_abstract,application_title),@contains_clause)
	order by
		fm.priority_year desc
	RETURN
END

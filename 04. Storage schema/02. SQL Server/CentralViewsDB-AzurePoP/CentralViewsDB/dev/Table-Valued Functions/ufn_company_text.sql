CREATE FUNCTION [dev].[ufn_company_text]
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
	if(@add_double_quotes=1)
		set @contains_clause = '"'+@contains_clause+'"'

	INSERT @returntable
	SELECT
		bvd_id as company_id
	FROM
		[$(scd_v2017_004)].dbo.orbis_text
	WHERE
		contains(text_content,@contains_clause)
	RETURN
END

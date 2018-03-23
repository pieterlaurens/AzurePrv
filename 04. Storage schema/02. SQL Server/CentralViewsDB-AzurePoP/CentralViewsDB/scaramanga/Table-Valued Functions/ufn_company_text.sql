CREATE FUNCTION [scaramanga].[ufn_company_text]
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
		cast(lb.bb_ticker as nvarchar(50)) as company_id
	FROM
		[$(scd_v2017_003)].dbo.orbis_text o JOIN
		[$(idr_linktables_v2017_004)].dbo.linktable_Bloomberg2Orbis_top5 lb ON lb.bvd_id=o.bvd_id
	WHERE
		lb.[rank]=1
		and
		contains(text_content,@contains_clause)
	RETURN
END

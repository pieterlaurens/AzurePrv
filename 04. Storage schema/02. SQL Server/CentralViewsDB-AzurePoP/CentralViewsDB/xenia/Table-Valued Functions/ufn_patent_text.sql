CREATE FUNCTION xenia.[ufn_patent_text]
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
		f.inpadoc_family_id as patent_family_id
		, aa.appln_id as patent_application_id
	FROM
		(select
			appln_id
		from
			[$(ps15a)].dbo.tls203_appln_abstr
		WHERE
			contains(appln_abstract,@contains_clause)
		union
		select
			appln_id
		from
			[$(ps15a)].dbo.tls202_appln_title
		WHERE
			contains(appln_title,@contains_clause)
		) aa JOIN
		[$(ps15a)].dbo.tls201_appln a ON a.appln_id=aa.appln_id JOIN
		[$(ps15a)].dbo.tls219_inpadoc_fam f ON f.appln_id=aa.appln_id
	where
		year(a.appln_filing_date) < 9000
	order by
		a.[appln_filing_date] desc
	RETURN
END

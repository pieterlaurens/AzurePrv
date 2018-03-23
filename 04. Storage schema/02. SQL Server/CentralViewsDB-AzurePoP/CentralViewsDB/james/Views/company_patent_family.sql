CREATE VIEW [james].[company_patent_family]
	AS
SELECT
	lb.ticker as bvd_id
	, inpadoc_family_id as patent_family_id
FROM
	[$(idr_linktables_v2017_002)].dbo.linktable_ticker_to_bvd lb JOIN
	[$(pwc_v2016b_002)].[aggregate].company_family cf ON cf.bvd_id=lb.bvd_id

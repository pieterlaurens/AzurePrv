CREATE VIEW [james].[company_financial_ratio] AS

SELECT
	ticker as bvd_id
	, y
	, [type]
	, CAST([value] AS REAL) AS [value]
from
	[$(idr_linktables_v2017_002)].dbo.linktable_ticker_to_bvd lb JOIN
	[$(scd_v2017_002)].dbo.orbis_financials f ON f.bvd_id=lb.bvd_id
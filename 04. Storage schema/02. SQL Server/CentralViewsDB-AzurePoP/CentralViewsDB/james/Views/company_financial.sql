CREATE VIEW [james].[company_financial] AS

SELECT
	ticker as bvd_id
	, y
	, [type]
	, cast([value] as BIGINT) as [value]
from
	[$(idr_linktables_v2017_002)].dbo.linktable_ticker_to_bvd lb JOIN
	[$(scd_v2017_002)].dbo.orbis_financials f ON lb.bvd_id=f.bvd_id
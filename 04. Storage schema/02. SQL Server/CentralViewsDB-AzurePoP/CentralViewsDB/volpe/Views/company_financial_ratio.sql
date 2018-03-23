CREATE VIEW [volpe].[company_financial_ratio] AS

SELECT
	cast(bvd_id as nvarchar(50)) as bvd_id
	, y
	, [type]
	, CAST([value] AS REAL) AS [value]
from
	[$(scd_v2017_005)].dbo.orbis_financials

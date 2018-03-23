CREATE VIEW [vesper].[company_financial_ratio] AS

SELECT
	cast(bvd_id as nvarchar(50)) as bvd_id
	, y
	, [type]
	, CAST([value] AS REAL) AS [value]
from
	[$(scd_v2017_002)].dbo.orbis_financials
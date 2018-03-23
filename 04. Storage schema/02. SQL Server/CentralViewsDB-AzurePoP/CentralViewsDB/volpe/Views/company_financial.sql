CREATE VIEW [volpe].[company_financial] AS

SELECT
	cast(bvd_id as nvarchar(50)) as bvd_id
	, y
	, [type]
	, cast([value] as BIGINT) as [value]
from
	[$(scd_v2017_005)].dbo.orbis_financials

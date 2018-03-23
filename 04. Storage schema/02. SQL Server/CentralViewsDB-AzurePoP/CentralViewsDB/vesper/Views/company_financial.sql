CREATE VIEW [vesper].[company_financial] AS

SELECT
	cast(bvd_id as nvarchar(50)) as bvd_id
	, y
	, [type]
	, cast([value] as BIGINT) as [value]
from
	[$(scd_v2017_002)].dbo.orbis_financials
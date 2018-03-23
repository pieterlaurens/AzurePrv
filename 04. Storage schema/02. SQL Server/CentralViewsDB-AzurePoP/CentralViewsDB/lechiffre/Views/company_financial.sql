CREATE VIEW [lechiffre].[company_financial] AS

SELECT
	cast(current_bvd_id as nvarchar(50)) as bvd_id
	, y
	, [type]
	, [value]
from
	[$(scd_v2016_005)].dbo.orbis_financials
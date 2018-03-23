CREATE VIEW [lechiffre].[company_financial_ratio] AS

SELECT
	cast(current_bvd_id as nvarchar(50)) as bvd_id
	, y
	, [type]
	, [value]
from
	[$(scd_v2016_005)].dbo.orbis_financial_ratios
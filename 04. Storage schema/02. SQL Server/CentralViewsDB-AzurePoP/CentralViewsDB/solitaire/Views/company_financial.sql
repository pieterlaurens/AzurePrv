﻿CREATE VIEW [solitaire].[company_financial] AS

SELECT
	cast(bvd_id as nvarchar(50)) as bvd_id
	, y
	, [type]
	, [value]
from
	[$(scd_v2016_007)].dbo.orbis_financials
﻿CREATE VIEW jaws.[company_financial_ratio] AS

SELECT
	cast(bvd_id as nvarchar(50)) as bvd_id
	, y
	, [type]
	, [value]
from
	[$(scd_v2016_006)].dbo.orbis_financial_ratios
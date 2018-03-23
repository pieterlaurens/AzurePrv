﻿CREATE VIEW [scaramanga].[company_financial] AS

SELECT
	cast(lb.bb_ticker as nvarchar(50)) as bvd_id
	, y
	, [type]
	, cast([value] as BIGINT) as [value]
from
	[$(idr_linktables_v2017_004)].dbo.linktable_Bloomberg2Orbis_top5 lb JOIN
	[$(scd_v2017_003)].dbo.orbis_financials f ON lb.bvd_id=f.bvd_id
where
	lb.[rank]=1
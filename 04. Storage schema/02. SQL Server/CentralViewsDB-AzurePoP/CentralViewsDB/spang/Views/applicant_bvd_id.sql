﻿CREATE VIEW [spang].[applicant_bvd_id]
	AS
SELECT
	person_id as applicant_id
	, bvd_id
FROM
	[$(idr_linktables_v2016_006)].dbo.linktable_top5_match_Patstat2Orbis_full_lineage
WHERE
	[rank] = 1
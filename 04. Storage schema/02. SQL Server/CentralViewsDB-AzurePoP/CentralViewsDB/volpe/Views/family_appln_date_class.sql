﻿CREATE VIEW [volpe].[appln_family_class_date]
	AS
SELECT
	inpadoc_family_id as patent_family_id
	, null as patent_application_id
	, cpc_first_date as priority_date
	, cpc_id as class_id
FROM
	[$(pw_v2017a_001)].patstat.family_cpc
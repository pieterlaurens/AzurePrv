﻿CREATE VIEW [drax].[applicant_bvd_id]
	AS
SELECT
	person_id as applicant_id
	, bvd_id
FROM
	[$(pwc_v2016a_005)].idr.person_to_bvd_id
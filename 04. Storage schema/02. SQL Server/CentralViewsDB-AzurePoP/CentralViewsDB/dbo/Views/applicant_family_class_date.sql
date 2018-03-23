﻿CREATE VIEW [dbo].[applicant_family_class_date] AS
SELECT
	doc_std_name_id as applicant_id
	, inpadoc_family_id as patent_family_id
	, all_ipc_id as class_id
	, priority_date
FROM
	[$(PatentsWork15bcpc_server)].[$(pw15b_cpc)].dbo.doc_std_name_fam_cpc_full


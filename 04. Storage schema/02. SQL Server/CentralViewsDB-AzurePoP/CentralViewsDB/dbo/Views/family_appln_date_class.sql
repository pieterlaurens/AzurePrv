CREATE VIEW [dbo].[appln_family_class_date]
	AS
SELECT
	inpadoc_family_id as patent_family_id
	, appln_id as patent_application_id
	, priority_date
	, all_ipc_id as class_id
FROM
	[$(PatentsWork15bcpc_server)].[$(pw15b_cpc)].dbo.app_fam_full_cpc_id
CREATE VIEW felix.[applicant_family_class_date] AS
SELECT
	person_id as applicant_id
	, inpadoc_family_id as patent_family_id
	, all_ipc_id as class_id
	, person_priority_date as priority_date
FROM
	[$(pw15b_cpc)].dbo.person_fam_cpc_full


CREATE VIEW lechiffre.[applicant_family_class_date] AS
SELECT
	person_id as applicant_id
	, inpadoc_family_id as patent_family_id
	, cpc_id as class_id
	, person_first_date as priority_date
FROM
	[$(pw_v2015b_002)].patstat.family_person_cpc


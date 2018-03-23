CREATE VIEW [scaramanga].[applicant_family_class_date] AS
SELECT
	fp.person_id as applicant_id
	, fp.inpadoc_family_id as patent_family_id
	, fc.cpc_id as class_id
	, fp.person_first_date as priority_date
FROM
	[$(pw_v2017a_001)].patstat.family_person fp JOIN
	[$(pw_v2017a_001)].patstat.family_cpc fc ON fc.inpadoc_family_id=fp.inpadoc_family_id

CREATE VIEW [spang].[applicant] AS
SELECT
	pe.person_id as applicant_id
	, person_name as [name]
	, person_address as [address]
	, person_ctry_code as [country]
	, null as first_filing
	, null as last_filing
	, pm.applications_inventor as occurrences_as_inventor
	, pm.applications_applicant as occurrences_as_applicant
	, null as class_group_level1
FROM
	[$(pw_v2016a_001)].patstat.person_entry pe LEFT OUTER JOIN
	[$(pw_v2016a_001)].patstat.person_metric pm ON pm.person_id=pe.person_id
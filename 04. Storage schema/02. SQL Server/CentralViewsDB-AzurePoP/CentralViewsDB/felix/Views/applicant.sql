CREATE VIEW felix.[applicant] AS
SELECT
	person_id as applicant_id
	, person_name as [name]
	, person_address as [address]
	, person_ctry_code as [country]
	, null as first_filing
	, null as last_filing
	, null as occurrences_as_inventor
	, null as occurrences_as_applicant
	, null as class_group_level1
FROM
	[$(ps15b)].dbo.tls906_person
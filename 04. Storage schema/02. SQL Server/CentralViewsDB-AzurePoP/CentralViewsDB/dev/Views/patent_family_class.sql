CREATE VIEW [dev].[patent_family_class]
	AS
SELECT
	inpadoc_family_id as patent_family_id
	, cpc_id as class_id
	, cpc_first_date as priority_date
FROM
	[$(pw_v2017a_001)].patstat.family_cpc

CREATE VIEW jaws.[patent_class] AS

SELECT
	fc.cpc_id as class_id
	, cast(fc.cpc_code as nvarchar(16)) as class_code
	, null as class_group_level1
	, null as class_group_level2
	, null as class_group_level3
	, null as n_appln
	, cm.cpc_num_families as n_fam
	, null as aggregate_n_appln
	, cm.cpc_num_families_aggregate as aggregate_n_fam
	, cast(fc.cpc_label as varchar(400))  as class_label
	, cast(fc.cpc_description as nvarchar(max))  as full_class_label
	, null as class_code_original_format
FROM
	[$(pw_v2016a_001)].patstat.cpc_entry fc LEFT OUTER JOIN
	[$(pw_v2016a_001)].patstat.cpc_metric cm ON fc.cpc_id=cm.cpc_id
CREATE VIEW xenia.[patent_class] AS

SELECT
	fc.all_ipc_id as class_id
	, fk.ipc_key as class_code
	, fc.ipc_subclass as class_group_level1
	, fc.ipc_maingroup as class_group_level2
	, fc.ipc_subgroup as class_group_level3
	, isnull(cs.class_size,0) as n_appln
	, isnull(cs.n_fam,0) as n_fam
	, isnull(acs.n_appln,0) as aggregate_n_appln
	, isnull(acs.n_fam,0) as aggregate_n_fam
	, fc.ipc_desc as class_label
	, fl.extended_ipc_label as full_class_label
	, fc.ipc_xml_label as class_code_original_format
FROM
	[$(pw15a_cpc)].dbo.full_cpc fc LEFT OUTER JOIN
	[$(pw15a_cpc)].dbo.full_cpc_key fk ON fk.all_ipc_id=fc.all_ipc_id LEFT OUTER JOIN
	[$(pw15a_cpc)].dbo.full_cpc_class_size cs ON cs.all_ipc_id=fc.all_ipc_id LEFT OUTER JOIN
	[$(pw15a_cpc)].dbo.full_cpc_aggregate_class_size acs ON acs.all_ipc_id=fc.all_ipc_id LEFT OUTER JOIN
	[$(pw15a_cpc)].dbo.full_cpc_full_label fl ON fl.all_ipc_id=fc.all_ipc_id
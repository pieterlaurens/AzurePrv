CREATE VIEW honeyrider.[patent_class_lineage] AS

SELECT
	all_ipc_id as parent_class_id
	, depth as parent_depth
	, top_id as child_class_id
	, null as child_depth

FROM
	[$(pw15b_cpc)].dbo.full_cpc_lineage
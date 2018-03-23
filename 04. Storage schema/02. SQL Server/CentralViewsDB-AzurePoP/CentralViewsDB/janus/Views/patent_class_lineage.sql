CREATE VIEW [janus].[patent_class_lineage] AS

SELECT
	cpc_ancestor_id as parent_class_id
	, cpc_ancestor_level as parent_depth
	, cpc_child_id as child_class_id
	, cpc_child_level as child_depth

FROM
	[$(pw15b_cpc_dev)].patstat.cpc_lineage
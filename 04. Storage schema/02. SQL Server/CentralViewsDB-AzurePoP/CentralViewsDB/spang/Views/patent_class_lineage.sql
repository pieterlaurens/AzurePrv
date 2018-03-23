CREATE VIEW [spang].[patent_class_lineage] AS

SELECT
	cpc_ancestor_id as parent_class_id
	, cpc_ancestor_level as parent_depth
	, cpc_child_id as child_class_id
	, cpc_child_level as child_depth
FROM
	[$(pw_v2016a_001)].patstat.cpc_lineage
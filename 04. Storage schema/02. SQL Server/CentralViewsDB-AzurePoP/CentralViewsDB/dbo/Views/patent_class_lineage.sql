CREATE VIEW [dbo].[patent_class_lineage] AS

/* very shakey code! must be checked and fixed (preferably in patents_work2015b!) */
SELECT
	all_ipc_id as parent_class_id
	, null as parent_depth
	, top_id as child_class_id
	, depth as child_depth
FROM
	[$(PatentsWork15bcpc_server)].[$(pw15b_cpc)].dbo.full_cpc_lineage

/*SELECT
	parent_id as parent_class_id
	, parent_depth
	, child_id as child_class_id
	, child_depth

FROM
	[$(PatentsWork15bcpc_server)].[$(pw15b_cpc)].dbo.full_cpc_lineage_b*/
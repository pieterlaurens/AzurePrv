CREATE VIEW [boris].deal_structure AS

SELECT
	cast([deal_id] as nvarchar(10)) as [deal_id]
    ,structure_type as [structure_field_name]
    ,structure_content as [structure_field_value]
FROM
	[$(sdd_v2016_005)].dbo.deal_structure

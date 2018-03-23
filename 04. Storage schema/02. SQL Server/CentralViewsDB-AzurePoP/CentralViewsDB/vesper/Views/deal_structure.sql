CREATE VIEW [vesper].deal_structure AS

SELECT
	cast([deal_id] as nvarchar(10)) as [deal_id]
    ,structure_type as [structure_field_name]
    ,structure_content as [structure_field_value]
FROM
	[$(sdd_v2017_001)].dbo.deal_structure

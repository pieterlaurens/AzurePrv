CREATE VIEW [lechiffre].deal_structure AS

SELECT
	cast([deal_id] as nvarchar(10)) as [deal_id]
    ,[structure_field_name]
    ,[structure_field_value]
FROM
	[$(sdd_v2016_002)].dbo.deal_structure

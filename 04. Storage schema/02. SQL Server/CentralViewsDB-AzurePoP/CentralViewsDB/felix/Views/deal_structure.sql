CREATE VIEW felix.deal_structure AS

SELECT
	[deal_id]
      ,[structure_field_name]
      ,[structure_field_value]
FROM
	[$(scdr_16_1_server)].[$(scdr_16_1)].dbo.deal_structure

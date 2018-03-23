CREATE VIEW xenia.deal_structure AS

SELECT
	[deal_id]
      ,[structure_field_name]
      ,[structure_field_value]
FROM
	[$(scdr_15_1_server)].[$(scdr_15_1)].dbo.deal_structure

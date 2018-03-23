CREATE VIEW felix.[deal_text] AS

SELECT
	[deal_id]
      ,[text_field_name]
      ,[text_field_value]
FROM
	[$(scdr_16_1_server)].[$(scdr_16_1)].dbo.deal_text

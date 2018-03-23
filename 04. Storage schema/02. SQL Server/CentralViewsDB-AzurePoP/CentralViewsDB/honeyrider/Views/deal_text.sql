CREATE VIEW honeyrider.[deal_text] AS

SELECT
	[deal_id]
      ,[text_field_name]
      ,[text_field_value]
FROM
	[$(scdr_15_1_server)].[$(scdr_15_1)].dbo.deal_text

CREATE VIEW [janus].[deal_text] AS

SELECT
	cast([deal_id] as nvarchar(10)) as deal_id
      ,[text_field_name]
      ,[text_field_value]
FROM
	[$(sdd_16_1)].dbo.deal_text

CREATE VIEW [spang].[deal_text] AS

SELECT
	cast([deal_id] as nvarchar(10)) as deal_id
    ,[text_type] as [text_field_name]
    ,[text_content] as [text_field_value]
FROM
	[$(sdd_v2016_005)].dbo.deal_text

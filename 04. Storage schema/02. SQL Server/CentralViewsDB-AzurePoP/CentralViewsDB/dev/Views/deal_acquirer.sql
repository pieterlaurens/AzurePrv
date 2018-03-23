CREATE VIEW [dev].[deal_acquirer] AS

SELECT
	cast([deal_id] as nvarchar(10)) as deal_id
	,cast([acquirer_bvd_id] as nvarchar(25)) as acquirer_bvd_id
	,[acquirer_name]
	,cast([acquirer_country] as nvarchar(2)) as acquirer_country
	,[acquirer_business_description]
FROM
	[$(sdd_v2017_002)].dbo.[deal_acquirer]

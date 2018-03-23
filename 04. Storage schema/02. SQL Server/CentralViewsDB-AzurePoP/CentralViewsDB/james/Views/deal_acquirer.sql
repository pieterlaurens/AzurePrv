CREATE VIEW [james].[deal_acquirer] AS

SELECT
	cast([deal_id] as nvarchar(10)) as deal_id
	,cast(ticker as nvarchar(25)) as acquirer_bvd_id
	,[acquirer_name]
	,cast([acquirer_country] as nvarchar(2)) as acquirer_country
	,[acquirer_business_description]
FROM
	[$(idr_linktables_v2017_002)].dbo.linktable_ticker_to_bvd lb JOIN
	[$(sdd_v2017_001)].dbo.[deal_acquirer] a ON a.acquirer_bvd_id=lb.bvd_id

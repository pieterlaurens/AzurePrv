﻿CREATE VIEW felix.[deal_acquirer] AS

SELECT
	[deal_id]
      ,[acquirer_bvd_id]
      ,[acquirer_name]
      ,[acquirer_country]
      ,[acquirer_business_description]
FROM
	[$(scdr_16_1_server)].[$(scdr_16_1)].dbo.[deal_acquirer]
WHERE
	[org_acquirer_bvd_pk_rnk]=1

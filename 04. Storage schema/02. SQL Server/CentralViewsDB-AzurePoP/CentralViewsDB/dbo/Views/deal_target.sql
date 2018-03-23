CREATE VIEW [dbo].[deal_target] AS

SELECT
	[deal_id]
      ,[target_bvd_id]
      ,[target_name]
      ,[target_country]
      ,[target_business_description]
      ,[initial_stake]
      ,[acquired_stake]
      ,[final_stake]
      ,[pre_deal_ev_mult_ebitda]
      ,[pre_deal_ev_mult_rev_turnover]
      ,[target_nace_code]
      ,[target_nace_desc]
FROM
	[$(scdr_15_1_server)].[$(scdr_15_1)].dbo.deal_target
WHERE
	[org_target_bvd_pk_rnk]=1

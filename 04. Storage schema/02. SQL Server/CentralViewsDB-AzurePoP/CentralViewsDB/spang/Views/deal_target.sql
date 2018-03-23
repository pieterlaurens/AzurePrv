CREATE VIEW [spang].[deal_target] AS

SELECT
	cast([deal_id] as nvarchar(10)) as deal_id
    ,cast([target_bvd_id] as nvarchar(25)) as target_bvd_id
    ,[target_name]
    ,cast([target_country] as nvarchar(2)) as target_country
    ,[target_business_description]
    ,[initial_stake]
    ,[acquired_stake]
    ,[final_stake]
    ,[pre_deal_ev_mult_ebitda]
    ,[pre_deal_ev_mult_rev_turnover]
    ,cast([target_nace_code] as nvarchar(5)) as target_nace_code
    ,null as [target_nace_desc]
FROM
	[$(sdd_v2016_005)].dbo.deal_target

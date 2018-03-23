CREATE VIEW [scaramanga].[deal_target] AS

SELECT
	cast([deal_id] as nvarchar(10)) as deal_id
    ,cast(bb_ticker as nvarchar(25)) as target_bvd_id
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
	[$(idr_linktables_v2017_004)].dbo.linktable_Bloomberg2Orbis_top5 lb JOIN
	[$(sdd_v2017_002)].dbo.deal_target t ON t.target_bvd_id=lb.bvd_id
WHERE
	lb.[rank]=1
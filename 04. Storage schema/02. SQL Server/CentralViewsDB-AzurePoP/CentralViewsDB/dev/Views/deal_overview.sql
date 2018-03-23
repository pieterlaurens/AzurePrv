CREATE VIEW [dev].[deal_overview] AS

SELECT
	cast([deal_id] as nvarchar(10)) as deal_id
    ,[deal_headline]
    ,[deal_type]
    ,[deal_status]
    ,[deal_value]
    ,[rumor_date]
    ,[announced_date]
    ,[expected_completion_date]
    ,[assumed_completion_date]
    ,[completion_date]
    ,[postponed_date]
    ,[withdrawn_date]
    ,[last_deal_status_date]
    ,[deal_equity_value]
    ,[deal_enterprise_value]
    ,[deal_enterprise_value_modeled]
    ,[deal_total_target_value]
FROM
	[$(sdd_v2017_002)].dbo.deal_overview

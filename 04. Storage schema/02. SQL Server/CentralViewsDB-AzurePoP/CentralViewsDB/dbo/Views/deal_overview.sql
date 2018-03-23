CREATE VIEW [dbo].[deal_overview] AS

SELECT
	[deal_id]
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
	[$(scdr_15_1_server)].[$(scdr_15_1)].dbo.deal_overview

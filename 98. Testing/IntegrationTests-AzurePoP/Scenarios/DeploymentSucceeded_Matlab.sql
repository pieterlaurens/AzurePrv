
USE [prv_prj_deploytest]
GO

DELETE FROM dbo.company_score WHERE score_label = 'Temporal Test Score'
INSERT INTO dbo.company_score(score_label, is_numeric,display_in_fe, data_type, is_temporal) VALUES('Temporal Test Score',1,1,'real',1)

DELETE FROM dbo.company_time_score_real WHERE score_name='Temporal Test Score'
INSERT INTO dbo.company_time_score_real
SELECT
	company_id
	, 'Temporal Test Score'
	, c.id
	, 0.3
FROM
	dbo.company_long_list CROSS JOIN
	(SELECT TOP 10 id FROM prv_dev_dth.latest.calendar WHERE period_type='M' ORDER BY period_date desc) c

:setvar DeploymentServer "alpha-pop-vm"
use prv_dev_inh;
--SET ANSI_WARNINGS OFF


--select * from ivh.getExecutionTree('CreateLonglist',1)
--select * from ivh.getExecutionTree('CreateLandscape',1)

DECLARE @deployment_server sysname = '$(DeploymentServer)'

DECLARE @solution nvarchar(255) = 'PRV'
DECLARE @projectkey_ll nvarchar(100) = CONCAT(@solution, '_Test_PublishMatlabResources')--'testPipeline'

:setvar Q "'"

DECLARE @json_sla nvarchar(max) =
	$(Q)
	:r "..\Configurations\TestDeploySla.json"
	$(Q)
SET @json_sla = REPLACE(@json_sla,'DEPLOYMENT_SERVER',@deployment_server)
--SET @json_sla = REPLACE(REPLACE(@json_sla,'DEPLOYMENT_SERVER',@deployment_server),'latest','scaramanga')
		
DECLARE @json_config nvarchar(max) =
	$(Q)
	:r "..\Configurations\TestDeployMatlabExport.json"
	$(Q)
		
/* ================================================
3. Launch pipeline
================================================ */

DECLARE @RC int

BEGIN
	EXECUTE @RC = [ivh].[run_createNewRun] 
		@projectid = 1
		,@projectkey = @projectkey_ll
		,@solution = @solution
		,@api = 'PublishMatlabResources'
		,@json_sla = @json_sla
		,@json_config = @json_config
		,@debug = 1
	SET @RC = (select max(id) from ivh.run)
END
/*
print(concat('Matlab Export (run ',@RC,')'))

DECLARE @complete tinyint=0
while @complete = 0
begin
	set @complete = 1;
	SET @complete = (SELECT COUNT(*) FROM [nlh].[log] WHERE source_name='NotificationHandler.dtsx' AND [message] like concat('Run ',@RC,': Completed executable NotificationHandler'))

	-- print(concat('Complete: ',@complete))
	
	IF(@complete=0)
		WAITFOR DELAY '00:00:10';
end

select getdate()

-- Test report for SSIS execution
SELECT
	run_id
	, entry_point
	, e.added_on
	, et.name
	, et.[description]
FROM
	[ivh].[run_exectree] re JOIN
	[nlh].[event] e ON e.source_id=re.id JOIN
	[nlh].[event_type] et ON et.id=e.[type_id]
where
	run_id=@RC
order by
	e.added_on asc

-- Test report for the generated Datamart
SELECT
	*
	, CASE WHEN test_result='FAIL' THEN 'Content test failed' ELSE 'Content test passed' END AS [Specific test output]
FROM
	[prv_prj_deploytest].[report].[test_report]
WHERE
	run_id=@RC*/
use prv_dev_inh;
--SET ANSI_WARNINGS OFF

declare @db_exist tinyint = (select count(*) FROM master.dbo.sysdatabases WHERE name = 'prv_prj_deploytest')

--if @db_exist=1 -- no longer desired; end up with one complete datamart.
--	DROP DATABASE prv_prj_deploytest

--select * from ivh.getExecutionTree('CreateLonglist',1)
--select * from ivh.getExecutionTree('CreateLandscape',1)

DECLARE @deployment_server sysname = '$(DeploymentServer)'
DECLARE @solution nvarchar(255) = 'PRV'
DECLARE @projectkey_ll nvarchar(100) = CONCAT(@solution, '_Test_CreateLonglist')--'testPipeline'

:setvar Q "'"

DECLARE @json_sla nvarchar(max) =
	$(Q)
	:r "..\Configurations\TestDeploySla.json"
	$(Q)
SET @json_sla = REPLACE(@json_sla,'DEPLOYMENT_SERVER',@deployment_server)

DECLARE @json_config_ll nvarchar(max) =
	$(Q)
	:r "..\Configurations\TestDeployComprehensiveLonglist.json"
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
		,@api = 'CreateLonglist'
		,@json_sla = @json_sla
		,@json_config = @json_config_ll
		,@debug = 1
	SET @RC = (select max(id) from ivh.run)
END

print(concat('Longlist (run ',@RC,')'))

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
	run_id=@RC
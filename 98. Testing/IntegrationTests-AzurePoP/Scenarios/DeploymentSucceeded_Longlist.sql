:setvar Q "'"
:setvar DeploymentServer "alpha-pop-vm"


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


DECLARE @json_sla nvarchar(max) =
	$(Q)
	:r "..\Configurations\TestDeploySla.json"
	$(Q)
SET @json_sla = REPLACE(@json_sla,'DEPLOYMENT_SERVER',@deployment_server)

DECLARE @json_config_ll nvarchar(max) =
	$(Q)
	:r "..\Configurations\TestDeployLonglist.json"
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

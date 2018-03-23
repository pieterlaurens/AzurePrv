use prv_dev_inh;
--SET ANSI_WARNINGS OFF


--select * from ivh.getExecutionTree('CreateLonglist',1)
--select * from ivh.getExecutionTree('CreateLandscape',1)
:setvar DeploymentServer "equip-pop-vm"

DECLARE @deployment_server sysname = '$(DeploymentServer)'

DECLARE @solution nvarchar(255) = 'PRV'
DECLARE @projectkey_ll nvarchar(100) = CONCAT(@solution, '_Test_UpdateProjectScoretable')--'testPipeline'

:setvar Q "'"

DECLARE @json_sla nvarchar(max) =
	$(Q)
	:r "..\Configurations\TestDeploySla.json"
	$(Q)
SET @json_sla = REPLACE(@json_sla,'DEPLOYMENT_SERVER',@deployment_server)
		
DECLARE @json_config nvarchar(max) =
	$(Q)
	:r "..\Configurations\TestDeployUpdateScoreTable.json"
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
		,@api = 'UpdateScoreTable'
		,@json_sla = @json_sla
		,@json_config = @json_config
		,@debug = 1
	SET @RC = (select max(id) from ivh.run)
END

use prv_dev_inh;
--SET ANSI_WARNINGS OFF

declare @db_exist tinyint = (select count(*) FROM master.dbo.sysdatabases WHERE name = 'prv_prj_deploytest')

if @db_exist=1
	DROP DATABASE prv_prj_deploytest

--select * from ivh.getExecutionTree('CreateLonglist',1)
--select * from ivh.getExecutionTree('CreateLandscape',1)

DECLARE @deployment_server sysname = 'nlams00859'
DECLARE @RC_ll int
DECLARE @RC_ls int
DECLARE @RC_bt int

DECLARE @solution nvarchar(255) = 'PRV'
DECLARE @projectkey_ll nvarchar(100) = CONCAT(@solution, '_Test_CreateLonglist')--'testPipeline'
DECLARE @projectkey_ls nvarchar(100) = CONCAT(@solution, '_Test_CreateLandscape')--'testPipeline'

DECLARE @do_ls TINYINT = 0 -- Landscape
DECLARE @do_ll TINYINT = 1 -- Longlist
DECLARE @do_bt TINYINT = 0 -- Backtesting

:setvar Q "'"

DECLARE @json_sla nvarchar(max) =
	$(Q)
	:r ".\TestDeploySla.json"
	$(Q)
SET @json_sla = REPLACE(@json_sla,'DEPLOYMENT_SERVER',@deployment_server)

DECLARE @json_config_ll nvarchar(max) =
	$(Q)
	:r ".\TestDeployLonglist.json"
	$(Q)

DECLARE @json_config_ls nvarchar(max) =
	$(Q)
	:r ".\TestDeployLandscape.json"
	$(Q)
		
DECLARE @json_config_bt nvarchar(max) =
	$(Q)
	:r ".\TestDeployBacktesting.json"
	$(Q)
		
/* ================================================
3. Launch pipeline
================================================ */


IF(@do_ls=1)
BEGIN
	EXECUTE @RC_ls = [ivh].[run_createNewRun] 
		@projectid = 2
		,@projectkey = @projectkey_ls
		,@solution = @solution
		,@api = 'CreateLandscape'
		,@json_sla = @json_sla
		,@json_config = @json_config_ls
		,@debug = 1
	SET @RC_ls = (select max(id) from ivh.run)
	IF(@do_ll=1 OR @do_bt=1)
		WAITFOR DELAY '00:00:10';
END

IF(@do_ll=1)
BEGIN
	EXECUTE @RC_ll = [ivh].[run_createNewRun] 
		@projectid = 1
		,@projectkey = @projectkey_ll
		,@solution = @solution
		,@api = 'CreateLonglist'
		,@json_sla = @json_sla
		,@json_config = @json_config_ll
		,@debug = 1
	SET @RC_ll = (select max(id) from ivh.run)
	IF(@do_bt=1)
		WAITFOR DELAY '00:00:10';
END

IF(@do_bt=1)
BEGIN
	EXECUTE @RC_ll = [ivh].[run_createNewRun] 
		@projectid = 1
		,@projectkey = @projectkey_ll
		,@solution = @solution
		,@api = 'CreateLonglist'
		,@json_sla = @json_sla
		,@json_config = @json_config_bt
		,@debug = 1
	SET @RC_ll = (select max(id) from ivh.run)
END

--declare @RC_ll int = 10864, @RC_ls int = -1, @do_ls int = 0, @do_ll int = 1,@db_exist tinyint=0
/*
declare @complete tinyint = 0;

declare @ll_fail int
		, @ll_retrieve int
		, @ll_score_real int
		, @ll_score_int int
		, @ll_score_str int
		, @ls_fail int
		, @ls_nodes int
		, @ls_pos int
		, @ls_prop_num int
		, @ls_prop_str int

SET NOCOUNT ON;
--SET ANSI_WARNINGS OFF;

set @db_exist=0
while @db_exist = 0
begin
	WAITFOR DELAY '00:00:02';
	set @db_exist = (select count(*) FROM master.dbo.sysdatabases WHERE name = 'prv_prj_deploytest');
end


while @complete = 0
begin
	set @complete = 1;
	print(concat(getdate(),' =================================================='))

	if(@do_ls=1)
	BEGIN
		print(concat('Landscape (run ',@RC_ls,')'))
		SET @complete = (SELECT COUNT(*) FROM [nlh].[log] WHERE source_name='NotificationHandler.dtsx' AND [message] like concat('Run ',@RC_ls,': Completed executable NotificationHandler'))

		-- No failure or error events in this run
		set @ls_fail = (select count(*) as [Error/failure messages] from nlh.[log] where [status] in ('failure','error') and [message] like concat('Run ',@RC_ls,':%'))

		-- Landscape has nodes (-1 is false)
		set @ls_nodes = (select case when count(*)=0 then -1 else 0 end from prv_prj_deploytest.dbo.ls_node )

		-- Landscape nodes have a position
		set @ls_pos = ((select count(*) from prv_prj_deploytest.dbo.ls_node) - (select count(*) from prv_prj_deploytest.dbo.ls_node_position))

		-- Properties have a value
		DECLARE @pn TABLE(score_key nvarchar(100)) INSERT INTO @pn VALUES('Size'),('Technology Trend Value')
		SET @ls_prop_num = (SELECT COUNT(*) as [Numeric properties failed] FROM (SELECT s.score_key, count(distinct node_key) as n FROM 
			@pn s LEFT OUTER JOIN
			prv_prj_deploytest.dbo.ls_node_property_numeric csr ON csr.node_property_type=s.score_key
		GROUP BY
			s.score_key
		) a WHERE
			n=0)
		DECLARE @ps TABLE(score_key nvarchar(100)) INSERT INTO @ps VALUES('Label'),('High Level Label'),('Technology Trend')
		SET @ls_prop_str = (SELECT COUNT(*) as [Numeric properties failed] FROM (SELECT s.score_key, count(distinct node_key) as n FROM 
			@ps s LEFT OUTER JOIN
			prv_prj_deploytest.dbo.ls_node_property_str csr ON csr.node_property_type=s.score_key
		GROUP BY
			s.score_key
		) a WHERE
			n=0)
		/*
		, @ls_fail int
		, @ls_nodes int
		, @ls_pos int
		, @ls_prop_num int
		, @ls_prop_str int
		*/
		if(@ls_fail=0)		print('PASS: No failure/error messages') else			print(CONCAT('FAIL: failure/error messages for Run ',@RC_ls))
		if(@ls_nodes=0)		print('PASS: Nodes present') else						print('FAIL: Nodes absent') 
		if(@ls_pos=0)		print('PASS: All nodes have positions') else			print('FAIL: Nodes miss positions') 
		if(@ls_prop_num=0)	print('PASS: All numeric properties have values') else	print('FAIL: Numeric properties missing values') 
		if(@ls_prop_str=0)	print('PASS: All string properties have values') else	print('FAIL: String properties missing values')
	END

	IF(@do_ll=1)
	BEGIN
		SET @complete = (SELECT COUNT(*) FROM [nlh].[log] WHERE source_name='NotificationHandler.dtsx' AND [message] like concat('Run ',@RC_ll,': Completed executable NotificationHandler'))
		print(concat('Longlist (run ',@RC_ll,')'))

		-- No failure or error events in this run
		SET @ll_fail = (select count(*) as [Error/failure messages] from nlh.[log] where [status] in ('failure','error') and [message] like concat('Run ',@RC_ll,':%'))

		-- At least one company retrieved for each parameter
		DECLARE @s TABLE(retrieval_key nvarchar(100)) INSERT INTO @s VALUES('Business - AM'),('Business - AM wildcard'),('Dutch listed'),('IP - AM'),('Marked companies'),('PAT.Composite'),('TRD.Composite'),('WEB.Composite')
		SET @ll_retrieve = (SELECT COUNT(*) as [Retrievals failed] FROM (SELECT s.retrieval_key, count(distinct company_id) as n FROM 
			@s s LEFT OUTER JOIN
			prv_prj_deploytest.dbo.company_long_list cll ON cll.retrieval_key=s.retrieval_key
		GROUP BY
			s.retrieval_key
		) a WHERE
			n=0)

		-- Each score has a value for at least one company
		DECLARE @sr TABLE(score_key nvarchar(100)) INSERT INTO @sr VALUES('Business - AM'),('IP - AM'),('Topic - AM'),('PAT.Composite'),('TRD.Composite'),('WEB.Composite'),('Numeric future impact')
		SET @ll_score_real = (SELECT COUNT(*) as [Real scores failed] FROM (SELECT s.score_key, count(distinct company_id) as n FROM 
			@sr s LEFT OUTER JOIN
			prv_prj_deploytest.dbo.company_score_real csr ON csr.score_name=s.score_key
		GROUP BY
			s.score_key
		) a WHERE
			n=0)

		DECLARE @si TABLE(score_key nvarchar(100)) INSERT INTO @si VALUES('Age')
		SET @ll_score_int = (SELECT COUNT(*) as [Integer scores failed] FROM (SELECT s.score_key, count(distinct company_id) as n FROM 
			@si s LEFT OUTER JOIN
			prv_prj_deploytest.dbo.company_score_int csr ON csr.score_name=s.score_key
		GROUP BY
			s.score_key
		) a WHERE
			n=0)

		DECLARE @ss TABLE(score_key nvarchar(100)) INSERT INTO @ss VALUES('Country'),('Industry'),('Future impact')
		SET @ll_score_str = (SELECT COUNT(*) as [String scores failed] FROM (SELECT s.score_key, count(distinct company_id) as n FROM 
			@ss s LEFT OUTER JOIN
			prv_prj_deploytest.dbo.company_score_str csr ON csr.score_name=s.score_key
		GROUP BY
			s.score_key
		) a WHERE
			n=0)

		if(@ll_fail=0)		print('PASS: No failure/error messages') else			print(CONCAT('FAIL: failure/error messages for Run ',@RC_ll))
		if(@ll_retrieve=0)	print('PASS: All retrievals result in some companies') else	print('FAIL: Some retrievals fail to retrieve companies') 
		if(@ll_score_real=0) print('PASS: All real scores have values') else		print('FAIL: Some real scores miss values') 
		if(@ll_score_int=0)	print('PASS: All integer scores have values') else		print('FAIL: Some integers scores miss values') 
		if(@ll_score_str=0)	print('PASS: All string scores have values') else		print('FAIL: Some string scores miss values')
	END

	print(concat('Complete: ',@complete))

	IF(@complete=0)
		WAITFOR DELAY '00:00:30';
end*/
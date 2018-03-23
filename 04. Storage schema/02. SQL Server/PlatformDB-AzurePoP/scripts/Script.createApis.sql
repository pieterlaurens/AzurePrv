/*
Post-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be appended to the build script.		
 Use SQLCMD syntax to include a file in the post-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the post-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/
/* INITIALIZE SOLUTION 

Fill the solution databases with appropriate values and point to the shared components and feature components.
Create a work flow as a tree of components.

*/
DECLARE @debug bit = 0
		, @deployment_server sysname = '$(DeploymentServer)'
		, @solution sysname
		, @api_name sysname


kill_connection_before_altering_db:

	DECLARE @dbname sysname = '$(DatabaseName)'
			, @spid bigint = 0
			, @sql varchar(8000) = '';  

	SELECT @sql = @sql + 'kill ' + CONVERT(varchar(5), session_id) + ';'  
	FROM sys.dm_exec_sessions
	WHERE database_id  = DB_ID(@dbname)
	AND session_id != @@SPID;

	EXEC(@sql);
	ALTER DATABASE [$(DatabaseName)] SET ENABLE_BROKER


setup_config_tables:

	-- Needed because edges can be duplicate, so no way to merge / distinct between existing and newly added edges
	TRUNCATE TABLE ivh.api_workflow

	-- [01a] API: CreateLonglist
	SET @solution = 'PRV'

	EXEC [ivh].[api_addNode] @solution = @solution, @public = 1, @api = N'CreateLonglist', @entry_point = N'\SSISDB\$(SsisProjectName)\PlatformHandlers\InvocationHandler.dtsx', @type = N'project', @server = @deployment_server, @debug=@debug
	EXEC [ivh].[api_addNode] @solution = @solution, @public = 0, @api = N'PrepareProject', @entry_point = N'\SSISDB\$(SsisProjectName)\PlatformComponents\CreatePrepareEnvironment.dtsx', @type = N'project', @server = @deployment_server, @debug=@debug
	EXEC [ivh].[api_addNode] @solution = @solution, @public = 0, @api = N'RetrieveCompanies', @entry_point = N'\SSISDB\$(SsisProjectName)\PlatformComponents\CompanyRetrieval.dtsx', @type = N'project', @server = @deployment_server, @debug=@debug
	EXEC [ivh].[api_addNode] @solution = @solution, @public = 0, @api = N'ScoreCompanies', @entry_point = N'\SSISDB\$(SsisProjectName)\PlatformComponents\CompanyScoring.dtsx', @type = N'project', @server = @deployment_server, @debug=@debug
	EXEC [ivh].[api_addNode] @solution = @solution, @public = 0, @api = N'PublishProject', @entry_point = N'\SSISDB\$(SsisProjectName)\PlatformComponents\PrepareForVisualization.dtsx', @type = N'project', @server = @deployment_server, @debug=@debug

	EXEC [ivh].[api_addEdge] @solution = @solution, @from_node = N'CreateLonglist', @to_node = N'PrepareProject', @debug=@debug
	EXEC [ivh].[api_addEdge] @solution = @solution, @from_node = N'CreateLonglist', @to_node = N'RetrieveCompanies', @debug=@debug
	EXEC [ivh].[api_addEdge] @solution = @solution, @from_node = N'CreateLonglist', @to_node = N'ScoreCompanies', @debug=@debug
	EXEC [ivh].[api_addEdge] @solution = @solution, @from_node = N'CreateLonglist', @to_node = N'PublishProject', @debug=@debug

	-- [01b] API: CreateGroupedLonglist
	SET @solution = 'PRV'

	EXEC [ivh].[api_addNode] @solution = @solution, @public = 1, @api = N'CreateGroupedLonglist', @entry_point = N'\SSISDB\$(SsisProjectName)\PlatformHandlers\InvocationHandler.dtsx', @type = N'project', @server = @deployment_server, @debug=@debug
	EXEC [ivh].[api_addNode] @solution = @solution, @public = 0, @api = N'GroupScores', @entry_point = N'\SSISDB\$(SsisProjectName)\PlatformComponents\GroupScoresInBaskets.dtsx', @type = N'project', @server = @deployment_server, @debug=@debug

	EXEC [ivh].[api_addEdge] @solution = @solution, @from_node = N'CreateGroupedLonglist', @to_node = N'PrepareProject', @debug=@debug
	EXEC [ivh].[api_addEdge] @solution = @solution, @from_node = N'CreateGroupedLonglist', @to_node = N'RetrieveCompanies', @debug=@debug
	EXEC [ivh].[api_addEdge] @solution = @solution, @from_node = N'CreateGroupedLonglist', @to_node = N'ScoreCompanies', @debug=@debug
	EXEC [ivh].[api_addEdge] @solution = @solution, @from_node = N'CreateGroupedLonglist', @to_node = N'GroupScores', @debug=@debug
	EXEC [ivh].[api_addEdge] @solution = @solution, @from_node = N'CreateGroupedLonglist', @to_node = N'PublishProject', @debug=@debug

	-- [02] API: CreateLandscape
	SET @solution = 'PRV'

	EXEC [ivh].[api_addNode] @solution = @solution, @public = 1, @api = N'CreateLandscape', @entry_point = N'\SSISDB\$(SsisProjectName)\PlatformHandlers\InvocationHandler.dtsx', @type = N'project', @server = @deployment_server, @debug=@debug
	EXEC [ivh].[api_addNode] @solution = @solution, @public = 0, @api = N'SelectLandscapeNodes', @entry_point = N'\SSISDB\$(SsisProjectName)\PlatformComponents\SelectLandscapeNodes.dtsx', @type = N'project', @server = @deployment_server, @debug=@debug
	EXEC [ivh].[api_addNode] @solution = @solution, @public = 0, @api = N'ScoreLandscapeNodes', @entry_point = N'\SSISDB\$(SsisProjectName)\PlatformComponents\ScoreLandscapeNodes.dtsx', @type = N'project', @server = @deployment_server, @debug=@debug
	EXEC [ivh].[api_addNode] @solution = @solution, @public = 0, @api = N'GetNodeProperties', @entry_point = N'\SSISDB\$(SsisProjectName)\PlatformComponents\GetNodeProperties.dtsx', @type = N'project', @server = @deployment_server, @debug=@debug
	EXEC [ivh].[api_addNode] @solution = @solution, @public = 0, @api = N'CalculateLandscapeDistances', @entry_point = N'\SSISDB\$(SsisProjectName)\PlatformComponents\CalculateLandscapeDistances.dtsx', @type = N'project', @server = @deployment_server, @debug=@debug
	EXEC [ivh].[api_addNode] @solution = @solution, @public = 0, @api = N'ApproximateDistanceIn2D', @entry_point = N'\SSISDB\$(SsisProjectName)\PlatformComponents\ApproximateDistanceIn2D.dtsx', @type = N'project', @server = @deployment_server, @debug=@debug

	EXEC [ivh].[api_addEdge] @solution = @solution, @from_node = N'CreateLandscape', @to_node = N'PrepareProject', @debug=@debug
	EXEC [ivh].[api_addEdge] @solution = @solution, @from_node = N'CreateLandscape', @to_node = N'SelectLandscapeNodes', @debug=@debug
	EXEC [ivh].[api_addEdge] @solution = @solution, @from_node = N'CreateLandscape', @to_node = N'ScoreLandscapeNodes', @debug=@debug
	EXEC [ivh].[api_addEdge] @solution = @solution, @from_node = N'CreateLandscape', @to_node = N'GetNodeProperties', @parallel=1, @debug=@debug
	EXEC [ivh].[api_addEdge] @solution = @solution, @from_node = N'CreateLandscape', @to_node = N'CalculateLandscapeDistances', @parallel=1, @debug=@debug
	EXEC [ivh].[api_addEdge] @solution = @solution, @from_node = N'CreateLandscape', @to_node = N'ApproximateDistanceIn2D', @parallel=1, @dependent_on='CalculateLandscapeDistances', @debug=@debug
	EXEC [ivh].[api_addEdge] @solution = @solution, @from_node = N'CreateLandscape', @to_node = N'PublishProject', @debug=@debug


	-- [03] API: PublishMatlabResources
	SET @solution = 'PRV'

	EXEC [ivh].[api_addNode] @solution = @solution, @public = 1, @api = N'PublishMatlabResources', @entry_point = N'\SSISDB\$(SsisProjectName)\PlatformHandlers\InvocationHandler.dtsx', @type = N'project', @server = @deployment_server, @debug=@debug
	EXEC [ivh].[api_addNode] @solution = @solution, @public = 0, @api = N'GenerateMatlabTable', @entry_point = N'\SSISDB\$(SsisProjectName)\PlatformComponents\GenerateMatlabTable.dtsx', @type = N'project', @server = @deployment_server, @debug=@debug

	EXEC [ivh].[api_addEdge] @solution = @solution, @from_node = N'PublishMatlabResources', @to_node = N'GenerateMatlabTable', @debug=@debug


	-- [04] API: AddScoreToLonglist
	SET @solution = 'PRV'

	EXEC [ivh].[api_addNode] @solution = @solution, @public = 1, @api = N'AddScoreToLonglist', @entry_point = N'\SSISDB\$(SsisProjectName)\PlatformHandlers\InvocationHandler.dtsx', @type = N'project', @server = @deployment_server, @debug=@debug

	EXEC [ivh].[api_addEdge] @solution = @solution, @from_node = N'AddScoreToLonglist', @to_node = N'ScoreCompanies', @debug=@debug
	EXEC [ivh].[api_addEdge] @solution = @solution, @from_node = N'AddScoreToLonglist', @to_node = N'PublishProject', @debug=@debug


	-- [05] API: RescoreLandscape
	SET @solution = 'PRV'

	EXEC [ivh].[api_addNode] @solution = @solution, @public = 1, @api = N'RescoreLandscape', @entry_point = N'\SSISDB\$(SsisProjectName)\PlatformHandlers\InvocationHandler.dtsx', @type = N'project', @server = @deployment_server, @debug=@debug

	EXEC [ivh].[api_addEdge] @solution = @solution, @from_node = N'RescoreLandscape', @to_node = N'ScoreLandscapeNodes', @parallel=0, @sequence=1, @debug=@debug
	EXEC [ivh].[api_addEdge] @solution = @solution, @from_node = N'RescoreLandscape', @to_node = N'GetNodeProperties', @parallel=1, @sequence=1, @debug=@debug
	EXEC [ivh].[api_addEdge] @solution = @solution, @from_node = N'RescoreLandscape', @to_node = N'PublishProject', @debug=@debug


	-- [06] API: TestEndToEnd
	SET @solution = 'PRV'

	EXEC [ivh].[api_addNode] @solution = @solution, @public = 1, @api = N'TestEndToEnd', @entry_point = N'\SSISDB\$(SsisProjectName)\PlatformHandlers\InvocationHandler.dtsx', @type = N'project', @server = @deployment_server, @debug=@debug
	EXEC [ivh].[api_addNode] @solution = @solution, @public = 0, @api = N'End2EndIntegrationTest', @entry_point = N'\SSISDB\$(SsisProjectName)\PlatformComponents\End2EndIntegrationTest.dtsx', @type = N'project', @server = @deployment_server, @debug=@debug


	EXEC [ivh].[api_addEdge] @solution = @solution, @from_node = N'TestEndToEnd', @to_node = N'End2EndIntegrationTest', @debug=@debug


	-- [07] API: GetKeywordProfile
	SET @solution = 'PRV'

	EXEC [ivh].[api_addNode] @solution = @solution, @public = 1, @api = N'GetKeywordProfile', @entry_point = N'\SSISDB\$(SsisProjectName)\PlatformHandlers\InvocationHandler.dtsx', @type = N'project', @server = @deployment_server, @debug=@debug
	EXEC [ivh].[api_addNode] @solution = @solution, @public = 0, @api = N'RetrieveProfile', @entry_point = N'\SSISDB\$(SsisProjectName)\PlatformComponents\GetKeywordProfile.dtsx', @type = N'project', @server = @deployment_server, @debug=@debug


	EXEC [ivh].[api_addEdge] @solution = @solution, @from_node = N'GetKeywordProfile', @to_node = N'RetrieveProfile', @debug=@debug


	-- [08] API: GetStatsForScores
	SET @solution = 'GovernanceBox'

	EXEC [ivh].[api_addNode] @solution = @solution, @public = 1, @api = N'GetStatsForScores', @entry_point = N'\SSISDB\$(SsisProjectName)\PlatformHandlers\InvocationHandler.dtsx', @type = N'project', @server = @deployment_server, @debug=@debug
	EXEC [ivh].[api_addNode] @solution = @solution, @public = 0, @api = N'CreateStatsOverTopicsForCompanies', @entry_point = N'\SSISDB\$(SsisProjectName)\PlatformComponents\CreateStatsOverTopicsForCompanies.dtsx', @type = N'project', @server = @deployment_server, @debug=@debug

	EXEC [ivh].[api_addEdge] @solution = @solution, @from_node = N'GetStatsForScores', @to_node = N'CreateStatsOverTopicsForCompanies', @debug=@debug


	-- [09] API: SetManualScore -- Added by PL; under construction 18/9/2016
	SET @solution = 'PRV'

	EXEC [ivh].[api_addNode] @solution = @solution, @public = 1, @api = N'SetManualScore', @entry_point = N'\SSISDB\$(SsisProjectName)\PlatformHandlers\InvocationHandler.dtsx', @type = N'project', @server = @deployment_server, @debug=@debug
	EXEC [ivh].[api_addNode] @solution = @solution, @public = 0, @api = N'CompanyScoringSynchronous', @entry_point = N'\SSISDB\$(SsisProjectName)\PlatformComponents\CompanyScoringSynchronous.dtsx', @type = N'project', @server = @deployment_server, @debug=@debug


	EXEC [ivh].[api_addEdge] @solution = @solution, @from_node = N'SetManualScore', @to_node = N'CompanyScoringSynchronous', @debug=@debug


	-- [10] API:  Make new Focuslist with suggestions
	EXEC [ivh].[api_addNode] @solution = @solution, @public = 1, @api = N'ExpandCompanyList', @entry_point = N'\SSISDB\$(SsisProjectName)\PlatformHandlers\InvocationHandler.dtsx', @type = N'project', @server = @deployment_server, @debug=@debug
	EXEC [ivh].[api_addNode] @solution = @solution, @public = 0, @api = N'MakeCompanySuggestion', @entry_point = N'\SSISDB\$(SsisProjectName)\PlatformComponents\MakeCompanySuggestion.dtsx', @type = N'project', @server = @deployment_server, @debug=@debug
	EXEC [ivh].[api_addEdge] @solution = @solution, @from_node = N'ExpandCompanyList', @to_node = N'MakeCompanySuggestion', @debug=@debug
	

	-- [11] API: GeneratePeerGroupData
	SET @solution = 'GovernanceBox'
	SET @api_name = N'GeneratePeerGroupData'

	EXEC [ivh].[api_addNode] @solution = @solution, @public = 1, @api = @api_name, @entry_point = N'\SSISDB\$(SsisProjectName)\PlatformHandlers\InvocationHandler.dtsx', @type = N'project', @server = @deployment_server, @debug=@debug
	EXEC [ivh].[api_addNode] @solution = @solution, @public = 0, @api = N'AddGroupStatistics', @entry_point = N'\SSISDB\$(SsisProjectName)\WebshopFocusReports\AddGroupStatistics.dtsx', @type = N'project', @server = @deployment_server, @debug=@debug

	EXEC [ivh].[api_addEdge] @solution = @solution, @from_node = @api_name, @to_node = N'AddGroupStatistics', @debug=@debug

	IF @debug = 1 SELECT * FROM [ivh].[getExecutionTree] (@api_name, 1) ORDER BY [sequence];


	-- [12] API: LoadTopicScoresDatamart
	SET @solution = 'GovernanceBox'
	SET @api_name = N'LoadTopicScoresDatamart'

	EXEC [ivh].[api_addNode] @solution = @solution, @public = 1, @api = @api_name, @entry_point = N'\SSISDB\$(SsisProjectName)\PlatformHandlers\InvocationHandler.dtsx', @type = N'project', @server = @deployment_server, @debug=@debug
	EXEC [ivh].[api_addNode] @solution = @solution, @public = 0, @api = N'LoadCalendar', @entry_point = N'\SSISDB\$(SsisProjectName)\WebshopFocusReports\LoadCalendar.dtsx', @type = N'project', @server = @deployment_server, @debug=@debug
	EXEC [ivh].[api_addNode] @solution = @solution, @public = 0, @api = N'LoadCompanies', @entry_point = N'\SSISDB\$(SsisProjectName)\WebshopFocusReports\LoadCompanies.dtsx', @type = N'project', @server = @deployment_server, @debug=@debug
	EXEC [ivh].[api_addNode] @solution = @solution, @public = 0, @api = N'LoadIndustries', @entry_point = N'\SSISDB\$(SsisProjectName)\WebshopFocusReports\LoadIndustries.dtsx', @type = N'project', @server = @deployment_server, @debug=@debug
	EXEC [ivh].[api_addNode] @solution = @solution, @public = 0, @api = N'LoadCountries', @entry_point = N'\SSISDB\$(SsisProjectName)\WebshopFocusReports\LoadCountries.dtsx', @type = N'project', @server = @deployment_server, @debug=@debug
	EXEC [ivh].[api_addNode] @solution = @solution, @public = 0, @api = N'LoadDocuments', @entry_point = N'\SSISDB\$(SsisProjectName)\WebshopFocusReports\LoadDocuments.dtsx', @type = N'project', @server = @deployment_server, @debug=@debug
	EXEC [ivh].[api_addNode] @solution = @solution, @public = 0, @api = N'LoadSubjects', @entry_point = N'\SSISDB\$(SsisProjectName)\WebshopFocusReports\LoadSubjects.dtsx', @type = N'project', @server = @deployment_server, @debug=@debug
	EXEC [ivh].[api_addNode] @solution = @solution, @public = 0, @api = N'LoadSubjectScoreSources', @entry_point = N'\SSISDB\$(SsisProjectName)\WebshopFocusReports\LoadSubjectScoreSources.dtsx', @type = N'project', @server = @deployment_server, @debug=@debug
	EXEC [ivh].[api_addNode] @solution = @solution, @public = 0, @api = N'LoadSubjectScores', @entry_point = N'\SSISDB\$(SsisProjectName)\WebshopFocusReports\LoadSubjectScores.dtsx', @type = N'project', @server = @deployment_server, @debug=@debug

	EXEC [ivh].[api_addEdge] @solution = @solution, @from_node = @api_name, @to_node = N'LoadCalendar', @parallel=1, @debug=@debug
	EXEC [ivh].[api_addEdge] @solution = @solution, @from_node = @api_name, @to_node = N'LoadCompanies', @parallel=1, @debug=@debug
	EXEC [ivh].[api_addEdge] @solution = @solution, @from_node = @api_name, @to_node = N'LoadIndustries', @parallel=1, @debug=@debug
	EXEC [ivh].[api_addEdge] @solution = @solution, @from_node = @api_name, @to_node = N'LoadCountries', @parallel=1, @debug=@debug
	EXEC [ivh].[api_addEdge] @solution = @solution, @from_node = @api_name, @to_node = N'LoadDocuments', @parallel=1, @debug=@debug
	EXEC [ivh].[api_addEdge] @solution = @solution, @from_node = @api_name, @to_node = N'LoadSubjects', @parallel=1, @debug=@debug
	EXEC [ivh].[api_addEdge] @solution = @solution, @from_node = @api_name, @to_node = N'LoadSubjectScoreSources', @parallel=1, @debug=@debug
	EXEC [ivh].[api_addEdge] @solution = @solution, @from_node = @api_name, @to_node = N'LoadSubjectScores', @parallel=0, @debug=@debug

	IF @debug = 1 SELECT * FROM [ivh].[getExecutionTree] (@api_name, 1) ORDER BY [sequence];


	-- [13] API: PublishTopicScoresDatamart
	SET @solution = 'GovernanceBox'
	SET @api_name = N'PublishTopicScoresDatamart'

	EXEC [ivh].[api_addNode] @solution = @solution, @public = 1, @api = @api_name, @entry_point = N'\SSISDB\$(SsisProjectName)\PlatformHandlers\InvocationHandler.dtsx', @type = N'project', @server = @deployment_server, @debug=@debug
	EXEC [ivh].[api_addNode] @solution = @solution, @public = 0, @api = N'RefreshWebData', @entry_point = N'\SSISDB\$(SsisProjectName)\WebshopFocusReports\RefreshWebData.dtsx', @type = N'project', @server = @deployment_server, @debug=@debug

	EXEC [ivh].[api_addEdge] @solution = @solution, @from_node = @api_name, @to_node = N'RefreshWebData', @debug=@debug

	IF @debug = 1 SELECT * FROM [ivh].[getExecutionTree] (@api_name, 1) ORDER BY [sequence];


	-- [14] API: RefreshTopicScoresToWeb
	SET @solution = 'GovernanceBox'
	SET @api_name = N'RefreshTopicScores'

	EXEC [ivh].[api_addNode] @solution = @solution, @public = 1, @api = @api_name, @entry_point = N'\SSISDB\$(SsisProjectName)\PlatformHandlers\InvocationHandler.dtsx', @type = N'project', @server = @deployment_server, @debug=@debug

	EXEC [ivh].[api_addEdge] @solution = @solution, @from_node = @api_name, @to_node = N'LoadSubjectScores', @parallel=0, @debug=@debug
	EXEC [ivh].[api_addEdge] @solution = @solution, @from_node = @api_name, @to_node = N'PublishTopicScoresDatamart', @parallel=0, @debug=@debug

	IF @debug = 1 SELECT * FROM [ivh].[getExecutionTree] (@api_name, 1) ORDER BY [sequence];


	-- [15] API: PublishAdditionalDocumentsToWeb
	SET @solution = 'GovernanceBox'
	SET @api_name = N'PublishAdditionalDocuments'

	EXEC [ivh].[api_addNode] @solution = @solution, @public = 1, @api = @api_name, @entry_point = N'\SSISDB\$(SsisProjectName)\PlatformHandlers\InvocationHandler.dtsx', @type = N'project', @server = @deployment_server, @debug=@debug

	EXEC [ivh].[api_addEdge] @solution = @solution, @from_node = @api_name, @to_node = N'LoadCompanies', @parallel=1, @debug=@debug
	EXEC [ivh].[api_addEdge] @solution = @solution, @from_node = @api_name, @to_node = N'LoadDocuments', @parallel=1, @debug=@debug
	EXEC [ivh].[api_addEdge] @solution = @solution, @from_node = @api_name, @to_node = N'LoadSubjectScoreSources', @parallel=1, @debug=@debug
	EXEC [ivh].[api_addEdge] @solution = @solution, @from_node = @api_name, @to_node = N'LoadSubjectScores', @parallel=0, @debug=@debug
	EXEC [ivh].[api_addEdge] @solution = @solution, @from_node = @api_name, @to_node = N'PublishTopicScoresDatamart', @parallel=0, @debug=@debug

	IF @debug = 1 SELECT * FROM [ivh].[getExecutionTree] (@api_name, 1) ORDER BY [sequence];


	-- [16] API: LoadDealScoresDatamart
	SET @solution = 'GovernanceBox'
	SET @api_name = N'LoadDealScoresDatamart'

	EXEC [ivh].[api_addNode] @solution = @solution, @public = 1, @api = @api_name, @entry_point = N'\SSISDB\$(SsisProjectName)\PlatformHandlers\InvocationHandler.dtsx', @type = N'project', @server = @deployment_server, @debug=@debug
	EXEC [ivh].[api_addNode] @solution = @solution, @public = 0, @api = N'LoadCalendar', @entry_point = N'\SSISDB\$(SsisProjectName)\WebshopFocusReports\LoadCalendar.dtsx', @type = N'project', @server = @deployment_server, @debug=@debug
	EXEC [ivh].[api_addNode] @solution = @solution, @public = 0, @api = N'LoadCompanies', @entry_point = N'\SSISDB\$(SsisProjectName)\WebshopFocusReports\LoadCompanies.dtsx', @type = N'project', @server = @deployment_server, @debug=@debug
	EXEC [ivh].[api_addNode] @solution = @solution, @public = 0, @api = N'LoadIndustries', @entry_point = N'\SSISDB\$(SsisProjectName)\WebshopFocusReports\LoadIndustries.dtsx', @type = N'project', @server = @deployment_server, @debug=@debug
	EXEC [ivh].[api_addNode] @solution = @solution, @public = 0, @api = N'LoadCountries', @entry_point = N'\SSISDB\$(SsisProjectName)\WebshopFocusReports\LoadCountries.dtsx', @type = N'project', @server = @deployment_server, @debug=@debug
	EXEC [ivh].[api_addNode] @solution = @solution, @public = 0, @api = N'LoadDeals', @entry_point = N'\SSISDB\$(SsisProjectName)\WebshopFocusReports\LoadDeals.dtsx', @type = N'project', @server = @deployment_server, @debug=@debug
	EXEC [ivh].[api_addNode] @solution = @solution, @public = 0, @api = N'LoadDealScores', @entry_point = N'\SSISDB\$(SsisProjectName)\WebshopFocusReports\LoadDealScores.dtsx', @type = N'project', @server = @deployment_server, @debug=@debug

	EXEC [ivh].[api_addEdge] @solution = @solution, @from_node = @api_name, @to_node = N'LoadCalendar', @parallel=1, @debug=@debug
	EXEC [ivh].[api_addEdge] @solution = @solution, @from_node = @api_name, @to_node = N'LoadCompanies', @parallel=1, @debug=@debug
	EXEC [ivh].[api_addEdge] @solution = @solution, @from_node = @api_name, @to_node = N'LoadIndustries', @parallel=1, @debug=@debug
	EXEC [ivh].[api_addEdge] @solution = @solution, @from_node = @api_name, @to_node = N'LoadCountries', @parallel=1, @debug=@debug
	EXEC [ivh].[api_addEdge] @solution = @solution, @from_node = @api_name, @to_node = N'LoadDeals', @parallel=1, @debug=@debug
	EXEC [ivh].[api_addEdge] @solution = @solution, @from_node = @api_name, @to_node = N'LoadDealScores', @parallel=0, @debug=@debug

	IF @debug = 1 SELECT * FROM [ivh].[getExecutionTree] ('LoadDealScoresDatamart', 1) ORDER BY [sequence];


	-- [17] API: RefreshDealScoresToWeb
	SET @solution = 'GovernanceBox'
	SET @api_name = N'RefreshDealScores'

	EXEC [ivh].[api_addNode] @solution = @solution, @public = 1, @api = @api_name, @entry_point = N'\SSISDB\$(SsisProjectName)\PlatformHandlers\InvocationHandler.dtsx', @type = N'project', @server = @deployment_server, @debug=@debug

	EXEC [ivh].[api_addEdge] @solution = @solution, @from_node = @api_name, @to_node = N'LoadDealScores', @parallel=0, @debug=@debug
	EXEC [ivh].[api_addEdge] @solution = @solution, @from_node = @api_name, @to_node = N'PublishTopicScoresDatamart', @parallel=0, @debug=@debug

	IF @debug = 1 SELECT * FROM [ivh].[getExecutionTree] (@api_name, 1) ORDER BY [sequence];


	-- [18] API: ImportMatchingSoftwareFiles
	SET @solution = 'IDR'

	EXEC [ivh].[api_addNode] @solution = @solution, @public = 1, @api = N'ImportMatchingSoftwareFiles', @entry_point = N'\SSISDB\$(SsisProjectName)\PlatformHandlers\InvocationHandler.dtsx', @type = N'project', @server = @deployment_server, @debug=@debug
	EXEC [ivh].[api_addNode] @solution = @solution, @public = 0, @api = N'ImportMatchingSoftwareFile', @entry_point = N'\SSISDB\$(SsisProjectName)\DatacoreIDResolving\importMatchingSoftwareFile.dtsx', @type = N'project', @server = @deployment_server, @debug=@debug

	EXEC [ivh].[api_addEdge] @solution = @solution, @from_node = N'ImportMatchingSoftwareFiles', @to_node = N'ImportMatchingSoftwareFile', @parallel=1, @debug=@debug

	IF @debug = 1 SELECT * FROM [ivh].[getExecutionTree] ('ImportMatchingSoftwareFiles', 1) ORDER BY [sequence];


	-- [19] API: LoadCpcScoresDatamart
	SET @solution = 'GovernanceBox'
	SET @api_name = N'LoadTechnologyScoresDatamart'

	EXEC [ivh].[api_addNode] @solution = @solution, @public = 1, @api = @api_name, @entry_point = N'\SSISDB\$(SsisProjectName)\PlatformHandlers\InvocationHandler.dtsx', @type = N'project', @server = @deployment_server, @debug=@debug
	EXEC [ivh].[api_addNode] @solution = @solution, @public = 0, @api = N'LoadCalendar', @entry_point = N'\SSISDB\$(SsisProjectName)\WebshopFocusReports\LoadCalendar.dtsx', @type = N'project', @server = @deployment_server, @debug=@debug
	EXEC [ivh].[api_addNode] @solution = @solution, @public = 0, @api = N'LoadCompanies', @entry_point = N'\SSISDB\$(SsisProjectName)\WebshopFocusReports\LoadCompanies.dtsx', @type = N'project', @server = @deployment_server, @debug=@debug
	EXEC [ivh].[api_addNode] @solution = @solution, @public = 0, @api = N'LoadIndustries', @entry_point = N'\SSISDB\$(SsisProjectName)\WebshopFocusReports\LoadIndustries.dtsx', @type = N'project', @server = @deployment_server, @debug=@debug
	EXEC [ivh].[api_addNode] @solution = @solution, @public = 0, @api = N'LoadCountries', @entry_point = N'\SSISDB\$(SsisProjectName)\WebshopFocusReports\LoadCountries.dtsx', @type = N'project', @server = @deployment_server, @debug=@debug
	EXEC [ivh].[api_addNode] @solution = @solution, @public = 0, @api = N'LoadSubjects', @entry_point = N'\SSISDB\$(SsisProjectName)\WebshopFocusReports\LoadSubjects.dtsx', @type = N'project', @server = @deployment_server, @debug=@debug
	EXEC [ivh].[api_addNode] @solution = @solution, @public = 0, @api = N'LoadTechnologyScores', @entry_point = N'\SSISDB\$(SsisProjectName)\WebshopFocusReports\LoadTechnologyScores.dtsx', @type = N'project', @server = @deployment_server, @debug=@debug

	EXEC [ivh].[api_addEdge] @solution = @solution, @from_node = @api_name, @to_node = N'LoadCalendar', @parallel=1, @debug=@debug
	EXEC [ivh].[api_addEdge] @solution = @solution, @from_node = @api_name, @to_node = N'LoadCompanies', @parallel=1, @debug=@debug
	EXEC [ivh].[api_addEdge] @solution = @solution, @from_node = @api_name, @to_node = N'LoadIndustries', @parallel=1, @debug=@debug
	EXEC [ivh].[api_addEdge] @solution = @solution, @from_node = @api_name, @to_node = N'LoadCountries', @parallel=1, @debug=@debug
	EXEC [ivh].[api_addEdge] @solution = @solution, @from_node = @api_name, @to_node = N'LoadSubjects', @parallel=1, @debug=@debug
	EXEC [ivh].[api_addEdge] @solution = @solution, @from_node = @api_name, @to_node = N'LoadTechnologyScores', @parallel=0, @debug=@debug

	IF @debug = 1 SELECT * FROM [ivh].[getExecutionTree] (@api_name, 1) ORDER BY [sequence];

	-- [20] API: AnswerQuestion
	SET @solution = 'PRV'

	EXEC [ivh].[api_addNode] @solution = @solution, @public = 1, @api = N'AnswerQuestion', @entry_point = N'\SSISDB\$(SsisProjectName)\PlatformHandlers\InvocationHandler.dtsx', @type = N'project', @server = @deployment_server, @debug=@debug--, @wait_for_completion=1
	EXEC [ivh].[api_addNode] @solution = @solution, @public = 0, @api = N'StoreAnswer', @entry_point = N'\SSISDB\$(SsisProjectName)\PlatformComponents\StoreAnswer.dtsx', @type = N'project', @server = @deployment_server, @debug=@debug

	EXEC [ivh].[api_addEdge] @solution = @solution, @from_node = N'AnswerQuestion', @to_node = N'StoreAnswer', @debug=@debug


	-- [21] API: RefreshTechnologyScoresToWeb
	SET @solution = 'GovernanceBox'
	SET @api_name = N'RefreshTechnologyScores'

	EXEC [ivh].[api_addNode] @solution = @solution, @public = 1, @api = @api_name, @entry_point = N'\SSISDB\$(SsisProjectName)\PlatformHandlers\InvocationHandler.dtsx', @type = N'project', @server = @deployment_server, @debug=@debug

	EXEC [ivh].[api_addEdge] @solution = @solution, @from_node = @api_name, @to_node = N'LoadTechnologyScores', @parallel=0, @debug=@debug
	EXEC [ivh].[api_addEdge] @solution = @solution, @from_node = @api_name, @to_node = N'PublishTopicScoresDatamart', @parallel=0, @debug=@debug

	IF @debug = 1 SELECT * FROM [ivh].[getExecutionTree] (@api_name, 1) ORDER BY [sequence];

	-- [22] API: UpdateScoreTable
	SET @solution = 'PRV'

	EXEC [ivh].[api_addNode] @solution = @solution, @public = 1, @api = N'UpdateScoreTable', @entry_point = N'\SSISDB\$(SsisProjectName)\PlatformHandlers\InvocationHandler.dtsx', @type = N'project', @server = @deployment_server, @debug=@debug
	EXEC [ivh].[api_addNode] @solution = @solution, @public = 0, @api = N'ImportScoreTable', @entry_point = N'\SSISDB\$(SsisProjectName)\PlatformComponents\ImportProjectScoreTable.dtsx', @type = N'project', @server = @deployment_server, @debug=@debug

	EXEC [ivh].[api_addEdge] @solution = @solution, @from_node = N'UpdateScoreTable', @to_node = N'ImportScoreTable', @debug=@debug


create_default_configitems:

	; WITH config_items (api_id, item_type, item_key, item_default, description) AS 
	(
		SELECT [id]
			, 'initialisation'
			, 'component_config'
			, '{}'
			, 'contains the json-string with all applicable configuration items'
		FROM [ivh].[api]
		WHERE [Type] = 'project'
		AND [entry_point] NOT LIKE '%Handler.dtsx'
	)

	MERGE INTO [ivh].[api_configitem] T
	USING config_items S ON S.[api_id] = T.[api_id] AND S.[item_type] = T.[item_type] AND S.[item_key] = T.[item_key]
	WHEN MATCHED THEN
		UPDATE SET [item_default] = S.[item_default]
					, [description] = S.[description]
	WHEN NOT MATCHED BY SOURCE THEN
		DELETE
	WHEN NOT MATCHED BY TARGET THEN
		INSERT (api_id, item_type, item_key, item_default, description)
		VALUES (S.[api_id], S.[item_type], S.[item_key], S.[item_default], S.[description])
	;
--

/*
Reference: https://technet.microsoft.com/en-us/library/cc765981.aspx
*/

--[nlh].[event_level] ([name],[description])
DECLARE @referenceDataTable TABLE(name nvarchar(64), [description] nvarchar(256))
INSERT INTO @referenceDataTable 
     VALUES
           ('Information', 'Indicates that a change in an application or component has occurred, such as an operation has successfully completed, a resource has been created, or a service started.')
		   , ('Warning','Indicates that an issue has occurred that can impact service or result in a more serious problem if action is not taken.')
		   , ('Error','Indicates that a problem has occurred, which might impact functionality that is external to the application or component that triggered the event.')
		   , ('Critical','Indicates that a failure has occurred from which the application or component that triggered the event cannot automatically recover.')

MERGE INTO [nlh].[event_level] T
USING @referenceDataTable S ON S.[name] = T.[name]
WHEN MATCHED THEN
	UPDATE SET [description] = S.[description]
WHEN NOT MATCHED BY TARGET THEN
	INSERT  ( [name],[description] ) 
	VALUES ( S.[name], S.[description] )
;


--[nlh].[event_log] ([name],[description]) 
DELETE FROM @referenceDataTable;
INSERT INTO @referenceDataTable
           ([name]
           ,[description])
     VALUES
           ('System','Contains all platform events')
		   , ('Application','Contains all component events')

MERGE INTO [nlh].[event_log] T
USING @referenceDataTable S ON S.[name] = T.[name]
WHEN MATCHED THEN
	UPDATE SET [description] = S.[description]
WHEN NOT MATCHED BY TARGET THEN
	INSERT  ( [name],[description] ) 
	VALUES ( S.[name], S.[description] )
;


--[nlh].[event_type] ([name],[description]) 
DELETE FROM @referenceDataTable;
INSERT INTO @referenceDataTable
           ([name]
           ,[description])
     VALUES
           ('start', 'Process step started')
		   , ('fail','Process step failed') 
		   , ('complete','Process step successfully completed') 
		   , ('progress','Process step reports progress') 
		   , ('run_complete', 'All process steps of run completed successfully')
		   , ('run_fail', 'One or more process steps of run reported failure')

MERGE INTO [nlh].[event_type] T
USING @referenceDataTable S ON S.[name] = T.[name]
WHEN MATCHED THEN
	UPDATE SET [description] = S.[description]
WHEN NOT MATCHED BY TARGET THEN
	INSERT  ( [name],[description] ) 
	VALUES ( S.[name], S.[description] )
;


/* Make default configuration for Unit testing packages (run_id=-1) */
	declare @unit_test_config nvarchar(max);
	set @unit_test_config = N'{"Header": {
    "Creator": "developer@deloitte.nl"
  },
  "ComponentParams" : [ 
	{ 	"PackageName":"CreatePrepareEnvironment" 
	}, { 	"PackageName":"CompanyRetrieval"
		, "RetrievalParams" : [
			{"RetrievalType" : "CompanyList"
			, "RetrievalLabel" : "Marked companies"
			, "CompanyId" : "USD305504941D|DE2010000581"
			},{"RetrievalType" : "CompanyTextBagOfWords"
			, "RetrievalLabel" : "Business - AM"
			, "NumberOfCompanies" : 5
			, "Normalize" : "None"
			, "BagOfWords" : "additive manuf*|3d print*"
			},{ "RetrievalType" : "PatentClassProfile"
			, "RetrievalLabel" : "IP - AM"
			, "NumberOfCompanies" : 5
			, "Normalize" : "None"
			, "ClassProfile" : "B33Y 30/00:0.32|B33Y 70/00:0.254545|B33Y 80/00:0.423423"
			}
		]
	}, { 	"PackageName":"CompanyScoring"
		, "ScoringParams" : [
			{"ScoringType" : "OrbisAttribute"
			, "ScoringLabel" : "Country"
			, "AttributeName" : "country"
			},{"ScoringType" : "OrbisAttribute"
			, "ScoringLabel" : "Age"
			, "AttributeName" : "age"
			},{"ScoringType" : "IndustryAttribute"
			, "ScoringLabel" : "Industry"
			},{"ScoringType" : "CompanyTextBagOfWords"
			, "ScoringLabel" : "Business - AM"
			, "Normalize" : "Portfolio"
			, "BagOfWords" : "additive manuf*|3d print*"
			},{"ScoringType" : "PatentClassProfile"
			, "ScoringLabel" : "IP - AM"
			, "Normalize" : "Portfolio"
			, "ClassProfile" : "B33Y 30/00:0.32|B33Y 70/00:0.254545|B33Y 80/00:0.423423"
			}
		]
	}, { 	"PackageName":"PrepareForVisualization"
	}, { 	"PackageName":"SelectLandscapeNodes"
		, "NodeSelectionParams" :[
			{"NodeSelectionType" : "NodeList"
			, "NodeSelectionLabel" : "Test Node List"
			, "NodeList" : "B33Y 30/00|B33Y 70/00|B33Y 80/00|A61C 13/0019"
			}
		] 
	},{
		"PackageName":"GroupScoresInBaskets"
		, "ScoreGroupingParams" : [
		{
		"GroupingType" : "Percentiles"
		, "ScoringLabel" : "Age percentile"
		, "SourceScoringLabel" : "Age"
		, "NumberOfBaskets" : 3
		}, {
		"GroupingType" : "CustomBasketBounds"
		, "ScoringLabel" : "Age Basket"
		, "SourceScoringLabel" : "Age"
		, "BasketBounds" : "5|25|100|500"
		}, {
		"GroupingType" : "CustomBasketValues"
		, "ScoringLabel" : "Region"
		, "SourceScoringLabel" : "Country"
		, "BasketValues" : "Europe:NL,DE,FR,BE,ES,IT,GB|North America:US,CA,MX|Asia:CN,JP,TW,KR"
		}
	]
	}, { 	"PackageName":"ScoreLandscapeNodes"
		, "ScoreLandscapeNodesParams" :[
			{"ScoringType" : "CompanyPortfolio"
			, "ScoreGroup" : "Relevance"
			, "SeriesGroup" : "Relevant Companies"
			, "Normalize" : "None"
			, "CompanyId" : "USD305504941D|DE2010000581"
			},{"ScoringType" : "BagOfWords"
			, "ScoringLabel" : "Additive manufacturing"
			, "ScoreGroup" : "Relevance"
			, "SeriesGroup" : "Strategic area"
			, "Normalize" : "None"
			, "BagOfWords" : "additive manufact*|3d print*"
			},{"ScoringType" : "CompanyPortfolio"
			, "ScoreGroup" : "Weight"
			, "SeriesGroup" : "Relevant Companies"
			, "Normalize" : "Class"
			, "CompanyId" : "USD305504941D|DE2010000581"
			},{"ScoringType" : "BagOfWords"
			, "ScoringLabel" : "Additive manufacturing"
			, "ScoreGroup" : "Weight"
			, "SeriesGroup" : "Strategic area"
			, "Normalize" : "Class"
			, "BagOfWords" : "additive manufact*|3d print*"
			}
		]
	}, { 	"PackageName":"GetNodeProperties"
		, "GetNodePropertiesParams" :[
			{"PropertyLabel" : "Label"
			, "PropertyMethod" : "TechnologyClassLabel"
			},{"PropertyLabel" : "High Level Label"
			, "PropertyMethod" : "HighLevelTechnologyLabel"
			, "PropertyParameters" : "B33:Additive manufacturing"
			}
		]
	}, { "PackageName":"CalculateLandscapeDistances"
	}, { "PackageName":"ApproximateDistanceIn2D"
		, "NormalizeDistance" : "none"
					, "RandomSeed" : 0
			, "MaxIterations" : 100
			, "Algorithm" : "Random"
	} ,{ 	"PackageName":"GenerateMatlabTable"
		, "YearSpan":"2010-2015" 	, "Financials":"employees|revenue"
	},{
      "PackageName": "ImportProjectScoreTable",
      "ImportProjectScoreTableParams": {
        "ExcelPath": "\\\\nl\\data\\DataCore\\DataStore\\Projects\\SDIP Large cap\\SDImapping_unverified_with_client.xlsx"
      }
    }, { "PackageName":"End2EndIntegrationTest"
	, "RetrievalParams" : [
			{"RetrievalType" : "NutsRegionBag"
			, "CompanyId" : "TESTCOMPANYID"
			, "NumberOfCompanies" : 3
		}]
	}, { "PackageName":"GetKeywordProfile"
		, "GetKeywordProfileParams":{"BagOfWords" : "additive~manufacturing","NumberOfClasses":50,"MinimalClassSize":500,"StoreInProject":true}
	},{
      "PackageName": "StoreAnswer",
      "AnswerParams": [
        {
          "CompanyId": "AB1234",
          "QuestionName": "Q001 Why is it suitable",
          "QuestionId": 1,
          "Answer": "Because it is just so awesome",
          "Reference": "http://www.testcompany.nl"
        },
        {
          "CompanyId": "AB1234",
          "QuestionName": "Q002 Segment",
          "QuestionId": 2,
          "CheckedAnswers": [
            {
              "Id": 2,
              "Value": "Mid-cap",
              "Reference": "http://www.testcompany.nl/annual-report"
            }
          ]
        },
        {
          "CompanyId": "AB1234",
          "QuestionName": "Q003 Industries",
          "QuestionId": 3,
          "CheckedAnswers": [
            {
              "Id": 4,
              "Value": "Sustainable construction",
              "Reference": "http://www.testcompany.nl/industries/construction"
            },
            {
              "Id": 7,
              "Value": "Water engineering",
              "Reference": "http://www.testcompany.nl/products/dams_and_lakes"
            },
            {
              "Id": 5,
              "Value": "Renewable energy",
              "Reference": "http://www.testcompany.nl/upcoming/building_windmills"
            }
          ]
        }
      ]
    }
]}' 
	DELETE FROM ivh.run_paramvalue WHERE run_id=-1
	INSERT INTO ivh.run_paramvalue (run_id, parameter,value) values(-1,'api_config',@unit_test_config);
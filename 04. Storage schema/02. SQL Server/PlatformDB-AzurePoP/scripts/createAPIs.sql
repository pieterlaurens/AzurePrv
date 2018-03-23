DECLARE @deployment_server sysname = 'nlagpdatacore';

--TRUNCATE TABLE nlh.[log]
--TRUNCATE TABLE nlh.[event]

TRUNCATE TABLE ivh.api
TRUNCATE TABLE ivh.api_workflow
TRUNCATE TABLE ivh.run
TRUNCATE TABLE ivh.run_paramvalue
TRUNCATE TABLE ivh.run_configvalue
TRUNCATE TABLE ivh.run_exectree

SET IDENTITY_INSERT ivh.api ON
-- API: CreateLonglist
INSERT INTO ivh.api ([id], solution, api, [public], server, entry_point, type)
	VALUES (1, 'PRV', 'CreateLonglist', 1, @deployment_server, '\SSISDB\PRV\PlatformHandlers\InvocationHandler.dtsx', 'project')
			, (2, 'PRV', 'Longlist 1.1', 0, @deployment_server, 'PrepareProject', 'api')
			, (3, 'PRV', 'Longlist 1.2', 0, @deployment_server, 'RetrieveCompanies', 'api')
			, (4, 'PRV', 'Longlist 1.3', 0, @deployment_server, 'ScoreCompanies', 'api')
			, (5, 'PRV', 'Longlist 1.4', 0, @deployment_server, 'PublishProject', 'api')
			, (6,'PRV', 'PrepareProject', 0, @deployment_server, '\SSISDB\PRV\PlatformComponents\CreatePrepareEnvironment.dtsx', 'project')
			, (7,'PRV', 'RetrieveCompanies', 0, @deployment_server, '\SSISDB\PRV\PlatformComponents\CompanyRetrieval.dtsx', 'project')
			, (8,'PRV', 'ScoreCompanies', 0, @deployment_server, '\SSISDB\PRV\PlatformComponents\CompanyScoring.dtsx', 'project')
			, (9,'PRV', 'PublishProject', 0, @deployment_server, '\SSISDB\PRV\PlatformComponents\PrepareForVisualization.dtsx', 'project')
INSERT INTO ivh.api_workflow (caller_api_id, callee_api_id, sequence, dependent_on)
	VALUES (1,2,1,NULL)
			, (2,6,1,NULL)
			, (1,3,2,NULL)
			, (3,7,1,NULL)
			, (1,4,3,NULL)
			, (4,8,1,NULL)
			, (1,5,4,NULL)
			, (5,9,1,NULL)

-- API: CreateLandscape
INSERT INTO ivh.api ([id], solution, api, [public], server, entry_point, type)
	VALUES (10, 'PRV', 'CreateLandscape', 1, @deployment_server, '\SSISDB\PRV\PlatformHandlers\InvocationHandler.dtsx', 'project')
			, (12, 'PRV', 'Landscape 1.2', 0, @deployment_server, 'SelectLandscapeNodes', 'api')
			, (13, 'PRV', 'Landscape 1.3', 0, @deployment_server, 'ScoreLandscapeNodes', 'api')
			, (14, 'PRV', 'Landscape 1.4', 0, @deployment_server, 'GetNodeProperties', 'api')
			, (15, 'PRV', 'Landscape 1.5', 0, @deployment_server, 'CalculateLandscapeDistances', 'api')
			, (16, 'PRV', 'Landscape 1.6', 0, @deployment_server, 'ApproximateDistanceIn2D', 'api')
			, (19,'PRV', 'SelectLandscapeNodes', 0, @deployment_server, '\SSISDB\PRV\PlatformComponents\SelectLandscapeNodes.dtsx', 'project')
			, (20,'PRV', 'ScoreLandscapeNodes', 0, @deployment_server, '\SSISDB\PRV\PlatformComponents\ScoreLandscapeNodes.dtsx', 'project')
			, (21,'PRV', 'GetNodeProperties', 0, @deployment_server, '\SSISDB\PRV\PlatformComponents\GetNodeProperties.dtsx', 'project')
			, (22,'PRV', 'CalculateLandscapeDistances', 0, @deployment_server, '\SSISDB\PRV\PlatformComponents\CalculateLandscapeDistances.dtsx', 'project')
			, (23,'PRV', 'ApproximateDistanceIn2D', 0, @deployment_server, '\SSISDB\PRV\PlatformComponents\ApproximateDistanceIn2D.dtsx', 'project')
INSERT INTO ivh.api_workflow (caller_api_id, callee_api_id, sequence, dependent_on)
	VALUES (10,2,1,NULL)
			, (10,12,2,NULL)
			, (12,19,1,NULL)
			, (10,13,3,NULL)
			, (13,20,1,NULL)
			, (10,14,3,NULL)
			, (14,21,1,NULL)
			, (10,15,3,NULL)
			, (15,22,1,NULL)
			, (10,16,3,'15')
			, (16,23,1,NULL)
			, (10,5,4,NULL)						

-- API: Generate MATLAB table
INSERT INTO ivh.api ([id], solution, api, [public], server, entry_point, type)
	VALUES (24, 'PRV', 'GenerateMatlabTable', 1, @deployment_server, '\SSISDB\PRV\PlatformHandlers\InvocationHandler.dtsx', 'project')
			, (25, 'PRV', 'MatlabTable 1.1', 0, @deployment_server, 'GenerateMatlabTable', 'api')
			, (26,'PRV', 'CreateMatlabTable', 0, @deployment_server, '\SSISDB\PRV\PlatformComponents\GenerateMatlabTable.dtsx', 'project')
INSERT INTO ivh.api_workflow (caller_api_id, callee_api_id, sequence, dependent_on)
	VALUES (24,25,1,NULL)
			, (25,26,2,NULL)

SET IDENTITY_INSERT ivh.api OFF

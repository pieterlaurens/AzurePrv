--use prv_dev_inh

-----------------------
/* INITIALIZE SOLUTION 

Fill the solution databases with appropriate values and point to the shared components and feature components.
Create a work flow as a tree of components.

*/
-----------------------
DECLARE @api nvarchar(512) = 'AddScoreToLonglist' -- possible values {'CreateLonglist', 'CreateLandscape')
DECLARE @deployment_server sysname = 'nlagpdatacore'

-----------------------
/* END INITIALIZATION 

THe following steps will need to be done by the website. A lot of that can be shorthanded of course.

*/
-----------------------
DECLARE @RC int
DECLARE @projectid int = 007
DECLARE @projectkey nvarchar(100) = 'testPipeline'
DECLARE @solution nvarchar(255) = 'PRV'
DECLARE @runid int
DECLARE @json_sla nvarchar(max)
DECLARE @json_config_1 nvarchar(max)
DECLARE @json_config_2 nvarchar(max)
DECLARE @debug tinyint

SET @runid = 0
--SET @runid = IDENT_CURRENT('ivh.run')

-----------------------
/* MAKE SURE TO CONFIGURE THESE SETTINGS BEFORE EVERY RUN

This is the setting of the three main configuration parameters: project key, SLA/contract and the configuration

*/
-----------------------
SET @projectkey = CONCAT(@projectkey, @solution, '_', @api, '_', @runid)

SET @json_sla = N'{"ComponentID": "D0E4F952-663C-42CA-89E8-318C931D42A9"
					, "RunID": "-1"
					, "PollEvery": "00:00:10"
					, "TimeOutAfter": "3600"
					, "PlatformDataSource": "nlagpdatacore"
					, "PlatformCatalog": "prv_dev_inh"
					, "DatahandlerDataSource": "NLAGPDATACORE"
					, "DatahandlerCatalog": "prv_app_dth"
					, "DatahandlerVersion": "honeyrider"
					, "ProjectDataSource":"nlagpdatacore"
					, "ProjectCatalog":"prv_prj_equip2"
				}'


	SET @json_config_1 = N'{"ComponentParams" : [ 
	{ "PackageName":"CompanyScoring"
	, "ScoringParams" : [
		{"ScoringType" : "ManualScore"
		, "ScoringLabel" : "Value Chain Position"
		, "ScoreDataType" : "nvarchar"
		, "CompanyScore" : "CHCHE107136256:Raw Materials|CHCHE110110814:Design IP|CN30081PC:Raw Materials|CN9360000140:Design IP|DE2010000581:Software|DE2010000581:Printers|DE2270172157:Printers|DE2270172157:Raw Materials|DE4070280762:Raw Materials|DE4290178888:Printers|DE5330000056:Raw Materials|DE7150000030:Raw Materials|DE7230336659:Printers|DE7330593711:Printers|DE8030366267:Printers|DE8030366267:Raw Materials|DK32365590:Printers|FR41028670200056:Raw Materials|FR443645551:Printers|FR443645551:Software|FR445074685:Raw Materials|FR49956881400051:Printers|FR49956881400051:Software|FR49956881400051:Raw Materials|GB01106260:Printers|GB01106260:Raw Materials|GB03903306:Raw Materials|GB03903306:Software|GB03903306:Printers|IE389190:Printers|IL31714NU:Printers|IL31714NU:Software|IL31714NU:Raw Materials|ITMN0149665:Printers|ITMO0379518:Raw Materials|JP000020437JPN:Printers|JP000030720JPN:Printers|JP000030797JPN:Raw Materials|JP000090035JPN:Raw Materials|JP042747717S:Printers|JP042747717S:Raw Materials|JP130856896S:Printers|JP558828617S:Printers|KR1601110122880-2:Printers|NL14076998:Raw Materials|NL14095340:Raw Materials|SE5562889401:Raw Materials|SE5565395356:Printers|US*1550089520:Printers|US060570975:Design IP|US140689340:Printers|US222640650:Design IP|US222640650:Software|US461684608:Printers|US461684608:Raw Materials|US942802192:Software"
		}]
	}
	, { "PackageName":"PrepareForVisualization" }
	]}' 


	SET @json_config_2 = N'{"ComponentParams" : [ 
	{ "PackageName":"CompanyScoring"
	, "ScoringParams" : [
		{"ScoringType" : "ManualScore"
		, "ScoringLabel" : "Value Chain Position"
		, "ScoreDataType" : "nvarchar"
		, "CompanyScore" : "AT9070005375:Design IP|CA132894825L:Raw Materials|BE0811784189:Software"
		}]
	}
	, { "PackageName":"PrepareForVisualization" }
	]}' 


-----------------------
/* END CONFIGURATION 

Actually launch the pipeline.

*/
-----------------------

EXECUTE @RC = [ivh].[run_createNewRun] 
   @projectid = @projectid
  ,@projectkey = @projectkey
  ,@solution = @solution
  ,@api = @api
  ,@runid = @runid
  ,@json_sla = @json_sla
  ,@json_config = @json_config_1
  ,@debug = 1

WAITFOR DELAY '00:00:45';

  EXECUTE @RC = [ivh].[run_createNewRun] 
   @projectid = @projectid
  ,@projectkey = @projectkey
  ,@solution = @solution
  ,@api = @api
  ,@runid = @runid
  ,@json_sla = @json_sla
  ,@json_config = @json_config_2
  ,@debug = 1
GO


-----------------------
/* GET log/event INFORMATION */
-----------------------
SELECT TOP 1000 *
  FROM [nlh].[log]
  WHERE source_name <> 'PackageTemplate.dtsx'
  ORDER BY added_on DESC

SELECT TOP 1000 *
  FROM [nlh].[event]
  ORDER BY added_on DESC

/*
-----------------------
/* RUN FROM VISUAL STUDIO */
-----------------------
TRUNCATE TABLE ivh.run_exectree
UPDATE [prv_app_inh].[ivh].[run] SET status = 'Pending' WHERE id = 1

SELECT * FROM [prv_app_inh].[ivh].[run]

SELECT id, server, entry_point, type
FROM ivh.run_exectree
WHERE run_id = 1
ORDER BY sequence ASC
*/
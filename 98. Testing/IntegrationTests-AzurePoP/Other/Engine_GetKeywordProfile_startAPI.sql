use prv_dev_inh

DECLARE @api nvarchar(512) = 'GetKeywordProfile'

-----------------------
/*

THe following steps will need to be done by the website. A lot of that can be shorthanded of course.

*/
-----------------------
DECLARE @RC int
DECLARE @projectid int = 007
DECLARE @projectkey nvarchar(100) = 'testPipeline'
DECLARE @solution nvarchar(255) = 'PRV'
DECLARE @runid int
DECLARE @json_sla nvarchar(max)
DECLARE @json_config nvarchar(max)
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
					, "DatahandlerVersion": "felix"
					, "ProjectDataSource":"nlagpdatacore"
					, "ProjectCatalog":"prv_prj_equip2"
				}'

/**/SET @json_config = N'{"Header":{
						"NameOfApi":"GetKeywordProfile",
						"Creator":"pbaljon@deloitte.nl",
						"ConfigurationDescription":"",
						"ConfigurationVersion":"",
					},"ComponentParams" : [ 
					{
						"PackageName":"GetKeywordProfile",
						"GetKeywordProfileParams":{
							"ProfileType":"CompanyNameToCpc",
							"BagOfWOrds":"dsm",
							"MinimalClassSize":1000,
							"ScopeToProject":true
						}
					}
					]}' 

/*SET @json_config = N'{"Header":{
						"NameOfApi":"GetKeywordProfile",
						"Creator":"kwesseling@deloitte.nl",
						"ConfigurationDescription":"",
						"ConfigurationVersion":"",
					},"ComponentParams" : [ 
					{
						"PackageName":"GetKeywordProfile",
						"GetKeywordProfileParams":{
							"ProfileType":"BowToCpc",
							"BagOfWOrds":"thermoplastic",
							"MinimalClassSize":1000,
							"NumberOfClasses":100,
							"ScopeToProject":false
						}
					}
					]}' */

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
  ,@json_config = @json_config
  ,@debug = 1



-----------------------
/* GET log/event INFORMATION */
-----------------------
SELECT TOP 1000 *
  FROM [prv_app_inh].[nlh].[log]
  WHERE source_name <> 'PackageTemplate.dtsx'
  ORDER BY added_on DESC

SELECT TOP 1000 *
  FROM [prv_app_inh].[nlh].[event]
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
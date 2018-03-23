use prv_app_inh

DECLARE @api nvarchar(512) = 'AddScoreToLonglist'

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
					, "PlatformCatalog": "prv_app_inh"
					, "DatahandlerDataSource": "NLAGPDATACORE"
					, "DatahandlerCatalog": "prv_app_dth"
					, "DatahandlerVersion": "felix"
					, "ProjectDataSource":"nlagpdatacore"
					, "ProjectCatalog":"Validate_Impact_Investing_Landscape_Food"
				}'

/*SET @json_config = N'{"ComponentParams" : [ 
					{
					"ScoringParams" : [
						{
						"ScoringType" : "CompanyTextBagOfWords"
						, "ScoringLabel" : "Plastics Manufacturing"
						, "Normalize" : "Portfolio"
						, "BagOfWords" : "Plastic|Thermoplastic"
						}, {
						"ScoringType" : "OrbisAttribute"
						, "ScoringLabel" : "Country"
						, "AttributeName" : "country"
						},{
						"ScoringType" : "OrbisAggregateAttribute"
						, "ScoringLabel" : "Number of Acquisitions"
						, "AttributeName" : "number_of_acquisitions"
						}
					]
					},
					{}
					]}' */

SET @json_config = N'{"Header":{
						"NameOfApi":"ImpactAddScore",
						"Creator":"orakic@deloitte.nl",
						"ConfigurationDescription":"",
						"ConfigurationVersion":"",
					},"ComponentParams" : [ 
					{
					"PackageName":"CompanyScoring",
					"ScoringParams" : [
						{
						"ScoringType" : "OrbisAttribute"
						, "ScoringLabel" : "Country"
						, "AttributeName" : "country"
						},{
						"ScoringType" : "OrbisAttribute"
						, "ScoringLabel" : "Number of Patents"
						, "AttributeName" : "number_of_patents"
						},{
						"ScoringType" : "OrbisAttribute"
						, "ScoringLabel" : "listed"
						, "AttributeName" : "listed"
						},{
						"ScoringType" : "OrbisAttribute"
						, "ScoringLabel" : "website"
						, "AttributeName" : "website"
						},{
						"ScoringType" : "OrbisAttribute"
						, "ScoringLabel" : "guo_bvd_id"
						, "AttributeName" : "guo_bvd_id"
						},{
						"ScoringType" : "OrbisAttribute"
						, "ScoringLabel" : "guo_name"
						, "AttributeName" : "guo_name"
						}
					]
					},
					{"PackageName":"PrepareForVisualization"}
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
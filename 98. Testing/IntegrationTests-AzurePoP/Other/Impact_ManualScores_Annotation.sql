--use prv_dev_inh

-----------------------
/* INITIALIZE SOLUTION 

Fill the solution databases with appropriate values and point to the shared components and feature components.
Create a work flow as a tree of components.

*/
-----------------------
DECLARE @api nvarchar(512) = 'AddScoreToLonglist' -- possible values {'CreateLonglist', 'CreateLandscape')
DECLARE @deployment_server sysname = 'nlams00859'

-----------------------
/* END INITIALIZATION 

THe following steps will need to be done by the website. A lot of that can be shorthanded of course.

*/
-----------------------
DECLARE @RC int
DECLARE @projectid int = 007
DECLARE @projectkey nvarchar(100) = 'Impact'
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
					, "PlatformDataSource": "nlams00859"
					, "PlatformCatalog": "prv_dev_inh"
					, "DatahandlerDataSource": "nlams00859"
					, "DatahandlerCatalog": "prv_dev_dth"
					, "DatahandlerVersion": "jaws"
					, "ProjectDataSource":"nlams00859"
					, "ProjectCatalog":"prv_prj_deploytest"
				}'


/*EXECUTE @RC = [ivh].[run_createNewRun] 
   @projectid = @projectid
  ,@projectkey = @projectkey
  ,@solution = @solution
  ,@api = @api
  ,@runid = @runid
  ,@json_sla = @json_sla
  ,@json_config = N'{"Header":{
	"NameOfApi":"AddScoreToLonglist",
	"Creator":"pbaljon@deloitte.nl",
	"ConfigurationDescription":"",
	"ConfigurationVersion":"",
},"ComponentParams" : [ 
	{ "PackageName":"CompanyScoring"
	, "ScoringParams" : [
		{"ScoringType" : "ManualScore"
		, "ScoringLabel" : "Product impact"
		, "ScoreDataType" : "nvarchar"
		, "CompanyScore" : "DE8030366267:High, 3D printers allow people to save logistics"
		},{"ScoringType" : "ManualScore"
		, "ScoringLabel" : "Value chain impact"
		, "ScoreDataType" : "nvarchar"
		, "CompanyScore" : "DE8030366267:Low, Producing 3D printers has great impact on enironment"
		},{"ScoringType" : "ManualScore"
		, "ScoringLabel" : "Future impact"
		, "ScoreDataType" : "nvarchar"
		, "CompanyScore" : "DE8030366267:Medium, no expression of improvement"
		},{"ScoringType" : "ManualScore"
		, "ScoringLabel" : "PR impact"
		, "ScoreDataType" : "nvarchar"
		, "CompanyScore" : "DE8030366267:High, positioning as a sustainable company"
		}]
	}
	, { "PackageName":"PrepareForVisualization" }
	]}'
  ,@debug = 1 
  
WAITFOR DELAY '00:00:10';

EXECUTE @RC = [ivh].[run_createNewRun] 
   @projectid = @projectid
  ,@projectkey = @projectkey
  ,@solution = @solution
  ,@api = @api
  ,@runid = @runid
  ,@json_sla = @json_sla
  ,@json_config = N'{"Header":{
	"NameOfApi":"AddScoreToLonglist",
	"Creator":"pbaljon@deloitte.nl",
	"ConfigurationDescription":"",
	"ConfigurationVersion":"",
},"ComponentParams" : [ 
	{ "PackageName":"CompanyScoring"
	, "ScoringParams" : [
		{"ScoringType" : "ManualScore"
		, "ScoringLabel" : "Product impact"
		, "ScoreDataType" : "nvarchar"
		, "CompanyScore" : "DE2010000581:High, especially wind power"
		},{"ScoringType" : "ManualScore"
		, "ScoringLabel" : "Value chain impact"
		, "ScoreDataType" : "nvarchar"
		, "CompanyScore" : "DE2010000581:Low, depleting earth resources"
		},{"ScoringType" : "ManualScore"
		, "ScoringLabel" : "Future impact"
		, "ScoreDataType" : "nvarchar"
		, "CompanyScore" : "DE2010000581:High, developing extensive wind-power IP"
		},{"ScoringType" : "ManualScore"
		, "ScoringLabel" : "PR impact"
		, "ScoreDataType" : "nvarchar"
		, "CompanyScore" : "DE2010000581:Medium, no emphasis on impact"
		}]
	}
	, { "PackageName":"PrepareForVisualization" }
	]}'
  ,@debug = 1 

  */
EXECUTE @RC = [ivh].[run_createNewRun] 
   @projectid = @projectid
  ,@projectkey = @projectkey
  ,@solution = @solution
  ,@api = @api
  ,@runid = @runid
  ,@json_sla = @json_sla
  ,@json_config = N'{"Header":{
	"NameOfApi":"AddScoreToLonglist",
	"Creator":"pbaljon@deloitte.nl",
	"ConfigurationDescription":"",
	"ConfigurationVersion":"",
},"ComponentParams" : [ 
	{ "PackageName":"CompanyScoring"
	, "ScoringParams" : [
		{"ScoringType" : "ManualScore"
		, "ScoringLabel" : "Personel impact score"
		, "ScoreDataType" : "real"
		, "CompanyScore" : "US954431352:5"
		}]
	}
	, { "PackageName":"PrepareForVisualization" }
	]}'
  ,@debug = 1 

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
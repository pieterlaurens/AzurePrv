use prv_dev_inh

DECLARE @api nvarchar(512) = 'SetManualScore' -- possible values {'CreateLonglist', 'CreateLandscape')
--DECLARE @api nvarchar(512) = 'AddScoreToLonglist' -- possible values {'CreateLonglist', 'CreateLandscape')
DECLARE @deployment_server sysname = 'nlagpdatacore'

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

SET @projectkey = CONCAT(@projectkey, @solution, '_', @api, '_', @runid)

SET @json_sla = N'{"ComponentID": "D0E4F952-663C-42CA-89E8-318C931D42A9"
					, "RunID": "-1"
					, "PollEvery": "00:00:10"
					, "TimeOutAfter": "3600"
					, "PlatformDataSource": "nlagpdatacore"
					, "PlatformCatalog": "prv_dev_inh"
					, "DatahandlerDataSource": "nlagpdatacore"
					, "DatahandlerCatalog": "prv_dev_dth"
					, "DatahandlerVersion": "spang"
					, "ProjectDataSource":"nlagpdatacore"
					, "ProjectCatalog":"prv_prj_deploytest"
				}'

 -- 1. Happy flow 
EXECUTE @RC = [ivh].[run_createNewRun] 
   @projectid = @projectid
  ,@projectkey = @projectkey
  ,@solution = @solution
  ,@api = @api
  ,@runid = @runid
  ,@json_sla = @json_sla
  ,@json_config = N'{"Header":{
	"NameOfApi":"SetManualScore",
	"Creator":"pbaljon@deloitte.nl",
	"ConfigurationDescription":"",
	"ConfigurationVersion":"",
},"ComponentParams" : [ 
	{ "PackageName":"CompanyScoringSynchronous"
, "ScoringParams" : [
		{"ScoringType" : "ManualScore"
		, "ScoringLabel" : "Country"
		, "ScoreDataType" : "nvarchar"
		, "CompanyScore" : "TW27580987:YY"
		}]
	}
	]}'
  ,@debug = 1 

 /* -- 2. A score_name that doesn't exist */
 EXECUTE @RC = [ivh].[run_createNewRun] 
   @projectid = @projectid
  ,@projectkey = @projectkey
  ,@solution = @solution
  ,@api = @api
  ,@runid = @runid
  ,@json_sla = @json_sla
  ,@json_config = N'{"Header":{
	"NameOfApi":"SetManualScore",
	"Creator":"pbaljon@deloitte.nl",
	"ConfigurationDescription":"",
	"ConfigurationVersion":"",
},"ComponentParams" : [ 
	{ "PackageName":"CompanyScoringSynchronous"
, "ScoringParams" : [
		{"ScoringType" : "ManualScore"
		, "ScoringLabel" : "Non-existing score"
		, "ScoreDataType" : "nvarchar"
		, "CompanyScore" : "TW27580987:chao pleazze!?"
		}]
	}
	]}'
  ,@debug = 1

 /* -- 3. A numeric score type
 EXECUTE @RC = [ivh].[run_createNewRun] 
   @projectid = @projectid
  ,@projectkey = @projectkey
  ,@solution = @solution
  ,@api = @api
  ,@runid = @runid
  ,@json_sla = @json_sla
  ,@json_config = N'{"Header":{
	"NameOfApi":"SetManualScore",
	"Creator":"pbaljon@deloitte.nl",
	"ConfigurationDescription":"",
	"ConfigurationVersion":"",
},"ComponentParams" : [ 
	{ "PackageName":"CompanyScoringSynchronous"
, "ScoringParams" : [
		{"ScoringType" : "ManualScore"
		, "ScoringLabel" : "Age"
		, "ScoreDataType" : "int"
		, "CompanyScore" : "TW27580987:175"
		}]
	}
	]}'
  ,@debug = 1  */

 /* -- 4. Two immediately simultaneous scoring actions 
 EXECUTE @RC = [ivh].[run_createNewRun] 
   @projectid = @projectid
  ,@projectkey = @projectkey
  ,@solution = @solution
  ,@api = @api
  ,@runid = @runid
  ,@json_sla = @json_sla
  ,@json_config = N'{"Header":{
	"NameOfApi":"SetManualScore",
	"Creator":"pbaljon@deloitte.nl",
	"ConfigurationDescription":"",
	"ConfigurationVersion":"",
},"ComponentParams" : [ 
	{ "PackageName":"CompanyScoringSynchronous"
, "ScoringParams" : [
		{"ScoringType" : "ManualScore"
		, "ScoringLabel" : "Country"
		, "ScoreDataType" : "nvarchar"
		, "CompanyScore" : "TW27580987:AA"
		}]
	}
	]}'
  ,@debug = 1 
 EXECUTE @RC = [ivh].[run_createNewRun] 
   @projectid = @projectid
  ,@projectkey = @projectkey
  ,@solution = @solution
  ,@api = @api
  ,@runid = @runid
  ,@json_sla = @json_sla
  ,@json_config = N'{"Header":{
	"NameOfApi":"SetManualScore",
	"Creator":"pbaljon@deloitte.nl",
	"ConfigurationDescription":"",
	"ConfigurationVersion":"",
},"ComponentParams" : [ 
	{ "PackageName":"CompanyScoringSynchronous"
, "ScoringParams" : [
		{"ScoringType" : "ManualScore"
		, "ScoringLabel" : "Country"
		, "ScoreDataType" : "nvarchar"
		, "CompanyScore" : "DE8030366267:BB"
		}]
	}
	]}'
  ,@debug = 1 */

/* -- 5. Two conflicting scoring actions
 EXECUTE @RC = [ivh].[run_createNewRun] 
   @projectid = @projectid
  ,@projectkey = @projectkey
  ,@solution = @solution
  ,@api = @api
  ,@runid = @runid
  ,@json_sla = @json_sla
  ,@json_config = N'{"Header":{
	"NameOfApi":"SetManualScore",
	"Creator":"pbaljon@deloitte.nl",
	"ConfigurationDescription":"",
	"ConfigurationVersion":"",
},"ComponentParams" : [ 
	{ "PackageName":"CompanyScoringSynchronous"
, "ScoringParams" : [
		{"ScoringType" : "ManualScore"
		, "ScoringLabel" : "Country"
		, "ScoreDataType" : "nvarchar"
		, "CompanyScore" : "DE8030366267:XX"
		}]
	}
	]}'
  ,@debug = 1 
 EXECUTE @RC = [ivh].[run_createNewRun] 
   @projectid = @projectid
  ,@projectkey = @projectkey
  ,@solution = @solution
  ,@api = @api
  ,@runid = @runid
  ,@json_sla = @json_sla
  ,@json_config = N'{"Header":{
	"NameOfApi":"SetManualScore",
	"Creator":"pbaljon@deloitte.nl",
	"ConfigurationDescription":"",
	"ConfigurationVersion":"",
},"ComponentParams" : [ 
	{ "PackageName":"CompanyScoringSynchronous"
, "ScoringParams" : [
		{"ScoringType" : "ManualScore"
		, "ScoringLabel" : "Country"
		, "ScoreDataType" : "nvarchar"
		, "CompanyScore" : "DE8030366267:YY"
		}]
	}
	]}'
  ,@debug = 1  */
--use prv_dev_inh;

DECLARE @deployment_server sysname = 'nlagpdatacore'
DECLARE @RC_ls1 int
DECLARE @solution nvarchar(255) = 'PRV'
DECLARE @projectkey_ls1 nvarchar(100) = CONCAT(@solution, '_Test_CreateLandscape')--'testPipeline'
DECLARE @json_sla1 nvarchar(max)
DECLARE @json_config_ls nvarchar(max)

SET @json_sla1 = N'{"ComponentID": "D0E4F952-663C-42CA-89E8-318C931D42A9"
                                  , "RunID": "-1"
                                  , "PollEvery": "00:00:10"
                                  , "TimeOutAfter": "3600"
                                  , "PlatformDataSource": "nlagpdatacore"
                                  , "PlatformCatalog": "prv_dev_inh"
                                  , "DatahandlerDataSource": "NLAGPDATACORE"
                                  , "DatahandlerCatalog": "prv_dev_dth"
                                  , "DatahandlerVersion": "felix"
                                  , "ProjectDataSource":"nlagpdatacore"
                                  , "ProjectCatalog":"prv_prj_lstest1"
                           }'

SET @json_config_ls = N'{"Header":{
	"NameOfApi":"RescoreLandscape",
	"Creator":"pbaljon@deloitte.nl",
	"ConfigurationDescription":"",
	"ConfigurationVersion":"",
	},"ComponentParams" : [ 
	{ "PackageName":"ScoreLandscapeNodes"
		, "ScoreLandscapeNodesParams" :[{
		"ScoringType" : "CompanyPortfolio"
		, "ScoreGroup" : "Relevance"
		, "SeriesGroup" : "Relevant Companies"
		, "Normalize" : "None"
		, "CompanyId" : "USD305504941D|DE2010000581"
		},{
		"ScoringType" : "BagOfWords"
		, "ScoringLabel" : "Additive manufacturing"
		, "ScoreGroup" : "Relevance"
		, "SeriesGroup" : "Strategic area"
		, "Normalize" : "None"
		, "BagOfWords" : "additive manufact*|3d print*"
		},{
		"ScoringType" : "CompanyPortfolio"
		, "ScoreGroup" : "Weight"
		, "SeriesGroup" : "Relevant Companies"
		, "Normalize" : "Class"
		, "CompanyId" : "USD305504941D|DE2010000581"
		},{
		"ScoringType" : "BagOfWords"
		, "ScoringLabel" : "Additive manufacturing"
		, "ScoreGroup" : "Weight"
		, "SeriesGroup" : "Strategic area"
		, "Normalize" : "Class"
		, "BagOfWords" : "additive manufact*|3d print*"
		},{
		"ScoringType" : "BagOfWords"
		, "ScoringLabel" : "CAD Software"
		, "ScoreGroup" : "Weight"
		, "SeriesGroup" : "Strategic area"
		, "Normalize" : "Class"
		, "BagOfWords" : "cad~software"
		},{
		"ScoringType" : "BagOfWords"
		, "ScoringLabel" : "CAD Software"
		, "ScoreGroup" : "Weight"
		, "SeriesGroup" : "Strategic area"
		, "Normalize" : "Class"
		, "BagOfWords" : "cad~software"
		}]
		}
	, { "PackageName":"GetNodeProperties"
		, "GetNodePropertiesParams" :[
		{"PropertyLabel" : "Label"
		, "PropertyMethod" : "TechnologyClassLabel"
		},{"PropertyLabel" : "Size"
		, "PropertyMethod" : "TechnologyClassSize"
		},{"PropertyLabel" : "High Level Label"
		, "PropertyMethod" : "HighLevelTechnologyLabel"
		, "PropertyParameters" : "B33:Additive manufacturing"
		} ] }
	, { "PackageName":"PrepareForVisualization"
		,"ProjectType":"EngineClientProject" }
	]}'

EXECUTE @RC_ls1 = [ivh].[run_createNewRun] 
   @projectid = 2
  ,@projectkey = @projectkey_ls1
  ,@solution = @solution
  ,@api = 'RescoreLandscape'
  ,@json_sla = @json_sla1
  ,@json_config = @json_config_ls
  ,@debug = 1
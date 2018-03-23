DECLARE @deployment_server sysname = 'nlagpdatacore'
--DECLARE @deployment_server sysname = 'nlams10823'
DECLARE @RC_ll int
DECLARE @RC_ls int
DECLARE @solution nvarchar(255) = 'PRV'
DECLARE @projectkey_ll nvarchar(100) = CONCAT(@solution, '_TestDeployment_CreateLonglist')--'testPipeline'
DECLARE @projectkey_ls nvarchar(100) = CONCAT(@solution, '_TestDeployment_CreateLandscape')--'testPipeline'
DECLARE @json_sla nvarchar(max)
DECLARE @json_config_ll nvarchar(max)
DECLARE @json_config_ls nvarchar(max)

SET @json_sla = N'{"ComponentID": "D0E4F952-663C-42CA-89E8-318C931D42A9"
					, "RunID": "-1"
					, "PollEvery": "00:00:10"
					, "TimeOutAfter": "3600"
					, "PlatformDataSource": "nlagpdatacore"
					, "PlatformCatalog": "prv_app_inh"
					, "DatahandlerDataSource": "nlagpdatacore"
					, "DatahandlerCatalog": "prv_app_dth"
					, "DatahandlerVersion": "honeyrider"
					, "ProjectDataSource":"nlagpdatacore"
					, "ProjectCatalog":"prv_prj_deploytest"
				}'

SET @json_config_ll = N'{"ComponentParams" : [ 
{ }
, {"RetrievalParams" : [
			{
		"RetrievalType" : "CompanyList"
		, "RetrievalLabel" : "Marked companies"
		, "CompanyId" : "USD305504941D|DE2010000581"
		},{"RetrievalType" : "CompanyTextBagOfWords"
			, "RetrievalLabel" : "Business - AM"
			, "NumberOfCompanies" : 5
			, "Normalize" : "None"
			, "BagOfWords" : "additive manuf*|3d print*"
		} , { "RetrievalType" : "PatentClassProfile"
			, "RetrievalLabel" : "IP - AM"
			, "NumberOfCompanies" : 5
			, "Normalize" : "None"
			, "ClassProfile" : "B33Y 30/00:0.32|B33Y 70/00:0.254545|B33Y 80/00:0.423423"
		}
	]
	}
, { "ScoringParams" : [
		{"ScoringType" : "OrbisAttribute"
		, "ScoringLabel" : "Country"
		, "AttributeName" : "country"
		},{
		"ScoringType" : "OrbisAttribute"
		, "ScoringLabel" : "Age"
		, "AttributeName" : "age"
		},{
		"ScoringType" : "IndustryAttribute"
		, "ScoringLabel" : "Industry"
		},{
		"ScoringType" : "CompanyTextBagOfWords"
		, "ScoringLabel" : "Business - AM"
		, "Normalize" : "Portfolio"
		, "BagOfWords" : "additive manuf*|3d print*"
		},{
		"ScoringType" : "PatentClassProfile"
		, "ScoringLabel" : "IP - AM"
		, "Normalize" : "Portfolio"
		, "ClassProfile" : "B33Y 30/00:0.32|B33Y 70/00:0.254545|B33Y 80/00:0.423423"
		}
	]
	}
, {  }
	]}' 
SET @json_config_ls = N'{"ComponentParams" : [ 
	{ }
	, { "NodeSelectionParams" :[
		{"NodeSelectionType" : "NodeList"
		, "NodeSelectionLabel" : "Test Node List"
		, "NodeList" : "B33Y 30/00|B33Y 70/00|B33Y 80/00|A61C 13/0019"
		}
		] }
	, { "ScoreLandscapeNodesParams" :[{
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
		}]
		}
	, { "GetNodePropertiesParams" :[
		{"PropertyLabel" : "Label"
		, "PropertyMethod" : "TechnologyClassLabel"
		},{"PropertyLabel" : "High Level Label"
		, "PropertyMethod" : "HighLevelTechnologyLabel"
		, "PropertyParameters" : "B33:Additive manufacturing"
		} ] }
	, { }
	, {
		"NormalizeDistance" : "none"
		, "RandomSeed" : 0
		, "MaxIterations" : 100
		, "Algorithm" : "MatlabMds"
		} 
	, { }
	]}' 

/* ================================================
	3. Launch pipeline
   ================================================ */


EXECUTE @RC_ll = [ivh].[run_createNewRun] 
   @projectid = 1
  ,@projectkey = @projectkey_ll
  ,@solution = @solution
  ,@api = 'CreateLonglist'
  ,@json_sla = @json_sla
  ,@json_config = @json_config_ll
  ,@debug = 1

WAITFOR DELAY '00:00:30';

EXECUTE @RC_ls = [ivh].[run_createNewRun] 
   @projectid = 2
  ,@projectkey = @projectkey_ls
  ,@solution = @solution
  ,@api = 'CreateLandscape'
  ,@json_sla = @json_sla
  ,@json_config = @json_config_ls
  ,@debug = 1
/*GO
*/
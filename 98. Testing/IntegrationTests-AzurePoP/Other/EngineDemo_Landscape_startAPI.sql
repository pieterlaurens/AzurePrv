--use prv_app_inh
DECLARE @api nvarchar(512) = 'CreateLandscape';
DECLARE @deployment_server sysname = 'nlagpdatacore'
DECLARE @RC int
DECLARE @projectid int = 007
DECLARE @projectkey nvarchar(100) = 'testPipeline'
DECLARE @solution nvarchar(255) = 'PRV'
DECLARE @runid int
DECLARE @json_sla nvarchar(max)
DECLARE @json_config nvarchar(max)
DECLARE @debug tinyint
SET @runid = 0

/* ================================================
	1. Set SLA settings
   ================================================ */
SET @projectkey = CONCAT(@projectkey, @solution, '_', @api, '_', @runid)
SET @json_sla = N'{"ComponentID": "D0E4F952-663C-42CA-89E8-318C931D42A9"
					, "RunID": "-1"
					, "PollEvery": "00:00:10"
					, "TimeOutAfter": "3600"
					, "PlatformDataSource": "nlagpdatacore"
					, "PlatformCatalog": "prv_app_inh"
					, "DatahandlerDataSource": "NLAGPDATACORE"
					, "DatahandlerCatalog": "prv_app_dth"
					, "DatahandlerVersion": "honeyrider"
					, "ProjectDataSource":"nlagpdatacore"
					, "ProjectCatalog":"prv_prj_enginedemo"
				}'

/* ================================================
	2. Set pipeline configuration
   ================================================ */
SET @json_config = N'{"ComponentParams" : [ 
	{ }
	, { "NodeSelectionParams" :[
		{"NodeSelectionType" : "NodeList"
		, "NodeSelectionLabel" : "Original Node List"
		, "NodeList" : "B29C 33/3842|B29C 33/3857|B29C 41/12|B29C 41/36|B29C 47/0011|B29C 47/0014|B29C 47/0866|B29C 47/92|B29C 67/00|B29C 67/0051|B29C 67/0055|B29C 67/0059|B29C 67/0062|B29C 67/0066|B29C 67/007|B29C 67/0074|B29C 67/0077|B29C 67/0081|B29C 67/0085|B29C 67/0088|B29C 67/0092|B29C 67/0096|B29C 67/04|B29D 11/00432|B29K /00|B29K /0073|B29K /251|B29L /00|B29L /7532|B33Y 10/00|B33Y 30/00|B33Y 40/00|B33Y 50/00|B33Y 50/02|B33Y 70/00|B33Y 80/00"
		}
		] }
	, { "ScoreLandscapeNodesParams" :[{
		"ScoringType" : "CompanyPortfolio"
		, "ScoreGroup" : "Relevance"
		, "SeriesGroup" : "Relevant Companies"
		, "Normalize" : "None"
		, "CompanyId" : "USD305504941D|DE2010000581|US140689340|US941081436"
		},{
		"ScoringType" : "CompanyPortfolio"
		, "ScoreGroup" : "Weight"
		, "SeriesGroup" : "Relevant Companies"
		, "Normalize" : "Class"
		, "CompanyId" : "USD305504941D|DE2010000581|US140689340|US941081436"
		},{
		"ScoringType" : "BagOfWords"
		, "ScoringLabel" : "Additive manufacturing"
		, "ScoreGroup" : "Relevance"
		, "SeriesGroup" : "Strategic area"
		, "Normalize" : "None"
		, "BagOfWords" : "additive manufact*|3d print*"
		},{
		"ScoringType" : "BagOfWords"
		, "ScoringLabel" : "Additive manufacturing"
		, "ScoreGroup" : "Weight"
		, "SeriesGroup" : "Strategic area"
		, "Normalize" : "Class"
		, "BagOfWords" : "additive manufact*|3d print*"
		},{
		"ScoringType" : "BagOfWords"
		, "ScoringLabel" : "Selective Laser Sintering"
		, "ScoreGroup" : "Relevance"
		, "SeriesGroup" : "Strategic area"
		, "Normalize" : "None"
		, "BagOfWords" : "selective~laser~sinter*|sls"
		},{
		"ScoringType" : "BagOfWords"
		, "ScoringLabel" : "Selective Laser Sintering"
		, "ScoreGroup" : "Weight"
		, "SeriesGroup" : "Strategic area"
		, "Normalize" : "Class"
		, "BagOfWords" : "selective~laser~sinter*|sls"
		}]
		}
	, { "GetNodePropertiesParams" :[
		{"PropertyLabel" : "Label"
		, "PropertyMethod" : "TechnologyClassLabel"
		},{"PropertyLabel" : "High Level Label"
		, "PropertyMethod" : "HighLevelTechnologyLabel"
		, "PropertyParameters" : "B2:Finished part|B33:Additive manufacturing"
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
EXECUTE @RC = [ivh].[run_createNewRun] 
   @projectid = @projectid
  ,@projectkey = @projectkey
  ,@solution = @solution
  ,@api = @api
  ,@runid = @runid
  ,@json_sla = @json_sla
  ,@json_config = @json_config
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
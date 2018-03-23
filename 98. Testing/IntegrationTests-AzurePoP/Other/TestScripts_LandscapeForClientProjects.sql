--use prv_dev_inh;

DECLARE @deployment_server sysname = 'nlagpdatacore'
DECLARE @RC_ls1 int
DECLARE @RC_ls2 int
DECLARE @RC_ls3 int
DECLARE @RC_ls4 int
DECLARE @solution nvarchar(255) = 'PRV'
DECLARE @projectkey_ls1 nvarchar(100) = CONCAT(@solution, '_Test_CreateLandscape')--'testPipeline'
DECLARE @projectkey_ls2 nvarchar(100) = CONCAT(@solution, '_Test_CreateLandscape')--'testPipeline'
DECLARE @projectkey_ls3 nvarchar(100) = CONCAT(@solution, '_Test_CreateLandscape')--'testPipeline'
DECLARE @projectkey_ls4 nvarchar(100) = CONCAT(@solution, '_Test_CreateLandscape')--'testPipeline'
DECLARE @json_sla1 nvarchar(max)
DECLARE @json_sla2 nvarchar(max)
DECLARE @json_sla3 nvarchar(max)
DECLARE @json_sla4 nvarchar(max)
DECLARE @json_config_ls nvarchar(max)

/*
IF DB_ID('prv_prj_lstest1') IS NULL CREATE DATABASE prv_prj_lstest1 -- No user added data

IF DB_ID('prv_prj_lstest2') IS NULL CREATE DATABASE prv_prj_lstest2 -- User added attributes
IF OBJECT_ID('prv_prj_lstest2.[custom].ls_node_property_numeric','U') is null
CREATE TABLE prv_prj_lstest2.[custom].[ls_node_property_numeric] (
    node_key        int not null,
    node_property_type			NVARCHAR (150) NOT NULL,
    node_property_value numeric(30,10) NULL
);
IF DB_ID('prv_prj_lstest3') IS NULL CREATE DATABASE prv_prj_lstest3 -- User added scores
IF OBJECT_ID('prv_prj_lstest3.[custom].ls_node_score_numeric','U') is null
CREATE TABLE prv_prj_lstest3.[custom].[ls_node_score_numeric]
(
	node_key INT NOT NULL
	, node_score_group nvarchar(100) not null
	, node_score_series_group nvarchar(100) null
	, node_score_series_key nvarchar(100) not null
	, node_score_view nvarchar(100) null
	, node_score_value numeric(30,10) not null
);
IF DB_ID('prv_prj_lstest4') IS NULL CREATE DATABASE prv_prj_lstest4 -- Both user added attributes and scores.
IF OBJECT_ID('prv_prj_lstest4.[custom].ls_node_score_numeric','U') is null
CREATE TABLE prv_prj_lstest4.[custom].[ls_node_score_numeric]
(
	node_key INT NOT NULL
	, node_score_group nvarchar(100) not null
	, node_score_series_group nvarchar(100) null
	, node_score_series_key nvarchar(100) not null
	, node_score_view nvarchar(100) null
	, node_score_value numeric(30,10) not null
);
IF OBJECT_ID('prv_prj_lstest4.[custom].ls_node_property_numeric','U') is null
CREATE TABLE prv_prj_lstest4.[custom].[ls_node_property_numeric] (
    node_key        int not null,
    node_property_type			NVARCHAR (150) NOT NULL,
    node_property_value numeric(30,10) NULL
);
*/
truncate table prv_prj_lstest2.[custom].[ls_node_property_numeric];
INSERT INTO prv_prj_lstest2.[custom].[ls_node_property_numeric] (node_key, node_property_type,node_property_value)
	VALUES(57108,'Metric 1',10),(57108,'Metric 2',20),(57112,'Metric 1',15),(57112,'Metric 2',25)

truncate table prv_prj_lstest3.[custom].ls_node_score_numeric;
INSERT INTO prv_prj_lstest3.[custom].ls_node_score_numeric (node_key,node_score_group,node_score_series_group,node_score_series_key,node_score_view,node_score_value)
	VALUES(57108,'Weight','Additional scores','Item 1','1',0.2),(57108,'Relevance','Additional scores','Item 1','1',0.3),
		(57108,'Weight','Additional scores','Item 2','1',0.4),(57108,'Relevance','Additional scores','Item 2','1',0.5),
		(57112,'Weight','Additional scores','Item 1','1',0.2),(57112,'Relevance','Additional scores','Item 1','1',0.3),
		(57112,'Weight','Additional scores','Item 2','1',0.4),(57112,'Relevance','Additional scores','Item 2','1',0.5)

truncate table prv_prj_lstest4.[custom].[ls_node_property_numeric];
INSERT INTO prv_prj_lstest4.[custom].[ls_node_property_numeric] (node_key, node_property_type,node_property_value)
	VALUES(57108,'Metric 1',10),(57108,'Metric 2',20),(57112,'Metric 1',15),(57112,'Metric 2',25)

truncate table prv_prj_lstest4.[custom].ls_node_score_numeric;
INSERT INTO prv_prj_lstest4.[custom].ls_node_score_numeric (node_key,node_score_group,node_score_series_group,node_score_series_key,node_score_view,node_score_value)
	VALUES(57108,'Weight','Additional scores','Item 1','1',0.2),(57108,'Relevance','Additional scores','Item 1','1',0.3),
		(57108,'Weight','Additional scores','Item 2','1',0.4),(57108,'Relevance','Additional scores','Item 2','1',0.5),
		(57112,'Weight','Additional scores','Item 1','1',0.2),(57112,'Relevance','Additional scores','Item 1','1',0.3),
		(57112,'Weight','Additional scores','Item 2','1',0.4),(57112,'Relevance','Additional scores','Item 2','1',0.5)

SET @json_sla1 = N'{" ComponentID": "D0E4F952-663C-42CA-89E8-318C931D42A9"
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
SET @json_sla2 = N'{"ComponentID": "D0E4F952-663C-42CA-89E8-318C931D42A9"
                                  , "RunID": "-1"
                                  , "PollEvery": "00:00:10"
                                  , "TimeOutAfter": "3600"
                                  , "PlatformDataSource": "nlagpdatacore"
                                  , "PlatformCatalog": "prv_dev_inh"
                                  , "DatahandlerDataSource": "NLAGPDATACORE"
                                  , "DatahandlerCatalog": "prv_dev_dth"
                                  , "DatahandlerVersion": "felix"
                                  , "ProjectDataSource":"nlagpdatacore"
                                  , "ProjectCatalog":"prv_prj_lstest2"
                           }'
SET @json_sla3 = N'{"ComponentID": "D0E4F952-663C-42CA-89E8-318C931D42A9"
                                  , "RunID": "-1"
                                  , "PollEvery": "00:00:10"
                                  , "TimeOutAfter": "3600"
                                  , "PlatformDataSource": "nlagpdatacore"
                                  , "PlatformCatalog": "prv_dev_inh"
                                  , "DatahandlerDataSource": "NLAGPDATACORE"
                                  , "DatahandlerCatalog": "prv_dev_dth"
                                  , "DatahandlerVersion": "felix"
                                  , "ProjectDataSource":"nlagpdatacore"
                                  , "ProjectCatalog":"prv_prj_lstest3"
                           }'
SET @json_sla4 = N'{"ComponentID": "D0E4F952-663C-42CA-89E8-318C931D42A9"
                                  , "RunID": "-1"
                                  , "PollEvery": "00:00:10"
                                  , "TimeOutAfter": "3600"
                                  , "PlatformDataSource": "nlagpdatacore"
                                  , "PlatformCatalog": "prv_dev_inh"
                                  , "DatahandlerDataSource": "NLAGPDATACORE"
                                  , "DatahandlerCatalog": "prv_dev_dth"
                                  , "DatahandlerVersion": "felix"
                                  , "ProjectDataSource":"nlagpdatacore"
                                  , "ProjectCatalog":"prv_prj_lstest4"
                           }'



SET @json_config_ls = N'{"Header":{
	"NameOfApi":"CreateLandscape",
	"Creator":"pbaljon@deloitte.nl",
	"ConfigurationDescription":"",
	"ConfigurationVersion":"",
	},"ComponentParams" : [ 
	{ "PackageName":"CreatePrepareEnvironment"}
	, { "PackageName":"SelectLandscapeNodes"
		, "NodeSelectionParams" :[
		{"NodeSelectionType" : "NodeList"
		, "NodeSelectionLabel" : "Test Node List"
		, "NodeList" : "B33Y 30/00|B33Y 70/00|B33Y 80/00|A61C 13/0019"
		}
		] }
	, { "PackageName":"ScoreLandscapeNodes"
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
	, { "PackageName":"CalculateLandscapeDistances" }
	, {"PackageName":"ApproximateDistanceIn2D"
		, "NormalizeDistance" : "none"
		, "RandomSeed" : 0
		, "MaxIterations" : 100
		, "Algorithm" : "MatlabMds"
		} 
	, { "PackageName":"PrepareForVisualization"
		,"ProjectType":"EngineClientProject" }
	]}'

/* ================================================
	3. Launch pipeline
   ================================================ */

/*
EXECUTE @RC_ls1 = [ivh].[run_createNewRun] 
   @projectid = 2
  ,@projectkey = @projectkey_ls1
  ,@solution = @solution
  ,@api = 'CreateLandscape'
  ,@json_sla = @json_sla1
  ,@json_config = @json_config_ls
  ,@debug = 1

WAITFOR DELAY '00:00:10';
EXECUTE @RC_ls2 = [ivh].[run_createNewRun] 
   @projectid = 2
  ,@projectkey = @projectkey_ls2
  ,@solution = @solution
  ,@api = 'CreateLandscape'
  ,@json_sla = @json_sla2
  ,@json_config = @json_config_ls
  ,@debug = 1
WAITFOR DELAY '00:00:10';
EXECUTE @RC_ls3 = [ivh].[run_createNewRun] 
   @projectid = 2
  ,@projectkey = @projectkey_ls3
  ,@solution = @solution
  ,@api = 'CreateLandscape'
  ,@json_sla = @json_sla3
  ,@json_config = @json_config_ls
  ,@debug = 1

WAITFOR DELAY '00:00:10';*/
EXECUTE @RC_ls4 = [ivh].[run_createNewRun] 
   @projectid = 2
  ,@projectkey = @projectkey_ls4
  ,@solution = @solution
  ,@api = 'CreateLandscape'
  ,@json_sla = @json_sla4
  ,@json_config = @json_config_ls
  ,@debug = 1
GO

SELECT TOP 1000 *
  FROM [nlh].[log]
  WHERE source_name <> 'PackageTemplate.dtsx'
  ORDER BY added_on DESC

SELECT TOP 1000 *
  FROM [nlh].[event]
  ORDER BY added_on DESC

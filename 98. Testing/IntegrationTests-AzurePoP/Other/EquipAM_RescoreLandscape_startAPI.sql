--use prv_app_inh

-----------------------
/* INITIALIZE SOLUTION 

Fill the solution databases with appropriate values and point to the shared components and feature components.
Create a work flow as a tree of components.

*/
-----------------------
DECLARE @api nvarchar(512) = 'RescoreLandscape' -- possible values {'CreateLonglist', 'CreateLandscape')
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
					, "DatahandlerVersion": "honeyrider"
					, "ProjectDataSource":"nlagpdatacore"
					, "ProjectCatalog":"prv_prj_equip"
				}'


	SET @json_config = N'{"Header":{
		"NameOfApi":"RescoreLandscape",
		"Creator":"pbaljon@deloitte.nl",
		"ConfigurationDescription":"",
		"ConfigurationVersion":"",
	},"ComponentParams" : [ 
	{ "PackageName":"ScoreLandscapeNodes",
		"ScoreLandscapeNodesParams" :[{
		"ScoringType" : "CompanyPortfolio"
		, "ScoreGroup" : "Relevance"
		, "SeriesGroup" : "Materials Companies"
		, "Normalize" : "None"
		, "CompanyId" : "NL14022069|FR445074685|DE7150000030|DE5050411513|CN30081PC"
		},{
		"ScoringType" : "CompanyPortfolio"
		, "ScoreGroup" : "Weight"
		, "SeriesGroup" : "Materials Companies"
		, "Normalize" : "Class"
		, "CompanyId" : "NL14022069|FR445074685|DE7150000030|DE5050411513|CN30081PC"
		},{
		"ScoringType" : "CompanyPortfolio"
		, "ScoreGroup" : "Relevance"
		, "SeriesGroup" : "Processing Companies"
		, "Normalize" : "None"
		, "CompanyId" : "DE8290161341|US15-898-7698|US14-940-5503|US259183166L"
		},{
		"ScoringType" : "CompanyPortfolio"
		, "ScoreGroup" : "Weight"
		, "SeriesGroup" : "Processing Companies"
		, "Normalize" : "Class"
		, "CompanyId" : "DE8290161341|US15-898-7698|US14-940-5503|US259183166L"
		},{
		"ScoringType" : "CompanyPortfolio"
		, "ScoreGroup" : "Relevance"
		, "SeriesGroup" : "OEMs"
		, "Normalize" : "None"
		, "CompanyId" : "DE7070237351-1000|DE2070000543|US380549190|JP000001080JPN|US201178440L"
		},{
		"ScoringType" : "CompanyPortfolio"
		, "ScoreGroup" : "Weight"
		, "SeriesGroup" : "OEMs"
		, "Normalize" : "Class"
		, "CompanyId" : "DE7070237351-1000|DE2070000543|US380549190|JP000001080JPN|US201178440L"
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
		},{
		"ScoringType" : "BagOfWords"
		, "ScoringLabel" : "UV Photo Curable"
		, "ScoreGroup" : "Relevance"
		, "SeriesGroup" : "Strategic area"
		, "Normalize" : "None"
		, "BagOfWords" : "uv~photo~cur*"
		},{
		"ScoringType" : "BagOfWords"
		, "ScoringLabel" : "UV Photo Curable"
		, "ScoreGroup" : "Weight"
		, "SeriesGroup" : "Strategic area"
		, "Normalize" : "Class"
		, "BagOfWords" : "uv~photo~cur*"
		},{
		"ScoringType" : "BagOfWords"
		, "ScoringLabel" : "Fused Deposition Modeling"
		, "ScoreGroup" : "Relevance"
		, "SeriesGroup" : "Strategic area"
		, "Normalize" : "None"
		, "BagOfWords" : "fused~deposition~model*"
		},{
		"ScoringType" : "BagOfWords"
		, "ScoringLabel" : "Fused Deposition Modeling"
		, "ScoreGroup" : "Weight"
		, "SeriesGroup" : "Strategic area"
		, "Normalize" : "Class"
		, "BagOfWords" : "fused~deposition~model*"
		},{
		"ScoringType" : "BagOfWords"
		, "ScoringLabel" : "Stereo Lithography"
		, "ScoreGroup" : "Relevance"
		, "SeriesGroup" : "Strategic area"
		, "Normalize" : "None"
		, "BagOfWords" : "stereo~lithograph*"
		},{
		"ScoringType" : "BagOfWords"
		, "ScoringLabel" : "Stereo Lithography"
		, "ScoreGroup" : "Weight"
		, "SeriesGroup" : "Strategic area"
		, "Normalize" : "Class"
		, "BagOfWords" : "stereo~lithograph*"
		},{
		"ScoringType" : "BagOfWords"
		, "ScoringLabel" : "Electron Beam Melting"
		, "ScoreGroup" : "Relevance"
		, "SeriesGroup" : "Strategic area"
		, "Normalize" : "None"
		, "BagOfWords" : "electron~beam~melt*"
		},{
		"ScoringType" : "BagOfWords"
		, "ScoringLabel" : "Electron Beam Melting"
		, "ScoreGroup" : "Weight"
		, "SeriesGroup" : "Strategic area"
		, "Normalize" : "Class"
		, "BagOfWords" : "electron~beam~melt*"
		},{
		"ScoringType" : "BagOfWords"
		, "ScoringLabel" : "Binder Jetting"
		, "ScoreGroup" : "Relevance"
		, "SeriesGroup" : "Strategic area"
		, "Normalize" : "None"
		, "BagOfWords" : "binder~jet*"
		},{
		"ScoringType" : "BagOfWords"
		, "ScoringLabel" : "Binder Jetting"
		, "ScoreGroup" : "Weight"
		, "SeriesGroup" : "Strategic area"
		, "Normalize" : "Class"
		, "BagOfWords" : "binder~jet*"
		},{
		"ScoringType" : "BagOfWords"
		, "ScoringLabel" : "Nylon"
		, "ScoreGroup" : "Relevance"
		, "SeriesGroup" : "Materials"
		, "Normalize" : "None"
		, "BagOfWords" : "nylon|polyamide"
		},{
		"ScoringType" : "BagOfWords"
		, "ScoringLabel" : "Nylon"
		, "ScoreGroup" : "Weight"
		, "SeriesGroup" : "Materials"
		, "Normalize" : "Class"
		, "BagOfWords" : "nylon|polyamide"
		},{
		"ScoringType" : "BagOfWords"
		, "ScoringLabel" : "Polycarbonate"
		, "ScoreGroup" : "Relevance"
		, "SeriesGroup" : "Materials"
		, "Normalize" : "None"
		, "BagOfWords" : "polycarbonate"
		},{
		"ScoringType" : "BagOfWords"
		, "ScoringLabel" : "Polycarbonate"
		, "ScoreGroup" : "Weight"
		, "SeriesGroup" : "Materials"
		, "Normalize" : "Class"
		, "BagOfWords" : "polycarbonate"
		},{
		"ScoringType" : "BagOfWords"
		, "ScoringLabel" : "PLA"
		, "ScoreGroup" : "Relevance"
		, "SeriesGroup" : "Materials"
		, "Normalize" : "None"
		, "BagOfWords" : "polylactic acid|pla"
		},{
		"ScoringType" : "BagOfWords"
		, "ScoringLabel" : "PLA"
		, "ScoreGroup" : "Weight"
		, "SeriesGroup" : "Materials"
		, "Normalize" : "Class"
		, "BagOfWords" : "polylactic acid|pla"
		}]
		}
	, { "PackageName":"GetNodeProperties",
		"GetNodePropertiesParams" :[
		{"PropertyLabel" : "Label"
		, "PropertyMethod" : "TechnologyClassLabel"
		},{"PropertyLabel" : "Extended Label"
		, "PropertyMethod" : "TechnologyClassExtendedLabel"
		},{"PropertyLabel" : "Technology Class"
		, "PropertyMethod" : "NodeId"
		},{"PropertyLabel" : "Size"
		, "PropertyMethod" : "TechnologyClassSize"
		},{"PropertyLabel" : "Trend"
		, "PropertyMethod" : "TechnologyTrendRelativeToLandscape"
		},{"PropertyLabel" : "High Level Label"
		, "PropertyMethod" : "HighLevelTechnologyLabel"
		, "PropertyParameters" : "H04:Software|G06:Software|B41:Printing|B42:Printing|B43:Printing|B44:Printing|C09:Inks and Dyes|C07:Raw material|C08:Raw material|C2:Raw material|B2:Finished part|B33:Additive manufacturing"
		} ] }
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
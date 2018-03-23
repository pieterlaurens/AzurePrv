DECLARE @api nvarchar(512) = 'CreateLandscape' -- possible values {'CreateLonglist', 'CreateLandscape')

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
					, "DatahandlerVersion": "xenia"
					, "ProjectDataSource":"nlagpdatacore"
					, "ProjectCatalog":"prv_prj_testDeploy"
				}'

IF @api = 'CreateLonglist'
BEGIN
	SET @json_config = N'{"ComponentParams" : [ 
						{ }
						, {"RetrievalParams" : [
								{"RetrievalType" : "CompanyTextBagOfWords"
									, "RetrievalLabel" : "Plastics Manufacturing"
									, "NumberOfCompanies" : 3
									, "Normalize" : "Portfolio"
									, "BagOfWords" : "Plastic|Thermoplastic"
									, "Constraints" : "company_category:Medium sized company|country:NL,BE,DE,FR,GB,ES,IT"
								}
								, { "RetrievalType" : "CompanyList" 	
									, "RetrievalLabel" : "Required companies" 	
									, "CompanyId" : "GB00446897|US126166035L|NL14076998|GB00305979|NONEXISTENT" 	
								}
								, { "RetrievalType" : "PatentClassProfile"
									, "RetrievalLabel" : "Shaping or Joining of Plastics"
									, "NumberOfCompanies" : 3
									, "Normalize" : "Portfolio"
									, "ClassProfile" : "B29C 00/00:0.5|B29C 31/00:0.5"
									, "Constraints" : "company_category:Medium sized company|country:NL,BE,DE,FR,GB,ES,IT"
								}  	
							]
							}
						, { "ScoringParams" : [
								{"ScoringType" : "OrbisAttribute"
								, "ScoringLabel" : "Country"
								, "AttributeName" : "country"
								},{
								"ScoringType" : "OrbisAttribute"
								, "ScoringLabel" : "Number of Patents"
								, "AttributeName" : "number_of_patents"
								},{
								"ScoringType" : "PatentClassProfile"
								, "ScoringLabel" : "Shaping or Joining of Plastics"
								, "Normalize" : "Portfolio"
								, "ClassProfile" : "B29C 00/00:0.5|B29C 31/00:0.5"
								}
							]
							}
						, { }
						 ]}' 
END
ELSE IF @api = 'CreateLandscape'
BEGIN
	SET @json_config = N'{"ComponentParams" : [ 
						{ }
						, { "NodeSelectionParams" :[
								{"NodeSelectionType" : "NodeList"
								, "NodeSelectionLabel" : "Example list of Nodes"
								, "NodeList" : "B32B 27/00|B29C 66/71"
								}
							] }
						, { "ScoreLandscapeNodesParams" :[{
								"ScoringType" : "CompanyPortfolio"
								, "ScoreGroup" : "Relevance"
								, "SeriesGroup" : "Relevant Companies"
								, "Normalize" : "None"
								, "CompanyId" : "GB00446897|US126166035L|NL14076998|US510014090|GB00218019|NONEXISTENT"
								},{
								"ScoringType" : "CompanyPortfolio"
								, "ScoreGroup" : "Weight"
								, "SeriesGroup" : "Relevant Companies"
								, "Normalize" : "Portfolio"
								, "CompanyId" : "GB00446897|US126166035L|NL14076998|US510014090|GB00218019|NONEXISTENT"
								},{
								"ScoringType" : "BagOfWords"
								, "ScoringLabel" : "Shaping or Joining of Plastics"
								, "ScoreGroup" : "Weight"
								, "SeriesGroup" : "Strategic area"
								, "Normalize" : "Portfolio"
								, "BagOfWords" : "thermoplastic|thermoforming"
								},{
								"ScoringType" : "BagOfWords"
								, "ScoringLabel" : "Shaping or Joining of Plastics"
								, "ScoreGroup" : "Relevance"
								, "SeriesGroup" : "Strategic area"
								, "Normalize" : "None"
								, "BagOfWords" : "thermoplastic|thermoforming"
								}]
							}
						, { "GetNodePropertiesParams" :[
								{"PropertyLabel" : "Label"
								, "PropertyMethod" : "TechnologyClassLabel"
								},{"PropertyLabel" : "Extended Label"
								, "PropertyMethod" : "TechnologyClassExtendedLabel"
								},{"PropertyLabel" : "Size"
								, "PropertyMethod" : "TechnologyClassSize"
								}
							] }
						, { }
						, {
								"NormalizeDistance" : "none"
								, "RandomSeed" : 0
								, "ReferencePoints" : "B29C 00/00,0.5,0.2|B29C 31/00,-0.5,-0.2"
								, "MaxIterations" : 100
								, "Algorithm" : "Random"
							} 
						, { }
						 ]}' 
END

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
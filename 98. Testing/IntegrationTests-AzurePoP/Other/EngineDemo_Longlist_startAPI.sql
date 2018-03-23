--use prv_app_inh
DECLARE @api nvarchar(512) = 'CreateLonglist';
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
, {"RetrievalParams" : [
			{
		"RetrievalType" : "CompanyList"
		, "RetrievalLabel" : "Marked companies"
		, "CompanyId" : "CHCHE107136256|CHCHE110110814|CN30081PC|CN9360000140|DE2010000581|DE2010000581|DE2270172157|DE2270172157|DE4070280762|DE4290178888|DE5330000056|DE7150000030|DE7230336659|DE7330593711|DE8030366267|DE8030366267|DK32365590|FR41028670200056|FR443645551|FR443645551|FR445074685|FR49956881400051|FR49956881400051|FR49956881400051|GB01106260|GB01106260|GB03903306|GB03903306|GB03903306|IE389190|IL31714NU|IL31714NU|IL31714NU|ITMN0149665|ITMO0379518|JP000020437JPN|JP000030720JPN|JP000030797JPN|JP000090035JPN|JP042747717S|JP042747717S|JP130856896S|JP558828617S|KR1601110122880-2|NL14076998|NL14095340|SE5562889401|SE5565395356|US*1550089520|US060570975|US140689340|US222640650|US222640650|US461684608|US461684608|US942802192"
		},{"RetrievalType" : "CompanyTextBagOfWords"
			, "RetrievalLabel" : "AM in Trade Description"
			, "NumberOfCompanies" : 50
			, "Normalize" : "None"
			, "BagOfWords" : "additive manuf*|3d print*"
		}
		, { "RetrievalType" : "PatentClassProfile"
			, "RetrievalLabel" : "CPC - AM Specific"
			, "NumberOfCompanies" : 50
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
		"ScoringType" : "OrbisAttribute"
		, "ScoringLabel" : "Number of Patents"
		, "AttributeName" : "number_of_patents"
		},{
		"ScoringType" : "OrbisAttribute"
		, "ScoringLabel" : "Segment"
		, "AttributeName" : "company_category"
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
		, "ScoringLabel" : "IP - Specific AM"
		, "Normalize" : "Portfolio"
		, "ClassProfile" : "B33Y 30/00:0.32|B33Y 70/00:0.254545|B33Y 80/00:0.423423"
		}
	]
	}
, { 	"LongListFilters":"... with >10 patents: [Number of Patents] > 10" }
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
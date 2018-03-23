use prv_dev_inh;

DECLARE @deployment_server sysname = 'nlagpdatacore'
DECLARE @RC_ll int
DECLARE @RC_ls int
DECLARE @solution nvarchar(255) = 'PRV'
DECLARE @projectkey_ll nvarchar(100) = CONCAT(@solution, '_Test_CreateLonglist')--'testPipeline'
DECLARE @json_sla nvarchar(max)
DECLARE @json_config_ll nvarchar(max)

SET @json_sla = N'{"ComponentID": "D0E4F952-663C-42CA-89E8-318C931D42A9"
                                  , "RunID": "-1"
                                  , "PollEvery": "00:00:10"
                                  , "TimeOutAfter": "3600"
                                  , "PlatformDataSource": "nlagpdatacore"
                                  , "PlatformCatalog": "prv_dev_inh"
                                  , "DatahandlerDataSource": "NLAGPDATACORE"
                                  , "DatahandlerCatalog": "prv_dev_dth"
                                  , "DatahandlerVersion": "janus"
                                  , "ProjectDataSource":"nlagpdatacore"
                                  , "ProjectCatalog":"prv_prj_correctiontestpre"
                           }'

SET @json_config_ll = N'{"Header":{
	"NameOfApi":"CreateLonglist",
	"Creator":"pbaljon@deloitte.nl",
	"ConfigurationDescription":"Configuration to test the fixing of ID matches.",
	"ConfigurationVersion":"1.0",
},"ComponentParams" : [ 
{ "PackageName":"CreatePrepareEnvironment"}
, { "PackageName":"CompanyRetrieval"
	, "RetrievalParams" : [
			{
		"RetrievalType" : "CompanyList"
		, "RetrievalLabel" : "Marked companies"
		, "CompanyId" : "USD305504941D|DE2010000581"
		},{ "RetrievalType" : "PatentClassProfile"
			, "RetrievalLabel" : "IP - AM"
			, "NumberOfCompanies" : 250
			, "Normalize" : "None"
			, "ClassProfile" : "B33Y:.11|B33Y 10/00:.11|B33Y 30/00:.11|B33Y 40/00:.11|B33Y 50/00:.11|B33Y 50/02:.11|B33Y 70/00:.11|B33Y 80/00:.11|B33Y 99/00:.11"
		}
	]
	}
, { "PackageName":"CompanyScoring"
	, "ScoringParams" : [
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
		"ScoringType" : "PatentClassProfile"
		, "ScoringLabel" : "IP - AM"
		, "Normalize" : "Portfolio"
		, "ClassProfile" : "B33Y:.11|B33Y 10/00:.11|B33Y 30/00:.11|B33Y 40/00:.11|B33Y 50/00:.11|B33Y 50/02:.11|B33Y 70/00:.11|B33Y 80/00:.11|B33Y 99/00:.11"
		},{
		"ScoringType" : "PatentClassProfile"
		, "ScoringLabel" : "IP - General Shaping"
		, "Normalize" : "Portfolio"
		, "ClassProfile" : "B21B 11/00:.005|B21B 13/00:.005|B21B 19/00:.005|B21B 21/00:.005|B21B 2205/00:.005|B21B 2269/00:.005|B21B 27/00:.005|B21B 3/00:.005|B21B 31/00:.005|B21B 38/00:.005|B21B 39/00:.005|B21B 41/00:.005|B21B 45/00:.005|B21B 47/00:.005|B21B 5/00:.005|B21B 99/00:.005|B21C:.005|B21C 25/00:.005|B21C 26/00:.005|B21C 29/00:.005|B21C 47/00:.005|B21D:.005|B21D 26/00:.005|B21D 31/00:.005|B21D 37/00:.005|B21D 39/00:.005|B21D 45/00:.005|B21D 51/00:.005|B21D 53/00:.005|B21D 9/00:.005|B21F 1/00:.005|B21F 33/00:.005|B21F 45/00:.005|B21G 3/00:.005|B21H 1/00:.005|B21H 5/00:.005|B21H 7/00:.005|B21H 8/00:.005|B21J 1/00:.005|B21J 13/00:.005|B21J 3/00:.005|B21J 5/00:.005|B21K 13/00:.005|B21K 17/00:.005|B21K 19/00:.005|B21K 29/00:.005|B21K 3/00:.005|B21K 9/00:.005|B22C:.005|B22C 1/00:.005|B22C 21/00:.005|B22C 23/00:.005|B22C 25/00:.005|B22D:.005|B22D 1/00:.005|B22D 11/00:.005|B22D 13/00:.005|B22D 15/00:.005|B22D 17/00:.005|B22D 21/00:.005|B22D 29/00:.005|B22D 35/00:.005|B22D 7/00:.005|B22F:.005|B22F 2203/00:.005|B23B 1/00:.005|B23B 2228/00:.005|B23B 3/00:.005|B23B 31/00:.005|B23B 39/00:.005|B23B 45/00:.005|B23B 51/00:.005|B23C 2224/00:.005|B23C 2235/00:.005|B23C 2240/00:.005|B23C 2245/00:.005|B23C 2270/00:.005|B23C 3/00:.005|B23D 15/00:.005|B23D 21/00:.005|B23D 2277/00:.005|B23D 23/00:.005|B23D 3/00:.005|B23D 35/00:.005|B23D 36/00:.005|B23D 47/00:.005|B23D 51/00:.005|B23D 65/00:.005|B23D 67/00:.005|B23D 7/00:.005|B23D 73/00:.005|B23D 77/00:.005|B23D 81/00:.005|B23F:.005|B23F 1/00:.005|B23F 7/00:.005|B23G:.005|B23G 1/00:.005|B23G 2210/00:.005|B23G 2240/00:.005|B23G 5/00:.005|B23H:.005|B23H 7/00:.005|B23H 9/00:.005|B23K 2203/00:.005|B23K 23/00:.005|B23K 26/00:.005|B23K 3/00:.005|B23K 37/00:.005|B23K 5/00:.005|B23K 7/00:.005|B23K 9/00:.005|B23P 11/00:.005|B23P 13/00:.005|B23P 15/00:.005|B23P 19/00:.005|B23P 25/00:.005|B23Q 2220/00:.005|B23Q 2230/00:.005|B23Q 2240/00:.005|B23Q 2701/00:.005|B23Q 2705/00:.005|B23Q 2707/00:.005|B23Q 2717/00:.005|B23Q 3/00:.005|B23Q 33/00:.005|B23Q 39/00:.005|B23Q 7/00:.005|B24B 1/00:.005|B24B 11/00:.005|B24B 27/00:.005|B24B 37/00:.005|B24B 45/00:.005|B24B 7/00:.005|B24D 18/00:.005|B24D 5/00:.005|B24D 7/00:.005|B25B 11/00:.005|B25B 17/00:.005|B25B 25/00:.005|B25B 29/00:.005|B25C 1/00:.005|B25C 3/00:.005|B25D 16/00:.005|B25D 2209/00:.005|B25D 2222/00:.005|B25F 1/00:.005|B25G 1/00:.005|B25H:.005|B25H 5/00:.005|B25J 19/00:.005|B25J 3/00:.005|B26B 25/00:.005|B26B 5/00:.005|B26B 9/00:.005|B26D 5/00:.005|B26D 7/00:.005|B27B 13/00:.005|B27B 17/00:.005|B27B 21/00:.005|B27B 23/00:.005|B27C 1/00:.005|B27D 1/00:.005|B27F 1/00:.005|B27G 1/00:.005|B27G 11/00:.005|B27G 21/00:.005|B27G 5/00:.005|B27J:.005|B27J 1/00:.005|B27K:.005|B27K 2200/00:.005|B27K 3/00:.005|B27L 1/00:.005|B27L 11/00:.005|B28B 17/00:.005|B28B 21/00:.005|B28B 5/00:.005|B28C:.005|B28C 7/00:.005|B28D 3/00:.005|B29B:.005|B29B 17/00:.005|B29C 2793/00:.005|B29C 2945/00:.005|B29C 2949/00:.005|B29C 35/00:.005|B29C 45/00:.005|B29C 47/00:.005|B29C 61/00:.005|B29C 66/00:.005|B29C 69/00:.005|B29D 1/00:.005|B29D 12/00:.005|B29D 22/00:.005|B29D 24/00:.005|B29D 30/00:.005|B29D 7/00:.005|B29D 99/00:.005|B29K 2001/00:.005|B29K 2003/00:.005|B29K 2029/00:.005|B29K 2035/00:.005|B29K 2059/00:.005|B29K 2067/00:.005|B29K 2081/00:.005|B29K 2083/00:.005|B29K 2105/00:.005|B29K 2203/00:.005|B29K 2205/00:.005|B29K 2239/00:.005|B29K 2245/00:.005|B29K 2259/00:.005|B29K 2269/00:.005|B29K 2271/00:.005|B29K 2273/00:.005|B29K 2291/00:.005|B29K 2295/00:.005|B29K 2309/00:.005|B29K 2407/00:.005|B29K 2409/00:.005|B29K 2419/00:.005|B29K 2427/00:.005|B29K 2429/00:.005|B29K 2455/00:.005|B29K 2463/00:.005|B29K 2465/00:.005|B29K 2467/00:.005|B29K 2469/00:.005|B29K 2471/00:.005|B29K 2473/00:.005|B29K 2475/00:.005|B29K 2483/00:.005|B29K 2501/00:.005|B29K 2503/00:.005|B29K 2505/00:.005|B29K 2509/00:.005|B29K 2607/00:.005|B29K 2619/00:.005|B29K 2625/00:.005|B29K 2627/00:.005|B29K 2631/00:.005|B29K 2639/00:.005|B29K 2649/00:.005|B29K 2663/00:.005|B29K 2673/00:.005|B29K 2675/00:.005|B29K 2683/00:.005|B29K 2689/00:.005|B29K 2695/00:.005|B29K 2701/00:.005|B29K 2705/00:.005|B29K 2803/00:.005|B29K 2805/00:.005|B29K 2821/00:.005|B29K 2823/00:.005|B29K 2829/00:.005|B29K 2877/00:.005|B29K 2881/00:.005|B29K 2886/00:.005|B29K 2903/00:.005|B29K 2905/00:.005|B29L:.005|B29L 2005/00:.005|B29L 2012/00:.005|B29L 2023/00:.005|B29L 2024/00:.005|B29L 2028/00:.005|B29L 2030/00:.005|B30B 13/00:.005|B30B 15/00:.005|B30B 5/00:.005|B31B:.005|B31B 19/00:.005|B31B 29/00:.005|B31B 37/00:.005|B31B 49/00:.005|B31B 5/00:.005|B31C 1/00:.005|B31F:.005|B31F 5/00:.005|B32B:.005|B32B 11/00:.005|B32B 15/00:.005|B32B 17/00:.005|B32B 2272/00:.005|B32B 2305/00:.005|B32B 2310/00:.005|B32B 2313/00:.005|B32B 2318/00:.005|B32B 2379/00:.005|B32B 2383/00:.005|B32B 2405/00:.005|B32B 2429/00:.005|B32B 2451/00:.005|B32B 2581/00:.005|B32B 3/00:.005|B32B 38/00:.005|B32B 39/00:.005|B32B 9/00:.005"
		}
	]
	}
, { "PackageName":"PrepareForVisualization"}
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

GO

SELECT TOP 1000 *
  FROM [nlh].[log]
  WHERE source_name <> 'PackageTemplate.dtsx'
  ORDER BY added_on DESC

SELECT TOP 1000 *
  FROM [nlh].[event]
  ORDER BY added_on DESC

use prv_dev_inh

DECLARE @api nvarchar(512) = 'ExpandCompanyList' -- possible values {'CreateLonglist', 'CreateLandscape')
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
					, "ProjectCatalog":"prv_prj_sdipapg_largecap"
				}'


EXECUTE @RC = [ivh].[run_createNewRun] 
   @projectid = @projectid
  ,@projectkey = @projectkey
  ,@solution = @solution
  ,@api = @api
  ,@runid = @runid
  ,@json_sla = @json_sla
  ,@json_config = N'{"Header":{"Creator":"kwesseling@deloitte.nl","CreationDate":null,"BuildVersion":null,"ProjectId":null,"SsisApiRunId":7344,"NameOfApi":"ExpandCompanyList","ConfigurationDescription":null,"ConfigurationVersion":null},"ComponentParams":[{"PackageName":"MakeCompanySuggestion","ProjectType":"Eugf","CreateStatsParams":null,"ScoreRiskTextParams":null,"LoadCalendarParams":null,"LoadCompaniesParams":null,"LoadIndustriesParams":null,"LoadParagraphsParams":null,"LoadSubjectTreeParams":null,"LoadSubjectScoreSourcesParams":null,"LoadDealScoresParams":null,"LoadSubjectScoresParams":null,"RefreshWebDataParams":null,"GetKeywordProfileParams":null,"RetrievalParams":null,"ScoringParams":null,"ScoreGroupingParams":null,"NodeSelectionParams":null,"ScoreLandscapeNodesParams":null,"GetNodePropertiesParams":null,"NormalizeDistance":null,"RandomSeed":null,"MaxIterations":null,"Algorithm":"Random","YearSpan":null,"Financials":null,"FinancialRatios":null,"IpMetrics":null,"LongListFilters":null,"CompanySuggestionParams":{"PositiveInstance":"JP000001080JPN|DE7150000030|US310411980|US750289970|SE5560160680|JP000000906JPN|US160393470|FR552096281|DE2070000543|JP000000855JPN","NegativeInstance":"US360698440|US411321939|US042695240|US221918501|US352145715|US135315170|US610647538|CA30102NC|IE527629|US320375147|IE545333|JP000000756JPN|US050494040|CHCHE103867266|US364316614|US360781620|US134151777|GB02723534|FR380129866|US943047598|US220760120|JP000000690JPN|US221024240|US953540776|GB03888792|US220790350|US471758322|US310958666|AU051588348|DK69749917|CHCHE101188361|US133444607|JP000000998JPN|US410231510|FR552032534|FR395030844|JP000001032JPN|DK24256790|US460696167|US042209186|JP000000714JPN|PA16585RPP|US591995548","FocuslistName":"karel_test_expander_ neg8"},"BagOfWords":null}]}'
  ,@debug = 1 
--CompanySuggestionParams":{


/*EXECUTE @RC = [ivh].[run_createNewRun] 
   @projectid = @projectid
  ,@projectkey = @projectkey
  ,@solution = @solution
  ,@api = @api
  ,@runid = @runid
  ,@json_sla = @json_sla
  ,@json_config = N'{"Header":{
	"NameOfApi":"ExpandCompanyList",
	"Creator":"pbaljon@deloitte.nl",
	"ConfigurationDescription":"",
	"ConfigurationVersion":"",
},"ComponentParams" : [ 
	{ "PackageName":"MakeCompanySuggestion"
		, "PositiveInstance" : "AU000710074|BE0437556112|BE0897553074|CA251551511L|CA257357618L|CHCHE100136893|DE7050000100|FR542105572|GB07696824|NL08218195|US164428956L|US206039148L|US241581014L"
		, "FocuslistName" : "Disruptors"
	}
	]}'
  ,@debug = 1 
*/
/*EXECUTE @RC = [ivh].[run_createNewRun] 
   @projectid = @projectid
  ,@projectkey = @projectkey
  ,@solution = @solution
  ,@api = @api
  ,@runid = @runid
  ,@json_sla = @json_sla
  ,@json_config = N'{"Header":{
	"NameOfApi":"ExpandCompanyList",
	"Creator":"pbaljon@deloitte.nl",
	"ConfigurationDescription":"",
	"ConfigurationVersion":"",
},"ComponentParams" : [ 
	{ "PackageName":"MakeCompanySuggestion"
		, "PositiveInstance" : "CN9361523321|CN9363195554|CN9365301023|CN9361070010|CN9362866263|CN9364930377|CN*HX000315146|CN9363203236|CN9364096870|CN*908294987|CN9360051835|JP595412107S|CN*856003656"
		, "FocuslistName" : "Chinese sorbent universities"
	}
	]}'
  ,@debug = 1 
  
*/
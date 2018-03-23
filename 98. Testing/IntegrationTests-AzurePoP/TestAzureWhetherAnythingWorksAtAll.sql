use prv_dev_inh

EXEC [ivh].[run_removeSqlServerAgentJobs]

DECLARE @json_sla varchar(max)
DECLARE @json_config_ll varchar(max)
set @json_sla = N'{"ComponentID": "D0E4F952-663C-42CA-89E8-318C931D42A9"
  , "RunID": "-1"
  , "PollEvery": "00:00:10"
  , "TimeOutAfter": "3600"
  , "PlatformDataSource": "equip-pop-vm"
  , "PlatformCatalog": "prv_dev_inh"
  , "DatahandlerDataSource": "equip-pop-vm"
  , "DatahandlerCatalog": "prv_dev_dth"
  , "DatahandlerVersion": "latest"
  , "ProjectDataSource":"equip-pop-vm"
  , "ProjectCatalog":"prv_prj_deploytest"
}'

SET @json_config_ll = N'{"Header":{
	"NameOfApi":"CreateLonglist",
	"Creator":"pbaljon@deloitte.nl",
	"ConfigurationDescription":"Integration testing scenario - Creating an Additive manufacturing longlist",
	"ConfigurationVersion":""
},"ComponentParams" : [
  {
    "PackageName": "CreatePrepareEnvironment",
    "CreatePrepareEnvironmentParams": {
      "Append": false
    }
  },
  {
    "PackageName": "CompanyRetrieval",
    "RetrievalParams": [
      {
        "RetrievalType": "BasicConstraints",
        "RetrievalLabel": "Dutch listed",
        "NumberOfCompanies": 5,
        "Constraints": "country:NL|listed:Listed|age:48"
      },
      {
        "RetrievalType": "CompanyTextBagOfWords",
        "RetrievalLabel": "Business - AM",
        "NumberOfCompanies": 5,
        "Normalize": "None",
        "Constraints": "",
        "BagOfWords": "additive manuf*|3d print*"
      },
      {
        "RetrievalType": "TopicScore",
        "RetrievalLabel": "PAT.Composite",
        "NumberOfCompanies": 5,
        "Normalize": "None",
        "Constraints": "",
        "TopicName": "Advanced composite",
        "TopicCorpus": "Patents"
      },
      {
        "RetrievalType": "TopicScore",
        "RetrievalLabel": "TRD.Composite",
        "NumberOfCompanies": 5,
        "Normalize": "None",
        "Constraints": "",
        "TopicName": "Advanced composite",
        "TopicCorpus": "Trade"
      },
      {
        "RetrievalType": "TopicScore",
        "RetrievalLabel": "SEC.Composite",
        "NumberOfCompanies": 5,
        "Normalize": "None",
        "Constraints": "",
        "TopicName": "Advanced composite",
        "TopicCorpus": "Sec"
      },
      {
        "RetrievalType": "TopicScore",
        "RetrievalLabel": "WEB.Composite",
        "NumberOfCompanies": 5,
        "Normalize": "None",
        "Constraints": "",
        "TopicName": "Advanced composite",
        "TopicCorpus": "Website"
      },
      {
        "RetrievalType": "CompanyList",
        "RetrievalLabel": "Marked companies",
        "CompanyId": "USD305504941D|DE2010000581|JP000000843JPN|JP000000746JPN|JP000001066JPN"
      },
      {
        "RetrievalType": "CompanyTextBagOfWords",
        "RetrievalLabel": "Business - AM wildcard",
        "NumberOfCompanies": 5,
        "Normalize": "None",
        "BagOfWords": "#additive manuf*# OR #3d print*#",
        "Constraints": "country:US"
      }
    ]
  },
  {
    "PackageName": "CompanyScoring",
    "ScoringParams": [
      {
        "ScoringType": "OrbisAttribute",
        "ScoringLabel": "Country",
        "AttributeName": "country"
      },
      {
        "ScoringType": "OrbisAttribute",
        "ScoringLabel": "Age",
        "AttributeName": "age"
      },
      {
        "ScoringType": "IndustryAttribute",
        "ScoringLabel": "Industry"
      },
      {
        "ScoringType": "TopicScore",
        "ScoringLabel": "PAT.Composite",
        "TopicCorpus": "Patents",
        "TopicName": "Advanced composite"
      },
      {
        "ScoringType": "TopicScore",
        "ScoringLabel": "WEB.Composite",
        "TopicCorpus": "Website",
        "TopicName": "Advanced composite"
      },
      {
        "ScoringType": "TopicScore",
        "ScoringLabel": "SEC.Composite",
        "TopicCorpus": "Sec",
        "TopicName": "Advanced composite"
      },
      {
        "ScoringType": "TopicScore",
        "ScoringLabel": "TRD.Composite",
        "TopicCorpus": "Trade",
        "TopicName": "Advanced composite"
      },
      {
        "ScoringType": "CompanyTextBagOfWords",
        "ScoringLabel": "Business - AM",
        "Normalize": "Portfolio",
        "BagOfWords": "additive manuf*|3d print*"
      },
      {
        "ScoringType": "ManualScore",
        "ScoringLabel": "Future Impact",
        "ScoreDataType": "nvarchar",
        "CompanyScore": "USD305504941D:High, developing extensive wind-power IP|DE2010000581:Low but dont care"
      },
      {
        "ScoringType": "ManualScore",
        "ScoringLabel": "Numeric Future Impact",
        "ScoreDataType": "real",
        "CompanyScore": "USD305504941D:9.123|DE2010000581:5"
      }
    ]
  }, { "PackageName":"PrepareForVisualization"}
	]}'

	EXECUTE [ivh].[run_createNewRun] 
		@projectid = 1
		,@projectkey = 'Test'
		,@solution = 'PRV'
		,@api = 'CreateLonglist'
		,@json_sla = @json_sla
		,@json_config = @json_config_ll
		,@debug = 1
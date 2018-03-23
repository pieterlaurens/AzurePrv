use prv_dev_inh

/*
	The starting point of this function is a project where you succesfully
	created a longlist with a set of scores. For the test we'll use prv_prj_test_equip.
	============================================================
*/

/*
	1. The second step is to set the SLA that points the pipeline to the right
	project and Data Handler.
	- The project should be prv_prj_test_equip. If you feel confident, you can also
	  run it against against your own projet of choice.
	- The Data Handler, in order to use IP metrics, should be Janus. This is the
	  first version where we introduced the IP metrics over time.
*/
	DECLARE @json_sla nvarchar(max)
	SET @json_sla = N'{"ComponentID": "D0E4F952-663C-42CA-89E8-318C931D42A9"
					, "RunID": "-1"
					, "PollEvery": "00:00:10"
					, "TimeOutAfter": "3600"
					, "PlatformDataSource": "nlagpdatacore"
					, "PlatformCatalog": "prv_dev_inh"
					, "DatahandlerDataSource": "NLAGPDATACORE"
					, "DatahandlerCatalog": "prv_dev_dth"
					, "DatahandlerVersion": "jaws"
					, "ProjectDataSource":"nlagpdatacore"
					, "ProjectCatalog":"prv_prj_impactdev"
				}'


/*
	2. The third step is to set the configuration to create the Matlab table.
	- The project should be prv_prj_test_equip. If you feel confident, you can also
	  run it against against your own projet of choice.
	- The Data Handler, in order to use IP metrics, should be Janus. This is the
	  first version where we introduced the IP metrics over time.
	- In the first example, we add to the columns in the longlsit, the pivoted
	  column with employees.
*/
	DECLARE @json_sla nvarchar(max)
	DECLARE @RC int
	SET @json_sla = N'{"ComponentID": "D0E4F952-663C-42CA-89E8-318C931D42A9"
					, "RunID": "-1"
					, "PollEvery": "00:00:10"
					, "TimeOutAfter": "3600"
					, "PlatformDataSource": "nlagpdatacore"
					, "PlatformCatalog": "prv_dev_inh"
					, "DatahandlerDataSource": "NLAGPDATACORE"
					, "DatahandlerCatalog": "prv_dev_dth"
					, "DatahandlerVersion": "jaws"
					, "ProjectDataSource":"nlagpdatacore"
					, "ProjectCatalog":"prv_prj_impactdev"
				}'
	DECLARE @json_config nvarchar(max)
	SET @json_config = N'{"Header":{
						"NameOfApi":"MatlabDataGenerator",
						"Creator":"orakic@deloitte.nl",
						"ConfigurationDescription":"",
						"ConfigurationVersion":"",
					},"ComponentParams" : [ 
					{
						"PackageName":"GenerateMatlabTable"
						,"YearSpan":"2010-2015"
						, "Financials":"revenue"
						, "IpMetrics":"number_of_patents|citations_per_age_year"
					}
					]}'

	EXECUTE @RC = [ivh].[run_createNewRun] 
	   @projectid = 007
	  ,@projectkey = 'testPipeline_PRV_GenerateMatlabResources'
	  ,@solution = 'PRV'
	  ,@api = 'PublishMatlabResources'
	  ,@runid = 0
	  ,@json_sla = @json_sla
	  ,@json_config = @json_config
	  ,@debug = 1
	GO

  /* 3. Now, we also want to add IP metrics. The configuration below, will add both 6 columns
        with employees from 2010 through 2015, and 6 columns with the number of newly filed
		patents per year. By also requesting the number of patents, you are able to test
		whether the difference between years in total number of patents equals the number of
		newly filed patents.
 */
	DECLARE @json_sla nvarchar(max)
	DECLARE @RC int
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
					, "ProjectCatalog":"prv_prj_test_equip"
				}'
 	DECLARE @json_config nvarchar(max)
	SET @json_config = N'{"Header":{
							"NameOfApi":"MatlabDataGenerator",
							"Creator":"orakic@deloitte.nl",
							"ConfigurationDescription":"",
							"ConfigurationVersion":"",
						},"ComponentParams" : [ 
						{
							"PackageName":"GenerateMatlabTable",
							"YearSpan":"2010-2015"
							, "Financials":"employees"
							, "IpMetrics":"number_of_new_patents|number_of_patents"
						}
						]}'

	EXECUTE @RC = [ivh].[run_createNewRun] 
	   @projectid = 007
	  ,@projectkey = 'testPipeline_PRV_GenerateMatlabResources'
	  ,@solution = 'PRV'
	  ,@api = 'PublishMatlabResources'
	  ,@runid = 0
	  ,@json_sla = @json_sla
	  ,@json_config = @json_config
	  ,@debug = 1
	GO
  /* 4. The last step is to add an IP score to the longlist first, and then regenerate the Matlab table.
 */
 
 /* 4a. Add the score to the Matlab table */
	DECLARE @json_sla nvarchar(max)
	DECLARE @RC int
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
					, "ProjectCatalog":"prv_prj_test_equip"
				}'
	DECLARE @json_config NVARCHAR(max)
	SET @json_config = N'{"Header":{
						"NameOfApi":"AddScoreToLonglist",
						"Creator":"orakic@deloitte.nl",
						"ConfigurationDescription":"",
						"ConfigurationVersion":"",
					},"ComponentParams" : [ 
					{
					"PackageName":"CompanyScoring",
					"ScoringParams" : [
						{
						"ScoringType" : "OrbisAttribute"
						, "ScoringLabel" : "Country"
						, "AttributeName" : "citations_per_age_year"
						}
					]
					},
					{"PackageName":"PrepareForVisualization"}
					]}' 
	EXECUTE @RC = [ivh].[run_createNewRun] 
	   @projectid = 007
	  ,@projectkey = 'testPipeline_PRV_AddScoreToLonglist'
	  ,@solution = 'PRV'
	  ,@api = 'AddScoreToLonglist'
	  ,@runid = 0
	  ,@json_sla = @json_sla
	  ,@json_config = @json_config
	  ,@debug = 1
	GO
 /* 4b. Regenerate the Matlab table */
	DECLARE @json_sla nvarchar(max)
	DECLARE @RC int
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
					, "ProjectCatalog":"prv_prj_test_equip"
				}'
	DECLARE @json_config NVARCHAR(max)
	SET @json_config = N'{"Header":{
							"NameOfApi":"MatlabDataGenerator",
							"Creator":"orakic@deloitte.nl",
							"ConfigurationDescription":"",
							"ConfigurationVersion":"",
						},"ComponentParams" : [ 
						{
							"PackageName":"GenerateMatlabTable",
							"YearSpan":"2010-2015"
							, "Financials":"employees"
							, "IpMetrics":"number_of_new_patents|number_of_patents"
						}
						]}'
	EXECUTE @RC = [ivh].[run_createNewRun] 
	   @projectid = 007
	  ,@projectkey = 'testPipeline_PRV_GenerateMatlabResources'
	  ,@solution = 'PRV'
	  ,@api = 'PublishMatlabResources'
	  ,@runid = 0
	  ,@json_sla = @json_sla
	  ,@json_config = @json_config
	  ,@debug = 1



/* ================================================
	0. Initialize
   ================================================ */
USE prv_dev_inh
GO

SET NOCOUNT ON
GO

DECLARE @debug bit = 1
		, @logmessage NVARCHAR(4000) ;


/* ================================================
	1. Configure startup values
   ================================================ */
DECLARE @Application sysname = 'Technology'			-- {Risk, Strategy, BusinessProcess, Deal, Technology}
		, @Environment sysname = 'Development'		-- {GovernanceBox, Development, Production}
		, @Version tinyint = 1
;

DECLARE @CalculateTrendFromYear int = 2007
		, @CalculateTrendToYear int = 2016
		-- public enum CompanySelectionType: {SecFilings, AnnualReports, ManualInput, Deals, Patents}
		, @CompaniesToLoad nvarchar(256) = 'Patents'
		-- public enum SubjectTreeType: {Risk_Intelligence_Map, Shareholder_Value_Map, Business_Process_Grouping, Nace_Industry_Classification, Cooperative_Patent_Classification}
		, @SubjectTreeList nvarchar(256) = 'Cooperative_Patent_Classification'
		, @TruncateDimensionsBeforeLoad bit = 1
		, @TruncateFactsBeforeLoad bit = 1


/* ================================================
	2. Set application constants
   ================================================ */
DECLARE @SOLUTION nvarchar(255) = 'GovernanceBox'
		, @PROJECTID int = 007
		, @PROJECTKEY nvarchar(100) = CONCAT(@Application, 'FocusReports')
		, @API nvarchar(512) = 'LoadTechnologyScoresDatamart'
		, @DBKEY sysname = CONCAT(@Application, 'Focus', CASE WHEN @Version <> 1 THEN @Version END)
;


/* ================================================
	3a. Set environment specification
   ================================================ */
DECLARE @PlatformServer sysname, @ProjectServer sysname, @WebDbServer sysname
		, @PlatformCatalog sysname, @ProjectCatalog sysname, @WebDbCatalog sysname

IF @Environment = 'Development'
BEGIN
	SELECT @PlatformServer = 'NLAMS00859', @PlatformCatalog = 'prv_dev_inh'
			, @ProjectServer = 'NLAMS10859', @ProjectCatalog = CONCAT(@DBKEY, 'Data')
			, @WebDbServer = 'NLAMS10859', @WebDbCatalog = CONCAT(@DBKEY, 'Web')
END
ELSE IF @Environment = 'GovernanceBox'
BEGIN
	SELECT @PlatformServer = 'NLAMS00859', @PlatformCatalog = 'prv_dev_inh'
			, @ProjectServer = 'NLAMS10859', @ProjectCatalog = 'GovernanceBox'
			, @WebDbServer = 'NLAMS10859', @WebDbCatalog = 'GovernanceBoxStats'
END
ELSE IF @Environment = 'Production'
BEGIN
	SELECT @PlatformServer = 'NLAMS10848', @PlatformCatalog = 'GovernanceBoxPipeline'
			, @ProjectServer = 'NLAMS10848', @ProjectCatalog = CONCAT(@DBKEY, 'Data')
			, @WebDbServer = 'NLAMS10848', @WebDbCatalog = CONCAT(@DBKEY, 'Web')
END
ELSE IF @Application NOT IN ('Development', 'GovernanceBox', 'Production')
BEGIN
	SET @logmessage = CONVERT(nvarchar, GETDATE(), 121) + ' No valid environment specified; environment should be in {GovernanceBox, Development, Production}'
	RAISERROR (@logmessage, 0, 1) WITH NOWAIT
	
	RETURN
END


PRINT CONCAT('Running for project database / application ', @ProjectCatalog, ' on server ', @ProjectServer)

/* ================================================
	3b. Set application specification
   ================================================ */
DECLARE @TopicDbServer sysname
		, @TopicDbCatalog sysname

IF @Application IN ('Risk')
BEGIN
	SELECT @TopicDbServer = 'NLAMS00822', @TopicDbCatalog = 'p00019_TopicDB'
END
ELSE IF @Application IN ('Strategy', 'BusinessProcess')
BEGIN
	SELECT @TopicDbServer = 'NLAMS00822', @TopicDbCatalog = 'p00130_TopicDB'
END
ELSE IF @Application IN ('Technology')
BEGIN
	SELECT @TopicDbServer = 'NLAGPDATACORE', @TopicDbCatalog = 'pw_v2017a_001'
END
ELSE IF @Application NOT IN ('Risk', 'Strategy', 'BusinessProcess', 'Deal', 'Technology')
BEGIN
	SET @logmessage = CONVERT(nvarchar, GETDATE(), 121) + ' No valid application specified; application should be in {Risk, Strategy, BusinessProcess, Deals}'
	RAISERROR (@logmessage, 0, 1) WITH NOWAIT
	
	RETURN
END


/* ================================================
	4. Set SLA settings
   ================================================ */
DECLARE @json_sla nvarchar(max)
SET @json_sla = N'{
					"ComponentID": "D0E4F952-663C-42CA-89E8-318C931D42A9",
					"RunID": 0,
					"PollEvery": "00:00:10",
					"TimeOutAfter": 3600,
					"PlatformDataSource": "$(PlatformServer)",
					"PlatformCatalog": "$(PlatformCatalog)",
					"DatahandlerDataSource": "nlams00859",
					"DatahandlerCatalog": "prv_dev_dth",
					"DatahandlerVersion": "latest",
					"ProjectDataSource": "$(ProjectServer)",
					"ProjectCatalog": "$(ProjectCatalog)"
				}'
SET @json_sla = REPLACE(@json_sla, '$(PlatformServer)',  @PlatformServer)
SET @json_sla = REPLACE(@json_sla, '$(PlatformCatalog)',  @PlatformCatalog)
SET @json_sla = REPLACE(@json_sla, '$(ProjectServer)',  @ProjectServer)
SET @json_sla = REPLACE(@json_sla, '$(ProjectCatalog)',  @ProjectCatalog)

IF @Debug = 1 PRINT @json_sla


/* ================================================
	5. Set pipeline configuration
   ================================================ */
DECLARE @json_config nvarchar(max)
SET @json_config = N'{
    "Header":
    {
        "NameOfApi": "$(Api)",
        "Creator": "$(User)",
        "ConfigurationDescription": "",
        "ConfigurationVersion": ""
    },
    "ComponentParams":
    [
        {   "PackageName": "LoadCalendar",
            "ProjectType": "PdfReport",
            "loadCalendarParams":
            {
                "CalendarStartYear": $(CalculateTrendFromYear),
                "CalendarEndYear": $(CalculateTrendToYear),
                "TruncateBeforeLoad": $(TruncateDimensionsBeforeLoad)
            }
        },
        {   "PackageName": "LoadCompanies",
            "ProjectType": "PdfReport",
            "loadCompaniesParams":
            {
                "CompaniesToLoad": "Patents",
				"CompanyOwnershipDataSource": "NLAGPDATACORE",
				"CompanyOwnershipCatalog": "company_ownership",
                "DealsCatalog": "sdd",
                "DealsDataSource": "NLAGPDATACORE",
                "OrbisCatalog": "scd_v2017_005",
                "OrbisDataSource": "NLAGPDATACORE",
                "PatentsCatalog": "$(PatentCompaniesCatalog)",
                "PatentsDataSource": "$(PatentCompaniesServer)",
                "TruncateBeforeLoad": $(TruncateDimensionsBeforeLoad)
            }
        },
        {   "PackageName": "LoadIndustries",
            "ProjectType": "PdfReport",
            "loadIndustriesParams":
            {
                "NaceCatalog": "nace_code_v2017_001",
                "NaceDataSource": "NLAGPDATACORE",
                "TruncateBeforeLoad": $(TruncateDimensionsBeforeLoad)
            }
        },
        {   "PackageName": "LoadCountries",
            "ProjectType": "PdfReport",
            "loadCountriesParams":
            {
                "CountryCatalog": "country_code",
                "CountryDataSource": "NLAGPDATACORE",
                "TruncateBeforeLoad": $(TruncateDimensionsBeforeLoad)
            }
        },
       {   "PackageName": "LoadSubjects",
            "ProjectType": "PdfReport",
            "loadSubjectTreeParams":
            {
                "SubjectTreesToLoad": "$(SubjectTreeList)",
                "TopicDefinitionCatalog": "$(TopicDbCatalog)",
                "TopicDefinitionDataSource": "$(TopicDbServer)",
                "TruncateBeforeLoad": $(TruncateDimensionsBeforeLoad)
            }
        },
        {   "PackageName": "LoadTechnologyScores",
            "ProjectType": "PdfReport",
            "loadTechnologyScoresParams":
            {
				"IndustryLevelsToCalculate": "0|1|2|3",
				"MinimumNumberOfTechnologiesRequired": 7,
                "MinimumVarianceForTrendChange": 3.0,
                "PatentScoresCatalog": "$(TopicDbCatalog)",
                "PatentScoresDataSource": "$(TopicDbServer)",
                "PatentCompaniesCatalog": "$(PatentCompaniesCatalog)",
                "PatentCompaniesDataSource": "$(PatentCompaniesServer)",
				"SubjectLevelsToCalculate": "1|2|3|4",
                "TrendStartYear": $(CalculateTrendFromYear),
                "TrendEndYear": $(CalculateTrendToYear),
                "TruncateBeforeLoad": $(TruncateFactsBeforeLoad)
            }
        }
    ]
}' 
SET @json_config = REPLACE(@json_config, '$(Api)',  @API)
SET @json_config = REPLACE(@json_config, '$(User)',  CONCAT( REPLACE(SYSTEM_USER, 'NL\', ''), '@deloitte.nl' ) )
SET @json_config = REPLACE(@json_config, '$(ProjectServer)',  @ProjectServer)
SET @json_config = REPLACE(@json_config, '$(ProjectCatalog)',  @ProjectCatalog)
SET @json_config = REPLACE(@json_config, '$(TopicDbServer)',  @TopicDbServer)
SET @json_config = REPLACE(@json_config, '$(TopicDbCatalog)',  @TopicDbCatalog)

SET @json_config = REPLACE(@json_config, '$(PatentCompaniesServer)',  @TopicDbServer)
SET @json_config = REPLACE(@json_config, '$(PatentCompaniesCatalog)',	REPLACE(@TopicDbCatalog, 'pw_', 'pwc_'))
SET @json_config = REPLACE(@json_config, '$(CalculateTrendFromYear)',  @CalculateTrendFromYear)
SET @json_config = REPLACE(@json_config, '$(CalculateTrendToYear)',  @CalculateTrendToYear)
SET @json_config = REPLACE(@json_config, '$(CompaniesToLoad)',  @CompaniesToLoad)
SET @json_config = REPLACE(@json_config, '$(SubjectTreeList)',  @SubjectTreeList)
SET @json_config = REPLACE(@json_config, '$(TruncateDimensionsBeforeLoad)',  CASE WHEN @TruncateDimensionsBeforeLoad = 1 THEN 'true' ELSE 'false' END)
SET @json_config = REPLACE(@json_config, '$(TruncateFactsBeforeLoad)',  CASE WHEN @TruncateFactsBeforeLoad = 1 THEN 'true' ELSE 'false' END)

IF @Debug = 1 PRINT @json_config


/* ================================================
	6. Launch pipeline
   ================================================ */
DECLARE @RC int
DECLARE @runid int = 0
DECLARE @pkey sysname = CONCAT(@PROJECTKEY, @SOLUTION, '_', @API, '_', @runid)

EXECUTE @RC = [ivh].[run_createNewRun] 
   @projectid = @PROJECTid
  ,@projectkey = @pkey
  ,@solution = @SOLUTION
  ,@api = @API
  ,@runid = @runid
  ,@json_sla = @json_sla
  ,@json_config = @json_config
  ,@debug = @Debug
GO


/* ================================================
	7. Get records from [nlh].[log] / [nlh].[event]
   ================================================ */
SELECT TOP 100 *
  FROM [nlh].[log]
  WHERE source_name <> 'PackageTemplate.dtsx'
  ORDER BY added_on DESC

SELECT TOP 100 *
  FROM [nlh].[event]
  ORDER BY added_on DESC
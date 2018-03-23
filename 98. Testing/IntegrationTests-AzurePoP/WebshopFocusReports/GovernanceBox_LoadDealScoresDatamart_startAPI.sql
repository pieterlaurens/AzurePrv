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
DECLARE @Application sysname = 'Deal'					-- {Deal}
		, @Environment sysname = 'Development'			-- {GovernanceBox, Development, Production}
		, @Version tinyint = 3
;

DECLARE @CalculateTrendFromYear int = 2007
		, @CalculateTrendToYear int = 2016
		, @TruncateDimensionsBeforeLoad bit = 1
		, @TruncateFactsBeforeLoad bit = 1


/* ================================================
	2. Set application constants
   ================================================ */
DECLARE @SOLUTION nvarchar(255) = 'GovernanceBox'
		, @PROJECTID int = 007
		, @PROJECTKEY nvarchar(100) = CONCAT(@Application, 'FocusReports')
		, @API nvarchar(512) = 'LoadDealScoresDatamart'
		, @DBKEY sysname = CONCAT(@Application, 'Focus', CASE WHEN @Version <> 1 THEN @Version END)
;


PRINT CONCAT('Running for project database / application ', @ProjectCatalog, ' on server ', @WebDbCatalog)

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
ELSE IF @Application NOT IN ('Risk', 'Strategy', 'BusinessProcess', 'Deal', 'Technology')
BEGIN
	SET @logmessage = CONVERT(nvarchar, GETDATE(), 121) + ' No valid application specified; application should be in {Risk, Strategy, BusinessProcess, Deal}'
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
					"TimeOutAfter": 10800,
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
                "CompaniesToLoad": "Deals",
				"CompanyOwnershipDataSource": "NLAGPDATACORE",
				"CompanyOwnershipCatalog": "company_ownership",
                "DealsCatalog": "sdd",
                "DealsDataSource": "NLAGPDATACORE",
				"EntityTypesToLoad": "Bank|Financial company|Industrial company|Insurance company",
                "OrbisCatalog": "scd",
                "OrbisDataSource": "NLAGPDATACORE",
                "PatentsCatalog": "pwc_v2016b_002",
                "PatentsDataSource": "NLAMS10859",
                "TruncateBeforeLoad": $(TruncateDimensionsBeforeLoad)
            }
        },
        {   "PackageName": "LoadIndustries",
            "ProjectType": "PdfReport",
            "loadIndustriesParams":
            {
                "NaceCatalog": "nace_code",
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
        {   "PackageName": "LoadDeals",
            "ProjectType": "PdfReport",
            "loadDealsParams":
            {
                "DealsCatalog": "sdd",
                "DealsDataSource": "NLAGPDATACORE",
                "DealStatusToLoad": "Announced|Completed|Pending|Unconditional",
                "DealTypesToLoad": "Acquisition|Demerger|Merger|Minority stake|Joint venture",
                "TrendStartYear": $(CalculateTrendFromYear),
                "TrendEndYear": $(CalculateTrendToYear),
                "TruncateBeforeLoad": $(TruncateFactsBeforeLoad)
            }
        },
        {   "PackageName": "LoadDealScores",
            "ProjectType": "PdfReport",
            "loadDealScoresParams":
            {
                "CompanyOwnershipCatalog": "company_ownership",
                "CompanyOwnershipDataSource": "NLAGPDATACORE",
                "DealsCatalog": "sdd",
                "DealsDataSource": "NLAGPDATACORE",
                "DealStatusToLoad": "Announced|Completed",
                "DealTypesToLoad": "Acquisition|Demerger|Merger|Minority stake|Joint venture",
				"IndustryLevelsToCalculate": "0|1|2|3",
                "MinimumVarianceForTrendChange": 3.0,
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

SET @json_config = REPLACE(@json_config, '$(CalculateTrendFromYear)',  @CalculateTrendFromYear)
SET @json_config = REPLACE(@json_config, '$(CalculateTrendToYear)',  @CalculateTrendToYear)
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
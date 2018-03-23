﻿/* ================================================
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
DECLARE @Application sysname = 'Risk'				-- {Risk, Strategy, BusinessProcess}
		, @Environment sysname = 'Development'		-- {GovernanceBox, Development, Production}
		, @Version tinyint = 4
;

DECLARE @CalculateTrendFromYear int = 2012
		, @CalculateTrendToYear int = 2016
		-- public enum ParagraphSource: {SecFilings, AnnualReports, ManualInput}
		-- public enum DocumentSelectionType: {SecFilings, AnnualReports, ManualInput, Web}
		, @DocumentsToLoad nvarchar(256) = 'SecFilings|Web|AnnualReports'
		, @MultipleDocumentTypesPerCompany bit = 0
		-- public enum SubjectTreeType: {Risk_Intelligence_Map, Shareholder_Value_Map, Business_Process_Grouping, Cooperative_Patent_Classification}
		, @SubjectTreeList nvarchar(256) = 'Risk_Intelligence_Map'
		-- RISK: {Dutch annual reports (risk paragraph), Manual input (risk paragraph), SEC 10k by filing id [risk], Annual reports, Dedupped, IsRiskScore filtered (stemmed, aggregated to doc_id)}
		-- STRATEGY: {Company SEC (business paragraph, not aggregated), Company SEC (full text, not aggregated), Company report (annualreports.com), Web annual reports (test, full text. not aggregated)}
		, @SourceDescriptionSetsToLoad nvarchar(512) = 'SEC 10k by filing id [risk]|Annual reports, Dedupped, IsRiskScore filtered (stemmed, aggregated to doc_id)|Dutch annual reports (risk paragraph)'
		, @TruncateFactsBeforeLoad bit = 1


/* ================================================
	2. Set application constants
   ================================================ */
DECLARE @SOLUTION nvarchar(255) = 'GovernanceBox'
		, @PROJECTID int = 007
		, @PROJECTKEY nvarchar(100) = CONCAT(@Application, 'FocusReports')
		, @API nvarchar(512) = 'RefreshTopicScores'
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
        {   "PackageName": "LoadSubjectScores",
            "ProjectType": "PdfReport",
            "loadSubjectScoresParams":
            {
                "DocumentsToLoad": "$(DocumentsToLoad)",
				"IndustryLevelsToCalculate": "0|1|2|3",
                "MinimumNumberOfTopicMatchesRequired": 7,
				"MinimumTopicScoreRequired" : 0.5,
                "MinimumVarianceForTrendChange": 3.0,
                "MultipleDocumentTypesPerCompany": $(MultipleDocumentTypesPerCompany),
                "SourceDescriptionSetsToLoad": "$(SourceDescriptionSetsToLoad)",
  				"SubjectLevelsToCalculate": "1|2|3|4",
                "TopicScoresCatalog": "$(TopicDbCatalog)",
                "TopicScoresDataSource": "$(TopicDbServer)",
                "TrendStartYear": $(CalculateTrendFromYear),
                "TrendEndYear": $(CalculateTrendToYear),
                "TruncateBeforeLoad": $(TruncateFactsBeforeLoad)
            }
        },
		{   "PackageName": "RefreshWebData",
            "ProjectType": "PdfReport",
            "RefreshWebDataParams":
            {
				"IndustryLevelsToPublish": "0|1|2|3",
                "MinimumVarianceForTrendChange": 3.0,
                "PublishCatalog": "$(WebDbCatalog)",
                "PublishDataSource": "$(WebDbServer)",
				"SubjectLevelsToPublish": "0|1|2|3|4",
                "SubjectTreesToPublish": "$(SubjectTreeList)",
                "TrendStartYear": $(CalculateTrendFromYear),
                "TrendEndYear": $(CalculateTrendToYear),
                "TruncateBeforeLoad": $(TruncateFactsBeforeLoad)
            }
        }
    ]
}' 
SET @json_config = REPLACE(@json_config, '$(Api)',  @API)
SET @json_config = REPLACE(@json_config, '$(User)',  CONCAT( REPLACE(SYSTEM_USER, 'NL\', ''), '@deloitte.nl' ) )
SET @json_config = REPLACE(@json_config, '$(TopicDbServer)',  @TopicDbServer)
SET @json_config = REPLACE(@json_config, '$(TopicDbCatalog)',  @TopicDbCatalog)
SET @json_config = REPLACE(@json_config, '$(WebDbServer)',  @WebDbServer)
SET @json_config = REPLACE(@json_config, '$(WebDbCatalog)',  @WebDbCatalog)

SET @json_config = REPLACE(@json_config, '$(CalculateTrendFromYear)',  @CalculateTrendFromYear)
SET @json_config = REPLACE(@json_config, '$(CalculateTrendToYear)',  @CalculateTrendToYear)
SET @json_config = REPLACE(@json_config, '$(DocumentsToLoad)',  @DocumentsToLoad)
SET @json_config = REPLACE(@json_config, '$(MultipleDocumentTypesPerCompany)',  CASE WHEN @MultipleDocumentTypesPerCompany = 1 THEN 'true' ELSE 'false' END)
SET @json_config = REPLACE(@json_config, '$(SourceDescriptionSetsToLoad)',  @SourceDescriptionSetsToLoad )
SET @json_config = REPLACE(@json_config, '$(SubjectTreeList)',  @SubjectTreeList)
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
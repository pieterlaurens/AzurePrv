/* ================================================
	0. Initialize
   ================================================ */
USE GovernanceBoxPipeline
GO

SET NOCOUNT ON
GO

DECLARE @debug bit = 1
		, @logmessage NVARCHAR(4000) ;


/* ================================================
	1. Configure startup values
   ================================================ */
DECLARE @Application sysname = 'Risk'				-- {Risk, Strategy, BusinessProcess, Deal}
		, @Environment sysname = 'Production'		-- {GovernanceBox, Development, Production}
		, @Version tinyint = 4
;

DECLARE @CalculateTrendFromYear int = 2012
		, @CalculateTrendToYear int = 2016
		, @GroupName sysname = 'IntegrationTest 20180105-a'
		, @CompanyBvdIdList nvarchar(max) = 'LULB153549,LULB155908,LULB72391,LULB82454,MH30028AQ,MH30033AQ,MH30034AQ,MH40003AQ,NL02045200,NL06045666,NL09007809,NL09051284,NL09092395,NL14022069,NL14117527,NL17001910,NL17085815,NL23008599,NL24051830,NL24186237,NL24192692,NL24233482,NL24261450,NL24262564,NL24295332,NL24395416,NL24473890,NL27076669,NL27083420,NL27120091,NL27168968,NL30037466,NL30058019,NL30077528,NL30089954,NL30113646,NL33001320,NL33006580,NL33011433,NL33104467,NL33121350,NL33145851,NL33201106,NL33202517,NL33216172,NL33230134,NL33231073,NL33261158,NL33267240,NL33286441,NL34224566,NL34241787,NL34261128,NL35000363,NL50338269,NL51470497,NL52387534,NL56821166,NL61036137,NL61411809,NL63329743,US*S00181566,US000980301,US010355758,US010393663,US010393723,US010404322,US010425066,US010526993,US010562944,US010573945,US010592299,US010609375,US010612052,US010616867,US010666114,US010724376,US010731997,US010789977,US010801232,US010893376,US010894487,US010949984,US010959140,US010969655,US020181050,US020377419,US020381573,US020405716,US020433924,US020513618,US020556934,US020563302,US020563870,US020565834,US020592619,US020636095,US020642224,US020681276,US020698101,US020732285,US020781046,US020815199,US025075361,US026201259,US030338873,US030339228,US030366218,US030422069,US030448754,US030450326,US030460133,US030483872,US030491827,US030542659,US030552903,US030567133,US030573898,US041278810,US041866480,US041923360,US041961130,US042052042,US042103460,US042147929,US042207613,US042209186,US042240991,US042260388,US042271897,US042272148,US042277512,US042295040,US042302115,US042314970,US042348234,US042372210,US042441294,US042453033,US042454372,US042458042,US042473675,US042564110,US042594045,US042619298,US042623104,US042648081,US042652826,US042664794,US042680009,US042693383,US042695240,US042713778,US042718215,US042723701,US042726691,US042729386,US042735766,US042739697,US042741391,US042742593,US042742817,US042743260,US042746201,US042776269,US042787865,US042795294,US042795439,US042797789,US042825458,US042832409,US042833935,US042837126,US042837575,US042866152,US042882273,US042893483,US042896127,US042902449,US042911026,US042916536,US042921333,US042949533,US042959321,US042977748,US042985631,US042997780,US043007151,US043039129,US043040660,US043053198,US043072298,US043072771,US043081657,US043099750,US043106389,US043110160,US043125110,US043145961,US043153858,US043158289,US043186647,US043197974,US043205099,US043210530'
;

/* ================================================
	2. Set application constants
   ================================================ */
DECLARE @SOLUTION nvarchar(255) = 'GovernanceBox'
		, @PROJECTID int = 007
		, @PROJECTKEY nvarchar(100) = CONCAT(@Application, 'FocusReports')
		, @API nvarchar(512) = 'GeneratePeerGroupData'
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
	SELECT @PlatformServer = 'NLAGPDATACORE', @PlatformCatalog = 'GovernanceBoxPipeline'
			, @ProjectServer = 'NLAGPDATACORE', @ProjectCatalog = CONCAT(@DBKEY, 'Data')
			, @WebDbServer = 'NLAGPDATACORE', @WebDbCatalog = CONCAT(@DBKEY, 'Web')
END
ELSE IF @Application NOT IN ('Development', 'GovernanceBox', 'Production')
BEGIN
	SET @logmessage = CONVERT(nvarchar, GETDATE(), 121) + ' No valid environment specified; environment should be in {GovernanceBox, Development, Production}'
	RAISERROR (@logmessage, 0, 1) WITH NOWAIT
	
	RETURN
END


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
        {
            "PackageName": "AddGroupStatistics",
			"ProjectType": "PdfReport",
            "CreateStatsParams":
            {
                "DestDbName": "$(WebDbCatalog)",
                "PublishDataSource": "$(WebDbServer)",
                "PublishCatalog": "$(WebDbCatalog)",
                "TrendStartYear": $(CalculateTrendFromYear),
                "TrendEndYear": $(CalculateTrendToYear),
                "StableTrendThreshold": 3.0,
                "Debug": $(Debug),
                "CompanyIdList": "$(CompanyBvdIdList)",
                "GroupName": "$(GroupName)"
            }
        }
    ]
}' 
SET @json_config = REPLACE(@json_config, '$(Api)',  @API)
SET @json_config = REPLACE(@json_config, '$(User)',  CONCAT( REPLACE(SYSTEM_USER, 'NL\', ''), '@deloitte.nl' ) )

SET @json_config = REPLACE(@json_config, '$(Debug)',  CASE WHEN @debug = 1 THEN 'true' ELSE 'false' END)
SET @json_config = REPLACE(@json_config, '$(WebDbServer)',  @WebDbServer)
SET @json_config = REPLACE(@json_config, '$(WebDbCatalog)',  @WebDbCatalog)


SET @json_config = REPLACE(@json_config, '$(CompanyBvdIdList)',  @CompanyBvdIdList)
SET @json_config = REPLACE(@json_config, '$(GroupName)',  @GroupName)
SET @json_config = REPLACE(@json_config, '$(CalculateTrendFromYear)',  @CalculateTrendFromYear)
SET @json_config = REPLACE(@json_config, '$(CalculateTrendToYear)',  @CalculateTrendToYear)

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
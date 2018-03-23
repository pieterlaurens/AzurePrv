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
DECLARE @Folder nvarchar(4000) = '\\\\nl\\data\\DataCore\\DataStore\\strategic\\source\\candidate matches\\Patstat vs BvD Matching Software\\Patstat 2014a vs BvD matching software v39\\output\\NoCtryAddress'
		, @Filename nvarchar(4000) = '0_Results_r39.txt'
		, @DestinationSchema sysname = 'input'
		, @DestinationTable sysname = 'pipeline_testtable'

/* ================================================
	2. Set application constants
   ================================================ */
DECLARE @Application sysname = 'IDR'				-- {IDR}
		, @Environment sysname = 'Development'		-- {Development, Production}

DECLARE @SOLUTION nvarchar(255) = 'IDR'
		, @PROJECTID int = 007
		, @PROJECTKEY nvarchar(100) = 'Input'
		, @API nvarchar(512) = 'ImportMatchingSoftwareFiles';


/* ================================================
	3. Set environment specification
   ================================================ */
DECLARE @PlatformServer sysname, @ProjectServer sysname
		, @PlatformCatalog sysname, @ProjectCatalog sysname

IF @Environment = 'Development'
BEGIN
	SELECT @PlatformServer = 'NLAMS00859', @PlatformCatalog = 'prv_dev_inh'
			, @ProjectServer = 'NLAMS10823', @ProjectCatalog = 'ID_Resolving_input'
END
ELSE IF @Environment = 'Production'
BEGIN
	SELECT @PlatformServer = 'NLAGPDATACORE', @PlatformCatalog = 'prv_dev_inh'
			, @ProjectServer = 'NLAMS10823', @ProjectCatalog = 'ID_Resolving_input'
END
ELSE IF @Environment NOT IN ('Development', 'Production')
BEGIN
	SET @logmessage = CONVERT(nvarchar, GETDATE(), 121) + ' No valid environment specified; environment should be in {GovernanceBox, Development, Production}'
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
        {   "PackageName": "importMatchingSoftwareFile",
            "ProjectType": "IdResolving",
            "ImportMatchingSoftwareFileParams":
            [
                {
                    "Folder": "$(Folder)",
                    "Filename": "$(Filename)",
                    "DestinationSchema": "$(DestinationSchema)",
                    "DestinationTable": "$(DestinationTable)"
                }
            ]
        }
    ]
}' 
SET @json_config = REPLACE(@json_config, '$(Api)',  @API)
SET @json_config = REPLACE(@json_config, '$(User)',  CONCAT( REPLACE(SYSTEM_USER, 'NL\', ''), '@deloitte.nl' ) )
SET @json_config = REPLACE(@json_config, '$(ProjectServer)',  @ProjectServer)
SET @json_config = REPLACE(@json_config, '$(ProjectCatalog)',  @ProjectCatalog)

SET @json_config = REPLACE(@json_config, '$(Folder)',  @Folder)
SET @json_config = REPLACE(@json_config, '$(Filename)',  @Filename)
SET @json_config = REPLACE(@json_config, '$(DestinationSchema)',  @DestinationSchema)
SET @json_config = REPLACE(@json_config, '$(DestinationTable)',   @DestinationTable)

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



CREATE PROCEDURE [ivh].[run_createNewRun] 
/* Generic parameters */	
	@projectid as int = 0
	, @projectkey as nvarchar(100) = N''
	, @solution as nvarchar(255) = N'topicmodeler'
	, @api as nvarchar(255) = N'main'
	, @runid as int = 0
	, @json_sla nvarchar(max) = N''
	, @json_config nvarchar(max) = N''
	, @caller_type nvarchar(50) = N'SsisApiRunId'
	, @caller_id nvarchar(50) = N'-1'
	, @debug as tinyint = 0

AS
BEGIN
	DECLARE @api_exists bit = 0
	DECLARE @entrypoint nvarchar(255), @server sysname, @passthrough nvarchar(512), @type nvarchar(50), @run_as sysname, @runtime_mode nchar(6), @wait_for_completion bit
	DECLARE @jobname sysname, @jobstatus smallint
	DECLARE @query nvarchar(2000), @parameters nvarchar(255)
	DECLARE @current_identity int
	DECLARE @logmessage nvarchar(255)
			, @object_name nvarchar(255) = CONCAT(OBJECT_SCHEMA_NAME(@@PROCID), '.', OBJECT_NAME(@@PROCID))

	SET NOCOUNT ON

validate_input:
	
	SELECT @api_exists = [ivh].[checkApi](@solution, @api, 1)
	IF ( @api_exists = 1)
	BEGIN
		SET @logmessage = CONCAT('Creating new run for api ', @api)
		EXEC nlh.log_addEntry @component='InvocationHandler',@source_type='SP',@source_name=@object_name, @source_id = NULL, @action='START', @status='SUCCESS'
									, @message=@logmessage, @added_on = NULL, @added_by = NULL
	END
	ELSE IF ( @api_exists <> 1)
	BEGIN
		SET @logmessage = CONCAT('Failed to create run for api ', @api, '. Api not found or not public') -- Removed semi-colon from message; PL 5/5/17
		EXEC nlh.log_addEntry @component='InvocationHandler',@source_type='SP',@source_name=@object_name, @source_id = NULL, @action='START', @status='FAILURE'
									, @message=@logmessage, @added_on = NULL, @added_by = NULL

		RETURN
	END

insert_run_parameters:

-- If new run, than insert run parameters
-- otherwise, use already existing parameters
	SELECT @current_identity = IDENT_CURRENT('ivh.run')
	IF NOT EXISTS ( SELECT 1 FROM [ivh].[run] WHERE [id] = @runid )
	BEGIN
		-- create new run

		IF ( @runid <= 0 )
		BEGIN
			-- no runid specified; insert new run with generated identity
			INSERT INTO ivh.run ([api], [status], [caller_type], [caller_id])
			VALUES (@api, 'Pending', @caller_type, @caller_id)
			SET @runid = IDENT_CURRENT('ivh.run')
		END
		ELSE
		BEGIN
			-- runid specified; insert new run with specified identity

			SET IDENTITY_INSERT [ivh].[run] ON
			INSERT INTO ivh.run ([id], [api], [status], [caller_type], [caller_id]) 
			VALUES (@runid, @api, 'Pending', @caller_type, @caller_id)
			SET IDENTITY_INSERT [ivh].[run] OFF
		END

		INSERT INTO ivh.run_paramvalue (run_id, parameter, value) VALUES (@runid, 'solution', @solution)
		INSERT INTO ivh.run_paramvalue (run_id, parameter, value) VALUES (@runid, 'projectid', @projectid)
		INSERT INTO ivh.run_paramvalue (run_id, parameter, value) VALUES (@runid, 'projectkey', @projectkey)
		INSERT INTO ivh.run_paramvalue (run_id, parameter, value) VALUES (@runid, 'api', @api)
		INSERT INTO ivh.run_paramvalue (run_id, parameter, value) VALUES (@runid, 'api_sla', @json_sla)
		INSERT INTO ivh.run_paramvalue (run_id, parameter, value) VALUES (@runid, 'api_config', @json_config)
	END
	ELSE
	BEGIN
		-- rerun existing run
		UPDATE [ivh].[run] SET [status] = 'Pending' WHERE [id] = @runid
	END


select_job_attributes:

	SELECT TOP 1 @entrypoint = T1.[entry_point]
					, @server = T1.[server]
					, @passthrough=T1.[parameters]
					, @type = T1.[type]
					, @run_as = T1.run_as
					, @runtime_mode = T1.runtime_mode
					, @wait_for_completion = T1.wait_for_completion
	from ivh.api T1 
	where T1.[solution] = @solution and T1.[api] = @api and T1.[public] = 1

clean_job_parameters:
	IF LEN(@json_sla) > 3750
	BEGIN
		SET @json_sla = '{parameter too long for direct passthrough. Please read from [ivh].[run_paramvalue], parameter ''api_sla''}' -- Removed semi-colon from message; PL 5/5/17
	END

	IF LEN(@json_config) > 3750
	BEGIN
		SET @json_config = '{parameter too long for direct passthrough. Please read from [ivh].[run_paramvalue], parameter ''api_config''}' -- Removed semi-colon from message; PL 5/5/17
	END

check_already_running:

	IF LEN(@entrypoint) > 0 AND @type = 'job'

	BEGIN
		SET @parameters = N'@jobname_in varchar(255), @jobstatus_out smallint OUTPUT';
		SET @query = 'SELECT @jobstatus_out = COUNT(1)
		FROM msdb.dbo.sysjobactivity ja
		INNER JOIN msdb.dbo.sysjobs j ON ja.job_id = j.job_id
		LEFT JOIN msdb.dbo.sysjobsteps js ON js.job_id = ja.job_id AND ja.last_executed_step_id = js.step_id
		WHERE [name] = @jobname_in
		AND start_execution_date IS NOT NULL 
		AND stop_execution_date IS NULL'

		IF @debug = 1 PRINT @query
		EXEC sp_executesql @query, @parameters, @jobname_in=@entrypoint, @jobstatus_out=@jobstatus OUTPUT;

		WHILE @jobstatus > 0
		BEGIN
			WAITFOR DELAY '00:00:10'
			EXEC sp_executesql @query, @parameters, @jobname_in=@entrypoint, @jobstatus_out=@jobstatus OUTPUT;
		END

		EXEC msdb.dbo.sp_start_job @entrypoint ;
	END


create_new_job:

	IF LEN(@entrypoint) > 0 AND @type IN ('project', 'package')
	BEGIN
		SET @parameters = N'@package nvarchar(255), @server nvarchar(100), @deployment_mode nvarchar(50), @jobname nvarchar(100), @runid int, @json_sla nvarchar(max), @json_config nvarchar(max), @proxy_name sysname, @runtime_mode nchar(6), @wait_for_completion bit, @debug bit';
		SET @query = 'EXEC ivh.run_executeSSISPackage @package, @server, @deployment_mode, @jobname, @runid, @json_sla, @json_config, @proxy_name, @runtime_mode, @wait_for_completion, @debug'
		SELECT @jobname = [ivh].[getJobName] ( @runid, '' )

		IF @debug = 1 PRINT @query
		EXEC sp_executesql @query, @parameters
							, @package=@entrypoint
							, @server=@server
							, @deployment_mode=@type
							, @jobname=@jobname
							, @runid=@runid
							, @json_sla=@json_sla
							, @json_config=@json_config
							, @proxy_name=@run_as
							, @runtime_mode=@runtime_mode
							, @wait_for_completion=@wait_for_completion
							, @debug=@debug;
	END

log_end:

		SET @logmessage = 'Created new run for api ' + @api
		EXEC nlh.log_addEntry @component='InvocationHandler',@source_type='SP',@source_name=@object_name, @source_id = NULL, @action='END', @status='SUCCESS'
									, @message=@logmessage, @added_on = NULL, @added_by = NULL
END
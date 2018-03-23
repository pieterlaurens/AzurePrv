CREATE PROCEDURE [ivh].[run_executeSSISPackage] ( 
	@package_fullpath nvarchar(255)
	, @server sysname ='localhost'
	, @deployment_mode nvarchar(50)='project'
	, @label sysname = ''
	, @runid int = -1
	, @json_sla nvarchar(max) = N''
	, @json_config nvarchar(max) = N''
	, @proxy_name sysname = NULL
	, @runtime_mode nchar(6) = '64-bit'
	, @wait_for_completion bit = 0
	, @debug bit = 0) 
AS
BEGIN
	 DECLARE @logmessage NVARCHAR(4000)
			, @object_name nvarchar(255) = CONCAT(OBJECT_SCHEMA_NAME(@@PROCID), '.', OBJECT_NAME(@@PROCID))
	DECLARE @package_exists BIT = 0, @proxy_exists BIT = 0
	DECLARE @debugmode varchar(5) = 'False'
	DECLARE @return_value INT = 0

	SET NOCOUNT ON

	IF @debug = 1 SET @debugmode = 'True'


validate_input:

		SELECT @package_exists = ivh.checkPackage(ISNULL(@package_fullpath, ''), @deployment_mode)
		SELECT @proxy_exists = ivh.checkProxy(-1, ISNULL(@proxy_name, ''))

		IF @package_exists = 1 AND (@proxy_exists = 1 OR LEN(ISNULL(@proxy_name, ''))=0)
		BEGIN
			SET @logmessage = 'Start SSIS package "' + @package_fullpath + '" on server "' + @server + '" for Run ID ' + CONVERT(nvarchar, @runid)
			EXEC nlh.log_addEntry @component='InvocationHandler',@source_type='SP',@source_name=@object_name, @source_id=NULL, @action='START', @status='SUCCESS'
										, @message=@logmessage, @added_on = NULL, @added_by = NULL
		END
		ELSE IF @package_exists <> 1
		BEGIN
			SET @logmessage = 'Failed to start SSIS package "' + @package_fullpath + '". Package not found.' -- Removed semi-colon from message; PL 5/5/17
			EXEC nlh.log_addEntry @component='InvocationHandler',@source_type='SP',@source_name=@object_name, @source_id=NULL, @action='START', @status='FAILURE'
										, @message=@logmessage, @added_on = NULL, @added_by = NULL

			RETURN
		END
		ELSE IF @proxy_exists <> 1 AND LEN(ISNULL(@proxy_name, ''))>0
		BEGIN
			SET @logmessage = 'Failed to start SSIS package "' + @package_fullpath + '". Proxy account specified not found.' -- Removed semi-colon from message; PL 5/5/17
			EXEC nlh.log_addEntry @component='InvocationHandler',@source_type='SP',@source_name=@object_name, @source_id=NULL, @action='START', @status='FAILURE'
										, @message=@logmessage, @added_on = NULL, @added_by = NULL

			RETURN
		END

		IF @wait_for_completion = 0
			SET @json_sla = REPLACE(REPLACE(REPLACE(@json_sla
													, '\"', '\"\"')				-- To handle JSON double quote escapes
													, '""', '""""')				-- To handle empty strings, seems to be related to SQL Server Agent use
													, '"', '""')				-- To escape double quotation marks on dtexec commandline, https://msdn.microsoft.com/en-us/library/ms162810.aspx

		IF LEN(@json_sla) > 4000
		BEGIN
			SET @logmessage = 'Failed to start SSIS package "' + @package_fullpath + '". Provided SLA too long (maximum 4000 characters).' -- Removed semi-colon from message; PL 5/5/17
			EXEC nlh.log_addEntry @component='InvocationHandler',@source_type='SP',@source_name=@object_name, @source_id=NULL, @action='START', @status='FAILURE'
										, @message=@logmessage, @added_on = NULL, @added_by = NULL

			RETURN
		END
		
		IF @wait_for_completion = 0
			SET @json_config = REPLACE(REPLACE(REPLACE(REPLACE(@json_config
														, '\"', '\"\"')				-- To handle JSON double quote escapes
														, '""', '""""')				-- To handle empty strings, seems to be related to SQL Server Agent invocation
														, '"', '""')				-- To escape double quotation marks on dtexec commandline, https://msdn.microsoft.com/en-us/library/ms162810.aspx
														, '; ', '"; "')				-- To handle semicolon follow by space ("; "-pattern), seems to be related to DTExec invocation

		IF LEN(@json_config) > 4000
		BEGIN
			SET @logmessage = 'Risky start of SSIS package "' + @package_fullpath + '". Provided package configuration too long (maximum 4000 characters).' -- Removed semi-colon from message; PL 5/5/17
			EXEC nlh.log_addEntry @component='InvocationHandler',@source_type='SP',@source_name=@object_name, @source_id=NULL, @action='START', @status='WARNING'
										, @message=@logmessage, @added_on = NULL, @added_by = NULL

			SET @json_config = '{parameter too long for direct passthrough. Please read from [ivh].[run_execvalue], parameter ''component_config''}' -- Removed semi-colon from message; PL 5/5/17
			--RETURN
		END
     
		--to prevent "Operand type clash: nvarchar(max) is incompatible with sql_variant" 
		DECLARE @json_config_4000 nvarchar(4000) = @json_config
		DECLARE @json_sla_4000 nvarchar(4000) = @json_sla

-- synchronous execution
IF @wait_for_completion = 1
BEGIN
execute_synchronously:

	DECLARE @execution_id AS INT = -1
	DECLARE @package_name AS SYSNAME = (SELECT [string] FROM utl.splitString(@package_fullpath, '\') WHERE seq = 5)
	DECLARE @project_name AS SYSNAME = (SELECT [string] FROM utl.splitString(@package_fullpath, '\') WHERE seq = 4)
	DECLARE @folder_name AS SYSNAME = (SELECT [string] FROM utl.splitString(@package_fullpath, '\') WHERE seq = 3)
	DECLARE @catalog_name AS SYSNAME = (SELECT [string] FROM utl.splitString(@package_fullpath, '\') WHERE seq = 2)
	DECLARE @use32bitruntime AS BIT = 0

	create_execution:

		IF @runtime_mode = '32-bit' SET @use32bitruntime = 1
		EXEC [SSISDB].[catalog].[create_execution] @package_name=@package_name, @execution_id=@execution_id OUTPUT, @folder_name=@folder_name, @project_name=@project_name, @use32bitruntime=@use32bitruntime, @reference_id=NULL

	set_parameters:

		-- Set system parameters
		-- For these parameters, set object_type to 50
		EXEC [SSISDB].[catalog].[set_execution_parameter_value] @execution_id,  @object_type=50, @parameter_name=N'LOGGING_LEVEL', @parameter_value=1
		EXEC [SSISDB].[catalog].[set_execution_parameter_value] @execution_id,  @object_type=50, @parameter_name=N'DUMP_ON_ERROR', @parameter_value=0
		EXEC [SSISDB].[catalog].[set_execution_parameter_value] @execution_id,  @object_type=50, @parameter_name=N'CALLER_INFO', @parameter_value=N'[ivh].[run_executeSSISPackage]'
		EXEC [SSISDB].[catalog].[set_execution_parameter_value] @execution_id,  @object_type=50, @parameter_name=N'SYNCHRONIZED', @parameter_value=@wait_for_completion

		-- Set project parameters
		-- For these parameters, set object_type to 20

		-- Set package parameters
		-- For these parameters, set object_type to 30
		EXEC [SSISDB].[catalog].[set_execution_parameter_value] @execution_id,  @object_type=30, @parameter_name=N'RUN_ID', @parameter_value=@runid
		EXEC [SSISDB].[catalog].[set_execution_parameter_value] @execution_id,  @object_type=30, @parameter_name=N'JSON_CONFIG', @parameter_value=@json_config_4000--Shouldn't it be @json_config? 20/2/2016, PL
		EXEC [SSISDB].[catalog].[set_execution_parameter_value] @execution_id,  @object_type=30, @parameter_name=N'JSON_SLA', @parameter_value=@json_sla_4000
		EXEC [SSISDB].[catalog].[set_execution_parameter_value] @execution_id,  @object_type=30, @parameter_name=N'IN_DEBUG_MODE', @parameter_value=@debugmode


	start_execution:

		SET @logmessage = 'Started executing SSIS package in synchronous mode: "' + @package_fullpath + '"'
					EXEC nlh.log_addEntry @component='InvocationHandler',@source_type='SP',@source_name=@object_name, @source_id=NULL, @action='EXECUTE', @status='SUCCESS'
									, @message=@logmessage, @added_on = NULL, @added_by = NULL

		EXEC [SSISDB].[catalog].[start_execution] @execution_id

		SET @logmessage = 'Ended executing SSIS package in synchronous mode: "' + @package_fullpath + '"'
					EXEC nlh.log_addEntry @component='InvocationHandler',@source_type='SP',@source_name=@object_name, @source_id=NULL, @action='EXECUTE', @status='SUCCESS'
									, @message=@logmessage, @added_on = NULL, @added_by = NULL


	determine_status:

		SELECT @return_value = 
					CASE [status] 
					WHEN 1 THEN  0 -- 'created' 
					WHEN 2 THEN  0 -- 'running'
					WHEN 3 THEN  0 -- 'canceled'
					WHEN 4 THEN -1 -- 'failed'
					WHEN 5 THEN  0 -- 'pending'
					WHEN 6 THEN -1 -- 'ended unexpectedly'
					WHEN 7 THEN  0 -- 'successful'
					WHEN 8 THEN  0 -- 'stopping'
					WHEN 9 THEN  0 -- 'completed'
					END 
		FROM [SSISDB].[catalog].[executions] e 
		WHERE e.execution_id = @execution_id

		RETURN @return_value

END

-- asynchrounous execution
ELSE IF @wait_for_completion = 0
BEGIN
execute_asynchronously_using_sqlserver_agent:

		DECLARE @jobid uniqueidentifier
				, @jobname nvarchar(255)
				, @command nvarchar(max)
				, @subsystem sysname = N'SSIS'

		compose_command:
					-- For more information about the dtexec commandline, 
					-- visit https://docs.microsoft.com/en-us/sql/integration-services/packages/dtexec-utility

					-- Configure package source
					IF @deployment_mode = 'package' 
					BEGIN
						SET @command= CONCAT(
										N'/FILE "\"', @package_fullpath, '\""')
					END
					ELSE IF @deployment_mode = 'project' 
					BEGIN
						SET @command= CONCAT(
										N'/ISSERVER "\"', @package_fullpath, '\""'
										, ' /SERVER "\"', @server,'\""') -- 2/3/2018, Added quotes around server names to allow dashed server names.
--										, ' /SERVER ', @server)
					END

					-- Configure 32/64-bit
					IF @runtime_mode = '32-bit' SET @command = CONCAT(@command, ' /X86')

					-- Configure miscellaneous
					SET @command = CONCAT(@command, N' /CALLERINFO SQLAGENT /REPORTING E')

					-- Configure parameters
					SET @command = CONCAT(@command
											, ' /SET \Package.Variables[$Package::RUN_ID];', CONVERT(nvarchar, @runid)

											-- Based on https://www.sqlservercentral.com/Forums/Topic851583-148-1.aspx
											-- escaping with "\" does NOT allow special characters
											-- while escaping with """ does
											-- Based on http://stackoverflow.com/questions/43524739/dtexec-how-to-use-a-semicolon-within-a-parameter-value-for-ssis-package
											-- double double quotes should be used; this only works when the string does contain special characters.
											-- Using double double quotes does not work for SLA, so applied to JSON_CONFIG only.
											
											/* In the current mode, without encoding/decoding the strings, passing the configuration is too 'dangerous'
											   and causes too many errors. In current operation modes, it is not critical to pass it here either, since
											   it's read by the package from the SQL table exec_paramvalue in the platform DB. Therefore, it's temporarily
											   commented out, until we have a proper solution for generating valid DTExec commands as well as passing 
											   the configurations correctly. */
											--, ' /SET \Package.Variables[$Package::JSON_CONFIG];""""""', REPLACE(@json_config_4000, '''', ''''''), '""""""'
											--, ' /SET \Package.Variables[$Package::JSON_SLA];"""', REPLACE(@json_sla_4000, '''', ''''''), '"""' -- Replced by PL, 2/3/2018 to enable server names with dashes.
											, ' /Par "\"JSON_SLA\"";"\"', REPLACE(REPLACE(@json_sla_4000, '''', ''''''),'"','\"'),'\""' -- PL 2/3/2018
											, ' /SET \Package.Variables[$Package::IN_DEBUG_MODE];', @debugmode
											, ' /Par "\"$ServerOption::LOGGING_LEVEL(Int16)\"";1'
											, ' /Par "\"$ServerOption::SYNCHRONIZED(Boolean)\"";True '
											)

					IF @label = '' SET @jobname = replace(reverse(left(reverse(@package_fullpath), charindex('\',reverse(@package_fullpath), 1) - 1)), '.dtsx', '') 
					ELSE SET @jobname = @label

					SET @logmessage = 'Starting SSIS package in asynchronous mode using command: "' + @command + '"'
					EXEC nlh.log_addEntry @component='InvocationHandler',@source_type='SP',@source_name=@object_name, @source_id=NULL, @action='EXECUTE', @status='SUCCESS'
									, @message=@logmessage, @added_on = NULL, @added_by = NULL

		delete_job_if_exists:
					SELECT @jobid = job_id FROM msdb.dbo.sysjobs_view WHERE (name = @jobname)
					IF (@jobid IS NOT NULL)
					BEGIN
						EXEC msdb.dbo.sp_delete_job @jobid
					END
					SET @jobid = NULL


		create_job:
					DECLARE @return_code int = 0

					EXEC @return_code = msdb.dbo.sp_add_job @job_name = @jobname, @enabled = 1, @category_name = '', @delete_level = 1, @job_id = @jobid OUTPUT
					IF @return_code <> 0
					BEGIN
						SET @logmessage = CONCAT( 'Failed to started SSIS package in asynchronous mode; could not add job, return code: ', @return_code )
						EXEC nlh.log_addEntry @component='InvocationHandler',@source_type='SP',@source_name=@object_name, @source_id=NULL, @action='EXECUTE', @status='FAILED'
										, @message=@logmessage, @added_on = NULL, @added_by = NULL
					END

					EXEC @return_code = msdb.dbo.sp_add_jobserver @job_id = @jobid, @server_name = '(local)'
					IF @return_code <> 0
					BEGIN
						SET @logmessage = CONCAT( 'Failed to started SSIS package in asynchronous mode; could not add job server, return code: ', @return_code )
						EXEC nlh.log_addEntry @component='InvocationHandler',@source_type='SP',@source_name=@object_name, @source_id=NULL, @action='EXECUTE', @status='FAILED'
										, @message=@logmessage, @added_on = NULL, @added_by = NULL
					END

					IF @proxy_exists = 1 EXEC @return_code = msdb.dbo.sp_add_jobstep @job_id = @jobid, @step_name = 'Execute DTS', @subsystem = @subsystem, @command = @command, @proxy_name = @proxy_name
					ELSE EXEC @return_code = msdb.dbo.sp_add_jobstep @job_id = @jobid, @step_name = 'Execute DTS', @subsystem = @subsystem, @command = @command
					IF @return_code <> 0
					BEGIN
						SET @logmessage = CONCAT( 'Failed to started SSIS package in asynchronous mode; could not add job step, return code: ', @return_code )
						EXEC nlh.log_addEntry @component='InvocationHandler',@source_type='SP',@source_name=@object_name, @source_id=NULL, @action='EXECUTE', @status='FAILED'
										, @message=@logmessage, @added_on = NULL, @added_by = NULL
					END

					EXEC @return_code = msdb.dbo.sp_start_job @job_id = @jobid
					IF @return_code <> 0
					BEGIN
						SET @logmessage = CONCAT( 'Failed to started SSIS package in asynchronous mode; could not start job, return code: ', @return_code )
						EXEC nlh.log_addEntry @component='InvocationHandler',@source_type='SP',@source_name=@object_name, @source_id=NULL, @action='EXECUTE', @status='FAILED'
										, @message=@logmessage, @added_on = NULL, @added_by = NULL
					END

					RETURN @return_value
		END
  END
CREATE PROCEDURE [score].[newScoreTable_runPackage](
		@server nvarchar(500) = NULL
		, @database nvarchar(500) = NULL
		, @fileroot nvarchar(500) = NULL
		, @filename nvarchar(500) = NULL
)
AS
BEGIN

	set @server = isnull(@server, @@SERVERNAME) 
	set @database = isnull(@database, DB_NAME())
	set @fileroot = isnull(@fileroot, '\\nl\data\DataCore\DataStore\Projects\SDIP Large cap\')
	set @filename = isnull(@filename, 'SDImapping_unverified_with_client.xlsx')


	--prepare SSIS parameters:
	declare @packageName nvarchar(500) = N'load_sdi_score_table.dtsx'
	declare @parameterString nvarchar(max) = concat(@server, '.', @database, ' ; ', @fileroot, @filename)

	DECLARE @message NVARCHAR(1000)
	DECLARE @curProc NVARCHAR(1023) = OBJECT_NAME(@@PROCID)
	
	EXEC report.postLogEntry @component = @curProc, @action = 1, @status = 1, @message = @parameterString

	BEGIN TRY

		--Go to SSIS execution:

		-- Create the execution object
		DECLARE @execution_id BIGINT
		EXEC [SSISDB].[catalog].[create_execution] 
			@package_name = @packageName
			, @project_name = N'dataloader'
			, @folder_name = N'bacmap'
			, @use32bitruntime = False
			, @reference_id = NULL
			, @execution_id = @execution_id OUTPUT

		-- System parameters
		EXEC [SSISDB].[catalog].[set_execution_parameter_value] 
			@execution_id
			, @object_type = 50	-- System parameter
			, @parameter_name = N'SYNCHRONIZED'
			, @parameter_value = 1

		-- set the project parameters:
		EXEC [SSISDB].[catalog].[set_execution_parameter_value] 
		@execution_id
		, @object_type = 20	-- project parameter
		, @parameter_name = 'server'
		, @parameter_value =  @server

		EXEC [SSISDB].[catalog].[set_execution_parameter_value] 
		@execution_id
		, @object_type = 20	-- project parameter
		, @parameter_name = 'database'
		, @parameter_value =  @database

		EXEC [SSISDB].[catalog].[set_execution_parameter_value] 
		@execution_id
		, @object_type = 20	-- project parameter
		, @parameter_name = 'fileroot'
		, @parameter_value =  @fileroot
		
		EXEC [SSISDB].[catalog].[set_execution_parameter_value] 
		@execution_id
		, @object_type = 20	-- project parameter
		, @parameter_name = 'filename'
		, @parameter_value =  @filename


		-- Execute the package
		EXEC [SSISDB].[catalog].[start_execution] @execution_id

		-- Check package status, and fail script if the package failed
		IF 7 <> (SELECT [status] FROM [SSISDB].[catalog].[executions] WHERE execution_id = @execution_id)
		RAISERROR('The package failed. Check the SSIS catalog logs for more information', 16, 1)

		EXEC report.postLogEntry @component = @curProc, @message = 'Executed succesfully', @action = -1, @status = 1

	END TRY
	--if fail:
	BEGIN CATCH

		DECLARE @ErrorMessage NVARCHAR(4000);
		SELECT @ErrorMessage = ERROR_MESSAGE()

		EXEC report.postLogEntry @component = @curProc, @action = 0, @status = -1, @message = @ErrorMessage;
		THROW

	END CATCH

END

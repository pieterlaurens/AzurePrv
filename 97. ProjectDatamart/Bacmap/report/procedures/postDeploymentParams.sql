CREATE PROCEDURE report.postDeploymentParams 
AS
BEGIN
	DECLARE @curProc NVARCHAR(1023) = OBJECT_NAME(@@PROCID)
	EXEC report.postLogEntry @component = @curProc, @action = 1, @status = 1

	BEGIN TRY

		TRUNCATE TABLE report.[deployment_parameters]


		INSERT INTO report.[deployment_parameters] (parameter, parameter_value)
																values	('DataHandler',			'$(DataHandlerDb)')
																		, ('Bloomberg',		'$(bb_db)')																values	('idr_db',			'$(idr_db)')
																		/*('idr_db',			'$(idr_db)')
																		, ('pwc_db',		'$(pwc_db)')	
																		, ('topic_db',		'$(topic_db)')
																		, ('topic_server',	'$(topic_server)')
																		, ('useScoreCutOff','$(useScoreCutOff)')	
																		, ('workspaceId',	'$(workspaceId)')*/


		EXEC report.postLogEntry @component = @curProc, @action = -1, @status = 1, @rowcount = @@ROWCOUNT

	END TRY
	--if fail:
	BEGIN CATCH

		DECLARE @ErrorMessage NVARCHAR(4000);
		SELECT @ErrorMessage = ERROR_MESSAGE()

		EXEC report.postLogEntry @component = @curProc, @action = 0, @status = -1, @message = @ErrorMessage;
		THROW

	END CATCH
END
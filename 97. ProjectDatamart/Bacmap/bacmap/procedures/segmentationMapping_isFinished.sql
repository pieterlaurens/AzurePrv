CREATE PROCEDURE [bacmap].[segmentationMapping_isFinished]
(
	@debug BIT  = 0
	, @bvd_id VARCHAR(25)
	, @period_id VARCHAR(32)
	, @is_finished BIT
	, @user NVARCHAR(500) = NULL
)
AS
BEGIN
	DECLARE @message NVARCHAR(max) = ''
	DECLARE @curProc NVARCHAR(1023) = OBJECT_NAME(@@PROCID)

	set @message = 'bvd_id = ' + @bvd_id + ' ; period_id = ' + @period_id + ' ; is_finished = ' + cast(@is_finished as nvarchar(1))
		EXEC report.postLogEntry @component = @curProc, @action = 1, @status = 1, @message = @message

	IF LEN(@user) = 0 OR @user IS null SET @user = SYSTEM_USER

	BEGIN TRY
		
		DECLARE @entity_id VARCHAR(32)
			SELECT @entity_id = bacmap.getEntityIdFromBvd(@bvd_id)

		IF @entity_id IS NULL
			RAISERROR('ENTITY_ID cannot be null', 11,1)
			
		--add new status:
		INSERT INTO [bacmap].[custom_mapping_entity_status] (
									[entity_id]
									, [period_id]
									, [is_finished]
									, [modified_by]
									, [is_active]
				)
			VALUES (@entity_id, @period_id, @is_finished, @user, 1)

		--set old status to inactive:
		declare @newId INT = @@IDENTITY

		UPDATE [bacmap].[custom_mapping_entity_status]
			SET [is_active] = 0
				WHERE 
					id <> @newId
				and
					entity_id = @entity_id
				and
					period_id = @period_id


		EXEC report.postLogEntry @component = @curProc, @action = -1,
									@message = @message, @status = 1, @rowcount = @@ROWCOUNT


	END TRY
	--if fail:
	BEGIN CATCH

		DECLARE @ErrorMessage NVARCHAR(4000);
		SELECT @ErrorMessage = ERROR_MESSAGE()

		EXEC report.postLogEntry @component = @curProc, @action = 0, @status = -1, @message = @ErrorMessage;
		THROW

	END CATCH
END
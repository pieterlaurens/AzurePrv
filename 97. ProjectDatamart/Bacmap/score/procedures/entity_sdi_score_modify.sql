CREATE PROCEDURE [score].[entity_sdi_score_modify]
(
	@debug BIT  = 0
	, @bvd_id NVARCHAR(25)
	, @period_id VARCHAR(32) = NULL
	, @score real
	, @comment NVARCHAR(max) = NULL
	, @user NVARCHAR(50) = NULL
)
AS
BEGIN
	DECLARE @message NVARCHAR(max) = ''
	DECLARE @curProc NVARCHAR(1023) = OBJECT_NAME(@@PROCID)
	EXEC report.postLogEntry @component = @curProc, @action = 1, @status = 1

	IF LEN(@user) = 0 OR @user IS null SET @user = SYSTEM_USER

	BEGIN TRY
		DECLARE @entity_id NVARCHAR(250)
			SELECT @entity_id = [bacmap].getEntityIdFromBvd(@bvd_id)

		IF @entity_id is NULL RAISERROR('invalid bvd_id', 16,1)

		IF @period_id is NULL
		BEGIN
			SELECT TOP(1) @period_id = period_id FROM [bacmap].[period] 
													WHERE period_type='Y' ORDER BY period_year DESC
		END
				
		--01. First check if the line item -period already exists and set action_type
		UPDATE [score].entity_sdi_score
			set 
				is_active = 0
			where
				[entity_id] = @entity_id
			and
				[period_id] = @period_id
		--02. First check if the line item -period already exists and set action_type

		Insert into [score].entity_sdi_score
			([entity_id], [period_id], [score], [comment], [is_active], [modified_by])
		Values (
				@entity_id
				, @period_id
				, @score
				, @comment
				, 1
				, @user
			)
				
		EXEC report.postLogEntry @component = @curProc, @action = -1,
									@message = @message, @status = 1, @rowcount = @@ROWCOUNT

		IF @debug = 1 
		begin
			SELECT top(1) * FROM report.mapping_action order by id desc
			SELECT top(1) * FROM [bacmap].[line_item_custom_mapping] order by id desc
		end

	END TRY
	--if fail:
	BEGIN CATCH

		DECLARE @ErrorMessage NVARCHAR(4000);
		SELECT @ErrorMessage = ERROR_MESSAGE()

		EXEC report.postLogEntry @component = @curProc, @action = 0, @status = -1, @message = @ErrorMessage;
		THROW

	END CATCH
END
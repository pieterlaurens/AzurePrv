CREATE PROCEDURE [bacmap].[lineItemMapping_delete]
(
	@debug BIT  = 0
	, @line_item_id VARCHAR(32)
	, @custom_mapping_id VARCHAR(32)
	, @period_id VARCHAR(32)
	, @mapping_action_description NVARCHAR(max) = ''
	, @user NVARCHAR(50) = NULL
)
AS
BEGIN
	DECLARE @message NVARCHAR(1023) = ''
	DECLARE @curProc NVARCHAR(1023) = OBJECT_NAME(@@PROCID)
	EXEC report.postLogEntry @component = @curProc, @action = 1, @status = 1

	IF LEN(@user) = 0 OR @user is null SET @user = SYSTEM_USER

	BEGIN TRY
			
		set @message = 'Deleting custom mapping (line_item, period, mapping):' + 
							@line_item_id + ';' + @period_id + ';' + @custom_mapping_id
		
			
		DECLARE @action_type TINYINT = (select action_type_id from report.mapping_action_type where label = 'delete')

		--01. retrieve the line item to custom mapping record en return error if record does not exist:
		
			DECLARE @mapping_id INT
				set @mapping_id = (select id 
									from 
										[bacmap].line_item_custom_mapping
									where 
										line_item_id = @line_item_id
									and
										period_id = @period_id
									and
										custom_mapping_id = @custom_mapping_id
								)

				IF @mapping_id IS NULL
					RAISERROR('Cannot delete non-existent mapping', 16, 1)

		--02. add a record to the mapping_action log:

			IF LEN(@mapping_action_description) = 0 OR @mapping_action_description IS null 
				set @mapping_action_description = @message

			insert into report.mapping_action(
												[executed_by]
												, [action_type_id]
												, [line_item_custom_mapping_id]
												, [row_count]
												, [description]
												)
					select @user
							, @action_type
							, @mapping_id 
							, 1 as row_count
							, @mapping_action_description


		--03. write the change to the line_item_mapping table:

			declare @latest_mapping_action_id INT = @@IDENTITY

			UPDATE [bacmap].line_item_custom_mapping
				SET 
						latest_mapping_action_id = @latest_mapping_action_id
						, is_active = 0
					where 
						line_item_id = @line_item_id
					and
						period_id = @period_id
					and
						custom_mapping_id = @custom_mapping_id

 
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
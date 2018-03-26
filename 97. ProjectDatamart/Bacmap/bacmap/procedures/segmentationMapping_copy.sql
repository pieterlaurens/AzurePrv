CREATE PROCEDURE [bacmap].[segmentationMapping_copy]
(
	@debug BIT  = 0
	, @bvd_id VARCHAR(25)
	, @source_period_id VARCHAR(32)
	, @target_period_id VARCHAR(32)
	, @mapping_action_description NVARCHAR(max) = NULL
	, @user NVARCHAR(50) = NULL
)
AS
BEGIN
	DECLARE @message NVARCHAR(max) = ''
	DECLARE @curProc NVARCHAR(1023) = OBJECT_NAME(@@PROCID)
	EXEC report.postLogEntry @component = @curProc, @action = 1, @status = 1

	IF LEN(@user) = 0 OR @user IS null SET @user = SYSTEM_USER

	BEGIN TRY
				
		--01. First check if the line item -period already exists and set action_type
			
			DECLARE @action_type TINYINT = (select action_type_id from report.mapping_action_type where label = 'copy')
			
			DECLARE @mapping_id INT
			DECLARE @number_of_mapping_rows INT
			/* The active data, for the given source period and entity (to be copied) */
			DECLARE @source_data Table (line_item_id varchar(32), custom_mapping_id varchar(32), revenue_fraction real , comment nvarchar(max), comment_product nvarchar(max))
			
			; WITH mapping AS (
				select
					* 
				from 
					[bacmap].line_item_custom_mapping 
				where 
					period_id=@source_period_id 
				and 
					is_active = 1
			)
			INSERT INTO @source_data(line_item_id,custom_mapping_id,revenue_fraction,comment,comment_product)
				SELECT
					s.line_item_id
					, lim.custom_mapping_id
					, lim.revenue_fraction
					, lim.comment
					, lim.comment_product
				FROM
					[bacmap].getEntitySegmentation(@bvd_id,@target_period_id) s -- It should be the segmentation in the target period; otherwise there would be invalid mappings.
				JOIN
					mapping lim ON lim.line_item_id=s.line_item_id
			SET @number_of_mapping_rows = (SELECT COUNT(*) from @source_data)

			/* Any currently active data for the given target period and entity (to be overwritten) */
			DECLARE @old_data Table (id int)
			insert into @old_data
				select
					id
				from 
					[bacmap].line_item_custom_mapping
				where 
					period_id = @target_period_id
					and
					line_item_id IN (select line_item_id from @source_data)

			IF exists(select * from @old_data where id is not null)
				begin
					UPDATE [bacmap].line_item_custom_mapping SET is_active=0 WHERE id IN (select id from @old_data)
					SET @message = CONCAT('Set ' ,@@ROWCOUNT,' rows of current data for target mapping to inactive.')
					EXEC report.postLogEntry @component = @curProc, @action = 0, @status = 1, @message=@message
				end

			set @message = CONCAT('Copying custom mapping for ', @bvd_id, ' in period ',@source_period_id,' to ',@target_period_id)

		--02. add a record to the mapping_action log:

			insert into report.mapping_action(
												[executed_by]
												, [action_type_id]
												, [line_item_custom_mapping_id]
												, [row_count]
												, [description]
												)
					select @user
							, @action_type
							, NULL --because multiple lines
							, @number_of_mapping_rows  as row_count
							, @message


		--03. write the change to the line_item_mapping table:

			declare @latest_mapping_action_id INT = @@IDENTITY

			; WITH newRecord AS (
					select line_item_id
							, @target_period_id as period_id
							, custom_mapping_id
							, revenue_fraction	
							, comment
							, comment_product	
							, @latest_mapping_action_id AS latest_mapping_action_id
							, 1							AS is_active
						FROM
							@source_data
			)

			MERGE 
				[bacmap].[line_item_custom_mapping] AS Target
			USING 
				newRecord AS Source
			ON 
				(Target.line_item_id = Source.line_item_id 
					AND 
						Target.period_id = Source.period_id
					AND 
						Target.custom_mapping_id = Source.custom_mapping_id)

			WHEN MATCHED THEN
				UPDATE SET Target.revenue_fraction =				Source.revenue_fraction
								, Target.comment =					Source.comment 
								, Target.comment_product =			Source.comment_product
								, Target.latest_mapping_action_id =	Source.latest_mapping_action_id
								, Target.is_active =				Source.is_active

			WHEN NOT MATCHED BY TARGET THEN
				INSERT ([line_item_id],[period_id],[custom_mapping_id],
							[revenue_fraction],[comment], [comment_product], [latest_mapping_action_id],[is_active])
					VALUES(
							Source.[line_item_id]
							, Source.[period_id]
							, Source.[custom_mapping_id]
							, Source.[revenue_fraction]
							, Source.[comment]
							, Source.[comment_product]
							, Source.[latest_mapping_action_id]
							, Source.[is_active]
						);


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
CREATE PROCEDURE [bacmap].[lineItemMapping_modify]
(
	@debug BIT  = 0
	, @line_item_id VARCHAR(32)
	, @custom_mapping_id VARCHAR(32)
	, @period_id VARCHAR(32)
	, @revenue_fraction REAL = NULL
	, @certainty real = NULL
	, @mapping_action_description NVARCHAR(max) = NULL
	, @mapping_comment NVARCHAR(max) = Null
	, @mapping_comment_product NVARCHAR(max) = Null
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
			
			DECLARE @action_type TINYINT = (select action_type_id from report.mapping_action_type where label = 'modify')
			
			DECLARE @mapping_id INT
			DECLARE @old_data Table (id int, revenue_fraction real , comment nvarchar(max), comment_product nvarchar(max), certainty real)

			insert into @old_data
				select id, revenue_fraction, comment, comment_product, certainty
								from 
									[bacmap].line_item_custom_mapping
								where 
									line_item_id = @line_item_id
								and
									period_id = @period_id
								and
									custom_mapping_id = @custom_mapping_id

			IF not exists(select * from @old_data where id is not null)
				begin
					--initiate the input:
					set @action_type = (select action_type_id from report.mapping_action_type where label = 'add')
					set @revenue_fraction = isnull(@revenue_fraction, 0)
					set @mapping_comment = isnull(@mapping_comment, '')
					set @mapping_comment_product = isnull(@mapping_comment_product , '')
					set @certainty = isnull(@certainty, 0)
				end
			else
				begin
					--if the line item exists, but some fields are set null, take the old values:
					set @mapping_id =					(select id from @old_data)
					set @revenue_fraction =				(select isnull(@revenue_fraction,revenue_fraction) from @old_data)
					set @mapping_comment =				(select isnull(@mapping_comment,comment) from @old_data)
					set @mapping_comment_product =		(select isnull(@mapping_comment_product,comment_product) from @old_data)
					set @certainty =					(select isnull(@certainty, certainty) from @old_data)
				end

			set @message = 'Updating custom mapping (line_item; period; mapping; revenue_fraction; comment; comment_product):' + 
							@line_item_id + ';' + @period_id + ';' + @custom_mapping_id +
							cast(@revenue_fraction as nvarchar(25)) + ';' + @mapping_comment + ';' + @mapping_comment_product

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
							, @mapping_id --could be null if new item added
							, 1 as row_count
							, @mapping_action_description


		--03. write the change to the line_item_mapping table:

			declare @latest_mapping_action_id INT = @@IDENTITY

			; WITH newRecord AS (
					select @line_item_id				AS line_item_id
							, @period_id				AS period_id
							, @custom_mapping_id		AS custom_mapping_id
							, @revenue_fraction			AS revenue_fraction
							, @certainty				AS certainty	
							, @mapping_comment			AS comment
							, @mapping_comment_product	AS comment_product	
							, @latest_mapping_action_id AS latest_mapping_action_id
							, 1							AS is_active
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
								, Target.certainty =				Source.certainty
								, Target.comment_product =			Source.comment_product
								, Target.latest_mapping_action_id =	Source.latest_mapping_action_id
								, Target.is_active =				Source.is_active

			WHEN NOT MATCHED BY TARGET THEN
				INSERT ([line_item_id],[period_id],[custom_mapping_id],
							[revenue_fraction], [certainty], [comment], [comment_product], [latest_mapping_action_id],[is_active])
					VALUES(
							Source.[line_item_id]
							, Source.[period_id]
							, Source.[custom_mapping_id]
							, Source.[revenue_fraction]
							, Source.[certainty]
							, Source.[comment]
							, Source.[comment_product]
							, Source.[latest_mapping_action_id]
							, Source.[is_active]
						);


		--04. update the mapping action log with the latest mapping id, if the action is 'add'

			declare @latest_mapping_id INT = @@IDENTITY

			IF @mapping_id IS NULL
				UPDATE report.mapping_action
					set 
						line_item_custom_mapping_id = @latest_mapping_id
					where 
						id = @latest_mapping_action_id

 
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
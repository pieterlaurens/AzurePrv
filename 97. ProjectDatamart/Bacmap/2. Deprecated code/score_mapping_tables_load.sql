CREATE PROCEDURE [score].[score_mapping_tables_load]
(
	@sdi_scores AS [score].[score_table] READONLY
	, @user NVARCHAR(100) = NULL
	, @date DATETIME = NULL
	, @debug BIT  = 0
)
AS
BEGIN
	DECLARE @message NVARCHAR(1023) = 'loading new SDI score mapping'
	DECLARE @curProc NVARCHAR(1023) = OBJECT_NAME(@@PROCID)
	EXEC report.postLogEntry @component = @curProc, @action = 1, @status = 1

	BEGIN TRY
		--alter table [bacmap].[line_item_custom_mapping]
		--	drop constraint  custom_mapping_id_fk

		IF @user IS NULL SET @user = system_user
		IF @date IS NULL SET @date = getdate()

		; WITH newRecords AS (
					select	convert(varchar(32), hashbytes('md5', [custom_mapping_value]), 2)
														AS [custom_mapping_id]
							, [custom_mapping_value]
							, [custom_mapping_label]
							, [custom_mapping_display_order]
							, [custom_mapping_score]
							, [custom_mapping_relevancy]
							, [comment]
							, @user						AS modified_by
							, @date						AS modified_on
							, 1							AS is_active
					from 
						@sdi_scores
			)
			--select * from newRecords

			MERGE 
				[bacmap].[custom_mapping] AS Target
			USING 
				newRecords AS Source
			ON 
				Target.custom_mapping_id = Source.custom_mapping_id

			WHEN MATCHED THEN
				UPDATE SET Target.[custom_mapping_label]			= Source.[custom_mapping_label]
							, Target.[custom_mapping_display_order] = Source.[custom_mapping_display_order]
							, Target.[custom_mapping_score]			= Source.[custom_mapping_score]	
							, Target.[custom_mapping_relevancy]		= Source.[custom_mapping_relevancy]
							, Target.[comment]						= Source.[comment]
							, Target.modified_by					= Source.modified_by					
							, Target.modified_on					= Source.modified_on				
							, Target.is_active						= Source.is_active						

			WHEN NOT MATCHED BY TARGET THEN
				INSERT ([custom_mapping_value]
							, [custom_mapping_label]
							, [custom_mapping_display_order]
							, [custom_mapping_score]
							, [custom_mapping_relevancy]
							, [comment]
							, modified_by
							, modified_on
							, is_active
						)
						VALUES (
							Source.[custom_mapping_value]
							, Source.[custom_mapping_label]
							, Source.[custom_mapping_display_order]
							, Source.[custom_mapping_score]
							, Source.[custom_mapping_relevancy]
							, Source.[comment]
							, Source.modified_by
							, Source.modified_on
							, is_active
						)

				WHEN NOT MATCHED BY SOURCE THEN
				UPDATE SET  Target.modified_by					= @user					
							, Target.modified_on					= @date			
							, Target.is_active						= 0;

		if @debug =1
		begin
			select * from  [bacmap].[custom_mapping] order by id
		end

		EXEC report.postLogEntry @component = @curProc, @action = -1,
									@message = @message, @status = 1, @rowcount = @@ROWCOUNT

		
		UPDATE [report].[custom_mapping_history]
			set [is_active] = 0;

		--write history:
		insert into [report].[custom_mapping_history] (
							[custom_mapping_id]
							, [custom_mapping_value]
							, [custom_mapping_label]
							, [custom_mapping_display_order]
							, [custom_mapping_score]
							, [custom_mapping_relevancy]
							, [comment]
							, modified_by
							, modified_on
							, is_active
						)
			select [custom_mapping_id]
					, [custom_mapping_value]
					, [custom_mapping_label]
					, [custom_mapping_display_order]
					, [custom_mapping_score]
					, [custom_mapping_relevancy]
					, [comment]
					, modified_by
					, modified_on
					, is_active
				from [bacmap].[custom_mapping]

	END TRY
	--if fail:
	BEGIN CATCH

		DECLARE @ErrorMessage NVARCHAR(4000);
		SELECT @ErrorMessage = ERROR_MESSAGE()

		EXEC report.postLogEntry @component = @curProc, @action = 0, @status = -1, @message = @ErrorMessage;
		THROW

	END CATCH
END

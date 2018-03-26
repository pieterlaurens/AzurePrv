CREATE PROCEDURE [score].[newScoreTable_load]
(
	@user nvarchar(500) = null
	, @debug bit = 0
)
AS
BEGIN
	DECLARE @message NVARCHAR(max) = ''
	DECLARE @curProc NVARCHAR(1023) = OBJECT_NAME(@@PROCID)
	EXEC report.postLogEntry @component = @curProc, @action = 1, @status = 1

	IF LEN(@user) = 0 OR @user IS null SET @user = SYSTEM_USER
	DECLARE @date datetime = getdate()

	BEGIN TRY	

		declare @sdi_scores AS [score].[score_table]

		--set the standard category for the FE list:
			insert into @sdi_scores (
								[custom_mapping_value]
								, [custom_mapping_label]
								, [custom_mapping_display_order]
								, [custom_mapping_score]
								, [custom_mapping_relevancy]
								, [comment]
							)
					Values ('Irrelevant for SDI', 'Irrelevant for SDI', 1, 0 , 0, '')
							--, ('Controversial products', 'Controversial products', 2, 0 , -1, '')
							

			declare @num int
				select @num = count(*) from @sdi_scores

		--set the categories for the mapping dropdown:
			;with ld as(
				select distinct concat(theme, ' - ', category_label) as [value]
						, concat(theme, ' - ', category_label) as [label]
						, [baseline_score] as [score]
						, case
							when [theme_contribution] = 'negative' then
								-1
							when [theme_contribution] = 'positive' then
								1
							else
								0
							end as contribution
						, '' as comment
					from
						[temp].[sdi_categories]
				)
			insert into @sdi_scores ([custom_mapping_value]
								, [custom_mapping_label]
								, [custom_mapping_display_order]
								, [custom_mapping_score]
								, [custom_mapping_relevancy]
								, [comment]
							)
				select [value]	
						, [label]
						, @num + row_number() over(order by label) as display_order
						, score
						, contribution
						, comment
					from
						ld

			if @debug =1
				begin
					select * from  @sdi_scores order by [custom_mapping_display_order]
					return
				end

		--import the table:
		--exec [score].score_mapping_tables_load @sdi_scores, @user, @date

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
							, Source.is_active
						)

				WHEN NOT MATCHED BY SOURCE THEN
				UPDATE SET  Target.modified_by					= @user					
							, Target.modified_on					= @date			
							, Target.is_active						= 0;


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
CREATE PROCEDURE [score].[import_sdi_mapping]
(
	@user nvarchar(500) = null
)
AS
BEGIN
	DECLARE @message NVARCHAR(max) = ''
	DECLARE @curProc NVARCHAR(1023) = OBJECT_NAME(@@PROCID)
	EXEC report.postLogEntry @component = @curProc, @action = 1, @status = 1

	IF LEN(@user) = 0 OR @user IS null SET @user = SYSTEM_USER

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
			insert into @sdi_scores
				select [value]	
						, [label]
						, @num + row_number() over(order by label) as display_order
						, score
						, contribution
						, comment
					from
						ld

		--import the table:

		declare @date DATETIME = getdate()
		exec [score].score_mapping_tables_load @sdi_scores, @user, @date

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
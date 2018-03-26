
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
		Values('Irrelevant for SDI', 'Irrelevant for SDI', 1, 0 , 0, '')
				, ('Controversial products', 'Controversial products', 2, 0 , -1, '')

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

select * from @sdi_scores

declare @user NVARCHAR(100) = system_user
declare @date DATETIME = getdate()

exec [score].score_mapping_tables_load @sdi_scores, @user, @date

--Check:
select * from [bacmap].custom_mapping
	where is_active = 1
	order by [custom_mapping_display_order]

select * from [report].[custom_mapping_history]
	order by [custom_mapping_display_order]
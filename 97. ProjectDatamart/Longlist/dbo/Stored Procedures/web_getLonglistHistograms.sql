CREATE PROCEDURE [dbo].[web_getLonglistHistograms](@whereClause nvarchar(max)='1>0') AS 
		declare @sql nvarchar(max)
		declare @thisScore nvarchar(50);
		declare @thisGenericName nvarchar(15);
		declare @ss table(score_name nvarchar(50), generic_name nvarchar(15))
		declare @ns smallint
		insert into @ss select lh.score_label, cs.score_generic_name from [dbo].[longlist_histograms] lh JOIN company_score cs ON cs.score_label=lh.score_label
		set @ns = (select count(*) from @ss)

		IF(@ns > 0)
		BEGIN
			set @thisScore = (select top 1 score_name from @ss)
			set @thisGenericName = (select generic_name from @ss where score_name=@thisScore)

			set @sql = N'select
				'''+@thisScore+''' as [histogram]
				, '+@thisGenericName+' as [category]
				, count(*) as [value]
				, ' + case when @thisScore = 'Industry' then '1' else '1' end +' as [flex]
				, rank() over (order by count(*) desc) as r
			from
				[dbo].[DIM_COMPANYLONGLIST_WEB]
			where
				'+@whereClause+'
				and
				'+@thisGenericName+' is not null
			group by
				'+@thisGenericName

			delete from @ss where score_name = @thisScore
			set @ns = (select count(*) from @ss)
		END

		WHILE @ns > 0
		BEGIN
			set @thisScore = (select top 1 score_name from @ss)
			set @thisGenericName = (select generic_name from @ss where score_name=@thisScore)

			set @sql = @sql + N' union all select
				'''+@thisScore+''' as [histogram]
				, '+@thisGenericName+' as [category]
				, count(*) as [value]
				, ' + case when @thisScore = 'Industry' then '1' else '1' end +' as [flex]
				, rank() over (order by count(*) desc) as r
			from
				[dbo].[DIM_COMPANYLONGLIST_WEB]
			where
				'+@whereClause+'
				and
				'+@thisGenericName+' is not null
			group by
				'+@thisGenericName

			delete from @ss where score_name = @thisScore
			set @ns = (select count(*) from @ss)
		END

		print(@sql)
		exec('select histogram, category, [value],[flex] from ('+@sql+')a where r<=15 order by [histogram] asc, [value] desc')
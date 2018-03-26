CREATE PROCEDURE [dbo].[web_getIpcLatestCeDocuments](
		@ipc INT
		, @ww nvarchar(100)	= 'cellulose ester"OR"cellulose acetate' ) AS
		declare @w nvarchar(102);
		set @w = '"' + @ww + '"';

		select
			item_id as [Publication number]
			, [Title]
			, [Filing year]
		from
			(select
				[item_rank]
				, [item_id]
				, [item_attribute]
				, item_value
			from
				[dbo].[ls_node_list_item]
			where
				item_type = 'Patent'
				and
				node_key=@ipc
			) p
		pivot(
			max(item_value) for item_attribute in ([Title],[Filing year])
		) pvt
		order by
			[item_rank] asc

		insert into report.node_explore(node_key,created_on,[caller]) values(@ipc,getdate(),OBJECT_NAME(@@PROCID))
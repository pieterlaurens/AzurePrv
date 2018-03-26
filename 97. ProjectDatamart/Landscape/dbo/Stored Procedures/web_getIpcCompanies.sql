CREATE PROCEDURE [dbo].[web_getIpcCompanies](@ipc INT) as
		select
			[Name],[# Families in Class],[Total # Families],item_id as [Company ID]
		from
			(select
				[item_rank]
				, [item_id]
				, [item_attribute]
				, item_value
			from
				[dbo].[ls_node_list_item]
			where
				item_type = 'Company'
				and
				node_key=@ipc
			) p
		pivot(
			max(item_value) for item_attribute in ([Name],[# Families in Class],[Total # Families])
		) pvt
		order by
			[item_rank] asc

		insert into report.node_explore(node_key,created_on,[caller]) values(@ipc,getdate(),OBJECT_NAME(@@PROCID))
CREATE procedure [dbo].[web_getItemLandscapeNodes](@item_id nvarchar(max)) as
	declare @ii table(item_id nvarchar(100))
	insert into @ii
		select
			string
		from
			prv_dev_inh.[utl].[splitString] (@item_id, ',')
	
	select distinct
		node_key
	from
		dbo.[ls_node_list_item]
	where
		item_id in (select item_id from @ii)--@item_id
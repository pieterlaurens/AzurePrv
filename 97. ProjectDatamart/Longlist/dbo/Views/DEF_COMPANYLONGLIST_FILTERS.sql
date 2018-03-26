

CREATE view [dbo].[DEF_COMPANYLONGLIST_FILTERS] as
select
	focuslist_id as id
	, label as [title]
	, concat('[dbo].[onFocusList](companyPrimKey,',cast(focuslist_id as nvarchar(10)),')>0') as [where]
from
	[dbo].[focus_list]
where
	[status]='open'
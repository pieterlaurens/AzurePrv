CREATE PROCEDURE [dbo].[web_getLonglistStats](@whereClause nvarchar(max)='1>0' ) AS
	
	IF(len(@whereClause)=0)
		set @whereClause = '1>0'

	declare @sql nvarchar(max)
	set @sql = ' SELECT ' +
	'COUNT(*) AS ''Total # Companies'''+
	'from ' +
	'DIM_COMPANYLONGLIST_WEB' +
	' union all ' +
	' SELECT ' +
	'COUNT(*) AS ''Total # Companies'''+
	'from ' +
		'DIM_COMPANYLONGLIST_WEB ' + 
		'WHERE ' + @whereClause

	exec(@sql)





















CREATE PROCEDURE [ivh].[run_getExecValues]
(
	@runid int = 0
	, @exectree_id uniqueidentifier
	, @status nvarchar(255) = ''
	, @itemtype nvarchar(255) = ''
	, @itemscope nvarchar(255) = ''
	, @datatype nvarchar(255) = 'nvarchar(max)'
	, @key nvarchar(255) = ''
	, @debug tinyint = 0
) AS

DECLARE @configitem_in nvarchar(max)
		, @select_clause nvarchar(max)
		, @sql nvarchar(max)
		, @item_default nvarchar(1) = ''

	SET NOCOUNT ON

	SELECT @item_default = CASE WHEN @datatype IN ('int', 'decimal', 'numeric', 'float', 'double') THEN N'0' ELSE @item_default END
	SELECT @configitem_in = STUFF((SELECT DISTINCT ',' + QUOTENAME(t2.item_key)
								FROM [ivh].[run] t1
								CROSS JOIN [ivh].[api_configitem] t2
								INNER JOIN [ivh].[run_exectree] t3 ON t3.run_id = t1.id AND t3.callee_api_id = t2.api_id
								LEFT OUTER JOIN [ivh].[run_execvalue] t4 ON t4.run_id = t1.id and t4.[key] = t2.item_key and t4.exectree_id = t3.id
								WHERE ( t1.status = @status OR DATALENGTH(ISNULL(@status, '')) = 0 )
								AND ( t1.id = @runid OR ISNULL(@runid, 0) = 0 )
								AND ( t3.id = @exectree_id OR @exectree_id IS NULL )
								AND ( t2.[item_type] = @itemtype OR DATALENGTH(ISNULL(@itemtype, '')) = 0 )
								AND ( t4.[key] = @key OR DATALENGTH(ISNULL(@key, '')) = 0 )
								ORDER BY 1 ASC
								FOR XML PATH(''), TYPE
								).value('.', 'NVARCHAR(MAX)') 
							,1,1,'')

	SELECT @select_clause = STUFF((SELECT DISTINCT 
									CASE WHEN DATALENGTH(ISNULL(@datatype, '')) = 0
									THEN ', replace(replace(isnull(' + QUOTENAME(t2.item_key) + ', ''' + ISNULL(T2.item_default, @item_default) + '''), N''false'', N''0''), N''true'', N''1'') as ' +  QUOTENAME(t2.item_key)
									ELSE ', cast(replace(replace(isnull(' + QUOTENAME(t2.item_key) + ', ''' + ISNULL(T2.item_default, @item_default) + '''), N''false'', N''0''), N''true'', N''1'') as ' + @datatype + ') as ' +  QUOTENAME(t2.item_key)
									END
									FROM [ivh].[run] t1
									CROSS JOIN [ivh].[api_configitem] t2
									INNER JOIN [ivh].[run_exectree] t3 ON t3.run_id = t1.id AND t3.callee_api_id = t2.api_id
									LEFT OUTER JOIN [ivh].[run_execvalue] t4 ON t4.run_id = t1.id and t4.[key] = t2.item_key and t4.exectree_id = t3.id
									WHERE (t1.status = @status OR DATALENGTH(ISNULL(@status, '')) = 0)
									AND (t1.id = @runid OR @runid = 0)
									AND (t3.id = @exectree_id OR @exectree_id IS NULL )
									AND (t2.[item_type] = @itemtype OR DATALENGTH(ISNULL(@itemtype, '')) = 0)
									AND (t4.[key] = @key OR DATALENGTH(ISNULL(@key, '')) = 0)
									ORDER BY 1 ASC
									FOR XML PATH(''), TYPE
									).value('.', 'NVARCHAR(MAX)') 
								,1,1,'')
	
	SET @sql = 'SELECT ' + @select_clause + '
				FROM
				(
					SELECT t3.[key], t3.value
					FROM [ivh].[run] t1
					INNER JOIN [ivh].[run_exectree] t2 ON t2.run_id = t1.id
					LEFT OUTER JOIN [ivh].[run_execvalue] t3 ON t3.exectree_id = t2.id
					WHERE ( t1.status = ''' + ISNULL(@status, '') + ''' OR 0 = DATALENGTH(''' + ISNULL(@status, '') + ''') )
					AND ( t1.id = ' + CAST(@runid AS nvarchar(10)) + ' OR 0 = ' + CAST(@runid AS nvarchar(10)) + ' )
					AND ( t2.id = ''' + ISNULL(CAST(@exectree_id as varchar(40)), '')  + ''' OR 0 = DATALENGTH(''' + ISNULL(CAST(@exectree_id as varchar(40)), '') + ''') )
			   ) x
				pivot 
				(
					max(value)
					for [key] in (' + @configitem_in + ')
				) p  '

	IF @debug = 1
	BEGIN
		PRINT '[@configitem_in] ' + ISNULL(@configitem_in, 'NULL')
		PRINT '[@select_clause] ' + ISNULL(@select_clause, 'NULL')
		PRINT '[@sql] ' + ISNULL(@sql, 'NULL')
	END

	EXEC sp_executesql @sql
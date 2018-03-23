











CREATE PROCEDURE [ivh].[run_getParamValues]
(
	@runid int = -1 
	, @status nvarchar(1024) = ''
	, @parameter_name nvarchar(1024) = ''
	, @debug tinyint = 0
) AS

DECLARE @allruns int = -1
		, @parameters_in nvarchar(max)
		, @select_clause nvarchar(max)
		, @sql nvarchar(max);

	SET NOCOUNT ON

	SELECT @parameters_in = STUFF((SELECT DISTINCT ',' + QUOTENAME(parameter)
								FROM [ivh].[run] t1
								LEFT OUTER JOIN [ivh].[run_paramvalue] t2 ON t1.id = t2.run_id
								WHERE ( t1.status IN ( select [string] FROM [utl].[splitString](@status , ',') )
										OR DATALENGTH(@status) = 0
									  )
								AND (t1.id = @runid OR @runid = @allruns)
								AND ( t2.parameter IN ( select [string] FROM [utl].[splitString](@parameter_name , ',') )
										OR DATALENGTH(@parameter_name) = 0
									)
								ORDER BY 1 ASC
								FOR XML PATH(''), TYPE
								).value('.', 'NVARCHAR(MAX)') 
							,1,1,'')

	SELECT @select_clause = STUFF((SELECT DISTINCT ',' + QUOTENAME(parameter) + ' as ' +  QUOTENAME(parameter)
									FROM [ivh].[run] t1
									LEFT OUTER JOIN [ivh].[run_paramvalue] t2 ON t1.id = t2.run_id
									WHERE ( t1.status IN ( select [string] FROM [utl].[splitString](@status , ',') )
											OR DATALENGTH(@status) = 0
										  )
									AND (t1.id = @runid OR @runid = @allruns)
									AND ( t2.parameter IN ( select [string] FROM [utl].[splitString](@parameter_name , ',') )
											OR DATALENGTH(@parameter_name) = 0
										)
									ORDER BY 1 ASC
									FOR XML PATH(''), TYPE
									).value('.', 'NVARCHAR(MAX)') 
								,1,1,'')
	
	SET @sql = 'SELECT p.id, p.caller_type, p.caller_id, ' + @select_clause + ' FROM
				(
					SELECT t1.id, t1.caller_type, t1.caller_id, t2.parameter, t2.value
					FROM [ivh].[run] t1
					LEFT OUTER JOIN [ivh].[run_paramvalue] t2 ON t1.id = t2.run_id
					WHERE ( t1.status IN ( select [string] FROM [utl].[splitString](''' + @status + ''', '','') )
							OR DATALENGTH(''' + @status + ''') = 0
							)
					AND (t1.id = ' + CAST(@runid AS nvarchar(25)) + ' OR ' + CAST(@allruns AS nvarchar(25)) + ' = ' + CAST(@runid AS nvarchar(25)) + ')
				) x
				pivot 
				(
					max(value)
					for parameter in (' + @parameters_in + ')
				) p  '

	IF @debug = 1
		PRINT '[@parameters_in] ' + @parameters_in
		PRINT '[@select_clause] ' + @select_clause
		PRINT '[@sql] ' + @sql

	EXEC sp_executesql @sql
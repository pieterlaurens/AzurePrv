












CREATE FUNCTION [ivh].[getExecutionTree] (@api nvarchar(50), @executables_only bit)
   RETURNS @tbl TABLE ([root_api_id] int not null
						, [caller_api_id] int not null
						, [callee_api_id] int not null
						, sequence nvarchar(30) not null
						, [server] sysname not null
						, entry_point nvarchar(255) not null
						, [type] nvarchar(50) not null
						, dependent_on nvarchar(512) null
						) 
AS
BEGIN
	WITH api_tree (root_api, caller_api, callee_api, sequence, dependent_on)
	AS
	(
	SELECT T1.[id],T2.caller_api_id, T2.callee_api_id, CAST(T2.sequence as varchar)
			, ISNULL(T2.[dependent_on] + ',', '')
				+ ISNULL(STUFF((SELECT ',' + [dependent_on]
								FROM [ivh].[api_workflow]
								WHERE [callee_api_id] IN (select caller_api_id from [ivh].[getAncestors](T1.[id]))
								ORDER BY sequence ASC
								FOR XML PATH(''), TYPE
								).value('.', 'NVARCHAR(MAX)') 
								,1,1,''), '') AS  dependent_on
	FROM ivh.api T1
	INNER JOIN ivh.api_workflow T2 ON T2.caller_api_id = T1.id
	WHERE T1.[public] = 1
	AND T1.api = ISNULL(@api, T1.api)

	UNION ALL

	SELECT T2.root_api, T1.caller_api_id, T1.callee_api_id, CAST(CONCAT(T2.sequence, T1.sequence) AS varchar)
			, ISNULL(T1.[dependent_on] + ',', '')
				+ ISNULL(STUFF((SELECT ',' + [dependent_on]
								FROM [ivh].[api_workflow]
								WHERE [callee_api_id] IN (select caller_api_id from [ivh].[getAncestors](T1.[callee_api_id]))
								ORDER BY sequence ASC
								FOR XML PATH(''), TYPE
								).value('.', 'NVARCHAR(MAX)') 
								,1,1,''), '') AS  dependent_on
	FROM ivh.api_workflow T1
	INNER JOIN api_tree T2 ON T2.callee_api = T1.caller_api_id
	WHERE T1.caller_api_id <> T1.callee_api_id
	)

	INSERT INTO @tbl
	SELECT root_api AS [root_api_id], caller_api AS [caller_api_id], callee_api as [callee_api_id], sequence, [server], entry_point, [type]
			, CASE 
				WHEN RIGHT(T1.dependent_on, 1) = ',' THEN LEFT(T1.dependent_on, LEN(T1.dependent_on)-1)
				ELSE T1.dependent_on
			  END
	FROM api_tree T1
	INNER JOIN ivh.api T2 ON T2.id = T1.callee_api
	WHERE ( T2.[type] <> 'api'
			OR ISNULL(@executables_only, 0) = 0 )
	AND T2.[public] = 0

	RETURN

END
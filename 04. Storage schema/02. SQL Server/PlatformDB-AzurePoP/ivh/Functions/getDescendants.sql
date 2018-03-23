














CREATE FUNCTION [ivh].[getDescendants] (@root_api_ids nvarchar(4000), @executables_only bit)
   RETURNS @tbl TABLE ([caller_api_id] int null
						, [callee_api_id] int not null
						, sequence nvarchar(30) null
					   ) 
AS
BEGIN
	WITH api_tree (caller_api, callee_api, sequence)
	AS
	(
	SELECT T2.caller_api_id, T1.id, CAST(T2.sequence as varchar)
	FROM ivh.api T1
	LEFT OUTER JOIN ivh.api_workflow T2 ON T1.id = T2.callee_api_id
	WHERE T1.id IN (select [string] from utl.splitString(@root_api_ids, ','))

	UNION ALL

	SELECT T1.caller_api_id, T1.callee_api_id, CAST(CONCAT(T2.sequence, T1.sequence) AS varchar)
	FROM ivh.api_workflow T1
	INNER JOIN api_tree T2 ON T2.callee_api = T1.caller_api_id
	WHERE T1.caller_api_id <> T1.callee_api_id
	)

	INSERT INTO @tbl
	SELECT caller_api AS [caller_api_id], callee_api as [callee_api_id], sequence
	FROM api_tree T1
	INNER JOIN ivh.api T2 ON T2.id = T1.callee_api
	WHERE ( T2.[type] <> 'api'
			OR ISNULL(@executables_only, 0) = 0 )

	RETURN

END
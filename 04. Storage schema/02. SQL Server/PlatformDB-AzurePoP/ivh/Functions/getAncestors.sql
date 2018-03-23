















CREATE FUNCTION [ivh].[getAncestors] (@root_api_ids nvarchar(4000))
   RETURNS @tbl TABLE ([caller_api_id] int not null
						, [callee_api_id] int null
						, sequence nvarchar(30) null
					   ) 
AS
BEGIN
	WITH api_tree (caller_api, callee_api, sequence)
	AS
	(
	SELECT T1.caller_api_id, T1.callee_api_id, CAST(T1.sequence as varchar)
	FROM ivh.api_workflow T1
	WHERE T1.callee_api_id IN (select [string] from utl.splitString(@root_api_ids, ','))

	UNION ALL

	SELECT T1.caller_api_id, T1.callee_api_id, CAST(CONCAT(T2.sequence, T1.sequence) AS varchar)
	FROM ivh.api_workflow T1
	INNER JOIN api_tree T2 ON T2.caller_api = T1.callee_api_id
	WHERE T1.caller_api_id <> T1.callee_api_id
	)

	INSERT INTO @tbl
	SELECT caller_api AS [caller_api_id], callee_api AS [callee_api_id], sequence
	FROM api_tree T1
	INNER JOIN ivh.api T2 ON T2.id = T1.callee_api

	INSERT INTO @tbl
	SELECT TRY_CAST([string] AS INT) AS [caller_api_id], NULL AS [callee_api_id], NULL AS [sequence]
	FROM utl.splitString(@root_api_ids, ',')


	RETURN

END
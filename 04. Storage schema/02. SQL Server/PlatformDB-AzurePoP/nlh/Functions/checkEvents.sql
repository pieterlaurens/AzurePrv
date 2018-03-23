


CREATE FUNCTION [nlh].[checkEvents] (@source_ids nvarchar(4000), @event_type nvarchar(64))
RETURNS BIT
WITH EXECUTE AS CALLER
AS
BEGIN
	DECLARE @result BIT

	IF LEN(ISNULL(@source_ids, N'')) > 0
	BEGIN
		SELECT @result = MIN(SIGN(ISNULL([row_found], 0)))
		FROM
		(
		SELECT DISTINCT t1.[id], MAX(t3.[id]) OVER(PARTITION BY t1.[id]) AS row_found
		FROM [ivh].[run_exectree] t1
		LEFT JOIN [nlh].[event] t2 ON T2.source_id = t1.[id]
		LEFT JOIN [nlh].[event_type] t3 ON t3.id = t2.[type_id] AND t3.[name] = @event_type
		WHERE t1.[id] IN ( select convert(uniqueidentifier, [string]) from [utl].[splitString](@source_ids, ','))
		) a
	END
	ELSE SET @result = 1

	RETURN ISNULL(@result, 1)
END









CREATE FUNCTION [ivh].[checkApi] (@solution nvarchar(255), @api nvarchar(255), @public bit = 1)
RETURNS BIT
WITH EXECUTE AS CALLER
AS
BEGIN
	DECLARE @result BIT = 0

	SELECT  @result = 0 + isnull(sum(sign([id])),0)
	FROM ivh.api
	WHERE [solution] = @solution
	AND [api] = @api
	AND [public] = @public

	RETURN @result
END
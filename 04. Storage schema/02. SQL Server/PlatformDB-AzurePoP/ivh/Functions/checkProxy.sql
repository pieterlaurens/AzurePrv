







-- drop function [ivh].[checkProxy]


CREATE FUNCTION [ivh].[checkProxy] (@proxy_id int, @proxy_name nvarchar(255))
RETURNS BIT
WITH EXECUTE AS CALLER
AS
BEGIN
	DECLARE @result BIT = 0

	SELECT @result = 0 + ISNULL(COUNT(1), 0) 
	FROM msdb.dbo.sysproxies
	WHERE (name = @proxy_name OR LEN(@proxy_name) = 0)
	AND (proxy_id = @proxy_id OR @proxy_id = -1)

	RETURN @result
END


CREATE FUNCTION [ivh].[getComponentName] (@entry_point nvarchar(255), @type nvarchar(50))
RETURNS sysname
WITH EXECUTE AS CALLER
AS
BEGIN
	DECLARE @component_name sysname



create_componentname:

	SET @component_name = 
		CASE @type
		WHEN 'project'
			THEN replace(reverse(left(reverse( @entry_point ), CHARINDEX('\' , reverse( @entry_point ), 1) - 1)), '.dtsx' , '')
		END

	RETURN @component_name
END
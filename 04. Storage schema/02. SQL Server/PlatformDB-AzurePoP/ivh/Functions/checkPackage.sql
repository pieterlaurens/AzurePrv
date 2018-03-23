









CREATE FUNCTION [ivh].[checkPackage] (@package_fullpath nvarchar(255), @deployment_mode nvarchar(50))
RETURNS BIT
WITH EXECUTE AS CALLER
AS
BEGIN
	DECLARE @result BIT = 0

	DECLARE @package_name AS SYSNAME = (SELECT [string] FROM [utl].splitString(@package_fullpath, '\') WHERE seq = 5)
	DECLARE @project_name AS SYSNAME = (SELECT [string] FROM [utl].splitString(@package_fullpath, '\') WHERE seq = 4)
	DECLARE @folder_name AS SYSNAME = (SELECT [string] FROM [utl].splitString(@package_fullpath, '\') WHERE seq = 3)
	DECLARE @catalog_name AS SYSNAME = (SELECT [string] FROM [utl].splitString(@package_fullpath, '\') WHERE seq = 2)

	IF @deployment_mode = 'project'
	BEGIN
		SELECT @result = 0 + ISNULL(COUNT(1), 0)
		FROM SSISDB.catalog.folders T1
		INNER JOIN SSISDB.catalog.projects T2 ON T2.folder_id = T1.folder_id
		INNER JOIN SSISDB.catalog.packages T3 ON T3.project_id = T2.project_id
		WHERE T1.name = @folder_name
		AND T2.name = @project_name
		AND T3.name = @package_name
	END
	ELSE IF @deployment_mode = 'package'
	BEGIN
		DECLARE @returncode INT
		EXEC master.dbo.xp_fileexist @package_name, @returncode OUTPUT
		SET @result = cast(@returncode as bit)
	END

	RETURN @result
END
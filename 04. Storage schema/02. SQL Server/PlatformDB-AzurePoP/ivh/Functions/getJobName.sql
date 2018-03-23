













CREATE FUNCTION [ivh].[getJobName] (@runid int, @component_id nvarchar(38))
RETURNS sysname
WITH EXECUTE AS CALLER
AS
BEGIN
	DECLARE @job_name sysname = ''


get_run_parameters:

	DECLARE @api sysname
	DECLARE @solution sysname
	DECLARE @projectkey sysname
	SELECT @api = MAX(CASE parameter WHEN 'api' THEN value END)
			, @projectkey = MAX(CASE parameter WHEN 'projectkey' THEN value END)
			, @solution = MAX(CASE parameter WHEN 'solution' THEN value END)
	FROM [ivh].[run_paramvalue]
	WHERE run_id = @runid
	AND parameter IN ('api', 'projectkey', 'solution')

	IF LEN(ISNULL(@api, '')) = 0 OR LEN(ISNULL(@projectkey, '')) = 0 OR LEN(ISNULL(@solution, '')) = 0 RETURN @job_name


get_component_attributes:

	DECLARE @componentName sysname

	IF LEN(ISNULL(@component_id, '')) = 0
	BEGIN
		SELECT TOP 1 @componentName = [ivh].[getComponentName](T1.[entry_point], T1.[type])
		FROM ivh.api T1 
		WHERE T1.[solution] = @solution 
		AND T1.[api] = @api and T1.[public] = 1
	END
	ELSE
	BEGIN
		SELECT TOP 1 @componentName = [ivh].[getComponentName](T1.[entry_point], T1.[type])
		FROM [ivh].[run_exectree] T1
		WHERE T1.run_id = @runid
		AND T1.[id] = convert(uniqueidentifier, @component_id)
	END
			
	IF LEN(ISNULL(@componentName, '')) = 0 RETURN @job_name
		

create_jobname:

	SELECT @job_name = CONCAT( @solution
								, '_', @componentName
								, '_', @projectkey
								, '_', @runid
								, CASE WHEN DATALENGTH(ISNULL(@component_id, '')) > 0 
									THEN CONCAT('_{', @component_id, '}')
									ELSE '' 
								  END
							)
	RETURN @job_name
END
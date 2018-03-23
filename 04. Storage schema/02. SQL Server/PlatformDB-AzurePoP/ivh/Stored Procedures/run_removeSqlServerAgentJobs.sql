CREATE PROCEDURE [ivh].[run_removeSqlServerAgentJobs]
	@solution sysname = N'PRV'
	, @jobname_pattern nvarchar(64) = '%'
	-- more info, https://docs.microsoft.com/en-us/sql/relational-databases/system-tables/dbo-sysjobhistory-transact-sql
	, @run_status int = 0
	, @debug bit = 0
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @msg varchar(1024)
			, @object_name nvarchar(255) = CONCAT(OBJECT_SCHEMA_NAME(@@PROCID), '.', OBJECT_NAME(@@PROCID))
			, @rowcount int = 0

	DECLARE @sql nvarchar(max) = '' ;
	SELECT @sql = CONCAT(@sql, 'BEGIN TRY
									EXEC msdb.dbo.sp_delete_job ''', T2.[job_id], '''
								END TRY
								BEGIN CATCH
								END CATCH
								;'
						)
	FROM [msdb]..[sysjobhistory] T1
	JOIN [msdb]..[sysjobs_view] T2 ON T2.[job_id] = T1.[job_id]
	WHERE T1.[run_status] = 0	
	AND T1.[step_id] = 0
	AND T2.[name] LIKE CONCAT(@solution, '[_]', @jobname_pattern)

	SET @rowcount = @@ROWCOUNT
	PRINT CONCAT('Removing ', @rowcount, ' SQL Server Agent jobs')
	IF @debug = 1 PRINT CONCAT('Executing ', @sql)
	EXEC sp_executesql @sql


	RETURN 0
END

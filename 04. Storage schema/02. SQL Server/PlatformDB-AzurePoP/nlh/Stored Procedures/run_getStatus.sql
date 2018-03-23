






CREATE PROCEDURE [nlh].[run_getStatus]
	@run_id int = -1
	, @caller_type nvarchar(50) = ''
	, @caller_id nvarchar(50) = ''
	
AS
	DECLARE @componentStatusTable TABLE (component sysname
											, [sequence] int
											, [component_completed] bit
											, [component_failed] bit
											, [run_completed] bit
											, [run_failed] bit
											, [status] nvarchar(100)
											, [status_code] int
											, [run_status] nvarchar(100)
											, [run_status_code] int
										)

/* 
	Get status per component											
*/
	INSERT INTO @componentStatusTable
	SELECT [ivh].[getComponentName](T1.[entry_point], T1.[type])	as component_name
			, T1.[sequence]											as component_sequence
			, nlh.checkEvents(T1.[id], 'complete')					as component_completed
			, nlh.checkEvents(T1.[id], 'fail')					as component_failed
			, 0 ,0
			, null, null, null, null
	FROM [ivh].[run_exectree] T1
	JOIN [ivh].[run] T2 ON T2.[id] = T1.[run_id]
	WHERE ( T2.[id] = @run_id OR @run_id = -1 )
	AND ( T2.caller_type = @caller_type OR DATALENGTH(ISNULL(@caller_type, '')) = 0 )
	AND ( T2.caller_id = @caller_id OR DATALENGTH(ISNULL(@caller_id, '')) = 0 )


	UPDATE @componentStatusTable
	SET [status] = CASE WHEN component_completed = 1 THEN 'ComponentFinished'
						WHEN component_failed = 1 THEN 'ComponentError'
						ELSE 'ComponentRunning'
					END
		, [status_code] = CASE WHEN component_completed = 1 THEN 1000
						WHEN component_failed = 1 THEN 1090
						ELSE 1001
					END

/* 
	Get status for run
*/
	UPDATE @componentStatusTable
	SET [run_completed] = [nlh].[checkEventsForRun](@run_id, '', 'complete', 'all')
		, [run_failed] = [nlh].[checkEventsForRun](@run_id, '', 'fail', 'any')

	UPDATE @componentStatusTable
	SET [run_status] = CASE WHEN run_completed = 1 THEN 'PipelineReady'
							WHEN run_failed = 1 THEN 'PipelineReady'
							ELSE 'PipelineRunning'
						END
		, [run_status_code] = CASE WHEN run_completed = 1 THEN 1120
							WHEN run_failed = 1 THEN 1120
							ELSE 1101
						END

/*
	Update component status with run status to handle ungraceful exits
*/
	UPDATE @componentStatusTable
	SET [component_completed] = 1
	WHERE [component_completed] = 0
	AND [component_failed] = 0 
	AND [run_completed] = 1

	UPDATE @componentStatusTable
	SET [component_failed] = 1
	WHERE [component_completed] = 0
	AND [component_failed] = 0 
	AND [run_failed] = 1

/*
	Return result
*/
	select
		[run_status]		as [ApiStatus]
		, [run_status_code] as [ApiStatusCode]
		, [component]		as [ComponentName]
		, [status]			as [StateDescription]
		, [status_code]		as [StateDescriptionCode]
	
	from
		@componentStatusTable;
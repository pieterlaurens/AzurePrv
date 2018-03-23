-- Get log contents
DECLARE @source_type nvarchar(10) = 'PCK' ;	-- {SP, PCK}
DECLARE @source_name nvarchar(583) = 'RefreshWebData.dtsx';
DECLARE @msg nvarchar(1024) = '';

WITH log_entries AS
(
	SELECT TRY_CAST(SUBSTRING(T1.[message], 5, CHARINDEX(':', T1.[message], 5)-5) AS INT) AS [run_id]
			, T1.*
	FROM [nlh].[log] T1 WITH (NOLOCK)
)

, log_aggregations AS
(
SELECT  T1.*
		, convert(time
					, convert(datetime, [added_on]) 
						- convert(datetime, LEAD([added_on], 1, NULL) 
													OVER( PARTITION BY [run_id], [source_name] 
														  ORDER BY [added_on] DESC, [id] DESC)
														)
				  )																									AS duration_backwardlooking
		, convert(time
					, ISNULL(convert(datetime, LEAD([added_on], 1, NULL) 
														OVER( PARTITION BY [run_id], [source_name] 
															  ORDER BY [added_on] ASC, [id] ASC)
															)
							, GETDATE()) 
						- convert( datetime, [added_on] )
				)																									AS duration_forwardlooking
		, LEAD([rowcount], 1, NULL) OVER(PARTITION BY [run_id], [source_name] ORDER BY [added_on] ASC, [id] ASC)	AS rowcount_forwardlooking
FROM log_entries T1 WITH (NOLOCK)
WHERE ( LEN(ISNULL(@source_type, '')) = 0 OR T1.source_type = @source_type )
AND	  ( LEN(ISNULL(@source_name, '')) = 0 OR T1.source_name = @source_name )
AND   ( LEN(ISNULL(@msg, '')) = 0 OR T1.[id] IN 
										( SELECT [id] FROM log_entries  WITH (NOLOCK) WHERE [message] LIKE CONCAT('%', @msg, '%')
										  UNION
										  SELECT [id]+1 FROM log_entries  WITH (NOLOCK) WHERE [message] LIKE CONCAT('%', @msg, '%')
										)
	  )
)

, duration AS
(
	SELECT run_id, component, source_type, source_name, source_id, [status]
				, MIN([added_on])														AS start_time
				, MAX([added_on])														AS end_time
				, MIN([id])																AS min_log_id
				, MAX([id])																AS end_log_id
				, MAX([rowcount])														AS [rowcount]
				, SUM(DATEDIFF(MILLISECOND, '0:00:00', duration_backwardlooking))		AS duration_in_ms
				, SUM(DATEDIFF(SECOND, '0:00:00', duration_backwardlooking))			AS duration_in_sec
				, SUM(DATEDIFF(MINUTE, '0:00:00', duration_backwardlooking))			AS duration_in_min
				, SUM(DATEDIFF(HOUR, '0:00:00', duration_backwardlooking))				AS duration_in_hr
	FROM log_aggregations
	GROUP BY run_id, component, source_type, source_name, source_id, [status]
)

SELECT T1.[run_id], T1.[component], T1.[source_type], T1.[source_name], T1.[source_id], T1.[status], T1.[rowcount]
		, LEFT(CONVERT(VARCHAR, T1.[start_time], 120), 16) AS start_time
		, LEFT(CONVERT(VARCHAR, T1.[end_time], 120), 16) AS end_time
		, CONCAT(RIGHT(CONCAT('00', CONVERT(INT, T1.[duration_in_sec]/3600)), 2)
					, ':', RIGHT(CONCAT('00', CONVERT(INT, T1.[duration_in_sec]/60 )), 2)
					, ':', RIGHT(CONCAT('00', (CONVERT(INT, T1.[duration_in_ms]/1000) - CONVERT(INT, T1.[duration_in_sec]/60 )*60)), 2)
					, '.', RIGHT(CONCAT('000', (T1.[duration_in_ms] - CONVERT(INT, T1.[duration_in_ms]/1000)*1000)), 3)
				)																		AS [duration]
		, ( SELECT [message] FROM [nlh].[log] WHERE [id] = T1.[end_log_id] )			AS [last_message]
		, T2.[value]																	AS [component_configuration]
FROM duration T1
LEFT OUTER JOIN [ivh].[run_execvalue] T2 ON T2.run_id = T1.run_id AND T2.[exectree_id] = T1.[source_id] AND T2.[key] = 'component_config'
ORDER BY T1.[run_id] DESC


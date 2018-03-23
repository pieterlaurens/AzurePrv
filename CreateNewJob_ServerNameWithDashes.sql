USE [msdb]
GO

/****** Object:  Job [PRV_TerminationHandler_Test_18_{64746A1D-D976-4DB2-8050-7DEE7F34C088}]    Script Date: 02-03-2018 11:36:27 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 02-03-2018 11:36:28 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END
exec msdb.dbo.sp_delete_job @job_name="PRV_TerminationHandler_TestTest"
DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'PRV_TerminationHandler_TestTest', 
		@enabled=1, 
		@notify_level_eventlog=2, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=1, 
		@description=N'No description available.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'NT SERVICE\SQLSERVERAGENT', @job_id = @jobId OUTPUT
		PRINT @ReturnCode
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Execute DTS]    Script Date: 02-03-2018 11:36:28 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Execute DTS', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'SSIS', 
		@command=N'/ISSERVER "\"\SSISDB\PRV-dev\PlatformHandlers\TerminationHandler.dtsx\"" /SERVER "\"equip-pop-vm\"" /CALLERINFO SQLAGENT /REPORTING E /SET \Package.Variables[$Package::RUN_ID];18 /Par "\"JSON_SLA\"";"\"{\"\"ComponentID\"\": \"\"D0E4F952-663C-42CA-89E8-318C931D42A9\"\" 					, \"\"RunID\"\": \"\"2\"\" 		 			, \"\"PollEvery\"\": \"\"00:00:10\"\" 					, \"\"TimeOutAfter\"\": \"\"3600\"\" 					, \"\"PlatformDataSource\"\": \"\"equip-pop-vm\"\" 					, \"\"PlatformCatalog\"\": \"\"prv_dev_inh\"\" 					, \"\"DatahandlerDataSource\"\": \"\"equip-pop-vm\"\" 					, \"\"DatahandlerCatalog\"\": \"\"prv_dev_dth\"\" 					, \"\"DatahandlerVersion\"\": \"\"dbo\"\" 					, \"\"ProjectDataSource\"\":\"\"equip-pop-vm\"\" 					, \"\"ProjectCatalog\"\":\"\"prv_prj_deploytestv2\"\" 				}\"" /SET \Package.Variables[$Package::IN_DEBUG_MODE];True /Par "\"$ServerOption::LOGGING_LEVEL(Int16)\"";1 /Par "\"$ServerOption::SYNCHRONIZED(Boolean)\"";True ', 
		@flags=0
--/ISSERVER "\"\SSISDB\PRV-dev\PlatformHandlers\TerminationHandler.dtsx\"" /SERVER "\"equip-pop-vm\"" /Par "\"JSON_SLA\"";"\"{\"\"ComponentID\"\": \"\"D0E4F952-663C-42CA-89E8-318C931D42A9\"\" 					, \"\"RunID\"\": \"\"2\"\" 		 			, \"\"PollEvery\"\": \"\"00:00:10\"\" 					, \"\"TimeOutAfter\"\": \"\"3600\"\" 					, \"\"PlatformDataSource\"\": \"\"equip-pop-vm\"\" 					, \"\"PlatformCatalog\"\": \"\"prv_dev_inh\"\" 					, \"\"DatahandlerDataSource\"\": \"\"equip-pop-vm\"\" 					, \"\"DatahandlerCatalog\"\": \"\"prv_dev_dth\"\" 					, \"\"DatahandlerVersion\"\": \"\"dbo\"\" 					, \"\"ProjectDataSource\"\":\"\"equip-pop-vm\"\" 					, \"\"ProjectCatalog\"\":\"\"prv_prj_deploytestv2\"\" 				}\"" /Par "\"$ServerOption::LOGGING_LEVEL(Int16)\"";1 /Par "\"$ServerOption::SYNCHRONIZED(Boolean)\"";True /CALLERINFO SQLAGENT /REPORTING E

IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO



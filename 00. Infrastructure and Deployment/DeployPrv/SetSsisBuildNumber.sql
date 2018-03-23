use [SSISDB]

declare @r int

PRINT('Build number: [$(BuildNumber)]')
PRINT('Project name: [$(ProjectName)]')
PRINT('Environment name: [$(EnvironmentName)]')

update [internal].[projects]
set
	[description] = '$(BuildNumber)'
where
	[name] = '$(ProjectName)'
	and
	folder_id = (select folder_id from internal.folders where name='$(EnvironmentName)')

set @r = @@ROWCOUNT

IF(@r = 1)
	PRINT('PASS - One row was affected. [$(ProjectName)/$(EnvironmentName)->$(BuildNumber)]')

IF(@r > 1)
	PRINT('FAIL - More than one row were affected: appears Project-name/Environment are not a unique combination. [$(ProjectName)/$(EnvironmentName)->$(BuildNumber)]')

IF(@r = 0)
	PRINT('FAIL - No rows were affected: appears the Project-name/Environment does not exist. [$(ProjectName)/$(EnvironmentName)->$(BuildNumber)]')

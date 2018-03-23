CREATE PROCEDURE [nlh].[run_getStatusByProjectKey]
	@project_key int
AS

--lookup runid
declare @run_id int = (select top 1 run_id from [ivh].run_paramvalue where parameter = 'projectkey' and value = @project_key order by created_on desc);

EXEC [nlh].[run_getStatus] @run_id
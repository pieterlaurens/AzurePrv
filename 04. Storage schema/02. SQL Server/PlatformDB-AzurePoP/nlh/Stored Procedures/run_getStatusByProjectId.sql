CREATE PROCEDURE [nlh].[run_getStatusByProjectId]
	@project_id int
AS

--lookup runid
declare @run_id int = (select top 1 run_id from [ivh].run_paramvalue where parameter = 'projectid' and value = @project_id order by created_on desc);

EXEC [nlh].[run_getStatus] @run_id
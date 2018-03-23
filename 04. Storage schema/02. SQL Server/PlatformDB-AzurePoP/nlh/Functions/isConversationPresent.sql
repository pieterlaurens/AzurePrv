
CREATE FUNCTION [nlh].[isConversationPresent] ( @run_id int, @sourceService sysname, @targetService sysname, @contract sysname)
RETURNS BIT
WITH EXECUTE AS CALLER
AS
BEGIN
	DECLARE @conversation_present BIT

	SELECT @conversation_present = SIGN(run_id)
	FROM [nlh].[run_conversation]
	WHERE [run_id] = @run_id
	AND [from_service] = @sourceService
	AND [to_service] = @targetService
	AND [on_contract] = @contract
	AND [state_desc] NOT IN ('CLOSED', 'ERROR')

	RETURN ISNULL(@conversation_present, 0)
END
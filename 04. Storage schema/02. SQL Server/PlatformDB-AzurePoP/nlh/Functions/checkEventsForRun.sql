
















CREATE FUNCTION [nlh].[checkEventsForRun] ( @run_id int, @source_ids nvarchar(4000), @event_type nvarchar(64), @mode char(3) = 'all' )
RETURNS BIT
WITH EXECUTE AS CALLER
AS
BEGIN
	DECLARE @events_present BIT

	SELECT @events_present = 
						CASE @mode
						WHEN 'all' THEN min(cast(isnull(nlh.checkEvents([id], @event_type), 0) AS TINYINT))
						WHEN 'any' THEN max(cast(isnull(nlh.checkEvents([id], @event_type), 0) AS TINYINT))
						END
	FROM [ivh].[run_exectree]
	WHERE [run_id] = @run_id
	-- To not take PlatformHandlers into account
	AND [sequence] > 0
	AND ( [id] IN ( SELECT CONVERT(uniqueidentifier, [string]) FROM utl.splitString(@source_ids, ',') )
			OR DATALENGTH(ISNULL(@source_ids, '')) = 0 
		)

	RETURN ISNULL(@events_present, 1)
END
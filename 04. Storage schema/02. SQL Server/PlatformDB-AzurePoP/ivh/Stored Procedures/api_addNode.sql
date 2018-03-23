CREATE PROCEDURE [ivh].[api_addNode]
	@solution sysname = N'PRV'
	, @api sysname
	, @public bit = 0
	, @server sysname
	, @entry_point nvarchar(255)
	, @type nvarchar(50) = N'api'
	, @run_as sysname = NULL
	, @runtime_mode nvarchar(6) = '64-bit'
	, @wait_for_completion bit = 0
	, @debug tinyint = 0
AS
BEGIN
	SET NOCOUNT ON

	IF @solution IS NULL OR @api IS NULL OR @public IS NULL 
		OR @server IS NULL OR @entry_point IS NULL OR @type IS NULL 
		OR @wait_for_completion IS NULL
	BEGIN
		RETURN -1
	END

	UPDATE [ivh].[api]
	SET [public] = @public
					, [server] = @server
					, [entry_point] = @entry_point
					, [type] = @type
					, [run_as] = @run_as
					, [runtime_mode] = @runtime_mode
					, [wait_for_completion] = @wait_for_completion
	WHERE [solution] = @solution
	AND [api] = @api

	IF @@ROWCOUNT = 0
		INSERT INTO [ivh].[api] ([solution], [api], [public], [server], [entry_point], [type], [run_as], [runtime_mode], [wait_for_completion])
		VALUES (@solution, @api, @public, @server, @entry_point, @type, @run_as, @runtime_mode, @wait_for_completion)

	RETURN 0
END

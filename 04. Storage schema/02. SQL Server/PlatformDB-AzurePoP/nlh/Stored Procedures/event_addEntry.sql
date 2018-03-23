






CREATE PROCEDURE [nlh].[event_addEntry]
	@log nvarchar(64) = 'Application',
	@type nvarchar(64),
	@source_id nvarchar(38),
	@level nvarchar(64) = 'Information',
	@data nvarchar(512) = NULL,
	@added_on datetime2 = NULL,
	@added_by sysname = NULL
AS

SET NOCOUNT ON

	INSERT INTO nlh.[event] (log_id, [type_id], source_id, [level_id], [data], [added_on], [added_by])
	VALUES (
			(select [id] from [nlh].[event_log] where [name] = @log)
			, (select [id] from [nlh].[event_type] where [name] = @type)
			, convert(uniqueidentifier, @source_id)
			, (select [id] from [nlh].[event_level] where [name] = @level)
			, @data
			, ISNULL(@added_on, GETDATE())
			, ISNULL(@added_by, USER)
			)
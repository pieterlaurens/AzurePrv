










CREATE PROCEDURE [nlh].[log_addEntry]
	@component nvarchar(50),
	@source_type nvarchar(10),
	@source_name nvarchar(50) ,
	@source_id nvarchar(38) = null,
	@message nvarchar(1024),
	@action nvarchar(10),
	@status nvarchar(10),
	@rowcount int = 0,
	@added_on datetime2 = null,
	@added_by sysname = null
AS

SET NOCOUNT ON

	INSERT INTO nlh.[log]
	VALUES (@component
			, @source_type
			, @source_name
			, convert(uniqueidentifier, @source_id)
			, @message
			, @action
			, @status
			, @rowcount
			, ISNULL(@added_on, GETDATE())
			, ISNULL(@added_by, USER)
			)
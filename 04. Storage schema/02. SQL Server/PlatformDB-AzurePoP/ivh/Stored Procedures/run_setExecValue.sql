


















CREATE PROCEDURE [ivh].[run_setExecValue]
(
	@runid int
	, @exectree_id uniqueidentifier
	, @key nvarchar(255)
	, @datatype nvarchar(255) = 'nvarchar(max)'
	, @value nvarchar(max)
	, @debug bit = 0
) AS

SET NOCOUNT ON

	INSERT INTO [ivh].[run_execvalue] ([run_id], [exectree_id], [key], [datatype], [value])
	VALUES (@runid
			, @exectree_id
			, @key
			, @datatype
			, @value
			)
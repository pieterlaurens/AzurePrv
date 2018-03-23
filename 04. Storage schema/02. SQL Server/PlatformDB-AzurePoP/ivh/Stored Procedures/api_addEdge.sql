
CREATE PROCEDURE [ivh].[api_addEdge]
	@solution sysname = N'PRV'
	, @from_node sysname
	, @to_node sysname
	, @parallel bit = 0
	, @sequence smallint = 0
	, @dependent_on nvarchar(512) = NULL
	, @debug bit = 0
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @msg varchar(1024)
			, @object_name nvarchar(255) = CONCAT(OBJECT_SCHEMA_NAME(@@PROCID), '.', OBJECT_NAME(@@PROCID))

	DECLARE @from_api_id int, @nr_of_rows_from int
	SELECT @from_api_id = max([id])
			, @nr_of_rows_from = count(distinct [id])
	FROM [ivh].[api] WHERE [api] = @from_node AND [solution] = @solution

	IF ISNULL(@nr_of_rows_from, 0) > 1
	BEGIN
		SET @msg = CONCAT(convert(varchar, GETDATE(), 121), ' Node ', @from_node, ' not found; multiple (',  @nr_of_rows_from, ') nodes present with the same name in [ivh].[api]')
		RAISERROR (@msg, 0, 1) WITH NOWAIT

		RETURN -1
	END
	ELSE IF @from_api_id IS NULL
	BEGIN
		SET @msg = CONCAT(convert(varchar, GETDATE(), 121), ' Node ', @from_node, ' not found; please add it to [ivh].[api] using stored procedure [ivh].[api_addNode]')
		RAISERROR (@msg, 0, 1) WITH NOWAIT

		RETURN -1
	END


	DECLARE @to_api_id int, @nr_of_rows_to int
	SELECT @to_api_id = max([id])
			, @nr_of_rows_to = count(distinct [id])
	FROM [ivh].[api] WHERE [api] = @to_node AND [solution] = @solution

	IF ISNULL(@nr_of_rows_to, 0) > 1
	BEGIN
		SET @msg = CONCAT(convert(varchar, GETDATE(), 121), ' Node ', @to_node, ' not found; multiple (',  @nr_of_rows_to, ') nodes present with the same name in [ivh].[api]')
		RAISERROR (@msg, 0, 1) WITH NOWAIT

		RETURN -1
	END
	ELSE IF @to_api_id IS NULL
	BEGIN
		SET @msg = CONCAT(convert(varchar, GETDATE(), 121), ' Node ', @to_node, ' not found; please add it to [ivh].[api] using stored procedure [ivh].[api_addNode]')
		RAISERROR (@msg, 0, 1) WITH NOWAIT

		RETURN -1
	END

	IF @debug = 1 PRINT CONCAT('Edge defined between API id ', @from_api_id, ' and API id ', @to_node)

	-- Get ids for apis in dependent_on list
	DECLARE @dependent_on_id_list nvarchar(512) = STUFF((SELECT CONCAT(',',[id])
															FROM [ivh].[api]
															WHERE [api] IN ( SELECT [string]
																				FROM utl.splitString(ISNULL(@dependent_on, ''), ',')
																				WHERE LEN(ISNULL([string], '')) > 0
																			)
															ORDER BY [id] ASC
															FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)') 
															,1,1, '')

	-- Get last sequence present <= specified sequence
	DECLARE @sequence_to_assign smallint = ISNULL(( SELECT MAX([sequence])
													FROM [ivh].[api_workflow] 
													WHERE [caller_api_id] = @from_api_id 
													AND ( [sequence] <= @sequence OR @sequence = 0 )
													), 0)

	-- Sequence index starts at one
	-- , or insert after last sequence
	IF ( @sequence_to_assign = 0 )						-- first edge
		OR ( @sequence_to_assign < @sequence )		-- sequence specified beyond existing sequence numbers
		OR ( @sequence = 0 AND @parallel = 0 )      -- no sequence specified and no parallel execution
	SET @sequence_to_assign += 1 ;


	BEGIN TRANSACTION ivh_api_insert_new_edge

		-- Shift all following edges by one if edge is inserted between two existing sequences
		IF ( @sequence != 0 ) 
			AND ( @parallel = 0 )
			AND ( @sequence_to_assign = @sequence ) 
		UPDATE [ivh].[api_workflow]
		SET [sequence] = [sequence] + 1
		WHERE [caller_api_id] = @from_api_id 
		AND [sequence] >= @sequence_to_assign

		-- Insert newly defined edge
		INSERT INTO [ivh].[api_workflow] ([caller_api_id], [callee_api_id], [sequence], [dependent_on])
		VALUES (@from_api_id, @to_api_id, @sequence_to_assign, @dependent_on_id_list)

	COMMIT TRANSACTION ivh_api_insert_new_edge

	RETURN 0
END
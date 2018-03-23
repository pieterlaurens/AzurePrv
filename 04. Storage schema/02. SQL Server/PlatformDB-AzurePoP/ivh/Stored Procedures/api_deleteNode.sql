CREATE PROCEDURE [ivh].[api_deleteNode]
	@solution sysname = N'PRV'
	, @api sysname
	, @debug tinyint = 0
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @msg varchar(1024)
			, @object_name nvarchar(255) = CONCAT(OBJECT_SCHEMA_NAME(@@PROCID), '.', OBJECT_NAME(@@PROCID))

get_api_id:

	DECLARE @api_id INT = ( SELECT [id] FROM [ivh].[api] WHERE [solution] = @solution AND [api] = @api )
	IF @api_id IS NULL
	BEGIN
		SET @msg = CONCAT(convert(varchar, GETDATE(), 121), ' Api ''', @api, ''' not found for solution ''', @solution, '''')
		RAISERROR (@msg, 0, 1) WITH NOWAIT

		RETURN -1
	END


remove_spaces_from_dependent_on:

	BEGIN TRANSACTION ivh_api_delete_node

		-- necessary for algorithm to work correctly
		UPDATE [ivh].[api_workflow]
		SET [dependent_on] = REPLACE([dependent_on], ' ', '')
		WHERE CHARINDEX(' ', [dependent_on]) > 0 

		PRINT CONCAT(convert(varchar, GETDATE(), 121), ' Removed spaces from column [dependent_on]: ', @@ROWCOUNT, ' rows')


	delete_from_dependent_on:

		DECLARE @api_string nvarchar(16)

		-- Api ID found in middle of sequence
		SET @api_string = CONCAT(',', @api_id, ',')
		UPDATE [ivh].[api_workflow]
		SET [dependent_on] = REPLACE([dependent_on], @api_string, ',')
		WHERE CHARINDEX(@api_string, [dependent_on]) > 0 

		PRINT CONCAT(convert(varchar, GETDATE(), 121), ' Api ID found in middle of [dependent_on] sequence: ', @@ROWCOUNT, ' rows')

		-- Api ID found at start of sequence
		SET @api_string = CONCAT(@api_id, ',')
		UPDATE [ivh].[api_workflow]
		SET [dependent_on] = RIGHT([dependent_on], LEN([dependent_on]) - LEN(@api_string))
		WHERE CHARINDEX(@api_string, [dependent_on]) > 0 
		AND LEFT([dependent_on], LEN(@api_string)) = @api_string

		PRINT CONCAT(convert(varchar, GETDATE(), 121), ' Api ID found at start of [dependent_on] sequence: ', @@ROWCOUNT, ' rows')

		-- Api ID found at end of sequence
		SET @api_string = CONCAT(',', @api_id)
		UPDATE [ivh].[api_workflow]
		SET [dependent_on] = LEFT([dependent_on], LEN([dependent_on]) - LEN(@api_string))
		WHERE CHARINDEX(@api_string, [dependent_on]) > 0 
		AND RIGHT([dependent_on], LEN(@api_string)) = @api_string

		PRINT CONCAT(convert(varchar, GETDATE(), 121), ' Api ID found at end of [dependent_on] sequence: ', @@ROWCOUNT, ' rows')

		-- Api ID found is equal to sequence
		SET @api_string = CONVERT(nvarchar(10), @api_id)
		UPDATE [ivh].[api_workflow]
		SET [dependent_on] = NULL
		WHERE [dependent_on] = @api_string

		PRINT CONCAT(convert(varchar, GETDATE(), 121), ' Api ID found as being [dependent_on] sequence: ', @@ROWCOUNT, ' rows')


	delete_where_called:

		SELECT [caller_api_id], [sequence]
		INTO #api_workflow
		FROM [ivh].[api_workflow]
		WHERE [callee_api_id] = @api_id

		PRINT CONCAT(convert(varchar, GETDATE(), 121), ' Api ', @api , ' is being called ', @@ROWCOUNT, ' times')

		DECLARE @caller_api_id int
				, @sequence smallint

		DECLARE edge_cursor CURSOR LOCAL FAST_FORWARD 
		FOR
			SELECT [caller_api_id], [sequence]
			FROM #api_workflow

		OPEN edge_cursor
		FETCH NEXT FROM edge_cursor INTO @caller_api_id, @sequence

		WHILE @@FETCH_STATUS = 0
		BEGIN
			DELETE FROM [ivh].[api_workflow]
			WHERE [caller_api_id] = @caller_api_id
			AND [callee_api_id] = @api_id
			AND [sequence] = @sequence

			PRINT CONCAT(convert(varchar, GETDATE(), 121), ' Deleting edge from api id ', @caller_api_id, ' to api id ', @api_id, ' with sequence ', @sequence)

			-- To handle cases of parallel execution
			-- , which would not lead to sequence shits
			IF NOT EXISTS ( SELECT 1 FROM [ivh].[api_workflow] WHERE [caller_api_id] = @caller_api_id AND [sequence] = @sequence )
				UPDATE [ivh].[api_workflow]
				SET [sequence] = [sequence] - 1
				WHERE [caller_api_id] = @caller_api_id
				AND [sequence] > @sequence

			FETCH NEXT FROM edge_cursor INTO @caller_api_id, @sequence
		END


	delete_where_calling:

			DELETE FROM [ivh].[api_workflow]
			WHERE [caller_api_id] = @api_id

			PRINT CONCAT(convert(varchar, GETDATE(), 121), ' Deleted edges where api ', @api , ' was caller: ', @@ROWCOUNT, ' rows')


	delete_node:

			DELETE FROM [ivh].[api] 
			WHERE [solution] = @solution AND [api] = @api 

			PRINT CONCAT(convert(varchar, GETDATE(), 121), ' Deleted node for api ', @api, ': ', @@ROWCOUNT, ' rows')


	COMMIT TRANSACTION ivh_api_delete_node
	RETURN 0
END

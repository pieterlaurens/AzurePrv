
CREATE FUNCTION [ivh].[getDependencies] (@id uniqueidentifier)
RETURNS VARCHAR(8000)
WITH EXECUTE AS CALLER
AS
BEGIN
	DECLARE @string	varchar(8000) = ''
	
	DECLARE @run_id int
	DECLARE @api_id int
	DECLARE @sequence nvarchar(512)
	DECLARE @dependent_on nvarchar(512) = ''

	DECLARE @sequence_pos smallint = 1
	DECLARE @step_current varchar(128)

	SELECT @run_id = run_id
			, @api_id = callee_api_id
			, @sequence = sequence 
			, @dependent_on = ISNULL(dependent_on, '')
	FROM ivh.run_exectree 
	WHERE id = @id

	-- Get dependencies based on sequence 
	WHILE @sequence_pos <= LEN(@sequence)
	BEGIN
		SET @step_current = SUBSTRING(@sequence, @sequence_pos, 1)

		IF CAST(@step_current AS SMALLINT)> 1
		BEGIN
			SELECT @string = ISNULL(@string, '') + ISNULL((SELECT CONCAT(',', [id])
															FROM ivh.run_exectree T1
															WHERE sequence = (SELECT MAX(sequence) 
																				FROM ivh.run_exectree T11
																				WHERE LEFT(sequence, @sequence_pos) <= CONCAT(SUBSTRING(@sequence, 1, @sequence_pos-1), @step_current - 1)
																				AND run_id = T1.run_id)
															AND sequence > 0
															AND run_id = @run_id
															ORDER BY callee_api_id ASC
															FOR XML PATH(''), TYPE
															).value('.', 'NVARCHAR(MAX)') 
															, '')
				
		END
		SET @sequence_pos = @sequence_pos + 1
	END

	-- Get dependencies based on dependent_on
	SELECT @string = ISNULL(@string, '') + ISNULL((SELECT CONCAT(',', [id])
													FROM [ivh].[run_exectree]
													WHERE run_id = @run_id
													AND [callee_api_id] IN ( SELECT callee_api_id FROM [ivh].[getDescendants](@dependent_on, 1) )
													AND sequence > 0
													ORDER BY sequence ASC
													FOR XML PATH(''), TYPE
													).value('.', 'NVARCHAR(MAX)') 
													, '')


	RETURN STUFF(@string,1,1,'')
END
CREATE PROCEDURE temp.test 
(
	@debug BIT  = 0
)
AS
BEGIN
	DECLARE @message NVARCHAR(1023) = ''
	DECLARE @curProc NVARCHAR(1023) = OBJECT_NAME(@@PROCID)
	EXEC report.postLogEntry @component = @curProc, @action = 1, @status = 1

	BEGIN TRY

		--TRUNCATE TABLE [destTable]

		--SET @message  = 'do some action'

		/*
		; WITH cte AS (SELECT * FROM [$(patstat)].[TABLE] )
			INSERT INTO [destTable]

			SELECT * FROM cte
		*/

		--IF @debug = 1 SELECT  top(100) * FROM [destTable]

		EXEC report.postLogEntry @component = @curProc, @action = -1,
									@message = @message, @status = 1, @rowcount = @@ROWCOUNT

	END TRY
	--if fail:
	BEGIN CATCH

		DECLARE @ErrorMessage NVARCHAR(4000);
		SELECT @ErrorMessage = ERROR_MESSAGE()

		EXEC report.postLogEntry @component = @curProc, @action = 0, @status = -1, @message = @ErrorMessage;
		THROW

	END CATCH
END
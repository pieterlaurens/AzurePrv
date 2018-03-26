CREATE PROCEDURE [report].[postLogEntry] (
		@component				NVARCHAR(50)
		, @source_type			NVARCHAR(10) = NULL
		, @source_name			NVARCHAR(50) = NULL
		, @message				NVARCHAR(4000) = ''
		, @action				NVARCHAR(10)
		, @status				NVARCHAR(10)
		, @rowcount				INT = 0
		, @added_on				datetime = null
		, @added_by				nvarchar(50) = null
)
AS
BEGIN
	IF @added_on is null
		SET @added_on = getdate()

	IF @added_by is null
		SET @added_by = system_user

	INSERT INTO report.event_log ([component],
										[source_type],
										[source_name],
										[message],
										[action],
										[status],
										[rowcount],
										[added_on],
										[added_by]
		)
	SELECT @component
			, @source_type
			, @source_name
			, @message		
				, CASE
						WHEN @action	 = '1'	THEN 'START'
						WHEN @action	 = '0'	THEN 'PROGRESS'
						WHEN @action	 = '-1'	THEN 'END'
						ELSE @action
					END
				, CASE
						WHEN @status	 = '1'	THEN 'SUCCES'
						WHEN @status	 = '-1'	THEN 'FAIL'
						ELSE @status
					END
			, @rowcount
			, @added_on
			, @added_by
END

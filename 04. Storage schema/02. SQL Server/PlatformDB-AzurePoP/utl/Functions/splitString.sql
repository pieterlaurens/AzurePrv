






CREATE FUNCTION [utl].[splitString] (@str nvarchar(MAX), @delimiter nvarchar(1))
   RETURNS @tbl TABLE (string nvarchar(4000) NOT NULL
						, seq int NOT NULL) AS
BEGIN
	DECLARE @t AS [utl].[udt_strTable]
	INSERT INTO @t VALUES (@delimiter)

	INSERT INTO @tbl (string, seq)
	SELECT [string], [seq]
	FROM [utl].[splitString2](@str, @t, '')
	WHERE LEN(ISNULL([string], '')) > 0

   RETURN
END
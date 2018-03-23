













CREATE FUNCTION [utl].[splitString2] (@str nvarchar(MAX), @delimiter_table AS [utl].udt_strTable READONLY, @nonbreaking_char nvarchar(1)='')
   RETURNS @tbl TABLE (string nvarchar(4000) NOT NULL
						, seq int NOT NULL
						, delimited_by nvarchar(64)) AS
BEGIN
   DECLARE @pos				int = 0
           , @nextpos		int = 1
		   , @delimlen		int = 0
           , @valuelen		int = 0
		   , @seq			int = 0
		   , @string		nvarchar(4000) = ''
		   , @delimiter		nvarchar(64) = ''
		   , @nobreaking	bit = 0

   WHILE @nextpos > 0
   BEGIN

	  -- Determine next appearance of delimiter
	  -- or of non-breaking character, when applicable
      SELECT  @nextpos = MIN([next_pos])
	  FROM (
			SELECT min(case when charindex([str], @str, @pos + 1) > 0 then charindex([str], @str, @pos + 1) end) as [next_pos]
			FROM @delimiter_table
			WHERE @nobreaking = 0

			UNION

			SELECT min(case when charindex(@nonbreaking_char, @str, @pos + 1) > 0 then charindex(@nonbreaking_char, @str, @pos + 1) end) as [next_pos]
			WHERE len(replace(@nonbreaking_char, ' ', '_')) = 1
		) T1

	  -- Determine which delimiter was encountered
	  -- set to double-quote, when applicable
      SELECT @delimiter = [str]
					, @delimlen = [str_len]
	  FROM (
			SELECT [str], len(replace([str], ' ', '_')) as str_len
			FROM @delimiter_table
			WHERE @nobreaking = 0
			GROUP BY [str]
			HAVING min(charindex([str], @str, @pos + @delimlen)) = @nextpos

			UNION

			SELECT @nonbreaking_char, 1
			WHERE len(replace(@nonbreaking_char, ' ', '_')) = 1
			HAVING min(charindex(@nonbreaking_char, @str, @pos + @delimlen)) = @nextpos
	  ) T1
	  IF @delimiter = @nonbreaking_char SET @nobreaking = SIGN(ABS(@nobreaking - 1)) -- switch 0/1


	  -- Set some variables for properly filling the table
	  SET @seq = @seq + 1
	  SET @valuelen = CASE WHEN @nextpos > 0
                              THEN @nextpos
                              ELSE len(replace(@str, ' ', '_')) + 1
                         END - @pos - 1
      SET @delimiter = CASE WHEN @nextpos > 0
                              THEN @delimiter
							  ELSE ''
                         END
	  SET @string = rtrim(ltrim(substring(@str, @pos + 1, @valuelen)))

	  -- Add result to table
	  INSERT @tbl (string, seq, delimited_by) VALUES (@string, @seq, @delimiter)

	  -- Jump forward to next delimiter
      SELECT @pos = @nextpos + @delimlen - 1
   END
   RETURN
END
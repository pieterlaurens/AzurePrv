﻿CREATE FUNCTION [dbo].[ufn_company_text]
(
	@contains_clause nvarchar(4000)
)
RETURNS @returntable TABLE
(
	company_id nvarchar(50)
)
AS
BEGIN
	set @contains_clause = '"'+@contains_clause+'"'
	INSERT @returntable
	SELECT
		bvd_id as company_id
	FROM
		--[$(scdr_15_1_server)].[$(scdr_15_1)].dbo.orbis_text
		[$(scdr_15_1)].dbo.orbis_text
	WHERE
		contains(text_content,@contains_clause)
	RETURN
END

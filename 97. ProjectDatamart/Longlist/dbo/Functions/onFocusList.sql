CREATE FUNCTION [dbo].[onFocusList]( @company_id nvarchar(25), @focuslist_id int) RETURNS tinyint
	AS
	BEGIN

		declare @n int
		declare @r tinyint
		set @n = (SELECT COUNT(*) FROM [dbo].focus_list_company where company_id=@company_id and focuslist_id=@focuslist_id)
		IF @n>0
			SET @r = 1
		ELSE
			SET @r = 0

		RETURN @r
	END
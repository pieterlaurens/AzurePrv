


CREATE PROCEDURE [dbo].[companiesOnFocuslist]
	@focuslist_id int
AS
	IF @focuslist_id = -1 BEGIN
	select distinct c.focuslist_id, c.company_id from focus_list_company c inner join [dbo].[focus_list] f on f.focuslist_id = c.focuslist_id and f.status = 'open'
	END
	ELSE BEGIN
	select distinct focuslist_id, company_id from focus_list_company where focuslist_id = @focuslist_id
	END

RETURN 0
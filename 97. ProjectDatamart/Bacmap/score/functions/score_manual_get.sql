-- dependency on questionnaire not managed!

CREATE FUNCTION [score].[manual_get]
(
	@bvd_id NVARCHAR(25)
)
RETURNS REAL
AS
BEGIN
	declare @total real 
	select @total = cast([value] as real) from [$(ProjectDbQuestionnaire)].[questionnaire].[getLatestAnswer](@bvd_id,4)

	RETURN (case 
				when @total > 10 then 10
				when @total < 0 then 0
				else @total
				end
			)
END
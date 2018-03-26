CREATE FUNCTION [score].[technology_get]
(
	@bvd_id NVARCHAR(25)
)
RETURNS REAL
AS
BEGIN
	--some buffers:
	declare @total real 
	select @total = cast(text_answer as real) from [$(ProjectDbQuestionnaire)].[questionnaire].[getLatestAnswer](@bvd_id,0)
	
	RETURN (case 
				when @total > 10 then 10
				when @total < 0 then 0
				else @total
				end
			)

END

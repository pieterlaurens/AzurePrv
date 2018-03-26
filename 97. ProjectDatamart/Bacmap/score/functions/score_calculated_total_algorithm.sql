CREATE FUNCTION [score].[calculated_total_algorithm](
	@manualScore Real
	, @technologyScore REAL
	, @sdiScore REAL
)
RETURNS REAL
AS
BEGIN
	DECLARE @returnScore REAL

	select @sdiScore = case
			when cast(@manualScore as int) = -1 then 
				@sdiScore
			else
				@manualScore
			end

	SELECT @returnScore =
		case
			when @technologyScore >= 9 then
				@sdiScore + 1
			else
				@sdiScore
			end

	SELECT @returnScore = case
						when @returnScore > 10 then 10
						when @returnScore < 0 then 0
						else @returnScore
						end
		
	RETURN (@returnScore)
END


CREATE FUNCTION [score].[sdi_algorithm]
(
	@segmentScore REAL
	, @bonusScore REAL
)
RETURNS REAL
AS
BEGIN
	DECLARE @returnScore REAL
	SELECT @returnScore =
		ROUND(@segmentScore + @bonusScore, 0)

	SELECT @returnScore = case
					when @returnScore > 10 then 10
					when @returnScore < 0 then 0
					else @returnScore
					end

	RETURN ( @returnScore)
END

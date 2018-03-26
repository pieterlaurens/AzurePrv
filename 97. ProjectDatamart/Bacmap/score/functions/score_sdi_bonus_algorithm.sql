CREATE FUNCTION [score].[sdi_bonus_algorithm]
(
	@bvd_id NVARCHAR(25)
)
RETURNS REAL
AS
BEGIN
	--scoring definition:
	declare @bonus_scores TABLE (qid int, qscore INT)
		INSERT INTO @bonus_scores values (48, 1)
										, (49, -1)

	declare @bonus INT

	declare bonus_cursor CURSOR FAST_FORWARD
		FOR
			SELECT DISTINCT qid FROM @bonus_scores
	
	OPEN bonus_cursor

	declare @qid INT

	FETCH NEXT FROM bonus_cursor
		INTO 
			@qid

	WHILE @@FETCH_STATUS = 0
	BEGIN
		select @bonus =
			isnull(@bonus, 0) + isnull(sum(qscore),0)
			from 
				[$(ProjectDbQuestionnaire)].[questionnaire].[getLatestAnswer](@bvd_id, @qid) t0
			join
				@bonus_scores t1 on t1.qid = t0.id_question
		where 
			t0.id_user_answer is not null

		FETCH NEXT FROM bonus_cursor
			INTO 
				@qid
	END

	CLOSE bonus_cursor 
	DEALLOCATE bonus_cursor

	RETURN (@bonus)

END

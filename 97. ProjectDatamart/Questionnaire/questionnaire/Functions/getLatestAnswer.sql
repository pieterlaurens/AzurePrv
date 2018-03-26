CREATE FUNCTION questionnaire.[getLatestAnswer]
(
	@bvd_id varchar(25)
	, @question_id int
)
RETURNS @returntable TABLE
(
    [bvd_id]      VARCHAR (25),
    [id_question] INT,
    [is_latest]   BIT,
    [text_answer] NVARCHAR (MAX),
    [added_on]    DATETIME2,
    [added_by]    NVARCHAR (100),
    [status]      NVARCHAR (10) ,
    [reference]   NVARCHAR (1000),
    [comment]     NVARCHAR (MAX),
	[id_user_answer] int,
	[text] nvarchar(500),
	[value] nvarchar(150)
)
AS
BEGIN
	INSERT INTO @returntable ([bvd_id],
				[id_question],
				[is_latest],
				[text_answer],
				[added_on],
				[added_by],
				[status],
				[reference],
				[comment],
				[id_user_answer],
				[text],
				[value])
		select t0.[bvd_id],
				t0.[id_question],
				t0.[is_latest],
				t0.[text_answer],
				t0.[added_on],
				t0.[added_by],
				t0.[status],
				t0.[reference],
				t0.[comment],
				t1.[id_user_answer],
				t2.[text],
				t2.[value]
			FROM 
				[questionnaire].[user_answer] t0
			left outer join
				[questionnaire].[user_answer_checked] t1 on t0.id = t1.id_user_answer
			left outer join
				[questionnaire].[answer] t2 on t1.id_answer = t2.id
			WHERE 
				[bvd_id] = @bvd_id
			and
				[id_question] = @question_id
			and
				is_latest = 1
	RETURN
END
CREATE PROCEDURE hotness.[log_addEntry]
	@component varchar(100)
	, @message nvarchar(max)
	, @action varchar(10) = null
	, @status varchar(10) = null
	, @rowcount int = null
AS
	INSERT INTO
		hotness.[log] (component,[message],[action],[status],[rowcount],[added_on],[added_by])
	VALUES(
		@component
		, @message
		, @action
		, @status
		, @rowcount
		, GETDATE()
		, USER
	)
RETURN 0

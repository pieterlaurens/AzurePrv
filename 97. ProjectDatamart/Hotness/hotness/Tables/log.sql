CREATE TABLE hotness.[log]
(
	[id] INT IDENTITY(1,1) NOT NULL
	, [component] varchar(100) not null
	, [message] varchar(max) not null
	, [action] varchar(10) null
	, [status] varchar(10) null
	, [rowcount] int null
	, added_on datetime null
	, added_by varchar(25) null
	, constraint pk_log primary key (id)
)

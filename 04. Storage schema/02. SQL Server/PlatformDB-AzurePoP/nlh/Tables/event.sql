CREATE TABLE [nlh].[event] (
    [id]        BIGINT           IDENTITY (1, 1) NOT NULL,
    [log_id]    SMALLINT         NOT NULL,
    [type_id]   SMALLINT         NOT NULL,
    [source_id] UNIQUEIDENTIFIER NOT NULL,
    [level_id]  SMALLINT         NOT NULL,
    [data]      NVARCHAR (512)   NULL,
    [added_on]  DATETIME2 (7)    DEFAULT (getdate()) NOT NULL,
    [added_by]  [sysname]        DEFAULT (user_name()) NOT NULL,
    PRIMARY KEY CLUSTERED ([id] ASC)
);
GO





CREATE TRIGGER [nlh].[post_event]
on [nlh].[event]
AFTER INSERT
AS


get_events:

	DECLARE @event_level nvarchar(64)
			, @event_log nvarchar(64)
			, @event_type nvarchar(64)
			, @message nvarchar(128)
			, @server sysname
			, @component nvarchar(255)
			, @run_id int
 
	SELECT @event_level = T2.[name]
			, @event_log = T3.[name]
			, @event_type = T4.[name]
			, @message = T4.[description]
			, @server = T5.[server]
			, @component = [ivh].[getComponentName](T5.[entry_point], T5.[type])
			, @run_id = T5.run_id
	FROM inserted T1
	JOIN [nlh].[event_level] T2 ON T2.id = T1.[level_id]
	JOIN [nlh].[event_log] T3 ON T3.id = T1.[log_id]
	JOIN [nlh].[event_type] T4 ON T4.id = T1.[type_id]
	JOIN [ivh].[run_exectree] T5 ON T5.id = T1.[source_id]

	IF @run_id IS NULL RETURN

create_message_xml:

	DECLARE @xml XML
	SET @xml = (select @run_id		as RunId
					, @event_level	as EventLevel
					, @event_log	as EventLog
					, @event_type	as EventType
					, @message		as Message
					, @server		as Server
					, @component	as Component
	FOR XML path(''), type, root ('root'))
 

define_conversation_properties:

	DECLARE @new_conversation bit = 0
			, @conversation_id UNIQUEIDENTIFIER
			, @handle UNIQUEIDENTIFIER
			, @state_desc NVARCHAR(60)
			, @from_service SYSNAME = '//InvocationHandler-dev/EventNotificationService/Init'
			, @to_service SYSNAME = '//InvocationHandler-dev/EventNotificationService/Target'
			, @on_contract SYSNAME = '//InvocationHandler-dev/EventNotificationService/EventContract'
			, @message_type SYSNAME = '//InvocationHandler-dev/EventNotificationService/EventNotificationMessage'


get_open_conversation:

	SELECT @handle = [handle_init]
			, @state_desc = [state_desc]
	FROM [nlh].[run_conversation]
	WHERE run_id = @run_id
	AND from_service = @from_service
	AND to_service = @to_service
	AND on_contract = @on_contract;



open_the_dialog:

	IF @handle IS NULL
	BEGIN
		SET @new_conversation = 1

		-- Need to start a new conversation for the current run_id
		; BEGIN DIALOG CONVERSATION @handle
		FROM SERVICE @from_service
		TO SERVICE @to_service
		ON CONTRACT @on_contract
		WITH ENCRYPTION = OFF

		SELECT @state_desc = [state_desc] 
		FROM sys.conversation_endpoints 
		WHERE [is_initiator] = 1
		AND [conversation_handle] = @handle
	END;
		

send_message:

	IF @state_desc NOT IN ('CLOSED', 'ERROR')
	BEGIN
		; SEND ON CONVERSATION @handle 
		MESSAGE TYPE @message_type
		( @xml )
	END


update_run_conversations:

	IF @new_conversation = 1
		INSERT INTO [nlh].[run_conversation] ([id], [run_id], [from_service], [to_service], [on_contract], [group_init], [handle_init], [group_target], [handle_target], [state_desc])
		SELECT [INIT].[conversation_id], @run_id, @from_service, @to_service, @on_contract
		, [INIT].[conversation_group_id], [INIT].[conversation_handle]
		, [TARGET].[conversation_group_id], [TARGET].[conversation_handle]
		, [INIT].[state_desc]
		FROM sys.conversation_endpoints [INIT]
		JOIN  sys.conversation_endpoints [TARGET] ON [TARGET].conversation_id = [INIT].conversation_id
		WHERE [INIT].is_initiator = 1
		AND [TARGET].is_initiator = 0
		AND [INIT].[conversation_handle] = @handle
	ELSE IF @state_desc IS NULL
		UPDATE [nlh].[run_conversation] 
		SET [state_desc] = @state_desc
		WHERE run_id = @run_id


close_conversation:
	
	IF ( @event_type in ('run_complete', 'run_fail') )
	BEGIN
		END CONVERSATION @handle
		
		UPDATE [nlh].[run_conversation] 
		SET [state_desc] = 'CLOSED'
		WHERE run_id = @run_id

	END
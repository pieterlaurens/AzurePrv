CREATE SERVICE [//InvocationHandler-dev/EventNotificationService/Init]
    AUTHORIZATION [dbo]
    ON QUEUE [nlh].[EventResponseQueue]
    ([//InvocationHandler-dev/EventNotificationService/EventContract]);


CREATE SERVICE [//InvocationHandler-dev/EventNotificationService/Target]
    AUTHORIZATION [dbo]
    ON QUEUE [nlh].[EventNotificationQueue]
    ([//InvocationHandler-dev/EventNotificationService/EventContract]);


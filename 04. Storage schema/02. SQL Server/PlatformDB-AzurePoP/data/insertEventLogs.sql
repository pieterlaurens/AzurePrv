TRUNCATE TABLE [nlh].[event_log]
GO


INSERT INTO [nlh].[event_log]
           ([name]
           ,[description])
     VALUES
           ('System', 'Events raised by the platform handlers themselves')
           ,('Application', 'Events raised by the components running on the platform')
GO
/*
Reference: https://technet.microsoft.com/en-us/library/cc765981.aspx
*/

TRUNCATE TABLE [nlh].[event_level]
GO

INSERT INTO [nlh].[event_level]
           ([name]
           ,[description])
     VALUES
           ('Information', 'Indicates that a change in an application or component has occurred, such as an operation has successfully completed, a resource has been created, or a service started.')
		   , ('Warning','Indicates that an issue has occurred that can impact service or result in a more serious problem if action is not taken.')
		   , ('Error','Indicates that a problem has occurred, which might impact functionality that is external to the application or component that triggered the event.')
		   , ('Critical','Indicates that a failure has occurred from which the application or component that triggered the event cannot automatically recover.')
GO



TRUNCATE TABLE [nlh].[event_type]
GO

INSERT INTO [nlh].[event_type]
           ([name]
           ,[description])
     VALUES
           ('start', 'Process step started')
		   , ('fail','Process step failed') 
		   , ('complete','Process step completed successfully') 
		   , ('progress','Process step reports progress') 
		   , ('run_complete', 'All process steps of run completed successfully')
		   , ('run_fail', 'One or more process steps of run reported failure')
GO



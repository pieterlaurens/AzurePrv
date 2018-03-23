EXEC sp_addextendedproperty @name='PrimaryContact',
	@value ='fholwerda@deloitte.nl'
GO
GO
EXEC sp_addextendedproperty @name='Status',
	@value ='Platform Database'
GO
EXEC sp_addextendedproperty @name='VersionNumber',
	@value ='$(BuildVersion)'
GO
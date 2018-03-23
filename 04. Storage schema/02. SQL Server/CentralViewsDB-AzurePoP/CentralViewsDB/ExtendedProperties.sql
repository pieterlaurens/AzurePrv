EXEC sp_addextendedproperty @name='PrimaryContact',
	@value ='pbaljon@deloitte.nl'
GO
EXEC sp_addextendedproperty @name='Status',
	@value ='Platform Database'
GO
EXEC sp_addextendedproperty @name='VersionNumber',
	@value ='$(BuildVersion)'
GO
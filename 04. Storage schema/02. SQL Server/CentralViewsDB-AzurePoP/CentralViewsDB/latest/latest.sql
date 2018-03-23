CREATE SCHEMA latest
GO
EXECUTE sys.sp_addextendedproperty 
@name = N'Reference',
@value = N'volpe',
@level0type = N'SCHEMA', 
@level0name = latest;
CREATE SCHEMA [boris]
GO
EXECUTE sys.sp_addextendedproperty 
@name = N'Release date',
@value = N'2016-09-07',
@level0type = N'SCHEMA', 
@level0name = boris;
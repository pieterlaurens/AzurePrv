CREATE SCHEMA [drax];
GO
EXECUTE sys.sp_addextendedproperty 
@name = N'Release date',
@value = N'2017-02-14',
@level0type = N'SCHEMA', 
@level0name = drax;
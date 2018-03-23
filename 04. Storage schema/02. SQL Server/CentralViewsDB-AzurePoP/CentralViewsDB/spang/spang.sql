CREATE SCHEMA [spang];
GO
EXECUTE sys.sp_addextendedproperty 
@name = N'Release date',
@value = N'2016-10-12',
@level0type = N'SCHEMA', 
@level0name = spang;
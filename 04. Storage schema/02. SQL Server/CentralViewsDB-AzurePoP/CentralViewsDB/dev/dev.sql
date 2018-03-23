CREATE SCHEMA [dev];
GO
EXECUTE sys.sp_addextendedproperty 
@name = N'Release date',
@value = N'2017-10-11',
@level0type = N'SCHEMA', 
@level0name = dev;
GO
EXECUTE sys.sp_addextendedproperty 
@name = N'PwVersion',
@value = N'pw_v2017a_001',
@level0type = N'SCHEMA', 
@level0name = dev;
GO
EXECUTE sys.sp_addextendedproperty 
@name = N'PwcVersion',
@value = N'pwc_v2017a_001',
@level0type = N'SCHEMA', 
@level0name = dev;
GO
EXECUTE sys.sp_addextendedproperty 
@name = N'SddVersion',
@value = N'sdd_v2017_002',
@level0type = N'SCHEMA', 
@level0name = dev;
GO
EXECUTE sys.sp_addextendedproperty 
@name = N'ScdVersion',
@value = N'scd_v2017_004',
@level0type = N'SCHEMA', 
@level0name = dev;
GO
EXECUTE sys.sp_addextendedproperty 
@name = N'IdrVersion',
@value = N'idr_linktables_v2017_004',
@level0type = N'SCHEMA', 
@level0name = dev;
GO
EXECUTE sys.sp_addextendedproperty 
@name = N'TopicDb',
@value = N'p01155_TopicDb',
@level0type = N'SCHEMA', 
@level0name = dev;
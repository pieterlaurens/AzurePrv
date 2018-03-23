CREATE SCHEMA [james]
    AUTHORIZATION [dbo];


GO
EXECUTE sys.sp_addextendedproperty 
@name = N'Release date',
@value = N'2017-02-17',
@level0type = N'SCHEMA', 
@level0name = james;
GO
EXECUTE sys.sp_addextendedproperty 
@name = N'PwVersion',
@value = N'pw_v2016b_001',
@level0type = N'SCHEMA', 
@level0name = james;
GO
EXECUTE sys.sp_addextendedproperty 
@name = N'PwcVersion',
@value = N'pwc_v2016b_002',
@level0type = N'SCHEMA', 
@level0name = james;
GO
EXECUTE sys.sp_addextendedproperty 
@name = N'SddVersion',
@value = N'sdd_v2017_001',
@level0type = N'SCHEMA', 
@level0name = james;
GO
EXECUTE sys.sp_addextendedproperty 
@name = N'ScdVersion',
@value = N'scd_v2017_002',
@level0type = N'SCHEMA', 
@level0name = james;
GO
EXECUTE sys.sp_addextendedproperty 
@name = N'IdrVersion',
@value = N'idr_linktables_v2017_002',
@level0type = N'SCHEMA', 
@level0name = james;
GO
EXECUTE sys.sp_addextendedproperty 
@name = N'Bloomberg',
@value = N'bloomberg_v2017_000',
@level0type = N'SCHEMA', 
@level0name = james;
GO
EXECUTE sys.sp_addextendedproperty 
@name = N'AlphaFactors',
@value = N'alpha_factors_dev',
@level0type = N'SCHEMA', 
@level0name = james;
GO
EXECUTE sys.sp_addextendedproperty 
@name = N'FrenchFactors',
@value = N'french_data_library_v2017_001',
@level0type = N'SCHEMA', 
@level0name = james;
GO
EXECUTE sys.sp_addextendedproperty 
@name = N'TopicDb',
@value = N'p01155_TopicDb',
@level0type = N'SCHEMA', 
@level0name = james;
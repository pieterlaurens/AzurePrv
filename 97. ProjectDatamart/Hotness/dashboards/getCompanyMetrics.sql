use prv_prj_cybersecurity_hotness
declare @b varchar(25)
set @b = 'US043432319'

select * from hotness.company where bvd_id=@b
exec hotness.[GetCompanyHotness] @b
exec hotness.[GetCompanyCompetitivePosition] @b
--exec GetCompanyInvestorPreference @b
exec hotness.GetCompanyFrontierTechnologies @b


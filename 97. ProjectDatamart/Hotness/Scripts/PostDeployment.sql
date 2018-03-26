/*
Post-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be appended to the build script.		
 Use SQLCMD syntax to include a file in the post-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the post-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/

truncate table company;
INSERT INTO company (bvd_id,company_name)
SELECT
	fp.bvd_id
	, fp.company_name
FROM
	[$(ProjectStaging)].dbo.filter_pool fp JOIN
	[$(PatentsWorkCompanies)].[aggregate].company_ip_metric cim ON cim.bvd_id=fp.bvd_id
WHERE
	cim.number_of_families > 0

UPDATE company
SET size_market_cap = 1000 * os.current_market_capitalisation_th
FROM
	company c JOIN
	[$(StrategicCompanyData)].dbo.orbis_stock os ON os.bvd_id=c.bvd_id

UPDATE company
SET size_employees = fl.employees
	, size_revenue = fl.revenue
FROM
	company c JOIN
	[$(StrategicCompanyData)].dbo.financials_lay fl ON fl.bvd_id=c.bvd_id

UPDATE company
SET thematic_group = ISNULL(nem.engine_theme,'Unknown')
FROM
	company c LEFT OUTER JOIN
	[$(StrategicCompanyData)].dbo.orbis_basic ob ON ob.bvd_id=c.bvd_id LEFT OUTER JOIN
	(SELECT
		*
	FROM
		[$(ProjectStaging)].[industry].[nace_to_engine_mapping]
	WHERE
		load_id = (select max(load_id) from [$(ProjectStaging)].[industry].[nace_to_engine_mapping])
	) nem ON  ob.nace_code=right(nem.str_nace_code,len(nem.str_nace_code)-1)


/*
SELECT
	bvd_id, company_name
FROM
	nlagpdatacore.SCD_V2016_006.dbo.orbis_basic where dataset = 'GLC 1605'
*/


truncate table [report].[strategic_source_db];
INSERT INTO [report].[strategic_source_db]
		([strategic_source], [source_server_name], [source_db_name])
	VALUES	('frontier technologies'	, '$(FrontierTechnologyServer)','$(FrontierTechnologyDb)'	) 
	,		('patents_work'		, 'local'					, '$(pw_v2016a_001)')
	,		('patents_work_companies'			, 'local'	, '$(pwc_v2016a_005)')
	,		('investor theme'			, '$(InvestorThemeServer)','$(InvestorThemeDb)')
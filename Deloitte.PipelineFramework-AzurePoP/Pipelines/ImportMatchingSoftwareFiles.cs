using Deloitte.PipelineFramework.PlatformConfig;
using Deloitte.PipelineFramework.PlatformConfig.Enums;
using Deloitte.PipelineFramework.PlatformConfig.Params;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Deloitte.PipelineFramework.Pipelines
{
    /// <summary>
    /// With a lot of SEC filings with counts for terms (i.e. scores). This pipeline calculates 
    /// statistics per company, category and year. The statistics are used in the web report of 
    /// Governance Box.
    /// </summary>
    public class ImportMatchingSoftwareFiles : Root
    {

        public string PrepareDbForTest = @"
											WITH random_companies (CompanyId, IndustryId, NaceCodeLevel4, NaceCodeLevel3, NaceCodeLevel2, NaceCodeLevel1)
											AS
                                            (
												SELECT TOP 10 T1.CompanyId, MAX(T1.IndustryId)	AS IndustryID
																, MAX(T3.NaceCodeLevel4)		AS NaceCodeLevel4
																, MAX(T3.NaceCodeLevel3)		AS NaceCodeLevel3
																, MAX(T3.NaceCodeLevel2)		AS NaceCodeLevel2
																, MAX(T3.NaceCodeLevel1)		AS NaceCodeLevel1
                                                FROM [result].[FactSubjectScore] T1
												INNER JOIN [result].[DimCompany] T2 on T2.CompanyId = T1.CompanyId
												INNER JOIN [result].[DimIndustry] T3 on T3.IndustryId = T1.IndustryId
												GROUP BY T1.CompanyId
                                                ORDER BY HASHBYTES('md5',cast(T1.CompanyId+31 as varchar)) DESC
                                            )

											, related_industries (IndustryId, [Level])
											AS
											(
												SELECT IndustryId, 4 AS [Level] FROM random_companies
												UNION ALL SELECT IndustryId, [Level] FROM [result].[DimIndustry] WHERE [Level] = 3 AND NaceCodeLevel3 IN ( SELECT NaceCodeLevel3 FROM random_companies )
												UNION ALL SELECT IndustryId, [Level] FROM [result].[DimIndustry] WHERE [Level] = 2 AND NaceCodeLevel2 IN ( SELECT NaceCodeLevel2 FROM random_companies )
												UNION ALL SELECT IndustryId, [Level] FROM [result].[DimIndustry] WHERE [Level] = 1 AND NaceCodeLevel1 IN ( SELECT NaceCodeLevel1 FROM random_companies )
											)

	                                        DELETE FROM [result].[FactIndustryMetrics]
											WHERE IndustryId IN ( SELECT IndustryId FROM related_industries );

 											WITH random_companies (CompanyId)
											AS
                                            (
												SELECT TOP 10 T1.CompanyId
                                                FROM [result].[FactSubjectScore] T1
												INNER JOIN [result].[DimCompany] T2 on T2.CompanyId = T1.CompanyId
												GROUP BY T1.CompanyId
                                                ORDER BY HASHBYTES('md5',cast(T1.CompanyId+31 as varchar)) DESC
                                            )
                                            DELETE FROM [result].[FactCompanyMetrics]
											WHERE CompanyId IN ( SELECT CompanyId FROM random_companies );

 											WITH random_companies (CompanyId)
											AS
                                            (
												SELECT TOP 10 T1.CompanyId
                                                FROM [result].[FactSubjectScore] T1
												INNER JOIN [result].[DimCompany] T2 on T2.CompanyId = T1.CompanyId
												GROUP BY T1.CompanyId
                                                ORDER BY HASHBYTES('md5',cast(T1.CompanyId+31 as varchar)) DESC
                                            )
                                            DELETE FROM [result].[FactSubjectScore]
                                            WHERE CompanyId IN ( SELECT CompanyId FROM random_companies );
                                            ";

        /// <summary>
        /// With a lot of SEC filings with counts for terms (i.e. scores). This pipeline calculates 
        /// statistics per company, category and year. The statistics are used in the web report of 
        /// Governance Box.
        /// </summary>
        public ImportMatchingSoftwareFiles()
        {
            Header = new ConfigHeader
            {
                Creator = "IDResolving",
                NameOfApi = PipelineNames.ImportMatchingSoftwareFiles,
                
            };
            ComponentParams = new List<ComponentParam>()
            {
                new ComponentParam{ PackageName = PackageName.importMatchingSoftwareFile,
                    ProjectType = PlatformConfig.Enums.ProjectType.IdResolving,
                    ImportMatchingSoftwareFileParams = new List<ImportMatchingSoftwareFileParams>() {
                        new ImportMatchingSoftwareFileParams{
                                            Folder = @"\\nl\data\DataCore\DataStore\strategic\source\candidate matches\Patstat vs BvD Matching Software\Patstat 2015a vs BvD matching software v45\output\NoCtryAddress",
                                            Filename = @"2015a_nocountry_address_0_Results_r45.txt",
                                            DestinationSchema = @"[input]",
                                            DestinationTable = @"[pipeline_test]"
                                        }
                } }
            };
        }
    }
    /// <summary>
    /// With a lot of SEC filings with counts for terms (i.e. scores). This pipeline calculates 
    /// statistics per company, category and year. The statistics are used in the web report of 
    /// Governance Box.
    /// </summary>
    public class ImportMatchingSoftwareFilesSla : SLA
    {
        /// <summary>
        /// With a lot of SEC filings with counts for terms (i.e. scores). This pipeline calculates 
        /// statistics per company, category and year. The statistics are used in the web report of 
        /// Governance Box.
        /// </summary>
        public ImportMatchingSoftwareFilesSla()
        {
            RunID = "-1";
            PollEvery = "00:00:10";
            TimeOutAfter = "3600";
            PlatformDataSource = "nlagpdatacore";
            PlatformCatalog = "prv_dev_inh";
            DatahandlerDataSource = "nlagpdatacore";
            DatahandlerCatalog = "prv_dev_dth";
            DatahandlerVersion = "latest";
            ProjectDataSource = "nlams10823";
            ProjectCatalog = "ID_Resolving_input";
            ComponentID = "D0E4F952-663C-42CA-89E8-318C931D42A1";
        }
    }
}

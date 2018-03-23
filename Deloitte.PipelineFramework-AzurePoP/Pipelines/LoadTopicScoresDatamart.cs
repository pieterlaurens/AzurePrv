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
    public class LoadTopicScoresDatamart : Root
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
        public LoadTopicScoresDatamart()
        {
            Header = new ConfigHeader
            {
                Creator = "ReportWebsite",
                NameOfApi = PipelineNames.LoadTopicScoresDatamart,
                
            };
            ComponentParams = new List<ComponentParam>()
            {
                new ComponentParam{ PackageName = PackageName.LoadCalendar,
                    ProjectType = PlatformConfig.Enums.ProjectType.PdfReport,
                    LoadCalendarParams = new LoadCalendarParams{
                        CalendarStartYear = 2012,
                        CalendarEndYear = 2016,
                        TruncateBeforeLoad = false,
                    } },
                new ComponentParam{ PackageName = PackageName.LoadCompanies,
                    ProjectType = PlatformConfig.Enums.ProjectType.PdfReport,
                    LoadCompaniesParams = new LoadCompaniesParams{
                        CompaniesToLoad = "SecFilings|AnnualReports|ManualInput",
                        CompanyOwnershipCatalog = "company_ownership",
                        CompanyOwnershipDataSource = "NLAGPDATACORE",
                        DealsCatalog = "sdd",
                        DealsDataSource = "NLAGPDATACORE",
                        EntityTypesToLoad = "All",
                        OrbisCatalog = "scd",
                        OrbisDataSource = "NLAGPDATACORE",
                        TruncateBeforeLoad = false
                    } },
                new ComponentParam{ PackageName = PackageName.LoadIndustries,
                    ProjectType = PlatformConfig.Enums.ProjectType.PdfReport,
                    LoadIndustriesParams = new LoadIndustriesParams{
                        NaceCatalog = "nace_code",
                        NaceDataSource = "NLAGPDATACORE",
                        TruncateBeforeLoad = false
                    } },
                new ComponentParam{ PackageName = PackageName.LoadCountries,
                    ProjectType = PlatformConfig.Enums.ProjectType.PdfReport,
                    LoadCountriesParams = new LoadCountriesParams{
                        CountryCatalog = "country_code",
                        CountryDataSource = "NLAGPDATACORE",
                        TruncateBeforeLoad = false
                    } },
                new ComponentParam{ PackageName = PackageName.LoadDocuments,
                    ProjectType = PlatformConfig.Enums.ProjectType.PdfReport,
                    LoadDocumentsParams = new LoadDocumentsParams{
                        AnnualReportsCatalog = "GovernanceBox",
                        AnnualReportsDataSource = "NLAMS10859",
                        SecFilingsCatalog = "sec",
                        SecFilingsDataSource = "NLAGPDATACORE",
                        WebCatalog = "wcd_staging",
                        WebDataSource = "NLAGPDATACORE",
                        DocumentsToLoad = "SecFilings|AnnualReports|ManualInput|Web",
                        TruncateBeforeLoad = false
                    } },
                new ComponentParam{ PackageName = PackageName.LoadSubjects,
                    ProjectType = PlatformConfig.Enums.ProjectType.PdfReport,
                    LoadSubjectTreeParams = new LoadSubjectTreeParams{
                        SubjectTreesToLoad = "Risk_Intelligence_Map",
                        TopicDefinitionCatalog = "p00019_TopicDB",
                        TopicDefinitionDataSource = "NLAMS00822",
                        TruncateBeforeLoad = false
                    } },
                new ComponentParam{ PackageName = PackageName.LoadSubjectScoreSources,
                    ProjectType = PlatformConfig.Enums.ProjectType.PdfReport,
                    LoadSubjectScoreSourcesParams = new LoadSubjectScoreSourcesParams{
                        TopicScoresCatalog = "p00019_TopicDB",
                        TopicScoresDataSource = "NLAMS00822",
                        SourceDescriptionSetsToLoad = "Dutch annual reports (risk paragraph)|Manual input (risk paragraph)|Company SEC (risk paragraph, not aggregated)",
                        TruncateBeforeLoad = false
                    } },
                new ComponentParam{ PackageName = PackageName.LoadSubjectScores,
                    ProjectType = PlatformConfig.Enums.ProjectType.PdfReport,
                    LoadSubjectScoresParams = new LoadSubjectScoresParams{
                        DocumentsToLoad = "SecFilings|AnnualReports|ManualInput|Web",
                        IndustryLevelsToCalculate = "0|1|2|3",
                        MinimumNumberOfTopicMatchesRequired = 10,
                        MinimumTopicScoreRequired = 0,
                        MinimumVarianceForTrendChange = 3.0,
                        MultipleDocumentTypesPerCompany = false,
                        SourceDescriptionSetsToLoad = "Dutch annual reports (risk paragraph)|Manual input (risk paragraph)|Company SEC (risk paragraph, not aggregated)",
                        SubjectLevelsToCalculate = "0|1|2|3|4",
                        TopicScoresCatalog = "p00019_TopicDB",
                        TopicScoresDataSource = "NLAMS00822",
                        TrendEndYear = 2016,
                        TrendStartYear = 2012,
                        TruncateBeforeLoad = false
                    } }
            };
        }
    }
    /// <summary>
    /// With a lot of SEC filings with counts for terms (i.e. scores). This pipeline calculates 
    /// statistics per company, category and year. The statistics are used in the web report of 
    /// Governance Box.
    /// </summary>
    public class LoadTopicScoresDatamartSla : SLA
    {
        /// <summary>
        /// With a lot of SEC filings with counts for terms (i.e. scores). This pipeline calculates 
        /// statistics per company, category and year. The statistics are used in the web report of 
        /// Governance Box.
        /// </summary>
        public LoadTopicScoresDatamartSla()
        {
            RunID = "-1";
            PollEvery = "00:00:10";
            TimeOutAfter = "3600";
            PlatformDataSource = "nlagpdatacore";
            PlatformCatalog = "prv_dev_inh";
            DatahandlerDataSource = "nlagpdatacore";
            DatahandlerCatalog = "prv_dev_dth";
            DatahandlerVersion = "latest";
            ProjectDataSource = "nlams10859";
            ProjectCatalog = "GovernanceBox";
            ComponentID = "D0E4F952-663C-42CA-89E8-318C931D42A1";
        }
    }
}

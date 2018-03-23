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
    public class PublishAdditionalDocuments : Root
    {

        public string PrepareDbForTest = @"";

        /// <summary>
        /// With a lot of SEC filings with counts for terms (i.e. scores). This pipeline calculates 
        /// statistics per company, category and year. The statistics are used in the web report of 
        /// Governance Box.
        /// </summary>
        public PublishAdditionalDocuments()
        {
            Header = new ConfigHeader
            {
                Creator = "ReportWebsite",
                NameOfApi = PipelineNames.PublishAdditionalDocuments,
            };
            ComponentParams = new List<ComponentParam>()
            {
                new ComponentParam{ PackageName = PackageName.LoadCompanies,
                    ProjectType = PlatformConfig.Enums.ProjectType.PdfReport,
                    LoadCompaniesParams = new LoadCompaniesParams{
                        CompaniesToLoad = "ManualInput",
                        CompanyOwnershipCatalog = "company_ownership",
                        CompanyOwnershipDataSource = "NLAGPDATACORE",
                        DealsCatalog = "sdd",
                        DealsDataSource = "NLAGPDATACORE",
                        EntityTypesToLoad = "All",
                        OrbisCatalog = "scd",
                        OrbisDataSource = "NLAGPDATACORE",
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
                        DocumentsToLoad = "ManualInput",
                        TruncateBeforeLoad = false
                    } },
                new ComponentParam{ PackageName = PackageName.LoadSubjectScores,
                    ProjectType = PlatformConfig.Enums.ProjectType.PdfReport,
                    LoadSubjectScoresParams = new LoadSubjectScoresParams{
                        IndustryLevelsToCalculate = "0|1|2|3",
                        MinimumNumberOfTopicMatchesRequired = 10,
                        MinimumVarianceForTrendChange = 3.0,
                        TopicScoresCatalog = "p00019_TopicDB",
                        TopicScoresDataSource = "NLAMS00822",
                        SourceDescriptionSetsToLoad = "Manual input (risk paragraph)",
                        SubjectLevelsToCalculate = "0|1|2|3|4",
                        TrendEndYear = 2016,
                        TrendStartYear = 2012,
                        TruncateBeforeLoad = false
                    } },
               new ComponentParam{ PackageName = PackageName.RefreshWebData,
                    ProjectType = PlatformConfig.Enums.ProjectType.PdfReport,
                    RefreshWebDataParams = new RefreshWebDataParams{
                        PublishCatalog = "GovernanceBoxStats",
                        PublishDataSource = "NLAMS10859",
                        TrendStartYear = 2012,
                        TrendEndYear = 2016,
                        SubjectTreesToPublish = "Risk_Intelligence_Map",
                        IndustryLevelsToPublish = "0|1|2|3",
                        SubjectLevelsToPublish = "0|1|2",
                        MinimumVarianceForTrendChange = 3.0
                    } }
            };
        }
    }
    /// <summary>
    /// With a lot of SEC filings with counts for terms (i.e. scores). This pipeline calculates 
    /// statistics per company, category and year. The statistics are used in the web report of 
    /// Governance Box.
    /// </summary>
    public class PublishAdditionalDocumentsSla : SLA
    {
        /// <summary>
        /// With a lot of SEC filings with counts for terms (i.e. scores). This pipeline calculates 
        /// statistics per company, category and year. The statistics are used in the web report of 
        /// Governance Box.
        /// </summary>
        public PublishAdditionalDocumentsSla()
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

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
    public class RefreshTopicScores : Root
    {

        public string PrepareDbForTest = @"";

        /// <summary>
        /// With a lot of SEC filings with counts for terms (i.e. scores). This pipeline calculates 
        /// statistics per company, category and year. The statistics are used in the web report of 
        /// Governance Box.
        /// </summary>
        public RefreshTopicScores()
        {
            Header = new ConfigHeader
            {
                Creator = "ReportWebsite",
                NameOfApi = PipelineNames.RefreshTopicScores,
            };
            ComponentParams = new List<ComponentParam>()
            {
                new ComponentParam{ PackageName = PackageName.LoadSubjectScores,
                    ProjectType = PlatformConfig.Enums.ProjectType.PdfReport,
                    LoadSubjectScoresParams = new LoadSubjectScoresParams{
                        IndustryLevelsToCalculate = "0|1|2|3",
                        MinimumNumberOfTopicMatchesRequired = 10,
                        MinimumTopicScoreRequired = 0,
                        MinimumVarianceForTrendChange = 3.0,
                        MultipleDocumentTypesPerCompany = false,
                        TopicScoresCatalog = "p00019_TopicDB",
                        TopicScoresDataSource = "NLAMS00822",
                        SourceDescriptionSetsToLoad = "Dutch annual reports (risk paragraph)|Manual input (risk paragraph)|Company SEC (risk paragraph, not aggregated)",
                        SubjectLevelsToCalculate = "0|1|2",
                        TrendEndYear = 2016,
                        TrendStartYear = 2012,
                        TruncateBeforeLoad = true
                    } },
               new ComponentParam{ PackageName = PackageName.RefreshWebData,
                    ProjectType = PlatformConfig.Enums.ProjectType.PdfReport,
                    RefreshWebDataParams = new RefreshWebDataParams{
                        IndustryLevelsToPublish = "0|1|2|3",
                        MinimumVarianceForTrendChange = 3.0,
                        PublishCatalog = "GovernanceBoxStats",
                        PublishDataSource = "NLAMS10859",
                        SubjectTreesToPublish = "Risk_Intelligence_Map",
                        SubjectLevelsToPublish = "0|1|2",
                        TrendStartYear = 2012,
                        TrendEndYear = 2016,
                        TruncateBeforeLoad = true
                    } }
            };
        }
    }
    /// <summary>
    /// With a lot of SEC filings with counts for terms (i.e. scores). This pipeline calculates 
    /// statistics per company, category and year. The statistics are used in the web report of 
    /// Governance Box.
    /// </summary>
    public class RefreshTopicScoresSla : SLA
    {
        /// <summary>
        /// With a lot of SEC filings with counts for terms (i.e. scores). This pipeline calculates 
        /// statistics per company, category and year. The statistics are used in the web report of 
        /// Governance Box.
        /// </summary>
        public RefreshTopicScoresSla()
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

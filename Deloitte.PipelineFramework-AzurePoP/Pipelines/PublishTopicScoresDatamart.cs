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
    public class PublishTopicScoresDatamart : Root
    {

        public string PrepareDbForTest = @"";

        /// <summary>
        /// With a lot of SEC filings with counts for terms (i.e. scores). This pipeline calculates 
        /// statistics per company, category and year. The statistics are used in the web report of 
        /// Governance Box.
        /// </summary>
        public PublishTopicScoresDatamart()
        {
            Header = new ConfigHeader
            {
                Creator = "ReportWebsite",
                NameOfApi = PipelineNames.PublishTopicScoresDatamart,
                
            };
            ComponentParams = new List<ComponentParam>()
            {
                new ComponentParam{ PackageName = PackageName.RefreshWebData,
                    ProjectType = PlatformConfig.Enums.ProjectType.PdfReport,
                    RefreshWebDataParams = new RefreshWebDataParams{
                        PublishCatalog = "GovernanceBoxStats",
                        PublishDataSource = "NLAMS10859",
                        TrendStartYear = 2012,
                        TrendEndYear = 2016,
                        SubjectTreesToPublish = "Risk_Intelligence_Map",
                        SubjectLevelsToPublish = "0|1|2",
                        IndustryLevelsToPublish = "0|1|2|3",
                        MinimumVarianceForTrendChange = 3.0,
                        TruncateBeforeLoad = true
                    }
                }
            };
        }
    }
    /// <summary>
    /// With a lot of SEC filings with counts for terms (i.e. scores). This pipeline calculates 
    /// statistics per company, category and year. The statistics are used in the web report of 
    /// Governance Box.
    /// </summary>
    public class PublishTopicScoresDatamartSla : SLA
    {
        /// <summary>
        /// With a lot of SEC filings with counts for terms (i.e. scores). This pipeline calculates 
        /// statistics per company, category and year. The statistics are used in the web report of 
        /// Governance Box.
        /// </summary>
        public PublishTopicScoresDatamartSla()
        {
            RunID = "-1";
            PollEvery = "00:00:10";
            TimeOutAfter = "3600";
            PlatformDataSource = "nlagpdatacore";
            PlatformCatalog = "prv_dev_inh";
            DatahandlerDataSource = "nlagpdatacore";
            DatahandlerCatalog = "prv_app_dth";
            DatahandlerVersion = "felix"; // only felix provides the stored procedure to the GovernanceBox database.
            ProjectDataSource = "nlams10859";
            ProjectCatalog = "GovernanceBox";
            ComponentID = "D0E4F952-663C-42CA-89E8-318C931D42A1";
        }
    }
}

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
    public class CreateUserStats : Root
    {

        public string PrepareDbForTest = @"
DELETE t1 FROM dbo.user_group_definition t1 join dbo.user_group t2 on t1.group_id=t2.id where name='End2EndTestGroup';
DELETE FROM dbo.user_group where name='End2EndTestGroup;'
";

        /// <summary>
        /// With a lot of SEC filings with counts for terms (i.e. scores). This pipeline calculates 
        /// statistics per company, category and year. The statistics are used in the web report of 
        /// Governance Box.
        /// </summary>
        public CreateUserStats()
        {
            Header = new ConfigHeader
            {
                Creator = "ReportWebsite",
                NameOfApi = PipelineNames.CreateUserStats,
                
            };
            ComponentParams = new List<ComponentParam>()
            {
                new ComponentParam{ PackageName = PackageName.CreateStatsOverTopicsForCompanies,
                    ProjectType = PlatformConfig.Enums.ProjectType.PdfReport,
                    CreateStatsParams = new CreateStatsParams{
                        DestDbName = "GovernanceBoxStats",
                        TrendStartYear = 2012, // "TrendYearRange":"2011-2014", see TimeRange in ScoringParams.
                        TrendEndYear = 2015,
                        StableTrendThreshold = 0.01,
                        Debug = false,
                        // See CompanyId, Bag of IDs, preferably pipe separated.
                        CompanyIdList = "US630084140,US77051877",
                        GroupName = "End2EndTestGroup",
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
    public class CreateUserStatsSla : SLA
    {
        /// <summary>
        /// With a lot of SEC filings with counts for terms (i.e. scores). This pipeline calculates 
        /// statistics per company, category and year. The statistics are used in the web report of 
        /// Governance Box.
        /// </summary>
        public CreateUserStatsSla()
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

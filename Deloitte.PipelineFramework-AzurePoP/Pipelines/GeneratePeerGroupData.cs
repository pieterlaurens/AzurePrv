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
    /// When choosing a company report in the Deloitte WebShop, this company can be compared
    /// against a (custom) peer group. This pipeline makes the peer group available for the 
    /// front-end, and generates the necessary content/statistics for the report
    /// </summary>
    public class GeneratePeerGroupData : Root
    {

        public string PrepareDbForTest =
            @"  DECLARE @CategoryId INT = ( SELECT [Id] FROM dbo.CategorySet WHERE name='End2EndTestGroup' );
                DELETE FROM [dbo].[TopicPerCategoryPerPeriodSet] WHERE [Category_Id] = @CategoryId;
                DELETE FROM [dbo].[TopicPerCategoryTotalSet] WHERE [Category_Id] = @CategoryId;
                DELETE FROM [dbo].[CategorySet] WHERE [Id] = @CategoryId;
            ";

        /// <summary>
        /// With a lot of SEC filings with counts for terms (i.e. scores). This pipeline calculates 
        /// statistics per company, category and year. The statistics are used in the web report of 
        /// Governance Box.
        /// </summary>
        public GeneratePeerGroupData()
        {
            Header = new ConfigHeader
            {
                Creator = "ReportWebsite",
                NameOfApi = PipelineNames.GeneratePeerGroupData,
                
            };
            ComponentParams = new List<ComponentParam>()
            {
                new ComponentParam{ PackageName = PackageName.AddGroupStatistics,
                    ProjectType = PlatformConfig.Enums.ProjectType.PdfReport,
                    CreateStatsParams = new CreateStatsParams{
                        DestDbName = "GovernanceBoxStats",
                        PublishDataSource = "NLAMS10859",
                        PublishCatalog = "RiskFocusWeb",
                        TrendStartYear = 2012,
                        TrendEndYear = 2016,
                        StableTrendThreshold = 3.0,
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
    public class GeneratePeerGroupDataSla : SLA
    {
        /// <summary>
        /// With a lot of SEC filings with counts for terms (i.e. scores). This pipeline calculates 
        /// statistics per company, category and year. The statistics are used in the web report of 
        /// Governance Box.
        /// </summary>
        public GeneratePeerGroupDataSla()
        {
            RunID = "-1" ;
            PollEvery = "00:00:10";
            TimeOutAfter = "3600";
            PlatformDataSource = "NLAMS00859";
            PlatformCatalog = "prv_dev_inh";
            DatahandlerDataSource = "NLAMS00859";
            DatahandlerCatalog = "prv_dev_dth";
            DatahandlerVersion = "latest";
            ProjectDataSource = "nlams10859";
            ProjectCatalog = "GovernanceBox";
            ComponentID = "D0E4F952-663C-42CA-89E8-318C931D42A1";
        }
    }
}

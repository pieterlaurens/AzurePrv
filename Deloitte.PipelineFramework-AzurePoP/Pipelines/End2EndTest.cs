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
    /// The template configuration for retrieving keyword profiles from the website. The Bag Of Words is replaced by whatever's entered from the website.
    /// </summary>
    public class End2EndTest : Root
    {
        /// <summary>
        /// Cosntructor for the configuration for the Keyword Profile pipeline.
        /// </summary>
        public End2EndTest()
        {
            Header = new ConfigHeader
            {
                Creator = "Website",
                NameOfApi = PipelineNames.TestEndToEnd,
            };
            ComponentParams = new List<ComponentParam>()
            {
                new ComponentParam{ PackageName = PackageName.End2EndIntegrationTest,
                    RetrievalParams = new List<RetrievalParam>() {
                        new RetrievalParam
                        {
                            RetrievalType = CompanyRetrievalType.CompanyList,
                            CompanyId = "TESTCOMPANYID",
                            NumberOfCompanies = 3,
                        }
                    }
                }
            };
        }
    }

    /// <summary>
    /// The SLA as used for the Keyword Profile component.
    /// </summary>
    public class End2EndTestSla : SLA
    {
        public End2EndTestSla()
        {
            ComponentID = "D0E4F952-663C-42CA-89E8-318C931D42A9";
            RunID = "-1";
            PollEvery = "00:00:10";
            TimeOutAfter = "60";
            PlatformDataSource = "nlagpdatacore";
            PlatformCatalog = "prv_dev_inh";
            DatahandlerDataSource = "nlagpdatacore";
            DatahandlerCatalog = "prv_app_dth";
            DatahandlerVersion = "honeyrider";
            ProjectDataSource = "nlagpdatacore";
            ProjectCatalog = "prv_e2e_it";
        }
    }
}

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
    public class GetKeywordProfile : Root
    {
        /// <summary>
        /// Cosntructor for the configuration for the Keyword Profile pipeline.
        /// </summary>
        public GetKeywordProfile()
        {
            Header = new ConfigHeader
            {
                Creator = "EugfWebsite",
                NameOfApi = PipelineNames.GetKeywordProfile,
            };
            ComponentParams = new List<ComponentParam>()
            {
                new ComponentParam{ PackageName = PackageName.GetKeywordProfile,
                    GetKeywordProfileParams = new KeywordProfileParam{
                        BagOfWords = "polyamide",
                        MinimalClassSize = 750,
                        NumberOfClasses = 15,
                    }
                }
            };
        }
    }

    /// <summary>
    /// The SLA as used for the Keyword Profile component.
    /// </summary>
    public class GetKeywordProfileSla : SLA
    {
        public GetKeywordProfileSla()
        {
            ComponentID = "D0E4F952-663C-42CA-89E8-318C931D42A9";
            RunID = "-1";
            PollEvery = "00:00:10";
            TimeOutAfter = "3600";
            PlatformDataSource = "nlagpdatacore";
            PlatformCatalog = "prv_dev_inh";
            DatahandlerDataSource = "nlagpdatacore";
            DatahandlerCatalog = "prv_dev_dth";
            DatahandlerVersion = "felix";
            ProjectDataSource = "nlagpdatacore";
            ProjectCatalog = "prv_prj_testdeploy";
        }
    }
}

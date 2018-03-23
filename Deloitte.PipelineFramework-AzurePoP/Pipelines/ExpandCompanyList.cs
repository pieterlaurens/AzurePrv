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
    public class ExpandCompanyList : Root
    {
        public ExpandCompanyList() {
            Header = new ConfigHeader
            {
                Creator = "NL\\Kwesseling", // Could this be the user account of the web user?
                /* 1. Change the name of the API */
                NameOfApi = PipelineNames.ExpandCompanyList,
                //NameOfApi = PipelineNames.SetManualScore,
            };
            ComponentParams = new List<ComponentParam>()
            {
                /* 2. Change the package name within the API */
                new ComponentParam{ PackageName = PackageName.MakeCompanySuggestion,
                    PositiveInstance = "",//deprecated
                    NegativeInstance = "",//deprecated
                    FocuslistName = "",//deprecated
                    CompanySuggestionParams = new MakeCompanySuggestionParams{
                        PositiveInstance = "",//pipe separated list of example companies to expand
                        NegativeInstance = "",//for later, do not use
                        FocuslistName = "",//name of focuslist to replace or create
                    }
                },
            };
        }

    }
    public class ExpandCompanyListSla : SLA
    {
        public ExpandCompanyListSla()
        {
            ComponentID = "D0E4F952-663C-42CA-89E8-318C931D42A9";
            RunID = "-1";
            PollEvery = "00:00:10";
            TimeOutAfter = "3600";

            // Below should all be retrieved from the project settings
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

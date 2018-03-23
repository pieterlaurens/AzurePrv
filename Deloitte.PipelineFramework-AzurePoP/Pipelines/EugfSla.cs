using Deloitte.PipelineFramework.PlatformConfig;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Deloitte.PipelineFramework.Pipelines
{
    /// <summary>
    /// The default SLA as used for the longlist and landscape pipelines.
    /// </summary>
    public class EugfSla : SLA
    {
        /// <summary>
        /// The constructor for the SLA configuration for the Longlist and Landscape pipeline.
        /// </summary>
        public EugfSla()
        {
            ComponentID = "D0E4F952-663C-42CA-89E8-318C931D42A9";
            RunID = "-1";
            PollEvery = "00:00:10";
            TimeOutAfter = "7200";
            PlatformDataSource = "nlagpdatacore";
            PlatformCatalog = "prv_dev_inh";
            DatahandlerDataSource = "NLAGPDATACORE";
            DatahandlerCatalog = "prv_dev_dth";
            DatahandlerVersion = "boris";
            ProjectDataSource = "nlagpdatacore";
            ProjectCatalog = "prv_e2e_it";
        }
    }
}

using Deloitte.PipelineFramework.PlatformConfig.Enums;
using Newtonsoft.Json;
using Newtonsoft.Json.Converters;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Deloitte.PipelineFramework.PlatformConfig.Params
{
    /// <summary>
    /// The parameters used by the GetKeywordProfile pipelines.
    /// </summary>
    public class CreatePrepareEnvironmentParams
    {
        /// <summary>
        /// Whether to append to an existing datamart. If set to false, any existing datamart by this name is dropped.
        /// </summary>
        public bool? Append { get; set; } = true;

        /// <summary>
        /// [NOT IMPLEMENTED] Whether to backup the datamart in its current form, prior to running this pipeline.
        /// </summary>
        public bool? Backup { get; set; } = false;

    }
}

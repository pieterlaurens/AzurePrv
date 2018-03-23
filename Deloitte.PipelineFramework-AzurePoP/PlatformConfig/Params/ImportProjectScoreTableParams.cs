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
    public class ImportProjectScoreTableParams : DeloitteObject
    {
        /// <summary>
        /// The location on a network share where the Excel (according to predefined structural requirements) resides.
        /// </summary>
        public string ExcelPath { get; set; }
    }
}

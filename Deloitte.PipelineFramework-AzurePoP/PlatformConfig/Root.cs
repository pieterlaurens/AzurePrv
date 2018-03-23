using Newtonsoft.Json;
using Newtonsoft.Json.Converters;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Deloitte.PipelineFramework.PlatformConfig
{
    /// <summary>
    /// Base construction that is the root of a json_config.
    /// <para>Use this class as the base to construct a configuration for a pipeline.</para>
    /// </summary>
    public class Root : DeloitteObject
    {
        /// <summary>
        /// Contains the metadata for the current configuration.
        /// </summary>
        public ConfigHeader Header { get; set; }

        /// <summary>
        /// The configuration objects for the individual components in the API workflow.
        /// </summary>
        public IEnumerable<ComponentParam> ComponentParams { get; set; }
    }
    
}

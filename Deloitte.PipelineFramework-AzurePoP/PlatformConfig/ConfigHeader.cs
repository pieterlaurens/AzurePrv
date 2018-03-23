using Deloitte.PipelineFramework.Pipelines;
using Newtonsoft.Json;
using Newtonsoft.Json.Converters;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Deloitte.PipelineFramework.PlatformConfig
{
    /// <summary>
    /// Contains the metadata for the current configuration.
    /// </summary>
    public class ConfigHeader : DeloitteObject
    {
        /// <summary>
        /// The creator of this configuration.
        /// </summary>
        public string Creator { get; set; }

        /// <summary>
        /// Date this configuration was created,
        /// </summary>
        public DateTime? CreationDate { get; set; }

        /// <summary>
        /// The version of the PlatformConfig framework that this configuration is based on
        /// </summary>
        public string BuildVersion { get; set; } // "1.001"

        /// <summary>
        /// The project id used in the website where this config was constructed.
        /// <para>It refers to an entry in the webserver database Registrator and 
        /// is needed when calling the ssisapi from the pipeline.</para>
        /// </summary>
        public int? ProjectId { get; set; }

        /// <summary>
        /// When launching a pipeline from a website, the pipeline communicates to
        /// a centralized api endpoint. By sending this is, the api knows what run
        /// we are talking about.
        /// </summary>
        public int? SsisApiRunId { get; set; }

        /// <summary>
        /// The name of the set of components.
        /// </summary>
        [JsonConverter(typeof(StringEnumConverter))]
        public PipelineNames NameOfApi { get; set; }

        /// <summary>
        /// Some extra details about the deliverable this configuration belongs to.
        /// </summary>
        public string ConfigurationDescription { get; set; }

        /// <summary>
        /// Manual entry point to keep track of different versions.
        /// <para>For example every time a pipeline is launched from a website.</para>
        /// </summary>
        public string ConfigurationVersion { get; set; }

    }
}

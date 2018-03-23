using Deloitte.PipelineFramework.PlatformConfig.Enums;
using Newtonsoft.Json;
using Newtonsoft.Json.Converters;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Deloitte.PipelineFramework.PlatformConfig.Params
{
    /// <summary>
    /// Configuration object for the component that retrieves nodes for a landscape.
    /// </summary>
    public class NodeSelectionParam : DeloitteObject
    {
        /// <summary>
        /// The label by which the retrieved nodes can be identified.
        /// </summary>
        [JsonConverter(typeof(StringEnumConverter))]
        [Required]
        public NodeSelectionType NodeSelectionType { get; set; }
        /// <summary>
        /// The label of this way of selecting. Currently only NodeList is available.
        /// </summary>
        [Required]
        public string NodeSelectionLabel { get; set; }
        /// <summary>
        /// The list of nodes to be added, pipe-separated
        /// </summary>
        public string NodeList { get; set; }
    }
}

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
    /// Configuration object for the ID Resolving component that loads files from disk (network share) to database.
    /// The files specified should contain output from the Orbis Matching Software, and contain the 'default' columns.
    /// </summary>
    public class ImportMatchingSoftwareFileParams : DeloitteObject
    {
        /// <summary>
        /// Folder to load the specified file from
        /// </summary>
        public string Folder { get; set; }

        /// <summary>
        /// File to load
        /// </summary>
        public string Filename { get; set; }

        /// <summary>
        /// Destination database schema to (re-)create the destination table
        /// </summary>
        public string DestinationSchema { get; set; }

        /// <summary>
        /// Destination database table to load the specified file to
        /// </summary>
        public string DestinationTable { get; set; }
    }
}

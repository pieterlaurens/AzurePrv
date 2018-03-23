using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Deloitte.PipelineFramework.PlatformConfig
{
    /// <summary>
    /// Container for the Service Level Agreement in the revamped pipeline.
    /// </summary>
    public class SLA : DeloitteObject
    {
        /// <summary>
        /// 
        /// </summary>
        public string ComponentID { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public string RunID { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public string PollEvery { get; set; }
        
        /// <summary>
        /// 
        /// </summary>
        public string TimeOutAfter { get; set; }

        /// <summary>
        /// The server of the datastore that holds the information about 
        /// running and executing pipelines.
        /// </summary>
        public string PlatformDataSource { get; set; }

        /// <summary>
        /// The database that holds the information about running and 
        /// executing pipelines.
        /// </summary>
        public string PlatformCatalog { get; set; }

        /// <summary>
        /// The server where the Datahandler Views reside.
        /// </summary>
        public string DatahandlerDataSource { get; set; }
        
        /// <summary>
        /// A database filled with handy Views.
        /// </summary>
        public string DatahandlerCatalog { get; set; }

        /// <summary>
        /// Refers to a subset of sql Views that are prefixed with this setting.
        /// </summary>
        public string DatahandlerVersion { get; set; }

        /// <summary>
        /// The server where project data is located.
        /// </summary>
        public string ProjectDataSource { get; set; }

        /// <summary>
        /// The project database.
        /// </summary>
        public string ProjectCatalog { get; set; }
    }
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Deloitte.PipelineFramework.PlatformConfig.Params
{
    /// <summary>
    /// Container for the configuration for adding & scoring extra risk texts.
    /// The procedure should execute a query with a FROM composed of the properties below.
    /// SELECT *
    /// FROM [RiskTextHost].[RiskTextDb].[RiskTextTable]
    /// WHERE Processed = 0
    /// </summary>
    public class ScoreRiskTextParams
    {
        /// <summary>
        /// The database to store and handle the new risk text.
        /// </summary>
        public string DestDbName { get; set; }
        
        /// <summary>
        /// The server where the risk texts are stored.
        /// </summary>
        public string RiskTextHost { get; set; }
        
        /// <summary>
        /// The database where the risk texts are stored.
        /// </summary>
        public string RiskTextDb { get; set; }
        
        /// <summary>
        /// The table where the risk texts are stored.
        /// </summary>
        public string RiskTextTable { get; set; }
    }
}

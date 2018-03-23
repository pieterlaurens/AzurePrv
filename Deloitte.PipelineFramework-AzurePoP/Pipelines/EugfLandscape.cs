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
    /// <summary>
    /// Standard configuration for the CreateLandscape api.
    /// <para>Could be used as a startingpoint: instantiate this class, update 
    /// some values and send as json_config to the pipeline.</para>
    /// </summary>
    public class EugfLandscape : Root
    {
        /// <summary>
        /// Instantiate and prefill a json_config (Root).
        /// </summary>
        public EugfLandscape() 
        {
            Header = new ConfigHeader
            {
                Creator = "Website",
                CreationDate = DateTime.Now,
                NameOfApi = PipelineNames.CreateLandscape,
                ConfigurationDescription = "Create data for landscapes for EUGF.",
                BuildVersion = "3_0_0",
            };
            ComponentParams = new List<ComponentParam>()
            {
                new ComponentParam{ PackageName = PackageName.CreatePrepareEnvironment, },
                new ComponentParam{ PackageName = PackageName.SelectLandscapeNodes },
                new ComponentParam{ PackageName = PackageName.ScoreLandscapeNodes },
                new ComponentParam{ PackageName = PackageName.GetNodeProperties, 
                    GetNodePropertiesParams = new List<GetNodePropertiesParam>() {
                        new GetNodePropertiesParam{PropertyLabel = "Label", PropertyMethod = "TechnologyClassLabel" },
                        new GetNodePropertiesParam{PropertyLabel = "Extended Label", PropertyMethod = "TechnologyClassExtendedLabel" },
                        new GetNodePropertiesParam{PropertyLabel = "Size", PropertyMethod = "TechnologyClassSize" },
                        //new GetNodePropertiesParam{PropertyLabel = "Trend", PropertyMethod = "TechnologyTrendRelativeToLandscape" },
                        new GetNodePropertiesParam{PropertyLabel = "Trend", PropertyMethod = "TechnologyTrend", PropertyParameters = "aggww" },
                        new GetNodePropertiesParam{PropertyLabel = "Technology Class", PropertyMethod = "NodeId" },
                    }
                },
                new ComponentParam{ PackageName = PackageName.CalculateLandscapeDistances, },
                new ComponentParam{ PackageName = PackageName.ApproximateDistanceIn2D, 
                    NormalizeDistance = "none",
                    RandomSeed = 0,
                    MaxIterations = 100,
                    Algorithm = MdsAlgorithm.MatlabMds,
                },
                new ComponentParam{ PackageName = PackageName.PrepareForVisualization, },
            };

        }
    }
}

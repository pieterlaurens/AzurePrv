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
    /// Standard configuration for the CreateLonglist api.
    /// <para>Could be used as a startingpoint: instantiate this class, update 
    /// some values and send as json_config to the pipeline.</para>
    /// </summary>
    public class EugfLonglist : Root
    {
        /// <summary>
        /// Instantiate and prefill a json_config (Root).
        /// </summary>
        public EugfLonglist() 
        {
            Header = new ConfigHeader
            {
                Creator = "Website",
                CreationDate = DateTime.Now,
                NameOfApi = PipelineNames.CreateLonglist,
                ConfigurationDescription = "Create data for longlists for EUGF.",
                BuildVersion = "3_0_0",
            };
            ComponentParams = new List<ComponentParam>() {
                new ComponentParam{ PackageName = PackageName.CreatePrepareEnvironment },
                new ComponentParam{ PackageName = PackageName.CompanyRetrieval},
                new ComponentParam{ PackageName = PackageName.CompanyScoring,
                    ScoringParams = new List<ScoringParam>() {
                        new ScoringParam{ 
                            ScoringType = CompanyScoringType.OrbisAttribute, 
                            ScoringLabel = "Country", 
                            AttributeName = "country",
                        },
                        new ScoringParam{ 
                            ScoringType = CompanyScoringType.OrbisAttribute, 
                            ScoringLabel = "Company category", 
                            AttributeName = "company_category",
                        },
                        /* Currently too slow to function. PL, 2016/3/25
                         * new ScoringParam{ 
                            ScoringType = CompanyScoringType.OrbisAggregateAttribute, 
                            ScoringLabel = "Revenue", 
                            AttributeName = "revenue",
                        },
                        new ScoringParam{ 
                            ScoringType = CompanyScoringType.OrbisAggregateAttribute, 
                            ScoringLabel = "Employees", 
                            AttributeName = "employees",
                        },*/
                        new ScoringParam{ 
                            ScoringType = CompanyScoringType.OrbisAttribute, 
                            ScoringLabel = "Number of Patents", 
                            AttributeName = "number_of_patents",
                        },
                        new ScoringParam{ 
                            ScoringType = CompanyScoringType.IndustryAttribute, 
                            ScoringLabel = "Industry", 
                        }
                    }
                },
                new ComponentParam{ PackageName = PackageName.PrepareForVisualization },
            };
        }
    }
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Deloitte.PipelineFramework.PlatformConfig.Params
{
    public class LoadIndustriesParams
    {
        public string NaceDataSource { get; set; }
        public string NaceCatalog { get; set; }
        public bool? TruncateBeforeLoad { get; set; }
    }
}

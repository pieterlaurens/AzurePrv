using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Deloitte.PipelineFramework.PlatformConfig.Params
{
    public class CreateStatsParams
    {
        public string DestDbName { get; set; }
        public string PublishDataSource { get; set; }
        public string PublishCatalog { get; set; }
        public int? TrendEndYear { get; set; }
        public int? TrendStartYear { get; set; }
        public double? StableTrendThreshold { get; set; }
        public bool? Debug { get; set; }
        public string CompanyIdList { get; set; }
        public string GroupName { get; set; }
        public string GroupDescription { get; set; }
    }
}

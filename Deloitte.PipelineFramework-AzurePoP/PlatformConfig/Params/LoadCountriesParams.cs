using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Deloitte.PipelineFramework.PlatformConfig.Params
{
    public class LoadCountriesParams
    {
        public string CountryDataSource { get; set; }
        public string CountryCatalog { get; set; }
        public bool? TruncateBeforeLoad { get; set; }
    }
}

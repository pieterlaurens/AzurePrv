using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Deloitte.PipelineFramework.PlatformConfig.Params
{
    public class LoadCalendarParams
    {
        public int? CalendarEndYear { get; set; }
        public int? CalendarStartYear { get; set; }
        public bool? TruncateBeforeLoad { get; set; }
    }
}

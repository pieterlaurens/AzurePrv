using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Deloitte.PipelineFramework.PlatformConfig.Params
{
    public class MakeCompanySuggestionParams
    {
        /// <summary>
        /// A pipe seperated list of company IDs that serve as the positive instances; for which similar ones need to be suggested.
        /// </summary>
        public string PositiveInstance { get; set; }

        /// <summary>
        /// A pipe seperated list of company IDs that serve as the negative instances
        /// </summary>
        public string NegativeInstance { get; set; }

        /// <summary>
        /// The name of the focuslist to replace or create.
        /// </summary>
        public string FocuslistName { get; set; }

    }
}

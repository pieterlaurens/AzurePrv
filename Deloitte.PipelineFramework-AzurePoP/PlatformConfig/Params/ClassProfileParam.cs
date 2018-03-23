using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Deloitte.PipelineFramework.PlatformConfig.Params
{
    /// <summary>
    /// Single identifier/weight pair for the ClassProfiles property in <see cref="RetrievalParam"/>.
    /// </summary>
    public class ClassProfileParam
    {
        /// <summary>
        /// Identifier of the Class. String to allow for using the business key. In the case of CPC codes, 'A21B 02/01'.
        /// </summary>
        public string Identifier { get; set; }

        /// <summary>
        /// The weight assigned to the class. Used in calculating the inner product with other profiles.
        /// </summary>
        public double Weight { get; set; }
    }
}

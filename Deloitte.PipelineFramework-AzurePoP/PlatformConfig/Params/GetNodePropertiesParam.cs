using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Deloitte.PipelineFramework.PlatformConfig.Params
{
    /// <summary>
    /// Configuration object for the component that retrieves and calculates properties for nodes in a landscape. Typically part of a list that represents the various attributes for nodes.
    /// </summary>
    public class GetNodePropertiesParam : DeloitteObject
    {
        /// <summary>
        /// The label by which this property will be available.
        /// </summary>
        public string PropertyLabel { get; set; }

        /// <summary>
        /// The method of determining the value for each node in the landscape of this property. Which property is concerned is set by PropertyLabel. Methods include
        /// - TechnologyClassLabel: A brief technology label
        /// - TechnologyClassExtendedLabel: The long description of the technology
        /// - TechnologyClassSize: The size of the technology
        /// - NodeId: The technology Code (A12B 34/56)
        /// - HighLevelTechnologyLabel: A grouping label for points that are similar
        /// - TechnologyTrend: The trend in each technology class
        /// </summary>
        public string PropertyMethod { get; set; }

        /// <summary>
        /// Separate properties passed to the method. Properties are pipe-separated, and each property has a key:value style. Specific cases for PropertyMethod include
        /// HighLevelTechnologyLabel: B33:Additive manufacturing|A61:Health to obtain the blue label 'Additive manufacturing' at the average of the x,y location of all points in classes starting with B33.
        /// TechnologyTrend has 4 options
        /// - clsww: considering the number of patents in the class itself, relative to the worldwide trends
        /// - aggww: considering the number of patents in the class and all its children, relative to the worldwide trends
        /// - clsls: considering the number of patents in the class itself, relative to the other classes in the landscape
        /// - aggls: considering the number of patents in the class and all its children, relative to the other classes in the landscape
        /// </summary>
        public string PropertyParameters { get; set; }
    }

}

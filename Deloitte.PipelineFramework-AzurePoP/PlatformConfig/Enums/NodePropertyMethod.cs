using System;

namespace Deloitte.PipelineFramework.PlatformConfig.Enums
{
    /// <summary>
    /// The method of determining the value for each node in the landscape of this property. Which property it is about is set in a separate configuration entry.
    /// </summary>
    public enum NodePropertyMethod
    {
        /// <summary>
        /// The label of a technology class
        /// </summary>
        TechnologyClassLabel,
        /// <summary>
        /// The extended label of a technology class
        /// </summary>
        TechnologyClassExtendedLabel,
        /// <summary>
        /// The number of patent families in the class
        /// </summary>
        TechnologyClassSize,
        /// <summary>
        /// The business key, for a technology class the actual CPC code.
        /// </summary>
        NodeId,
        /// <summary>
        /// Deprecated: The trend of activity in the node, relative to the rest of the landscape
        /// </summary>
        TechnologyTrendRelativeToLandscape,
        /// <summary>
        /// The trend of activity in the node. Requires setting of PropertyParameters as aggls, aggww, clsls or clsww indicating whether to calculate the trend relative to the landscape, or all technologies (ls/ww) and whether to use filings in each class alone or also including its subclasses (cls/agg).
        /// </summary>
        TechnologyTrend,
        /// <summary>
        /// A high-level label for each class. Used to draw regions in the landscape.
        /// </summary>
        HighLevelTechnologyLabel
    }
}

using System;

namespace Deloitte.PipelineFramework.PayloadTypes
{
    /// <summary>
    /// Helper class to mark nodes in a landscape.
    /// </summary>
    public class LandscapeNodeMarker
    {
        /// <summary>
        /// Should correspond with the PointsToPlot_ID used when creating the nodes.
        /// </summary>
        public string NodeId { get; set; }
        /// <summary>
        /// Will influence the size of the marker.
        /// </summary>
        public double NodeSize { get; set; }
        /// <summary>
        /// Will set the color of the marker. May be null.
        /// </summary>
        public string Color { get; set; }
    }
}

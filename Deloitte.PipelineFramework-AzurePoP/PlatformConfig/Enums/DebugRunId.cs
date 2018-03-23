using System;

namespace Deloitte.PipelineFramework.PlatformConfig.Enums
{
    /// <summary>
    /// Run IDs with valid configurations available at deployment of the solution. These can be used to unit test 
    /// individual components, or to integration test individual APIs.
    /// </summary>
    public enum DebugRunId
    {
        /// <summary>
        /// Longlist functionality
        /// </summary>
        Longlistv2 = -1,
        /// <summary>
        /// Landscape functionality
        /// </summary>
        Landscapev2 = -2,
        /// <summary>
        /// Publish Matlab resources
        /// </summary>
        PublishMatlabResources = -3,
        /// <summary>
        /// Add a new score to an existing longlist
        /// </summary>
        AddScoreToLonglist = -4,
        /// <summary>
        /// Recalculate the scores and properties for the nodes in a landscape
        /// </summary>
        RescoreLandscape = -5,
        /// <summary>
        /// A single dummy component for end-to-end testing from the web server
        /// </summary>
        TestEndToEnd = -6
    }
}

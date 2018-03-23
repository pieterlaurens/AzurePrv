using System;

namespace Deloitte.PipelineFramework.PlatformConfig.Enums
{
    /// <summary>
    /// Indices available on Elastic search
    ///     , with corresponding description sets in TopicDb
    /// </summary>
    public enum DocumentSelectionType
    {
        SecFilings,
        AnnualReports,
        ManualInput,
        Web,
    }
}

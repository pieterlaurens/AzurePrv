using System;

namespace Deloitte.PipelineFramework.PlatformConfig.Enums
{
    /// <summary>
    /// Deal types found in the strategic datamart [sdd]
    ///  , views [deal_overview].[deal_status_engine]
    /// </summary>
    public enum DealStatus
    {
        Announced,
        Completed,
        Pending,
        Postponed,
        Rumour,
        Unconditional,
        Withdrawn,
    }
}

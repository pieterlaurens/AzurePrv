using System;

namespace Deloitte.PipelineFramework.PlatformConfig.Enums
{
    /// <summary>
    /// The algorithm used for scoring based on existing scores. Currently the options allow creating baskets of score values.
    /// </summary>
    public enum CompanyScoreGroupingType
    {
        /// <summary>
        /// For numeric scores, the score groups will correspond to ideally baskets with comparable numbers of values (unless when there's many identical values)
        /// </summary>
        Percentiles,

        /// <summary>
        /// For numeric scores, the score groups will contain items larger than or equal to the first bound, and smaller than the second bound. For n bounds, there will be n+1 baskets. Where the first basket contains elements smaller than the first bound, and the last basket contains items larger than or equal to the largest bound.
        /// </summary>
        CustomBasketBounds,

        /// <summary>
        /// For categorical/string and numeric scores, score groups represent the values in that basket. For instance, it can be used to group country codes in regions. Values not covered are put in a basket 'Other'.
        /// </summary>
        CustomBasketValues
    }

}

using System;

namespace Deloitte.PipelineFramework.PlatformConfig.Enums
{
    /// <summary>
    /// The algorithm used to score landscape nodes.
    /// </summary>
    public enum NodeScoringType
    {
        /// <summary>
        /// How many patents does a company have in each class?
        /// </summary>
        CompanyPortfolio,
        /// <summary>
        /// How often is the subject of this bag mentioned in each class?
        /// </summary>
        BagOfWords,
        /// <summary>
        /// How often is this topic mentioned in each class?
        /// </summary>
        TopicScore,
        /// <summary>
        /// How often is the landscape node (/class) co-occurring on a patent with the classes mentioned in this bag??
        /// </summary>
        BagOfClasses,
        /// <summary>
        /// How many patents, mentioning a subject, does a company have in each class? [not yet available]
        /// </summary>
        CompanyPortfolioBagOfWords,
    }
}

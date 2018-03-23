using System;

namespace Deloitte.PipelineFramework.PlatformConfig.Enums
{
    /// <summary>
    /// The item represents the algorithm used for retrieving companies.
    /// </summary>
    public enum CompanyRetrievalType
    {
        /// <summary>
        /// List of company IDs; forced companies.
        /// </summary>
        CompanyList,
        /// <summary>
        /// Based on the words used in their company description
        /// </summary>
        CompanyTextBagOfWords,
        /// <summary>
        /// Based on a weighted bag of patent classes.
        /// </summary>
        PatentClassProfile,
        /// <summary>
        /// Retrieving all companies in an industry. Using Constraints in the configuration can further restrict this selection [not implemented]
        /// </summary>
        IndustryClassBag,
        /// <summary>
        /// Retrieving all companies in one or a set of regions. Typically SPS functionality. [not implemented]
        /// </summary>
        NutsRegionBag,
        /// <summary>
        /// A score as the sum of all its underlying documents from ES.
        /// </summary>
        TopicScore,
        /// <summary>
        /// Constraints on company basic in the form "attributea:val1,val2|attributeb:val3,val4"
        /// </summary>
        BasicConstraints
    }
}

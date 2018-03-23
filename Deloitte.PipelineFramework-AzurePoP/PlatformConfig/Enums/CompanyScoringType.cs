using System;

namespace Deloitte.PipelineFramework.PlatformConfig.Enums
{
    /// <summary>
    /// The algorithm used for scoring companies.
    /// </summary>
    public enum CompanyScoringType
    {
        /// <summary>
        /// An attribute from the company_basic table
        /// </summary>
        OrbisAttribute,
        /// <summary>
        /// An attribute that assumes a value over time (financial, or financial ratio); not currently visualized in the front-end
        /// </summary>
        OrbisTemporalAttribute,
        /// <summary>
        /// An aggregated attribute from the _basic, financial_ratio or _financial table.
        /// </summary>
        OrbisAggregateAttribute,
        /// <summary>
        /// Company's text attributes (web text, trade description etc.) scored on an AND/OR bag of words
        /// </summary>
        CompanyTextBagOfWords,
        /// <summary>
        /// Company portfolio scored on a weighted bag of patent classes
        /// </summary>
        PatentClassProfile,
        /// <summary>
        /// An industry attribute such as NACE description at a particular level of aggregation.
        /// </summary>
        IndustryAttribute,
        /// <summary>
        /// A manually assigned score or classification. Particularly used in 'rescoring' API.
        /// </summary>
        ManualScore,
        /// <summary>~
        /// A score as the sum of all its underlying documents from ES.
        /// </summary>
        TopicScore,
        /// <summary>
        /// An attribute (i.e. lookup) that changes over time. Time for these attributes is governed by the calendar object.
        /// </summary>
        TemporalAttribute
    }
}

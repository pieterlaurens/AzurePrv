using System;

namespace Deloitte.PipelineFramework.PlatformConfig.Enums
{
    /// <summary>
    /// The types of projects that the datamarts can be visualized for. Components to execute ProjectType specific functionality 
    /// is in general undesirable; it is prefered to implement the differences between types as configurational differences and
    /// implement those configurations in the Templates <seealso cref="Deloitte.PipelineFramework.Pipelines.EugfLandscape"/>, 
    /// <seealso cref="Deloitte.PipelineFramework.Pipelines.EugfLonglist"/>. For visualization it proved inevitable to make several 
    /// ProjectType specific execution paths.
    /// </summary>
    public enum ProfileType
    {
        /// <summary>
        /// Map a Bag of Words to a bag of CPC classes, based on patents in those CPC classes that mention the words in the bag of Words.
        /// </summary>
        BowToCpc,

        /// <summary>
        /// Map a Company name (or part of a name) to a bag of CPC classes, based on the patents in the company's portfolio
        /// </summary>
        CompanyNameToCpc,
    }
}

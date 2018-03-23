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
    public enum ProjectType
    {
        /// <summary>
        /// Projects run entirely by the RD&amp;I team at tax, making use of Engine tooling.
        /// </summary>
        Eugf,

        /// <summary>
        /// Projects run entirely by the FAS team, making use of Engine tooling.
        /// </summary>
        FastVentures,

        /// <summary>
        /// Projects executed by the US consulting practice, supported by the Engine team.
        /// </summary>
        Equip,

        /// <summary>
        /// Projects executed by Edith with hands-on support from the Engine team.
        /// </summary>
        Sps,

        /// <summary>
        /// The projects the Engine team does for clients.
        /// </summary>
        EngineClientProject,

        /// <summary>
        /// Projects that generate PDF reports.
        /// </summary>
        PdfReport,

        /// <summary>
        /// Projects that generate PDF reports.
        /// </summary>
        IdResolving,
    }
}

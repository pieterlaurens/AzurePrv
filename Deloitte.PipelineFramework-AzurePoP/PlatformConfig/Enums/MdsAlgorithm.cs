using System;

namespace Deloitte.PipelineFramework.PlatformConfig.Enums
{
    /// <summary>
    /// Algorithms available for transforming distances to positions in two dimensions.
    /// </summary>
    public enum MdsAlgorithm
    {
        /// <summary>
        /// this method is not dependent on MCR and other DLLs. Primarily for testing purposes.
        /// </summary>
        Random,
        /// <summary>
        /// Matlab's own (Statistical Toolbox) mdscale() command. For reference,
        /// it executes mdscale(dist,2,'options',opts,'criterion','stress','start','cmdscale','replicates',10)
        /// </summary>
        MatlabMds,
        /// <summary>
        /// tSNE is a Stanford library for network analysis. [Not yet implemented.]
        /// </summary>
        tSne
    }
}

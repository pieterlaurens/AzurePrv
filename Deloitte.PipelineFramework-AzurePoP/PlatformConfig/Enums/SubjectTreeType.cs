using System;

namespace Deloitte.PipelineFramework.PlatformConfig.Enums
{
    /// <summary>
    ///  Defines different perspectives used in the Webshop FocusReports
    /// </summary>
    public enum SubjectTreeType
    {
        /// <summary>
        /// Perspective on the Deloitte Risk Intelligence Map, https://global.deloitteresources.com/Services/ggrm/Pages/The_RiskIntelligenceMap.aspx
        /// </summary>
        Risk_Intelligence_Map,
        /// <summary>
        /// Perspective on the Deloitte Enterprise Value Map, https://consulting.deloitteresources.com/sandd/cmt/enablingtools/Pages/evm.aspx
        /// </summary>
        Shareholder_Value_Map,
        /// <summary>
        /// Perspective on the Deloitte Enterprise Value Map, https://consulting.deloitteresources.com/sandd/cmt/enablingtools/Pages/evm.aspx
        /// </summary>
        Business_Process_Grouping,
        /// <summary>
        /// Nace Industry Classification, http://www.cso.ie/px/u/NACECoder/NACEItems/searchnace.asp
        /// </summary>
        Nace_Industry_Classification,
        /// <summary>
        ///  CPC Patent classification, https://www.epo.org/searching-for-patents/helpful-resources/first-time-here/classification/cpc.html
        /// </summary>
        Cooperative_Patent_Classification
    }
}

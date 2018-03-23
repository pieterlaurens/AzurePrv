using Deloitte.PipelineFramework.PlatformConfig;
using Deloitte.PipelineFramework.PlatformConfig.Enums;
using Deloitte.PipelineFramework.PlatformConfig.Params;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Deloitte.PipelineFramework.Pipelines
{
    /// <summary>
    /// The template configuration for adding a score, annotation or classification to the longlist.
    /// </summary>
    public class ClassifyCompanies : Root
    {
        /// <summary>
        /// Cosntructor for the configuration for adding a score to the longlist (or an annotation or a classification)
        /// </summary>
        public ClassifyCompanies()
        {
            Header = new ConfigHeader
            {
                Creator = "NL\\Kwesseling", // Could this be the user account of the web user?
                /* 1. Change the name of the API */
                NameOfApi = PipelineNames.AddScoreToLonglist,
                //NameOfApi = PipelineNames.SetManualScore,
            };
            ComponentParams = new List<ComponentParam>()
            {
                /* 2. Change the package name within the API */
                new ComponentParam{ PackageName = PackageName.CompanyScoring,
                //new ComponentParam{ PackageName = PackageName.CompanyScoringSynchronous,
                    ScoringParams = new List<ScoringParam>() {
                        new ScoringParam{ 
                            ScoringType = CompanyScoringType.ManualScore,
		                    ScoringLabel = "Value Chain Position", //web configuration which scores/annotations/classifications are available.
		                    ScoreDataType = "nvarchar",// linked to scoring label; all of one score label need to be the same type. Currently, can be real and nvarchar.
                            // Add company classification here!
                            // e.g. "CompanyScore" : "CHCHE107136256:Raw Materials|CHCHE110110814:Design IP|CN30081PC:Raw Materials|CN9360000140:Design IP|DE2010000581:Software|DE2010000581:Printers|DE2270172157:Printers|DE2270172157:Raw Materials|DE4070280762:Raw Materials|DE4290178888:Printers|DE5330000056:Raw Materials|DE7150000030:Raw Materials|DE7230336659:Printers|DE7330593711:Printers|DE8030366267:Printers|DE8030366267:Raw Materials|DK32365590:Printers|FR41028670200056:Raw Materials|FR443645551:Printers|FR443645551:Software|FR445074685:Raw Materials|FR49956881400051:Printers|FR49956881400051:Software|FR49956881400051:Raw Materials|GB01106260:Printers|GB01106260:Raw Materials|GB03903306:Raw Materials|GB03903306:Software|GB03903306:Printers|IE389190:Printers|IL31714NU:Printers|IL31714NU:Software|IL31714NU:Raw Materials|ITMN0149665:Printers|ITMO0379518:Raw Materials|JP000020437JPN:Printers|JP000030720JPN:Printers|JP000030797JPN:Raw Materials|JP000090035JPN:Raw Materials|JP042747717S:Printers|JP042747717S:Raw Materials|JP130856896S:Printers|JP558828617S:Printers|KR1601110122880-2:Printers|NL14076998:Raw Materials|NL14095340:Raw Materials|SE5562889401:Raw Materials|SE5565395356:Printers|US*1550089520:Printers|US060570975:Design IP|US140689340:Printers|US222640650:Design IP|US222640650:Software|US461684608:Printers|US461684608:Raw Materials|US942802192:Software"
                        }
                    }
                },
                /* 3. Disable the Prepare for visualization configuration */
                new ComponentParam{ PackageName = PackageName.PrepareForVisualization }
                // 
            };
        }
    }

    /// <summary>
    /// The SLA as used for the Add score to longlist Profile component.
    /// </summary>
    public class ClassifyCompaniesSla : SLA
    {
        public ClassifyCompaniesSla()
        {
            ComponentID = "D0E4F952-663C-42CA-89E8-318C931D42A9";
            RunID = "-1";
            PollEvery = "00:00:10";
            TimeOutAfter = "3600";
            
            // Below should all be retrieved from the project settings
            PlatformDataSource = "nlagpdatacore";
            PlatformCatalog = "prv_dev_inh";
            DatahandlerDataSource = "nlagpdatacore";
            DatahandlerCatalog = "prv_dev_dth";
            DatahandlerVersion = "felix";
            ProjectDataSource = "nlagpdatacore";
            ProjectCatalog = "prv_prj_testdeploy";
        }
    }
}

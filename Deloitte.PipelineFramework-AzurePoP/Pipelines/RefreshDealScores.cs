﻿using Deloitte.PipelineFramework.PlatformConfig;
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
    /// With a lot of SEC filings with counts for terms (i.e. scores). This pipeline calculates 
    /// statistics per company, category and year. The statistics are used in the web report of 
    /// Governance Box.
    /// </summary>
    public class RefreshDealScores : Root
    {

        public string PrepareDbForTest = @"
											WITH random_companies (CompanyId)
											AS
                                            ( SELECT TOP 10 T2.CompanyId
                                                FROM [result].[FactDealScore]  T1
												INNER JOIN [result].[DimCompany] T2 ON T2.CompanyId = T1.CompanyId
                                                ORDER BY HASHBYTES('md5',cast(T2.CompanyId+31 as varchar)) DESC
                                             )

                                            DELETE FROM [result].[FactDealScore]
											WHERE CompanyId IN ( SELECT CompanyId FROM random_companies );
                                            ";

        /// <summary>
        /// With a lot of SEC filings with counts for terms (i.e. scores). This pipeline calculates 
        /// statistics per company, category and year. The statistics are used in the web report of 
        /// Governance Box.
        /// </summary>
        public RefreshDealScores()
        {
            Header = new ConfigHeader
            {
                Creator = "ReportWebsite",
                NameOfApi = PipelineNames.RefreshDealScores,
            };
            ComponentParams = new List<ComponentParam>()
            {
                new ComponentParam{ PackageName = PackageName.LoadDealScores,
                    ProjectType = PlatformConfig.Enums.ProjectType.PdfReport,
                    LoadDealScoresParams = new LoadDealScoresParams{
                        CompanyOwnershipCatalog = "company_ownership",
                        CompanyOwnershipDataSource = "NLAGPDATACORE",
                        DealsCatalog = "sdd",
                        DealsDataSource = "NLAGPDATACORE",
                        IndustryLevelsToCalculate = "0|1|2|3",
                        MinimumVarianceForTrendChange = 3.0,
                        DealStatusToLoad = "Completed",
                        DealTypesToLoad = "Acquisition|Demerger|Merger|Minority stake|Joint venture",
                        SubjectLevelsToCalculate = "0|1|2|3|4",
                        TrendEndYear = 2016,
                        TrendStartYear = 2007,
                        TruncateBeforeLoad = false
                    } },
               new ComponentParam{ PackageName = PackageName.RefreshWebData,
                    ProjectType = PlatformConfig.Enums.ProjectType.PdfReport,
                    RefreshWebDataParams = new RefreshWebDataParams{
                        IndustryLevelsToPublish = "0|1|2|3",
                        MinimumVarianceForTrendChange = 3.0,
                        PublishCatalog = "GovernanceBoxStats",
                        PublishDataSource = "NLAMS10859",
                        SubjectTreesToPublish = "Nace_Industry_Classification",
                        SubjectLevelsToPublish = "0|1|2",
                        TrendStartYear = 2012,
                        TrendEndYear = 2016,
                        TruncateBeforeLoad = true
                    } }
            };
        }
    }
    /// <summary>
    /// With a lot of SEC filings with counts for terms (i.e. scores). This pipeline calculates 
    /// statistics per company, category and year. The statistics are used in the web report of 
    /// Governance Box.
    /// </summary>
    public class RefreshDealScoresSla : SLA
    {
        /// <summary>
        /// With a lot of SEC filings with counts for terms (i.e. scores). This pipeline calculates 
        /// statistics per company, category and year. The statistics are used in the web report of 
        /// Governance Box.
        /// </summary>
        public RefreshDealScoresSla()
        {
            RunID = "-1";
            PollEvery = "00:00:10";
            TimeOutAfter = "3600";
            PlatformDataSource = "nlagpdatacore";
            PlatformCatalog = "prv_dev_inh";
            DatahandlerDataSource = "nlagpdatacore";
            DatahandlerCatalog = "prv_dev_dth";
            DatahandlerVersion = "latest";
            ProjectDataSource = "nlams10859";
            ProjectCatalog = "GovernanceBox";
            ComponentID = "D0E4F952-663C-42CA-89E8-318C931D42A1";
        }
    }
}

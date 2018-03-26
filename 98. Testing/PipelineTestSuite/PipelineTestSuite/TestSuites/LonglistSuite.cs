using Newtonsoft.Json;
using Deloitte.PipelineFramework;
using Deloitte.PipelineFramework.Pipelines;
using Deloitte.PipelineFramework.PlatformConfig.Enums;
using Deloitte.PipelineFramework.PlatformConfig.Params;
using Deloitte.PipelineFramework.PlatformConfig;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;

namespace PipelineTestSuite.TestSuites
{
    public class LonglistSuite : BaseSuite
    {
        private static List<string> LonglistObjects = new List<string>()
        {
            // Views
            "DEF_COLUMN_GROUPS"
            ,"DEF_COMPANYLONGLIST_FILTERS"
            ,"DEF_OBJECTNAMES_WEB"
            // Tables
            ,"focus_list"
            ,"DIM_COMPANYLONGLIST_WEB"
            // Stored procedures
            ,"web_getLonglistHistograms"
            ,"web_getLonglistStats"
        };
        private static List<string> MatlabObjects = new List<string>()
        {
            // Tables
            "matlab_in.company_data"
            ,"matlab_in.ff_factor"
        };

        #region BaseSuite implementation
        protected override async Task RunTests(Root json)
        {
            switch (json.Header.NameOfApi)
            {
                case PipelineNames.CreateLonglist:
                    await AllRetrievalsReturnCompanies(json.ComponentParams.FirstOrDefault(c => c.PackageName == PackageName.CompanyRetrieval).RetrievalParams);
                    await AllCompanyScoresProcessed(json.ComponentParams.FirstOrDefault(c => c.PackageName == PackageName.CompanyScoring).ScoringParams);
                    await AllCompanyScoresYieldResults(json.ComponentParams.FirstOrDefault(c => c.PackageName == PackageName.CompanyScoring).ScoringParams);
                    await NoScoresOutsideConfiguration(json.ComponentParams.FirstOrDefault(c => c.PackageName == PackageName.CompanyScoring).ScoringParams);
                    await DatabaseObjectsExist(LonglistObjects);
                    break;
                case PipelineNames.AddScoreToLonglist:
                    await AllCompanyScoresProcessed(json.ComponentParams.FirstOrDefault(c => c.PackageName == PackageName.CompanyScoring).ScoringParams);
                    await AllCompanyScoresYieldResults(json.ComponentParams.FirstOrDefault(c => c.PackageName == PackageName.CompanyScoring).ScoringParams);
                    await DatabaseObjectsExist(LonglistObjects);
                    break;
                case PipelineNames.PublishMatlabResources:
                    await DatabaseObjectsExist(MatlabObjects);
                    break;
                default:
                    break;
            }
            // Only execute when one of the Longlist APIs was called!
            Results.Add(new TestResult
            {
                Message = "All tests executed successfully",
                Name = "TestExecute",
                Success = true,
            });
        }

        #endregion

        #region test definitions
        private async Task AllCompanyScoresProcessed(IEnumerable<ScoringParam> sps)
        {
            foreach (ScoringParam sp in sps)
            {
                // 1. Score ends up in the company_score table
                using (var cmd = Db.CreateCommand())
                {
                    cmd.CommandText = @"select
                                                count(distinct score_id) as NumberOfScoresInTable
                                                , count(distinct c.ORDINAL_POSITION) + count(distinct ct.ORDINAL_POSITION) as NumberOfColumnsInEndResult
                                            from
                                                dbo.company_score cs LEFT OUTER JOIN
                                                (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'DIM_COMPANYLONGLIST_WEB') c ON c.COLUMN_NAME=cs.score_generic_name LEFT OUTER JOIN
                                                (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'DIM_COMPANYLONGLIST_TEMPORAL') ct ON ct.COLUMN_NAME=cs.score_label
                                            where
                                                score_label = @p1";
                    cmd.Parameters.AddWithValue("@p1", sp.ScoringLabel);

                    using (var reader = await cmd.ExecuteReaderAsync())
                    {
                        while (await reader.ReadAsync() && !Program.StopNow)
                        {
                            int ns = (int)reader["NumberOfScoresInTable"];
                            Results.Add(new TestResult
                            {
                                Message = String.Format("Encountered {2}{1} score{3} for [{0}].", sp.ScoringLabel, ns, ns == 1 ? "exactly " : "", ns == 1 ? "" : "s"),
                                Name = "CompanyScored",
                                Success = (ns == 1),
                            });
                            int nc = (int)reader["NumberOfColumnsInEndResult"];
                            Results.Add(new TestResult
                            {
                                Message = String.Format("Encountered {2}{1} column{3} for [{0}].", sp.ScoringLabel, nc, nc == 1 ? "exactly " : "", nc == 1 ? "" : "s"),
                                Name = "ScoreInEndResult",
                                Success = (nc == 1),
                            });
                        }
                    }
                }
            }
        }

        private async Task AllCompanyScoresYieldResults(IEnumerable<ScoringParam> sps)
        {
            foreach (ScoringParam sp in sps)
            {
                // 2. There are companies with non-zero values
                string scoreTable;
                switch (sp.ScoringType)
                {
                    case CompanyScoringType.CompanyTextBagOfWords:
                    case CompanyScoringType.PatentClassProfile:
                    case CompanyScoringType.TopicScore:
                        scoreTable = "company_score_real";
                        break;
                    case CompanyScoringType.IndustryAttribute:
                        scoreTable = "company_score_str";
                        break;
                    case CompanyScoringType.OrbisTemporalAttribute:
                        scoreTable = (sp.ScoreDataType == "real" ? "company_time_score_real" : scoreTable = "company_time_score_int");
                        break;
                    case CompanyScoringType.ManualScore:
                        scoreTable = (sp.ScoreDataType == "real" ? "company_score_real" : (sp.ScoreDataType == "nvarchar" ? scoreTable = "company_score_str" : scoreTable = "company_score_int"));
                        break;
                    case CompanyScoringType.OrbisAttribute:
                        scoreTable = "unknown";
                        break;
                    default:
                        scoreTable = "unknown";
                        break;
                }

                using (var cmd = Db.CreateCommand())
                {
                    if (scoreTable == "unknown")
                        cmd.CommandText = @"select
                                                count(distinct isnull(csr.company_id,isnull(csi.company_id,isnull(css.company_id,isnull(csrt.company_id,csit.company_id))))) as NumberOfScoredCompanies
                                            from
                                                (select @p1 as score_name) s LEFT OUTER JOIN
                                                company_score_real csr ON csr.score_name=s.score_name LEFT OUTER JOIN
                                                company_score_int csi ON csi.score_name=s.score_name LEFT OUTER JOIN
                                                company_score_str css ON css.score_name=s.score_name LEFT OUTER JOIN
                                                company_time_score_real csrt ON csrt.score_name=s.score_name LEFT OUTER JOIN
                                                company_time_score_int csit ON csit.score_name=s.score_name";
                    else
                        cmd.CommandText = @"select
                                                count(distinct company_id) as NumberOfScoredCompanies
                                            from
                                                " + scoreTable + @"
                                            where
                                                score_name=@p1";

                    cmd.Parameters.AddWithValue("@p1", sp.ScoringLabel);

                    using (var reader = await cmd.ExecuteReaderAsync())
                    {
                        while (await reader.ReadAsync() && !Program.StopNow)
                        {
                            int nc = (int)reader["NumberOfScoredCompanies"];
                            Results.Add(new TestResult
                            {
                                Message = String.Format("Encountered {1} score-values for [{0}].", sp.ScoringLabel, nc),
                                Name = "ScoresHaveValues",
                                Success = (nc > 0),
                            });
                        }
                    }
                }
            }
        }

        private async Task NoScoresOutsideConfiguration(IEnumerable<ScoringParam> sps)
        {
            // 3. Scores end up in the longlist table (post-processing)
            using (var cmd = Db.CreateCommand())
            {
                cmd.CommandText = @"select
	                                        cs.score_label
	                                        , c.column_name
                                            , isnull(cs.score_label,c.column_name) as either_column
                                        from
                                            dbo.company_score cs FULL OUTER JOIN
                                            (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'DIM_COMPANYLONGLIST_WEB' AND COLUMN_NAME not in ('companyPrimKey','companyDummyMeas','companyName')) c ON c.COLUMN_NAME=cs.score_generic_name";

                bool AllColumnsFromConfig = true;
                using (var reader = await cmd.ExecuteReaderAsync())
                {
                    while (await reader.ReadAsync() && !Program.StopNow)
                    {
                        string cl = (string)reader["score_label"];
                        if (sps.Count(c => c.ScoringLabel == cl) == 0)
                            AllColumnsFromConfig = false;
                    }
                }
                Results.Add(new TestResult
                {
                    Message = (AllColumnsFromConfig ? "All columns in datamart come from configuration" : "Some columns in the datamart have no origin in the configuration"),
                    Name = "AllColumnsFromConfig",
                    Success = AllColumnsFromConfig,
                });
            }
        }

        private async Task AllRetrievalsReturnCompanies(IEnumerable<RetrievalParam> rps)
        {
            foreach (RetrievalParam rp in rps)
            {
                using (var cmd = Db.CreateCommand())
                {
                    cmd.CommandText = "select count(distinct company_id) as NumberOfRetrievedCompanies from dbo.company_long_list where retrieval_key = @p1";
                    cmd.Parameters.AddWithValue("@p1", rp.RetrievalLabel);

                    using (var reader = await cmd.ExecuteReaderAsync())
                    {
                        while (await reader.ReadAsync() && !Program.StopNow)
                        {
                            int n = (int)reader["NumberOfRetrievedCompanies"];
                            Results.Add(new TestResult
                            {
                                Message = String.Format("Retrieved {1} companies for [{0}].",rp.RetrievalLabel,n),
                                Name = "CompanyRetrieved",
                                Success = (n>0),
                            });
                        }
                    }
                }
            }
        }
        #endregion
    }
}

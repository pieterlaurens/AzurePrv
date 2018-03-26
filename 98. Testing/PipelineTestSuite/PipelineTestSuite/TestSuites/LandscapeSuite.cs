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
    public class LandscapeSuite : BaseSuite
    {
        private static List<string> LandscapeObjects = new List<string>()
        {
            // Views
            "CONFIG_TABLE_1"
            ,"DIM_FRONTEND_VIEW_1"
            ,"FACT_POINTS_TO_DOWNLOAD"
            ,"FACT_POINTS_TO_PLOT_1"
            // Tables
            ,"series_properties"
            // Stored procedures
            ,"web_getIpcCompanies"
            ,"web_getIpcLatestCeDocuments"
        };

        #region BaseSuite implementation
        protected override async Task RunTests(Root json)
        {
            switch (json.Header.NameOfApi)
            {
                case PipelineNames.CreateLandscape:
                    //await AllNodesProcessed(json.ComponentParams.FirstOrDefault(c => c.PackageName == PackageName.SelectLandscapeNodes).NodeSelectionParams);
                    await AllNodeScoresComputed(json.ComponentParams.FirstOrDefault(c => c.PackageName == PackageName.ScoreLandscapeNodes).ScoreLandscapeNodesParams);
                    await AllNodesHaveAtLeastOneDistance();
                    await AllNodesHavePosition();
                    // await NodesPositionedAlgorithmicly(json.ComponentParams.FirstOrDefault(c => c.PackageName == PackageName.ApproximateDistanceIn2D));
                    await AllNodePropertiesComputed(json.ComponentParams.FirstOrDefault(c => c.PackageName == PackageName.GetNodeProperties).GetNodePropertiesParams);
                    // await AllNodesHaveAllProperties(json.ComponentParams.FirstOrDefault(c => c.PackageName == PackageName.GetNodeProperties).GetNodePropertiesParams);
                    await DatabaseObjectsExist(LandscapeObjects);
                    break;
                case PipelineNames.RescoreLandscape:
                    await AllNodeScoresComputed(json.ComponentParams.FirstOrDefault(c => c.PackageName == PackageName.ScoreLandscapeNodes).ScoreLandscapeNodesParams);
                    await AllNodePropertiesComputed(json.ComponentParams.FirstOrDefault(c => c.PackageName == PackageName.GetNodeProperties).GetNodePropertiesParams);
                    await DatabaseObjectsExist(LandscapeObjects);
                    break;
                case PipelineNames.GetKeywordProfile:
                    await KeywordProfileIsTestable(json.ComponentParams.FirstOrDefault(c => c.PackageName == PackageName.GetKeywordProfile).GetKeywordProfileParams);
                    if (json.ComponentParams.FirstOrDefault(c => c.PackageName == PackageName.GetKeywordProfile).GetKeywordProfileParams.StoreInProject.Value)
                        await ProfileIsCorrectlyScoped(json.ComponentParams.FirstOrDefault(c => c.PackageName == PackageName.GetKeywordProfile).GetKeywordProfileParams);
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
        /*private async Task AllNodesProcessed(IEnumerable<NodeSelectionParam> nsp)
        {
            foreach (NodeSelectionParam ns in nsp)
            {
                string[] nl = ns.NodeList.Split('|');
                using (var con = new SqlConnection(cnx.ConnectionString))
                {
                    await con.OpenAsync();
                }
            }
        }*/

        private async Task AllNodeScoresComputed(IEnumerable<ScoreLandscapeNodesParam> sln)
        {
            foreach (ScoreLandscapeNodesParam sl in sln)
            {
                /* There are companies with non-zero values */
                using (var cmd = Db.CreateCommand())
                {
                    string scoreTable;
                    switch (sl.ScoringType)
                    {
                        case NodeScoringType.BagOfClasses:
                        case NodeScoringType.BagOfWords:
                        case NodeScoringType.CompanyPortfolio:
                            scoreTable = "ls_node_score_numeric";
                            break;
                        default:
                            scoreTable = "unknown";
                            break;
                    }

                    if (scoreTable == "unknown")
                        cmd.CommandText = @"select
                                            count(distinct isnull(csr.node_key,css.node_key)) as NumberOfScoredNodes
                                        from
                                            (select @score_series_group as node_score_series_group,@score_group as node_score_group) s LEFT OUTER JOIN
                                            ls_node_score_numeric csr ON csr.node_score_series_group=s.node_score_series_group AND csr.node_score_group=s.node_score_group LEFT OUTER JOIN
                                            ls_node_score_str css ON css.node_score_series_group=s.node_score_series_group AND css.node_score_group=s.node_score_group";
                    else
                        cmd.CommandText = @"select
                                            count(distinct node_key) as NumberOfScoredNodes
                                        from
                                            " + scoreTable + @"
                                        where
                                                node_score_group=@score_group AND node_score_series_group=@score_series_group";

                    cmd.Parameters.AddWithValue("@score_series_group", sl.SeriesGroup); // Topics, Players, Large companies etc.
                    cmd.Parameters.AddWithValue("@score_group", sl.ScoreGroup); // Weight, Relevance etc.

                    using (var reader = await cmd.ExecuteReaderAsync())
                    {
                        while (await reader.ReadAsync() && !Program.StopNow)
                        {
                            int nc = (int)reader["NumberOfScoredNodes"];
                            Results.Add(new TestResult
                            {
                                Message = String.Format("Encountered {1} score-values for [{0}/{2}] in {3}.", sl.ScoreGroup, nc, sl.SeriesGroup,scoreTable),
                                Name = "NumberOfScoredNodes",
                                Success = (nc > 0),
                            });
                        }
                    }
                }
            }
        }

        private async Task AllNodePropertiesComputed(IEnumerable<GetNodePropertiesParam> gnp)
        {
            foreach (GetNodePropertiesParam gn in gnp)
            {
                // There are companies with non-zero values
                using (var cmd = Db.CreateCommand())
                {
                    string scoreTable = "unknown";
                    try
                    {
                        NodePropertyMethod npm = (NodePropertyMethod)Enum.Parse(typeof(NodePropertyMethod), gn.PropertyMethod);
                        switch (npm)
                        {
                            case NodePropertyMethod.HighLevelTechnologyLabel:
                            case NodePropertyMethod.NodeId:
                            case NodePropertyMethod.TechnologyClassExtendedLabel:
                            case NodePropertyMethod.TechnologyClassLabel:
                                scoreTable = "ls_node_property_str";
                                break;
                            case NodePropertyMethod.TechnologyClassSize:
                                scoreTable = "ls_node_property_numeric";
                                break;
                            default:
                                scoreTable = "unknown";
                                break;
                        }
                    } catch(Exception e)
                    {
                        Console.WriteLine(gn.PropertyMethod + " could not be parsed onto NodePropertyMethod." );
                    }
                    if (scoreTable == "unknown")
                        cmd.CommandText = @"select
                                            count(distinct isnull(csr.node_key,css.node_key)) as NumberOfNodesWithProperty
                                        from
                                            (select @p1 as node_property_type) s LEFT OUTER JOIN
                                            ls_node_property_numeric csr ON csr.node_property_type=s.node_property_type LEFT OUTER JOIN
                                            ls_node_property_str css ON css.node_property_type=s.node_property_type";
                    else
                        cmd.CommandText = @"select
                                            count(distinct node_key) as NumberOfNodesWithProperty
                                        from
                                            " + scoreTable + @"
                                        where
                                                node_property_type=@p1";

                    cmd.Parameters.AddWithValue("@p1", gn.PropertyLabel);

                    using (var reader = await cmd.ExecuteReaderAsync())
                    {
                        while (await reader.ReadAsync() && !Program.StopNow)
                        {
                            int nc = (int)reader["NumberOfNodesWithProperty"];
                            Results.Add(new TestResult
                            {
                                Message = String.Format("Encountered {1} score-values for [{0}/{2}].", gn.PropertyMethod, nc, gn.PropertyLabel),
                                Name = "NumberOfNodesWithProperty",
                                Success = (nc > 0),
                            });
                        }
                    }
                }
            }
        }

        private async Task AllNodesHaveAtLeastOneDistance()
        {
            using (var cmd = Db.CreateCommand())
            {
                cmd.CommandText = @"select count(distinct node_key) as NodesWithoutDistance from ls_node where node_key not in (select class1_id from ls_node_distance union select class2_id from ls_node_distance)";

                using (var reader = await cmd.ExecuteReaderAsync())
                {
                    while (await reader.ReadAsync() && !Program.StopNow)
                    {
                        int nwd = (int)reader["NodesWithoutDistance"];
                        Results.Add(new TestResult
                        {
                            Message = String.Format("Encountered {0} node{1} that have no distance.", nwd, nwd==1?"":"s"),
                            Name = "NodesWithoutDistance",
                            Success = (nwd == 0),
                        });
                    }
                }
            }
        }

        private async Task AllNodesHavePosition()
        {
            using (var cmd = Db.CreateCommand())
            {
                cmd.CommandText = @"select count(*) as NodesWithoutPosition from ls_node where node_key not in (select node_key from ls_node_position)";

                using (var reader = await cmd.ExecuteReaderAsync())
                {
                    while (await reader.ReadAsync() && !Program.StopNow)
                    {
                        int nwp = (int)reader["NodesWithoutPosition"];
                        Results.Add(new TestResult
                        {
                            Message = String.Format("Encountered {0} node{1} that have no position.", nwp, nwp == 1 ? "" : "s"),
                            Name = "NodesWithoutPosition",
                            Success = (nwp == 0),
                        });
                    }
                }
            }
        }

        private async Task NodesPositionedAlgorithmicly(ComponentParam ad)
        {
            using (var cmd = Db.CreateCommand())
            {
                cmd.CommandText = @"select
                                            isnull([CORE],0) as [CORE],isnull([OTHER],0) as [OTHER], isnull([CORNER],0) as [CORNER]
                                        FROM
	                                        (select
		                                        case when
			                                        node_x between p1_x and p2_x
			                                        and
			                                        node_y between p1_y and p2_y then 'CORE'
		                                        when
			                                        (node_x < p25_x and node_y < p25_y)
			                                        or
			                                        (node_x < p25_x and node_y > p75_y)
			                                        or
			                                        (node_x > p75_x and node_y < p25_y)
			                                        or
			                                        (node_x > p75_x and node_y > p75_y) then 'CORNER'
		                                        else
			                                        'OTHER' end as [area]
		                                        , count(distinct node_key) as nn
	                                        from
		                                        ls_node_position np CROSS JOIN
		                                        (select	distinct
			                                        PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY node_x) OVER () as p75_x
			                                        , PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY node_y) OVER () as p75_y
			                                        , PERCENTILE_CONT(0.1) WITHIN GROUP (ORDER BY node_x) OVER () as p25_x
			                                        , PERCENTILE_CONT(0.1) WITHIN GROUP (ORDER BY node_y) OVER () as p25_y
			                                        , PERCENTILE_CONT(0.4) WITHIN GROUP (ORDER BY node_x) OVER () as p1_x
			                                        , PERCENTILE_CONT(0.4) WITHIN GROUP (ORDER BY node_y) OVER () as p1_y
			                                        , PERCENTILE_CONT(0.6) WITHIN GROUP (ORDER BY node_x) OVER () as p2_x
			                                        , PERCENTILE_CONT(0.6) WITHIN GROUP (ORDER BY node_y) OVER () as p2_y
		                                        FROM
			                                        ls_node_position
		                                        ) a
	                                        GROUP BY
		                                        case when
			                                        node_x between p1_x and p2_x
			                                        and
			                                        node_y between p1_y and p2_y then 'CORE'
		                                        when
			                                        (node_x < p25_x and node_y < p25_y)
			                                        or
			                                        (node_x < p25_x and node_y > p75_y)
			                                        or
			                                        (node_x > p75_x and node_y < p25_y)
			                                        or
			                                        (node_x > p75_x and node_y > p75_y) then 'CORNER'
		                                        else
			                                        'OTHER' end
	                                        ) a
                                        PIVOT(
	                                        max(nn) FOR area in ([CORE],[OTHER],[CORNER])
                                        ) pvt";

                using (var reader = await cmd.ExecuteReaderAsync())
                {
                    while (await reader.ReadAsync() && !Program.StopNow)
                    {
                        int nCore = (int)reader["CORE"];
                        int nCorner = (int)reader["CORNER"];
                        int nOther = (int)reader["OTHER"];

                        double cornerShareTotal = (double)nCorner / (double)(nCorner + nCore + nOther);
                        double cornerCoreRatio = (nCorner == 0 ? 1000 : (double)nCore / (double)nCorner);

                        switch (ad.Algorithm)
                        {
                            case MdsAlgorithm.Random: // The corner should contain 4% of points. Less than 1% or more than 10% fails the test (arbitrary boundaries)
                                Results.Add(new TestResult
                                {
                                    Message = String.Format("Corners share of points is {0} where 0.04 is expected in Random positioning.", cornerShareTotal),
                                    Name = "NodePositionedAlgorithmicly",
                                    Success = (cornerShareTotal > 0.01 && cornerShareTotal < 0.1),
                                });
                                break;
                            case MdsAlgorithm.MatlabMds: // The resulting distribution is circular. The core should contain at least twice as many points.
                                Results.Add(new TestResult
                                {
                                    Message = String.Format("Ratio of points in core vs corners is {0}. In circular MDS positioning at least a factor 2 is expected.", nCorner == 0 ? "Infinite" : String.Format("{0}", cornerCoreRatio)),
                                    Name = "NodePositionedAlgorithmicly",
                                    Success = (cornerCoreRatio >= 2),
                                });
                                break;


                        }
                    }
                }
            }
        }

        private async Task KeywordProfileIsTestable(KeywordProfileParam gnp)
        {
            if(gnp.StoreInProject ?? false)
                Results.Add(new TestResult
                {
                    Message = "Keyword profile is testable.",
                    Name = "TestableProfile",
                    Success = true,
                });
            else
                Results.Add(new TestResult
                {
                    Message = "Keyword profile is not testable; results not stored in database.",
                    Name = "TestableProfile",
                    Success = false,
                });
        }
        private async Task ProfileIsCorrectlyScoped(KeywordProfileParam gnp)
        {
            if(gnp.ScopeToProject ?? false)
            {
                using (var cmd = Db.CreateCommand())
                {
                    cmd.CommandText = @"select
                                    count(distinct node_key) as NumberOfProfileNodesOutsideLandscape
                                from
                                    report.requested_profile
                                where
                                    bag_of_words=@p1
                                    and
                                    class_code not in (select node_id from ls_node)";

                    cmd.Parameters.AddWithValue("@p1", gnp.BagOfWords);

                    using (var reader = await cmd.ExecuteReaderAsync())
                    {
                        while (await reader.ReadAsync() && !Program.StopNow)
                        {
                            int nc = (int)reader["NumberOfProfileNodesOutsideLandscape"];
                            Results.Add(new TestResult
                            {
                                Message = String.Format("Profile for [{1}] scoped to project: {0} nodes encountered that are not in dbo.ls_node.", nc, gnp.BagOfWords),
                                Name = "ProfileCorrectlyScoped",
                                Success = (nc == 0),
                            });
                        }
                    }
                }

            }
            else
            {
                // Don't write test result; this is not testable.
            }
            
            // There are companies with non-zero values
        }

        #endregion
    }
}

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
    public class QuestionnaireSuite : BaseSuite
    {

        private static List<string> QuestionnaireObjects = new List<string>()
        {
            // Tables
            "questionnaire.answer"
            ,"questionnaire.company_tab"
            ,"questionnaire.faq"
            ,"questionnaire.question"
            ,"questionnaire.question_tab"
            ,"questionnaire.tab"
            ,"questionnaire.user_answer"
            ,"questionnaire.user_answer_checked"
        };


        #region BaseSuite implementation
        protected override async Task RunTests(Root json) {
            switch (json.Header.NameOfApi)
            {
                case PipelineNames.AnswerQuestion:
                    await DatabaseObjectsExist(QuestionnaireObjects);
                    await ConfiguredAnswersAreWritten(json.ComponentParams.FirstOrDefault(c => c.PackageName == PackageName.StoreAnswer).AnswerParams);
                    await AllAnswersInDatamartPointToQuestions();
                    await CheckedAnswersInDatamartPointToAnswers(); // in user_answer_checked, answer_id exists as id in answer table
                    //await CheckedAnswersInDatamartPointToUserAnswers(); // in user_answer_checked, user_answer_id exists as id in user_answer table
                    await LatestAnswerForAllNonLatestAnswers();
                    // check whether empty answers overwrite previous non-empty answers correctly
                    break;
                default:
                    break;
            }
            // Only execute when one of the Questionnaire APIs was called!
            Results.Add(new TestResult
            {
                Message = "All tests executed successfully",
                Name = "TestExecute",
                Success = true,
            });
        }
        #endregion

        #region test definitions
        private async Task ConfiguredAnswersAreWritten(IEnumerable<AnswerParam> aps)
        {
            foreach (AnswerParam ap in aps)
            {
                /* There are companies with non-zero values */
                using (var cmd = Db.CreateCommand())
                {
                    cmd.CommandText = @"select
                                                count(distinct ua.id) as [NumberOfAnswers]
                                            from
                                                questionnaire.user_answer ua JOIN
                                                questionnaire.question q ON q.id=ua.id_question
                                            where
                                                bvd_id=@company_id
                                                and
                                                (id_question=@question_id
                                                or
                                                q.score_name=@question_name)
                                                and
                                                text_answer=@answer
                                                and
                                                reference=@reference
                                                and
                                                comment=@comment
                                            ";
                    //Console.WriteLine(cmd.CommandText);

                    cmd.Parameters.AddWithValue("@company_id", ap.CompanyId);
                    cmd.Parameters.AddWithValue("@question_id", ap.QuestionId);
                    cmd.Parameters.AddWithValue("@question_name", ap.QuestionName ?? "");
                    cmd.Parameters.AddWithValue("@answer", ap.Answer ?? "");
                    cmd.Parameters.AddWithValue("@comment", ap.Comment ?? "");
                    cmd.Parameters.AddWithValue("@reference", ap.Reference ?? "");

                    /*Console.WriteLine(cmd.CommandText);
                    Console.WriteLine("Company ID:[{0}], Question ID:[{1}], Question name:[{2}], Answer:[{3}], Reference:[{4}], Comment:[{5}]"
                        , ap.CompanyId
                        , ap.QuestionId
                        , ap.QuestionName
                        , ap.Answer == null ? "NULL" : ap.Answer
                        , ap.Reference == null ? "NULL" : ap.Reference
                        , ap.Comment == null ? "NULL" : ap.Comment);*/

                    using (var reader = await cmd.ExecuteReaderAsync())
                    {
                        while (await reader.ReadAsync() && !Program.StopNow)
                        {
                            // Actual combination of question, answer, reference and company_id are present
                            int nc = (int)reader["NumberOfAnswers"];
                            Results.Add(new TestResult
                            {
                                Message = String.Format("Encountered {0} identical answer {1} for combination [{2}/{3}]."
                                                , nc, (nc == 1 ? "entry" : "entries"), ap.CompanyId, ap.QuestionName),
                                Name = "NumberOfIdenticalAnswers",
                                Success = (nc > 0),
                            });

                            // If weird characters in any of the fields; also present in result
                            string strangeCharacters = "/!@#$%^&*()\"|\\";
                            if (!string.IsNullOrEmpty(ap.Answer) && strangeCharacters.All(c => ap.Answer.Contains(c)))
                            {
                                Results.Add(new TestResult
                                {
                                    Message = String.Format("Correctly store an answer with all strange characters: {0}"
                                                    , strangeCharacters),
                                    Name = "StrangeCharacters",
                                    Success = (nc > 0),
                                });
                            }

                            // If either answer, comment or reference is very long, report explicitly
                            if (!string.IsNullOrEmpty(ap.Answer) && (ap.Answer.Length > 1000 || ap.Reference.Length > 1000 || ap.Comment.Length > 1000))
                            {
                                Results.Add(new TestResult
                                {
                                    Message = String.Format("Long answer ({0} characters) successfully stored for [{1}/{2}]."
                                                    , Math.Max(Math.Max(ap.Answer.Length, ap.Comment.Length), ap.Reference.Length), ap.CompanyId, ap.QuestionName),
                                    Name = "LongAnswerStored",
                                    Success = (nc > 0),
                                });
                            }
                        }
                    }
                }
            }
        }

        private async Task AllAnswersInDatamartPointToQuestions()
        {
            using (var cmd = Db.CreateCommand())
            {
                cmd.CommandText = @"select count(distinct id) as AnswersWithoutQuestion from questionnaire.user_answer where id_question not in (select id from questionnaire.question)";

                using (var reader = await cmd.ExecuteReaderAsync())
                {
                    while (await reader.ReadAsync() && !Program.StopNow)
                    {
                        int awq = (int)reader["AnswersWithoutQuestion"];
                        Results.Add(new TestResult
                        {
                            Message = String.Format("Encountered {0} answer{1} that have no question.", awq, awq == 1 ? "" : "s"),
                            Name = "AllAnswersHaveQuestion",
                            Success = (awq == 0),
                        });
                    }
                }
            }
        }

        private async Task CheckedAnswersInDatamartPointToAnswers()
        {
            using (var cmd = Db.CreateCommand())
            {
                cmd.CommandText = @"select count(distinct id) as CheckedAnswersWithoutAnswer from questionnaire.user_answer_checked where id_answer not in (select id from questionnaire.answer)";

                using (var reader = await cmd.ExecuteReaderAsync())
                {
                    while (await reader.ReadAsync() && !Program.StopNow)
                    {
                        int awa = (int)reader["CheckedAnswersWithoutAnswer"];
                        Results.Add(new TestResult
                        {
                            Message = String.Format("Encountered {0} checked answer{1} that have no answer.", awa, awa == 1 ? "" : "s"),
                            Name = "AllAnswersHaveQuestion",
                            Success = (awa == 0),
                        });
                    }
                }
            }
        }

        private async Task LatestAnswerForAllNonLatestAnswers()
        {
            using (var cmd = Db.CreateCommand())
            {
                cmd.CommandText = @"select
                                        count(distinct uanl.id) as NonlatestAnswersWithoutLatestAnswer
                                    from
                                        (select * from questionnaire.user_answer where is_latest=0) uanl LEFT OUTER JOIN
                                        (select * from questionnaire.user_answer where is_latest=1) ual ON uanl.bvd_id=ual.bvd_id AND uanl.id_question=ual.id_question AND ual.id <> uanl.id
                                    where
                                        ual.id IS NULL";

                using (var reader = await cmd.ExecuteReaderAsync())
                {
                    while (await reader.ReadAsync() && !Program.StopNow)
                    {
                        int awa = (int)reader["NonlatestAnswersWithoutLatestAnswer"];
                        Results.Add(new TestResult
                        {
                            Message = String.Format("Encountered {0} non-latest answer{1} that have no (new) latest answer.", awa, awa == 1 ? "" : "s"),
                            Name = "ForAllNonlatestAnswersTheresLatestAnswer",
                            Success = (awa == 0),
                        });
                    }
                }
            }
        }
        #endregion

    }
}

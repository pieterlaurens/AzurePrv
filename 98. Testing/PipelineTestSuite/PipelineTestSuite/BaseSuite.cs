using Deloitte.PipelineFramework.PlatformConfig;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PipelineTestSuite
{
    public abstract class BaseSuite : IDisposable
    {
        public static void Run<T>() where T : BaseSuite, new()
        {
            using (var suite = new T())
            {
                Task.Run(() => suite.TestApi()).Wait();
                //Console.WriteLine("=============================================");
                //Console.WriteLine(String.Format("== Datamart: {0}.",Options.Catalog));
                suite.PrintTestResults();
            }
        }

        public static List<TestResult> Results = new List<TestResult>();

        public BaseSuite()
        {
            var cnx = new SqlConnectionStringBuilder();
            cnx.DataSource = Program.Options.DataSource;
            cnx.InitialCatalog = Program.Options.Catalog;
            cnx.IntegratedSecurity = true;
            cnx.MultipleActiveResultSets = true;
            Db = new SqlConnection(cnx.ConnectionString);
            Db.Open();
        }
        protected abstract Task RunTests(Root json);

        public async Task TestApi()
        {
            try
            {
                Root json = JsonConvert.DeserializeObject<Root>(
                    File.ReadAllText(Program.Options.Json)
                );
                Results.Add(new TestResult
                {
                    Message = "Read and parsed configuration successfully; valid JSON configuration.",
                    Name = "JsonRead",
                    Success = true,
                });

                CurrentApi = json.Header.NameOfApi.ToString();

                try
                {
                    await RunTests(json);
                }
                catch (Exception e)
                {
                    Results.Add(new TestResult
                    {
                        Message = e.Message,//e.ToString(),
                        Name = "TestExecute",
                        Success = false,
                    });
                }
            }
            catch (Exception e)
            {
                Results.Add(new TestResult
                {
                    Message = e.Message,
                    Name = "JsonRead",
                    Success = false,
                });
            }
        }

        protected async Task DatabaseObjectsExist(List<string> dbos)
        {
            string missingObjects = "";
            foreach (string dbo in dbos)
            {
                using (var cmd = Db.CreateCommand())
                {
                    cmd.CommandText = @"select case when OBJECT_ID('" + dbo + "') is null then 0 else 1 end as [exists]";

                    using (var reader = await cmd.ExecuteReaderAsync())
                    {
                        while (await reader.ReadAsync() && !Program.StopNow)
                        {
                            int dboExists = (int)reader["exists"];
                            if (dboExists == 0)
                                missingObjects += (missingObjects.Length > 0 ? ", " : "") + dbo;
                        }
                    }
                }
            }
            Results.Add(new TestResult
            {
                Message = (missingObjects.Length > 0 ? missingObjects + " missing in target database." : String.Format("All {0} required objects present in target database.", dbos.Count())),
                Name = "DatabaseObjectsExist",
                Success = (missingObjects.Length == 0),
            });
        }

        public void PrintTestResults()
        {
            if (Program.Options.OutputFile != null)
            {
                StreamWriter file = new StreamWriter(Program.Options.OutputFile);
                foreach (TestResult r in Results.FindAll(r => !r.Success))
                {
                    file.WriteLine(String.Format("{3}\t{0}\t{1}\t{2}", "FAIL", r.Name, r.Message, CurrentApi));
                }
                foreach (TestResult r in Results.FindAll(r => r.Success))
                {
                    file.WriteLine(String.Format("{3}\t{0}\t{1}\t{2}", "PASS", r.Name, r.Message, CurrentApi));
                }
                file.Close();
            }
            else
            {
                //Console.WriteLine("== API: " + thisApi);
                foreach (TestResult r in Results.FindAll(r => !r.Success))
                {
                    Console.WriteLine(String.Format("{3}\t{0}\t{1}\t{2}", "FAIL", r.Name, r.Message, CurrentApi));
                }
                foreach (TestResult r in Results.FindAll(r => r.Success))
                {
                    Console.WriteLine(String.Format("{3}\t{0}\t{1}\t{2}", "PASS", r.Name, r.Message, CurrentApi));
                }
            }
        }

        protected SqlConnection Db;
        protected string CurrentApi;


        #region IDisposable Support
        private bool disposedValue = false; // To detect redundant calls

        protected virtual void Dispose(bool disposing)
        {
            if (!disposedValue)
            {
                if (disposing)
                {
                    // TODO: dispose managed state (managed objects).
                    if (Db != null)
                    {
                        Db.Dispose();
                        Db = null;
                    }
                }

                // TODO: free unmanaged resources (unmanaged objects) and override a finalizer below.
                // TODO: set large fields to null.

                disposedValue = true;
            }
        }

        // TODO: override a finalizer only if Dispose(bool disposing) above has code to free unmanaged resources.
        // ~Suite1() {
        //   // Do not change this code. Put cleanup code in Dispose(bool disposing) above.
        //   Dispose(false);
        // }

        // This code added to correctly implement the disposable pattern.
        public void Dispose()
        {
            // Do not change this code. Put cleanup code in Dispose(bool disposing) above.
            Dispose(true);
            // TODO: uncomment the following line if the finalizer is overridden above.
            // GC.SuppressFinalize(this);
        }
        #endregion
    }
    public class TestResult
    {
        public string Name { get; set; }
        public bool Success { get; set; }
        public string Message { get; set; }
    }
}

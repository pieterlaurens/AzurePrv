using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Deloitte.PipelineFramework
{
    /// <summary>
    /// Logs a message to the standard datastore.
    /// </summary>
    public class Logger
    {
        /// <summary>
        /// Local store of all messages send to this instance.
        /// </summary>
        public IList<string> Messages { get; set; }

        /// <summary>
        /// Initialize a new instance, to start... logging!
        /// </summary>
        /// <param name="connection">The sql connection to the logging database.</param>
        /// <param name="executableName">The name of the script task.</param>
        /// <param name="packageName">The name of the package.</param>
        public Logger(SqlConnection connection, string packageName, string executableName)
        {
            this.Messages = new List<string>();
            this.PackageName = packageName;
            this.ExecutableName = executableName;
            this.MyLoggingConnection = connection;
        }

        /// <summary>
        /// Add a message to the data store.
        /// </summary>
        /// <param name="status">The type of message <see cref="LogStatus"/>.</param>
        /// <param name="message">Any message you like to be logged.</param>
        public void LogEntry(LogStatus status, string message)
        {
            using (SqlCommand cmd = new SqlCommand("nlh.log_addEntry", MyLoggingConnection))
            {
                string statusName = Enum.GetName(typeof(LogStatus), status);
                Messages.Add(string.Format("{0}: {1}", statusName, message));

                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@component", PackageName);
                cmd.Parameters.AddWithValue("@source_type", "SCRIPT");
                cmd.Parameters.AddWithValue("@source_name", ExecutableName);
				if (!string.IsNullOrEmpty(ComponentId))
					cmd.Parameters.AddWithValue("@source_id", ComponentId);
                cmd.Parameters.AddWithValue("@message", message);
                cmd.Parameters.AddWithValue("@action", "EXECUTE");
                cmd.Parameters.AddWithValue("@status", statusName);

                cmd.ExecuteNonQuery();
            }
        }
		
		/// <summary>
		/// The id of the component. Will be added to the log as "source_id" when not null.
		/// </summary>
		public string ComponentId { get; set; }

        /// <summary>
        /// resource should be managed by the calling package.
        /// </summary>
        public SqlConnection MyLoggingConnection { get; private set; }

        /// <summary>
        /// Holds the name of the package from where this instance is called.
        /// </summary>
        private string PackageName;

        /// <summary>
        /// The executable of the package from where this instance is called.
        /// </summary>
        private string ExecutableName;

    }

    /// <summary>
    /// The type of message to add to the log.
    /// </summary>
    public enum LogStatus
    {
        /// <summary>
        /// When the scripts fails to run.
        /// </summary>
        Failure,
        /// <summary>
        /// When the script successfully finishes
        /// </summary>
        Success,
        /// <summary>
        /// For messages while executing.
        /// </summary>
        Progress,
        /// <summary>
        /// To alert the user to certain unexpected, but non-blocking events.
        /// </summary>
        Warning,
    }
}

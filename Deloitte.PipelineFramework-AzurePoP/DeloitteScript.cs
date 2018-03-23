using System;
using System.Collections.Generic;
using System.Data.OleDb;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Deloitte.PipelineFramework.Extensions;
using Deloitte.PipelineFramework.PlatformConfig;
using Deloitte.PipelineFramework.PlatformConfig.Params;
using Microsoft.SqlServer.Dts.Runtime;
using Newtonsoft.Json;
using Microsoft.SqlServer.Dts.Tasks.ScriptTask;
using System.Data;
using System.Reflection;
using System.Net;
using System.Collections;
using Deloitte.PipelineFramework.PlatformConfig.Enums;

namespace Deloitte.PipelineFramework
{
    /// <summary>
    /// Extend this class in your script component to have logging and config made easy.
    /// <para>This class depends on some variables that need to be added to the readonly 
    /// variables of the task. When setup correctly the PackageConfig will automatically
    /// be available under the member variable <see cref="PackageConfig"/>.
    /// </para>
    /// <para>[Required] User::cfg_tpl_jsonConfiguration: should contain the json_config compatible with <see cref="PlatformConfig.Root"/></para>
    /// <para>[Required] System::PackageName: needed for selecting the correct ComponentConfiguration. Also needed for automatic logger setup.</para>
    /// <para>User::cfg_tpl_CMPlatformDB: needed to automatically set up the connection for the logger.</para>
    /// <para>System::TaskName: needed for automatic logger setup.</para>
    /// <example>
    /// <code>
    /// using System;
    /// using System.Collections.Generic;
    /// using System.Data;
    /// using System.Linq;
    /// using NewtonSoft.Json;
    /// using Deloitte.PipelineFramework;
    /// using Deloitte.PipelineFramework.PlatformConfig;
    /// using Deloitte.PipelineFramework.PlatformConfig.Params;
    /// public class MyScript : DeloitteScriptObjectModelBase {
    ///     ....
    ///     
    ///     public void Main() {
    ///         using (var deloitte = new DeloitteScript(Dts)) 
    ///         {
    ///             deloitte.SetupLogger();
    ///         
    ///             //check out the options in deloitte! Easy logging, 
    ///             //easy send message to webapi, easy setting variables 
    ///             //to Dts.Variables.
    ///             //see: http://nlams00852.nl.deloitte.com/pipelinedocs
    ///         
    ///         ...other code, maybe log something.
    ///         
    ///         }
    ///         return (int)ScriptResult.Success;
    ///     }
    /// 
    ///     ....
    /// }
    /// </code>
    /// </example>
    /// </summary>
    public sealed class DeloitteScript : IDisposable
    {
        /// <summary>
        /// Contains the codes that could be send using UpdateApi method.
        /// </summary>
        public enum UpdateCodes
        {
            /// <summary>
            /// The pipeline was stopped.
            /// </summary>
            PipelineStopped = 1100,
            
            /// <summary>
            /// When the pipeline is still running.
            /// </summary>
            PipelineRunning = 1101,

            /// <summary>
            /// When the invocationhandler started executing.
            /// </summary>
            PipelineExecutionStarted = 1110,

            /// <summary>
            /// When the pipeline was completed successfully.
            /// </summary>
            PipelineReady = 1120,

            /// <summary>
            /// When the pipeline finished, but there were errors.
            /// </summary>
            PipelineFinishedWithErrors = 1190,

            /// <summary>
            /// When the component has completed successfully.
            /// <remarks>When sending this code, the api expects solely the PackageName as the message.</remarks>
            /// </summary>
            ComponentFinished = 1000,
            
            /// <summary>
            /// When the component is still running.
            /// </summary>
            ComponentRunning = 1001,

            /// <summary>
            /// When the invocation handler started executing the component.
            /// </summary>
            ComponentExecutionStarted = 1010,

            /// <summary>
            /// When there was an error running a component.
            /// </summary>
            ComponentError = 1090,

            /// <summary>
            /// When the message is a json string, use this id as the code.
            /// </summary>
            PayLoad = 500,
        }
        /// <summary>
        /// Converts a value from one type to another, taking into account 
        /// specific requirements for Dts Variables.
        /// </summary>
        /// <param name="value">The value to convert.</param>
        /// <param name="sourceType">The type of the value itself.</param>
        /// <param name="targetType">The type of the Dts Variable.</param>
        /// <returns>An object whose type is conversionType and whose value is equivalent to value.-or-A
        /// null reference, if value is null and conversionType is not a value type.</returns>
        public static object ConvertVariable(object value, Type sourceType, Type targetType)
        {
            if (
                sourceType.IsSubclassOf(typeof(DeloitteObject))
                || (false == sourceType.Equals(typeof(string)) && (
                    sourceType.ImplementsInterface(typeof(IEnumerable<>))
                    || sourceType.ImplementsInterface(typeof(IList<>))
                ))
            )
            {
                return JsonConvert.SerializeObject(value);
            }
            else if (sourceType.IsEnum)
            {
                return Enum.GetName(sourceType, value);
            }
            /*else if (sourceType.IsClass)
            {
                return null;
            }*/
            return Convert.ChangeType(value, targetType);
        }

        /// <summary>
        /// Constructs a new instance and automatically tries to grab
        /// the System::PackageName and System::TaskName.
        /// <para>Please make sure those two variables are passed as readonly 
        /// vars in the task.</para>
        /// </summary>
        /// <param name="dts"></param>
        public DeloitteScript(ScriptObjectModel dts)
        {
            Dts = dts;
            //defaults indicate user action to take.
            TaskName = "AddReadOnlyVarSystemTaskNameToScriptTask";
            PackageName = "AddReadOnlyVarSystemPackageNameToScriptTask";
            if (Dts.Variables.Contains("System::TaskName"))
            {
                TaskName = Dts.Variables["System::TaskName"].Value.ToString();
            }
            if (Dts.Variables.Contains("System::PackageName"))
            {
                PackageName = Dts.Variables["System::PackageName"].Value.ToString();
            }
            GetConfigForPackage();
        }

        /// <summary>
        /// Holds the name of the package, if it is provided by the script as 
        /// a $(System::PackageName) readonly variable.
        /// </summary>
        public string PackageName { get; set; }

        /// <summary>
        /// Holds the name of the package, if it is provided by the script as 
        /// a $(System::TaskName) readonly variable.
        /// </summary>
        public string TaskName { get; set; }

        /// <summary>
        /// Contains all package information. (ie.json_config).
        /// </summary>
        public Root Config { get; set; }

        /// <summary>
        /// Contains the configuration for the current package.
        /// <see cref="GetConfigForPackage()"/>
        /// </summary>
        public ComponentParam PackageConfig { get; set; }

        /// <summary>
        /// Holds a logger instance.
        /// </summary>
        public Logger Logger { get; set; }

        /// <summary>
        /// The class to communicate with the standard api endpoint.
        /// <para>Will be instantiated with default values when null.</para>
        /// </summary>
        public WebApi WebApiEndpoint { get; set; }

        /// <summary>
        /// Reads a variable from Dts.Variables into a strong-typed container.
        /// <para>String- or longstring (System.Object) variables are supposed to contain json
        /// and will be deserialized with JsonConvert.</para>
        /// <para>Non-strings are typecasted.</para>
        /// </summary>
        /// <param name="varName">The name inside Dts.Variables.</param>
        /// <typeparam name="T">The type to desrialize the value into.</typeparam>
        /// <returns>The value converted to the requested type.</returns>
        public T ReadVariable<T>(string varName)
        {
            if (!string.IsNullOrEmpty(varName) && Dts.Variables.Contains(varName))
            {
                var varType = Dts.Variables[varName].DataType;
                string value;
                if (varType.Equals(TypeCode.String)) {
                    value = Dts.Variables[varName].Value.ToString();
//                    return JsonConvert.DeserializeObject<T>(value);
                    return JsonConvert.DeserializeObject<T>(value, new JsonSerializerSettings { NullValueHandling = NullValueHandling.Include });
                }
                else if (varType.Equals(TypeCode.Object))
                {
                    value = ReadLongStringVariable(varName);
                    if (value == null) return default(T);
//                    return JsonConvert.DeserializeObject<T>(value);
                    return JsonConvert.DeserializeObject<T>(value, new JsonSerializerSettings { NullValueHandling = NullValueHandling.Include });
                }
                return (T)Dts.Variables[varName].Value;
            }
            return default(T);
        }

        /// <summary>
        /// Loads the package configuration from the user variable: User:cfg_tpl_jsonConfiguration.
        /// </summary>
        public void LoadConfig()
        {
            LoadConfig(null);
        }

        /// <summary>
        /// Loads the package configuration from the variable with the given name.
        /// </summary>
        /// <param name="variableName">The name under which the json is stored. Defaults to User:cfg_tpl_jsonConfiguration.</param>
        public void LoadConfig(string variableName) 
        {
            var name = variableName ?? "User::cfg_tpl_jsonConfiguration";
            if (Dts.Variables.Contains(name))
            {
                try
                {
                    Config = ReadVariable<Root>(name);
                }
                catch (Exception e)
                {
                    if (Logger != null)
                    {
                        Logger.LogEntry(LogStatus.Warning, "Error loading config. The json in the variable " + name + " could not be deserialized to PlatformConfig.Root. The original exception was: " + e.ToString());
                        Logger.LogEntry(LogStatus.Warning, string.Format("Tried to parse variable {0}: {1}", name, ReadLongStringVariable(name)));
                    }
                }
            }
            else
            {
                if (Logger != null) Logger.LogEntry(LogStatus.Warning, "Error loading Config. Please add the variable " + name + " to the readonly variables of the task.");
            }
        }

        /// <summary>
        /// Adds all non-null properties from the supplied object
        /// to the Dts.Variable[varName].
        /// <para>The variables should by defined as read/write in the task.</para>
        /// <para>The variable names will be prefixed with `this_`.</para>
        /// </summary>
        /// <typeparam name="T">The type of class of the supplied object.</typeparam>
        /// <param name="varName">The name of the Dts Variable that holds the information.</param>
        public void SetNonNullUserVariablesFor<T>(string varName)
        {
            SetNonNullUserVariablesFor<T>(ReadVariable<T>(varName), null);
        }

        /// <summary>
        /// Adds all non-null properties from the supplied object
        /// to the Dts.Variable[varName].
        /// <para>The variables should by defined as read/write in the task.</para>
        /// </summary>
        /// <typeparam name="T">The type of class of the supplied object.</typeparam>
        /// <param name="varName">The name of the Dts Variable that holds the information.</param>
        /// <param name="prefix">The prefix to name add to the name of the variable. Defaults to `this_`.</param>
        public void SetNonNullUserVariablesFor<T>(string varName, string prefix)
        {
            SetNonNullUserVariablesFor<T>(ReadVariable<T>(varName), prefix);
        }

        /// <summary>
        /// Adds all non-null properties from the supplied object
        /// to the Dts.Variables.
        /// <para>The variables should by defined as read/write in the task.</para>
        /// <para>The variable names will be prefixed with `this_`.</para>
        /// </summary>
        /// <typeparam name="T">The type of class of the supplied object.</typeparam>
        /// <param name="config">The object to retrieve the values from.</param>
        public void SetNonNullUserVariablesFor<T>(T config)
        {
            SetNonNullUserVariablesFor<T>(config, null);
        }

        /// <summary>
        /// Adds all non-null properties from the supplied object
        /// to the Dts.Variables.
        /// <para>The variables should by defined as read/write in the task.</para>
        /// <para>The variable names will be prefixed with `this_`.</para>
        /// </summary>
        /// <typeparam name="T">The type of class of the supplied object.</typeparam>
        /// <param name="config">The object to retrieve the values from.</param>
        /// <param name="prefix">The prefix to name add to the name of the variable. Defaults to `this_`.</param>
        public void SetNonNullUserVariablesFor<T>(T config, string prefix)
        {
            if (config == null)
            {
                if (Logger != null)
                {
                    Logger.LogEntry(LogStatus.Failure, "Unable to set Variables, because the incoming data is null. Maybe the decoding of the json went wrong?");
                    Logger.LogEntry(LogStatus.Failure, "Please check that the components name is in the PackageName enum.");
                }
                throw new ArgumentNullException("config", "Unable to set Variables, because the incoming data is null. Maybe the decoding of the json went wrong?");
            }
            prefix = prefix ?? "this_";
            PropertyInfo[] props = typeof(T).GetProperties(BindingFlags.Instance | BindingFlags.Public);
            object value;
            string key;
            foreach (PropertyInfo prop in props)
            {
                value = prop.GetValue(config);
                key = prefix + prop.Name;
                // THere is no nullable string/int variable type in SSIS. This is solved by giving optional parameters in the configuration a default (empty string) value.
                // Otherwise, the value from a previous iteration is maintained, which is even worse.
                if (key != "cfg_tpl_jsonConfiguration" && value != null)
                {
                    if (
                        Dts.Variables.Contains(key)
                        && Dts.Variables[key].ReadOnly == false
                    )
                    {
                        try
                        {
                            Dts.Variables[key].Value = ConvertVariable(value, prop.PropertyType, Dts.Variables[key].Value.GetType());
                            /*                            var converted = ConvertVariable(value, prop.PropertyType, Dts.Variables[key].Value.GetType());
                                                        if (converted == null)
                                                        {
                                                            if (Logger != null) Logger.LogEntry(LogStatus.Warning, "Trying to Convert a class type object. Maybe you need to let the class extend DeloitteObject to let it go through the json serializer. See: DeloitteScript.ConvertVariable().");
                                                        }
                                                        else
                                                        {
                                                            Dts.Variables[key].Value = converted;
                                                        }
                            */
                            if (Logger != null) Logger.LogEntry(LogStatus.Progress, "Setting Variable " + key);
                        }
                        catch (Exception e)
                        {
                            if (Logger != null) Logger.LogEntry(LogStatus.Warning, "Unable to set Variable " + key + " because of a type-casting issue. The error was: " + e.ToString());
                        }
                    }
                    else if (Logger != null)
                    {
                        Logger.LogEntry(LogStatus.Warning, "Unable to set Variable " + key + " because it either not exists in Dts.Variables or the variable is readonly.");
                    }
                }
            }
        }

        /// <summary>
        /// Sets an enumarable to a Dts Variable so that it can be consumed 
        /// by a Ssis Foreach loop as Variable.
        /// </summary>
        /// <typeparam name="T">The type of item in the collection.</typeparam>
        /// <param name="collection">The data.</param>
        /// <param name="varName">The name of the variable to store it under.</param>
        /// <returns>True when ok, False when the variable name is not declared in the Task.</returns>
        public bool SetCollectionForForEachLoopToVar<T>(IEnumerable<T> collection, string varName)
        {
            if (Dts.Variables.Contains(varName))
            {
                ArrayList arr = new ArrayList();
                arr.AddRange(collection.Select(i => JsonConvert.SerializeObject(i)).ToList());
                Dts.Variables[varName].Value = arr;
                return true;
            }
            else
            {
                LogIfPossible(LogStatus.Failure, "Unable to set Variable " + varName + " because it doesn't exist. Please add it as a read/write variable to the Task.");
            }
            return false;
        }

        /// <summary>
        /// Puts the public properties of the the Header into a List of KeyValuePair&lt;string, object&gt; pairs.
        /// </summary>
        /// <param name="varName">The name of the writable variable to write to.</param>
        public void SetConfigHeaderToForEachLoopVar(string varName)
        {
            if (string.IsNullOrEmpty(varName))
            {
                LogOrThrow(LogStatus.Failure, "Unable to set configheader, because the varName attribute was not set.");
            }
            else
            {
                if (
                    Dts.Variables.Contains(varName)
                    && Dts.Variables[varName].ReadOnly == false
                    )
                {
                    List<KeyValuePair<string, object>> rows = new List<KeyValuePair<string, object>>();
                    if (Config != null && Config.Header != null)
                    {
                        foreach (var prop in typeof(ConfigHeader).GetProperties(BindingFlags.Instance | BindingFlags.Public))
                        {
                            rows.Add(new KeyValuePair<string, object>(prop.Name, prop.GetValue(Config.Header, null)));
                        }
                    }
                    SetCollectionForForEachLoopToVar<KeyValuePair<string, object>>(
                        rows,
                        varName
                    );
                    LogIfPossible(LogStatus.Success, "SetConfigHeaderToForEachLoopVar finished.");
                }
                else
                {
                    LogOrThrow(LogStatus.Failure, "Unable to set configheader, because the varName attribute was not set.");
                }
            }
        }

        /// <summary>
        /// Gets the configuration for the current package by its PackageName property.
        /// <seealso cref="PlatformConfig.ComponentParam"/>
        /// </summary>
        public void GetConfigForPackage()
        {
            if (string.IsNullOrEmpty(PackageName))
            {
                LogOrThrow(LogStatus.Failure, "Error loading config for package. Please add System::PackageName readonly variable to script task.");
            }
            else
            {
                LogIfPossible(LogStatus.Progress, string.Format("Loading config for PackageName {0}", PackageName));
                if (Config == null) LoadConfig();
                if (Config != null && Config.ComponentParams != null)
                {
                    PackageConfig = Config.ComponentParams.FirstOrDefault(c => Enum.GetName(typeof(PackageName), c.PackageName).Equals(PackageName, StringComparison.OrdinalIgnoreCase));
                    LogIfPossible(LogStatus.Success, "PackageConfig loaded");
                }
            }
        }

        /// <summary>
        /// Sets up a logger instance based on the current LoggingConnection.
        /// <para>If the connection is not there, a default will be set up. <see cref="SetupLoggingConnection()"/></para>
        /// <para>This method will use System::PackageName and System::TaskName variables for the logs
        /// and User::cfg_tpl_CMPlatformDB for the connection.</para>
        /// </summary>
        public void SetupLogger()
        {
            SetupLogger(null, PackageName, TaskName);
        }

        /// <summary>
        /// Sets up a logger instance based on the current LoggingConnection.
        /// <para>If the connection is not there, a default will be set up. <see cref="SetupLoggingConnection()"/></para>
        /// <para>This method will use System::PackageName and System::TaskName variables for the logs.</para>
        /// </summary>
        /// <param name="varNameOfConnection">The name of the variable holding information about the sqlconnection.</param>
        public void SetupLogger(string varNameOfConnection)
        {
            SetupLoggingConnection(varNameOfConnection);
            SetupLogger(PackageName, TaskName);
        }

        /// <summary>
        /// Sets up a logger instance based on the current LoggingConnection.
        /// <para>If the connection is not there, a default will be set up. <see cref="SetupLoggingConnection()"/></para>
        /// </summary>
        /// <param name="packageName">Your package name. ie End2EndIntegrationTest</param>
        /// <param name="executableName">Your current scripts name.</param>
        public void SetupLogger(string packageName, string executableName)
        {
            SetupLogger(null, packageName, executableName);
        }

        /// <summary>
        /// Sets up a logger instance based on the current LoggingConnection.
        /// <para>If the connection is not there, a default will be set up. <see cref="SetupLoggingConnection()"/></para>
        /// </summary>
        /// <param name="varNameOfConnection">The name of the variable holding information about the sqlconnection. Defaults to User::cfg_tpl_CMPlatformDB.</param>
        /// <param name="packageName">Your package name. ie End2EndIntegrationTest</param>
        /// <param name="executableName">Your current scripts name.</param>
        public void SetupLogger(string varNameOfConnection, string packageName, string executableName)
        {
            if (LoggingConnection == null) SetupLoggingConnection(varNameOfConnection);
            Logger = new Logger(LoggingConnection, packageName, executableName);
            
        }

        /// <summary>
        /// Sets up the connection based on the User::cfg_tpl_CMPlatformDB variable.
        /// <para>Make sure to call <see cref="Dispose()"/> at the end of your script.</para>
        /// </summary>
        public void SetupLoggingConnection()
        {
            SetupLoggingConnection(null);
        }

        /// <summary>
        /// Sets up the connection based on the provided variable name.
        /// <para>Make sure to call <see cref="Dispose()"/> at the end of your script.</para>
        /// </summary>
        /// <param name="var">The name of the variable that holds the connection information. Defaults to User::cfg_tpl_CMPlatformDB.</param>
        public void SetupLoggingConnection(string var) 
        {
            string loggingCMVar = var == null ? "User::cfg_tpl_CMPlatformDB" : var;

            if (Dts.Variables.Contains(loggingCMVar))
            {
                LoggingCMName = Dts.Variables[loggingCMVar].Value.ToString();
                LoggingConnection = Dts.Connections[LoggingCMName].AcquireConnection(Dts.Transaction) as SqlConnection;
            }
            else
            {
                throw new ArgumentNullException("Error setting up logging connection. Please add " + loggingCMVar + " to the readonly variables of the task.");
            }
        }

        /// <summary>
        /// Sends data to the ssis api (and autoforward to website, when possible).
        /// </summary>
        /// <param name="data">The data to send. Will be jsonSerialized.</param>
        public void SendDataToApi(object data) {
            UpdateApi((int)UpdateCodes.PayLoad, JsonConvert.SerializeObject(data));
        }

        /// <summary>
        /// Lets the api know that this component is finished. Does not say anything
        /// about success or failure.
        /// </summary>
        public void SendComponentFinishedToApi()
        {
            UpdateApi((int)UpdateCodes.ComponentFinished, PackageName);
        }


        /// <summary>
        /// Sends an update to the <see cref="WebApiEndpoint"/>.
        /// </summary>
        /// <param name="code">A code to pass.</param>
        /// <param name="message">Some message to add to the code.</param>
        public void UpdateApi(int code, string message) 
        {

            if (Config == null) LoadConfig();
            try
            {
                if (Logger == null) SetupLogger();
            }
            catch (ArgumentNullException) { }
            //validate
            if (WebApiEndpoint == null)
            {
                WebApiEndpoint = new WebApi();
                if (Logger != null) Logger.LogEntry(LogStatus.Warning, "WebApiEndpoint not set, using default settings: "+JsonConvert.SerializeObject(WebApiEndpoint));
            }
            //setup
            var data = new {
                ProjectId = Config == null || Config.Header == null ? -1 : Config.Header.ProjectId ?? -1,
                SsisApiRunId = Config == null || Config.Header == null ? -1 : Config.Header.SsisApiRunId ?? -1,
                Code = code,
                Created = DateTime.Now,
                Message = message,
            };
            //execute
            try
            {
                WebApiEndpoint.CallApi(data);
                //log
                if (Logger != null)
                {
                    Logger.LogEntry(
                        LogStatus.Success,
                        string.Format("Just sent an update to the webapi at {0}. Data sent: {1}",
                            WebApiEndpoint.Url.ToString(),
                            JsonConvert.SerializeObject(data)
                        )
                    );
                }
            }
            catch (Exception e) {
                if (Logger != null)
                {
                    Logger.LogEntry(
                        LogStatus.Failure,
                        string.Format("Unable to call the webapi at {0}. CRC: {1}",
                            WebApiEndpoint.Url.ToString(),
                            WebApiEndpoint.LastCrc
                        )
                    );
                    Logger.LogEntry(
                        LogStatus.Failure,
                        string.Format("Data to be sent: {0}",
                            JsonConvert.SerializeObject(data)
                        )
                    );
                    Logger.LogEntry(
                        LogStatus.Failure,
                        string.Format("Exception: {0}",
                            e.ToString()
                        )
                    );
                }
            }
        }

        /// <summary>
        /// Reads a string that is stored in a Object.
        /// </summary>
        /// <param name="variableName">The name under which the string is stored.</param>
        /// <returns>The value converted to string.</returns>
        public string ReadLongStringVariable(string variableName)
        {
            if (Dts.Variables[variableName].DataType.Equals(typeof(string))) {
                return Dts.Variables[variableName].Value.ToString();
            }
            OleDbDataAdapter da = new OleDbDataAdapter();
            DataTable dt = new DataTable();

            ADODB.Stream stm = new ADODB.Stream();
            ADODB.Recordset rs = ((ADODB.Recordset)Dts.Variables[variableName].Value).Clone();
            ADODB.Recordset rsCopy = new ADODB.Recordset();

            rs.Save(stm);
            rsCopy.Open(stm);
            da.Fill(dt, rs);
            dt.Clear();
            da.Fill(dt, rsCopy);

            if (
                dt.Rows.Count > 0
                && dt.Rows[0].ItemArray.Count() > 0
            )
            {
                return dt.Rows[0].ItemArray[0].ToString();
            }
            return null;
        }

        private string LoggingCMName;

        /// <summary>
        /// The SqlConnection to the logging database.
        /// </summary>
        private SqlConnection LoggingConnection;

        private void LogIfPossible(LogStatus status, string msg)
        {
            if (Logger != null) Logger.LogEntry(status, msg);
        }
        private void LogOrThrow(LogStatus status, string msg)
        {
            if (Logger != null) Logger.LogEntry(status, msg);
            else throw new Exception(msg);
        }

        /// <summary>
        /// Call this method at the end of your main() to release all resources.
        /// </summary>
        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }

        /// <summary>
        /// Deconstructor called by the Garbage Collector. Will dispose unmanaged resources.
        /// </summary>
        ~DeloitteScript()
        {
            Dispose(false);
        }

        /// <summary>
        /// Dispose all resources.
        /// </summary>
        /// <param name="disposing"></param>
        private void Dispose(bool disposing)
        {
            if (disposing)
            {
                if (Logger != null) Logger = null;
                if (LoggingConnection != null)
                {
                    Dts.Connections[LoggingCMName].ReleaseConnection(LoggingConnection);
                }
            }
        }

        private readonly ScriptObjectModel Dts;
    }
}

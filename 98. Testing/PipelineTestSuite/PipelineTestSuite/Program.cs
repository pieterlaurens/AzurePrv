using CommandLine;
using CommandLine.Text;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;
using PipelineTestSuite.TestSuites;

namespace PipelineTestSuite
{
    class Program
    {
        public static Options Options = new Options();

        public static bool StopNow = false;
        class NativeMethods
        {
            [DllImport("Kernel32")]
            public static extern bool SetConsoleCtrlHandler(HandlerRoutine Handler, bool Add);
        }
        // A delegate type to be used as the handler routine
        // for SetConsoleCtrlHandler.
        public delegate bool HandlerRoutine(CtrlTypes CtrlType);

        // An enumerated type for the control messages
        // sent to the handler routine.
        public enum CtrlTypes
        {
            CTRL_C_EVENT = 0,
            CTRL_BREAK_EVENT,
            CTRL_CLOSE_EVENT,
            CTRL_LOGOFF_EVENT = 5,
            CTRL_SHUTDOWN_EVENT
        }
        static void Main(string[] args)
        {
            Console.CancelKeyPress += (s, a) =>
            {
                a.Cancel = true;
                Console.WriteLine();
                Console.WriteLine("CancelKeyPressed");
                StopNow = true;
            };
            if (Parser.Default.ParseArguments(args, Options))
            {
                BaseSuite.Run<LonglistSuite>();
                BaseSuite.Run<LandscapeSuite>();
                BaseSuite.Run<QuestionnaireSuite>();
            }
        }


    }
    public class Options
    {
        [Option('s', "datasource", HelpText = ".")]
        public string DataSource { get; set; } //= "nlagpdatacore"

        [Option('c', "catalog", HelpText = ".")]
        public string Catalog { get; set; } //= "prv_prj_deploytest"

        [Option('o', "output", HelpText = ".")]
        public string OutputFile { get; set; } //= "prv_prj_deploytest"

        [Option('j', "json")]
        public string Json { get; set; }

        [HelpOption]
        public string GetUsage()
        {
            return HelpText.AutoBuild(this,
                (HelpText current) => HelpText.DefaultParsingErrorsHandler(this, current));
        }
    }
}

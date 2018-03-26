using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Text;
using Microsoft.Data.Tools.Schema.Sql.UnitTesting;
using Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace ProjectDbUnitTest
{
    [TestClass()]
    public class LandscapeTest : SqlDatabaseTestClass
    {

        public LandscapeTest()
        {
            InitializeComponent();
        }

        [TestInitialize()]
        public void TestInitialize()
        {
            base.InitializeTest();
        }
        [TestCleanup()]
        public void TestCleanup()
        {
            base.CleanupTest();
        }

        #region Designer support code

        /// <summary> 
        /// Required method for Designer support - do not modify 
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction dbo_web_getIpcLatestCeDocuments_ReturnEntry_TestAction;
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(LandscapeTest));
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction dbo_web_getIpcLatestCeDocuments_ReturnEntry_PretestAction;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.RowCountCondition rowCountCondition1;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction dbo_web_getIpcCompanies_ReturnEntry_TestAction;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction dbo_web_getIpcCompanies_ReturnEntry_PretestAction;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.RowCountCondition rowCountCondition2;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction dbo_web_getIpcLatestCeDocuments_NonexistentId_TestAction;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.EmptyResultSetCondition emptyResultSetCondition1;
            this.dbo_web_getIpcLatestCeDocuments_ReturnEntryData = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestActions();
            this.dbo_web_getIpcCompanies_ReturnEntryData = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestActions();
            this.dbo_web_getIpcLatestCeDocuments_NonexistentIdData = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestActions();
            dbo_web_getIpcLatestCeDocuments_ReturnEntry_TestAction = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction();
            dbo_web_getIpcLatestCeDocuments_ReturnEntry_PretestAction = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction();
            rowCountCondition1 = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.RowCountCondition();
            dbo_web_getIpcCompanies_ReturnEntry_TestAction = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction();
            dbo_web_getIpcCompanies_ReturnEntry_PretestAction = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction();
            rowCountCondition2 = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.RowCountCondition();
            dbo_web_getIpcLatestCeDocuments_NonexistentId_TestAction = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction();
            emptyResultSetCondition1 = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.EmptyResultSetCondition();
            // 
            // dbo_web_getIpcLatestCeDocuments_ReturnEntry_TestAction
            // 
            dbo_web_getIpcLatestCeDocuments_ReturnEntry_TestAction.Conditions.Add(rowCountCondition1);
            resources.ApplyResources(dbo_web_getIpcLatestCeDocuments_ReturnEntry_TestAction, "dbo_web_getIpcLatestCeDocuments_ReturnEntry_TestAction");
            // 
            // dbo_web_getIpcLatestCeDocuments_ReturnEntryData
            // 
            this.dbo_web_getIpcLatestCeDocuments_ReturnEntryData.PosttestAction = null;
            this.dbo_web_getIpcLatestCeDocuments_ReturnEntryData.PretestAction = dbo_web_getIpcLatestCeDocuments_ReturnEntry_PretestAction;
            this.dbo_web_getIpcLatestCeDocuments_ReturnEntryData.TestAction = dbo_web_getIpcLatestCeDocuments_ReturnEntry_TestAction;
            // 
            // dbo_web_getIpcLatestCeDocuments_ReturnEntry_PretestAction
            // 
            resources.ApplyResources(dbo_web_getIpcLatestCeDocuments_ReturnEntry_PretestAction, "dbo_web_getIpcLatestCeDocuments_ReturnEntry_PretestAction");
            // 
            // rowCountCondition1
            // 
            rowCountCondition1.Enabled = true;
            rowCountCondition1.Name = "rowCountCondition1";
            rowCountCondition1.ResultSet = 1;
            rowCountCondition1.RowCount = 1;
            // 
            // dbo_web_getIpcCompanies_ReturnEntryData
            // 
            this.dbo_web_getIpcCompanies_ReturnEntryData.PosttestAction = null;
            this.dbo_web_getIpcCompanies_ReturnEntryData.PretestAction = dbo_web_getIpcCompanies_ReturnEntry_PretestAction;
            this.dbo_web_getIpcCompanies_ReturnEntryData.TestAction = dbo_web_getIpcCompanies_ReturnEntry_TestAction;
            // 
            // dbo_web_getIpcCompanies_ReturnEntry_TestAction
            // 
            dbo_web_getIpcCompanies_ReturnEntry_TestAction.Conditions.Add(rowCountCondition2);
            resources.ApplyResources(dbo_web_getIpcCompanies_ReturnEntry_TestAction, "dbo_web_getIpcCompanies_ReturnEntry_TestAction");
            // 
            // dbo_web_getIpcCompanies_ReturnEntry_PretestAction
            // 
            resources.ApplyResources(dbo_web_getIpcCompanies_ReturnEntry_PretestAction, "dbo_web_getIpcCompanies_ReturnEntry_PretestAction");
            // 
            // rowCountCondition2
            // 
            rowCountCondition2.Enabled = true;
            rowCountCondition2.Name = "rowCountCondition2";
            rowCountCondition2.ResultSet = 1;
            rowCountCondition2.RowCount = 1;
            // 
            // dbo_web_getIpcLatestCeDocuments_NonexistentIdData
            // 
            this.dbo_web_getIpcLatestCeDocuments_NonexistentIdData.PosttestAction = null;
            this.dbo_web_getIpcLatestCeDocuments_NonexistentIdData.PretestAction = null;
            this.dbo_web_getIpcLatestCeDocuments_NonexistentIdData.TestAction = dbo_web_getIpcLatestCeDocuments_NonexistentId_TestAction;
            // 
            // dbo_web_getIpcLatestCeDocuments_NonexistentId_TestAction
            // 
            dbo_web_getIpcLatestCeDocuments_NonexistentId_TestAction.Conditions.Add(emptyResultSetCondition1);
            resources.ApplyResources(dbo_web_getIpcLatestCeDocuments_NonexistentId_TestAction, "dbo_web_getIpcLatestCeDocuments_NonexistentId_TestAction");
            // 
            // emptyResultSetCondition1
            // 
            emptyResultSetCondition1.Enabled = true;
            emptyResultSetCondition1.Name = "emptyResultSetCondition1";
            emptyResultSetCondition1.ResultSet = 1;
        }

        #endregion


        #region Additional test attributes
        //
        // You can use the following additional attributes as you write your tests:
        //
        // Use ClassInitialize to run code before running the first test in the class
        // [ClassInitialize()]
        // public static void MyClassInitialize(TestContext testContext) { }
        //
        // Use ClassCleanup to run code after all tests in a class have run
        // [ClassCleanup()]
        // public static void MyClassCleanup() { }
        //
        #endregion

        [TestMethod()]
        public void dbo_web_getIpcLatestCeDocuments_ReturnEntry()
        {
            SqlDatabaseTestActions testActions = this.dbo_web_getIpcLatestCeDocuments_ReturnEntryData;
            // Execute the pre-test script
            // 
            System.Diagnostics.Trace.WriteLineIf((testActions.PretestAction != null), "Executing pre-test script...");
            SqlExecutionResult[] pretestResults = TestService.Execute(this.PrivilegedContext, this.PrivilegedContext, testActions.PretestAction);
            try
            {
                // Execute the test script
                // 
                System.Diagnostics.Trace.WriteLineIf((testActions.TestAction != null), "Executing test script...");
                SqlExecutionResult[] testResults = TestService.Execute(this.ExecutionContext, this.PrivilegedContext, testActions.TestAction);
            }
            finally
            {
                // Execute the post-test script
                // 
                System.Diagnostics.Trace.WriteLineIf((testActions.PosttestAction != null), "Executing post-test script...");
                SqlExecutionResult[] posttestResults = TestService.Execute(this.PrivilegedContext, this.PrivilegedContext, testActions.PosttestAction);
            }
        }
        [TestMethod()]
        public void dbo_web_getIpcCompanies_ReturnEntry()
        {
            SqlDatabaseTestActions testActions = this.dbo_web_getIpcCompanies_ReturnEntryData;
            // Execute the pre-test script
            // 
            System.Diagnostics.Trace.WriteLineIf((testActions.PretestAction != null), "Executing pre-test script...");
            SqlExecutionResult[] pretestResults = TestService.Execute(this.PrivilegedContext, this.PrivilegedContext, testActions.PretestAction);
            try
            {
                // Execute the test script
                // 
                System.Diagnostics.Trace.WriteLineIf((testActions.TestAction != null), "Executing test script...");
                SqlExecutionResult[] testResults = TestService.Execute(this.ExecutionContext, this.PrivilegedContext, testActions.TestAction);
            }
            finally
            {
                // Execute the post-test script
                // 
                System.Diagnostics.Trace.WriteLineIf((testActions.PosttestAction != null), "Executing post-test script...");
                SqlExecutionResult[] posttestResults = TestService.Execute(this.PrivilegedContext, this.PrivilegedContext, testActions.PosttestAction);
            }
        }
        [TestMethod()]
        public void dbo_web_getIpcLatestCeDocuments_NonexistentId()
        {
            SqlDatabaseTestActions testActions = this.dbo_web_getIpcLatestCeDocuments_NonexistentIdData;
            // Execute the pre-test script
            // 
            System.Diagnostics.Trace.WriteLineIf((testActions.PretestAction != null), "Executing pre-test script...");
            SqlExecutionResult[] pretestResults = TestService.Execute(this.PrivilegedContext, this.PrivilegedContext, testActions.PretestAction);
            try
            {
                // Execute the test script
                // 
                System.Diagnostics.Trace.WriteLineIf((testActions.TestAction != null), "Executing test script...");
                SqlExecutionResult[] testResults = TestService.Execute(this.ExecutionContext, this.PrivilegedContext, testActions.TestAction);
            }
            finally
            {
                // Execute the post-test script
                // 
                System.Diagnostics.Trace.WriteLineIf((testActions.PosttestAction != null), "Executing post-test script...");
                SqlExecutionResult[] posttestResults = TestService.Execute(this.PrivilegedContext, this.PrivilegedContext, testActions.PosttestAction);
            }
        }


        private SqlDatabaseTestActions dbo_web_getIpcLatestCeDocuments_ReturnEntryData;
        private SqlDatabaseTestActions dbo_web_getIpcCompanies_ReturnEntryData;
        private SqlDatabaseTestActions dbo_web_getIpcLatestCeDocuments_NonexistentIdData;
    }
}

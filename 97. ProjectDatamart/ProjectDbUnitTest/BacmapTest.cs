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
    public class BacmapTest : SqlDatabaseTestClass
    {

        public BacmapTest()
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
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction bacmap_getEntityIdFromBvdTest_TestAction;
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(BacmapTest));
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.NotEmptyResultSetCondition notEmptyResultSetCondition1;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction bacmap_getEntityLabelFromBvdTest_TestAction;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.NotEmptyResultSetCondition notEmptyResultSetCondition2;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction bacmap_getEntityMappingTest_TestAction;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.NotEmptyResultSetCondition notEmptyResultSetCondition7;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction bacmap_getEntityMappingStatusTest_TestAction;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.NotEmptyResultSetCondition notEmptyResultSetCondition3;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction bacmap_getEntitySegmentationTest_TestAction;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.NotEmptyResultSetCondition notEmptyResultSetCondition6;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction score_calculate_mapping_fractionTest_TestAction;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.NotEmptyResultSetCondition notEmptyResultSetCondition5;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction score_calculate_sdi_scoreTest_TestAction;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.NotEmptyResultSetCondition notEmptyResultSetCondition4;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction score_calculate_mapping_fractionTest_PretestAction;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction score_calculate_mapping_fractionTest_PosttestAction;
            this.bacmap_getEntityIdFromBvdTestData = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestActions();
            this.bacmap_getEntityLabelFromBvdTestData = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestActions();
            this.bacmap_getEntityMappingTestData = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestActions();
            this.bacmap_getEntityMappingStatusTestData = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestActions();
            this.bacmap_getEntitySegmentationTestData = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestActions();
            this.score_calculate_mapping_fractionTestData = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestActions();
            this.score_calculate_sdi_scoreTestData = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestActions();
            bacmap_getEntityIdFromBvdTest_TestAction = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction();
            notEmptyResultSetCondition1 = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.NotEmptyResultSetCondition();
            bacmap_getEntityLabelFromBvdTest_TestAction = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction();
            notEmptyResultSetCondition2 = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.NotEmptyResultSetCondition();
            bacmap_getEntityMappingTest_TestAction = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction();
            notEmptyResultSetCondition7 = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.NotEmptyResultSetCondition();
            bacmap_getEntityMappingStatusTest_TestAction = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction();
            notEmptyResultSetCondition3 = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.NotEmptyResultSetCondition();
            bacmap_getEntitySegmentationTest_TestAction = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction();
            notEmptyResultSetCondition6 = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.NotEmptyResultSetCondition();
            score_calculate_mapping_fractionTest_TestAction = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction();
            notEmptyResultSetCondition5 = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.NotEmptyResultSetCondition();
            score_calculate_sdi_scoreTest_TestAction = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction();
            notEmptyResultSetCondition4 = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.NotEmptyResultSetCondition();
            score_calculate_mapping_fractionTest_PretestAction = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction();
            score_calculate_mapping_fractionTest_PosttestAction = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction();
            // 
            // bacmap_getEntityIdFromBvdTest_TestAction
            // 
            bacmap_getEntityIdFromBvdTest_TestAction.Conditions.Add(notEmptyResultSetCondition1);
            resources.ApplyResources(bacmap_getEntityIdFromBvdTest_TestAction, "bacmap_getEntityIdFromBvdTest_TestAction");
            // 
            // notEmptyResultSetCondition1
            // 
            notEmptyResultSetCondition1.Enabled = false;
            notEmptyResultSetCondition1.Name = "notEmptyResultSetCondition1";
            notEmptyResultSetCondition1.ResultSet = 1;
            // 
            // bacmap_getEntityLabelFromBvdTest_TestAction
            // 
            bacmap_getEntityLabelFromBvdTest_TestAction.Conditions.Add(notEmptyResultSetCondition2);
            resources.ApplyResources(bacmap_getEntityLabelFromBvdTest_TestAction, "bacmap_getEntityLabelFromBvdTest_TestAction");
            // 
            // notEmptyResultSetCondition2
            // 
            notEmptyResultSetCondition2.Enabled = false;
            notEmptyResultSetCondition2.Name = "notEmptyResultSetCondition2";
            notEmptyResultSetCondition2.ResultSet = 1;
            // 
            // bacmap_getEntityMappingTest_TestAction
            // 
            bacmap_getEntityMappingTest_TestAction.Conditions.Add(notEmptyResultSetCondition7);
            resources.ApplyResources(bacmap_getEntityMappingTest_TestAction, "bacmap_getEntityMappingTest_TestAction");
            // 
            // notEmptyResultSetCondition7
            // 
            notEmptyResultSetCondition7.Enabled = false;
            notEmptyResultSetCondition7.Name = "notEmptyResultSetCondition7";
            notEmptyResultSetCondition7.ResultSet = 1;
            // 
            // bacmap_getEntityMappingStatusTest_TestAction
            // 
            bacmap_getEntityMappingStatusTest_TestAction.Conditions.Add(notEmptyResultSetCondition3);
            resources.ApplyResources(bacmap_getEntityMappingStatusTest_TestAction, "bacmap_getEntityMappingStatusTest_TestAction");
            // 
            // notEmptyResultSetCondition3
            // 
            notEmptyResultSetCondition3.Enabled = false;
            notEmptyResultSetCondition3.Name = "notEmptyResultSetCondition3";
            notEmptyResultSetCondition3.ResultSet = 1;
            // 
            // bacmap_getEntitySegmentationTest_TestAction
            // 
            bacmap_getEntitySegmentationTest_TestAction.Conditions.Add(notEmptyResultSetCondition6);
            resources.ApplyResources(bacmap_getEntitySegmentationTest_TestAction, "bacmap_getEntitySegmentationTest_TestAction");
            // 
            // notEmptyResultSetCondition6
            // 
            notEmptyResultSetCondition6.Enabled = false;
            notEmptyResultSetCondition6.Name = "notEmptyResultSetCondition6";
            notEmptyResultSetCondition6.ResultSet = 1;
            // 
            // score_calculate_mapping_fractionTest_TestAction
            // 
            score_calculate_mapping_fractionTest_TestAction.Conditions.Add(notEmptyResultSetCondition5);
            resources.ApplyResources(score_calculate_mapping_fractionTest_TestAction, "score_calculate_mapping_fractionTest_TestAction");
            // 
            // notEmptyResultSetCondition5
            // 
            notEmptyResultSetCondition5.Enabled = false;
            notEmptyResultSetCondition5.Name = "notEmptyResultSetCondition5";
            notEmptyResultSetCondition5.ResultSet = 1;
            // 
            // score_calculate_sdi_scoreTest_TestAction
            // 
            score_calculate_sdi_scoreTest_TestAction.Conditions.Add(notEmptyResultSetCondition4);
            resources.ApplyResources(score_calculate_sdi_scoreTest_TestAction, "score_calculate_sdi_scoreTest_TestAction");
            // 
            // notEmptyResultSetCondition4
            // 
            notEmptyResultSetCondition4.Enabled = false;
            notEmptyResultSetCondition4.Name = "notEmptyResultSetCondition4";
            notEmptyResultSetCondition4.ResultSet = 1;
            // 
            // score_calculate_mapping_fractionTest_PretestAction
            // 
            resources.ApplyResources(score_calculate_mapping_fractionTest_PretestAction, "score_calculate_mapping_fractionTest_PretestAction");
            // 
            // score_calculate_mapping_fractionTest_PosttestAction
            // 
            resources.ApplyResources(score_calculate_mapping_fractionTest_PosttestAction, "score_calculate_mapping_fractionTest_PosttestAction");
            // 
            // bacmap_getEntityIdFromBvdTestData
            // 
            this.bacmap_getEntityIdFromBvdTestData.PosttestAction = null;
            this.bacmap_getEntityIdFromBvdTestData.PretestAction = null;
            this.bacmap_getEntityIdFromBvdTestData.TestAction = bacmap_getEntityIdFromBvdTest_TestAction;
            // 
            // bacmap_getEntityLabelFromBvdTestData
            // 
            this.bacmap_getEntityLabelFromBvdTestData.PosttestAction = null;
            this.bacmap_getEntityLabelFromBvdTestData.PretestAction = null;
            this.bacmap_getEntityLabelFromBvdTestData.TestAction = bacmap_getEntityLabelFromBvdTest_TestAction;
            // 
            // bacmap_getEntityMappingTestData
            // 
            this.bacmap_getEntityMappingTestData.PosttestAction = null;
            this.bacmap_getEntityMappingTestData.PretestAction = null;
            this.bacmap_getEntityMappingTestData.TestAction = bacmap_getEntityMappingTest_TestAction;
            // 
            // bacmap_getEntityMappingStatusTestData
            // 
            this.bacmap_getEntityMappingStatusTestData.PosttestAction = null;
            this.bacmap_getEntityMappingStatusTestData.PretestAction = null;
            this.bacmap_getEntityMappingStatusTestData.TestAction = bacmap_getEntityMappingStatusTest_TestAction;
            // 
            // bacmap_getEntitySegmentationTestData
            // 
            this.bacmap_getEntitySegmentationTestData.PosttestAction = null;
            this.bacmap_getEntitySegmentationTestData.PretestAction = null;
            this.bacmap_getEntitySegmentationTestData.TestAction = bacmap_getEntitySegmentationTest_TestAction;
            // 
            // score_calculate_mapping_fractionTestData
            // 
            this.score_calculate_mapping_fractionTestData.PosttestAction = score_calculate_mapping_fractionTest_PosttestAction;
            this.score_calculate_mapping_fractionTestData.PretestAction = score_calculate_mapping_fractionTest_PretestAction;
            this.score_calculate_mapping_fractionTestData.TestAction = score_calculate_mapping_fractionTest_TestAction;
            // 
            // score_calculate_sdi_scoreTestData
            // 
            this.score_calculate_sdi_scoreTestData.PosttestAction = null;
            this.score_calculate_sdi_scoreTestData.PretestAction = null;
            this.score_calculate_sdi_scoreTestData.TestAction = score_calculate_sdi_scoreTest_TestAction;
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
        public void bacmap_getEntityIdFromBvdTest()
        {
            SqlDatabaseTestActions testActions = this.bacmap_getEntityIdFromBvdTestData;
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
        public void bacmap_getEntityLabelFromBvdTest()
        {
            SqlDatabaseTestActions testActions = this.bacmap_getEntityLabelFromBvdTestData;
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
        public void bacmap_getEntityMappingTest()
        {
            SqlDatabaseTestActions testActions = this.bacmap_getEntityMappingTestData;
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
        public void bacmap_getEntityMappingStatusTest()
        {
            SqlDatabaseTestActions testActions = this.bacmap_getEntityMappingStatusTestData;
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
        public void bacmap_getEntitySegmentationTest()
        {
            SqlDatabaseTestActions testActions = this.bacmap_getEntitySegmentationTestData;
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
        public void score_calculate_mapping_fractionTest()
        {
            SqlDatabaseTestActions testActions = this.score_calculate_mapping_fractionTestData;
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
        public void score_calculate_sdi_scoreTest()
        {
            SqlDatabaseTestActions testActions = this.score_calculate_sdi_scoreTestData;
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
        private SqlDatabaseTestActions bacmap_getEntityIdFromBvdTestData;
        private SqlDatabaseTestActions bacmap_getEntityLabelFromBvdTestData;
        private SqlDatabaseTestActions bacmap_getEntityMappingTestData;
        private SqlDatabaseTestActions bacmap_getEntityMappingStatusTestData;
        private SqlDatabaseTestActions bacmap_getEntitySegmentationTestData;
        private SqlDatabaseTestActions score_calculate_mapping_fractionTestData;
        private SqlDatabaseTestActions score_calculate_sdi_scoreTestData;
    }
}

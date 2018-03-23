using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Text;
using Microsoft.Data.Tools.Schema.Sql.UnitTesting;
using Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace DatahandlerUnitTest
{
    [TestClass()]
    public class DevUnitTest1 : SqlDatabaseTestClass
    {

        public DevUnitTest1()
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
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction dev_ufn_company_textTest_TestAction;
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(DevUnitTest1));
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.NotEmptyResultSetCondition notEmptyResultSetCondition1;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction dev_ufn_company_text_topicTest_TestAction;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.NotEmptyResultSetCondition notEmptyResultSetCondition2;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction dev_ufn_keyword_patent_class_profileTest_TestAction;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.NotEmptyResultSetCondition notEmptyResultSetCondition4;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction dev_ufn_patent_text_topicTest_TestAction;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.NotEmptyResultSetCondition notEmptyResultSetCondition5;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction dev_ufn_pubmed_text_topicTest_TestAction;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.NotEmptyResultSetCondition notEmptyResultSetCondition7;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction dev_ufn_sec_text_topicTest_TestAction;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.NotEmptyResultSetCondition notEmptyResultSetCondition8;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction dev_ufn_web_text_topicTest_TestAction;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.NotEmptyResultSetCondition notEmptyResultSetCondition9;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction dev_company_basicTest_TestAction;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.NotEmptyResultSetCondition notEmptyResultSetCondition3;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction dev_applicantTest_TestAction;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.NotEmptyResultSetCondition notEmptyResultSetCondition10;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction dev_applicant_bvd_idTest_TestAction;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.NotEmptyResultSetCondition notEmptyResultSetCondition11;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction dev_applicant_family_class_dateTest_TestAction;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.NotEmptyResultSetCondition notEmptyResultSetCondition12;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction dev_calendarTest_TestAction;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.NotEmptyResultSetCondition notEmptyResultSetCondition13;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction dev_calendar_attribute_numericTest_TestAction;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.NotEmptyResultSetCondition notEmptyResultSetCondition14;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction dev_company_financialTest_TestAction;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.NotEmptyResultSetCondition notEmptyResultSetCondition15;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction dev_company_financial_ratioTest_TestAction;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.NotEmptyResultSetCondition notEmptyResultSetCondition16;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction dev_company_ip_timeTest_TestAction;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.NotEmptyResultSetCondition notEmptyResultSetCondition17;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction dev_company_patent_familyTest_TestAction;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.NotEmptyResultSetCondition notEmptyResultSetCondition18;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction dev_company_textTest_TestAction;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.NotEmptyResultSetCondition notEmptyResultSetCondition19;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction dev_company_websiteTest_TestAction;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.NotEmptyResultSetCondition notEmptyResultSetCondition20;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction dev_deal_acquirerTest_TestAction;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.NotEmptyResultSetCondition notEmptyResultSetCondition21;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction dev_deal_overviewTest_TestAction;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.NotEmptyResultSetCondition notEmptyResultSetCondition22;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction dev_deal_structureTest_TestAction;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.NotEmptyResultSetCondition notEmptyResultSetCondition23;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction dev_deal_targetTest_TestAction;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.NotEmptyResultSetCondition notEmptyResultSetCondition24;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction dev_deal_textTest_TestAction;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.NotEmptyResultSetCondition notEmptyResultSetCondition25;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction dev_family_appln_date_classTest_TestAction;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.NotEmptyResultSetCondition notEmptyResultSetCondition26;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction dev_industry_codeTest_TestAction;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.NotEmptyResultSetCondition notEmptyResultSetCondition27;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction dev_patent_classTest_TestAction;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.NotEmptyResultSetCondition notEmptyResultSetCondition28;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction dev_patent_class_lineageTest_TestAction;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.NotEmptyResultSetCondition notEmptyResultSetCondition29;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction dev_patent_class_metricTest_TestAction;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.NotEmptyResultSetCondition notEmptyResultSetCondition30;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction dev_patent_family_classTest_TestAction;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.NotEmptyResultSetCondition notEmptyResultSetCondition31;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction dev_company_retrieved_secTest_TestAction;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.NotEmptyResultSetCondition notEmptyResultSetCondition6;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction dev_company_retrieved_orbisTest_TestAction;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction dev_company_retrieved_webTest_TestAction;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction dev_company_retrieved_patentTest_TestAction;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction dev_company_tickerTest_TestAction;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.NotEmptyResultSetCondition notEmptyResultSetCondition32;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction dev_get_source_versionTest_TestAction;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.NotEmptyResultSetCondition notEmptyResultSetCondition33;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.NotEmptyResultSetCondition notEmptyResultSetCondition34;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.NotEmptyResultSetCondition notEmptyResultSetCondition35;
            Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.NotEmptyResultSetCondition notEmptyResultSetCondition36;
            this.dev_ufn_company_textTestData = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestActions();
            this.dev_ufn_company_text_topicTestData = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestActions();
            this.dev_ufn_keyword_patent_class_profileTestData = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestActions();
            this.dev_ufn_patent_text_topicTestData = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestActions();
            this.dev_ufn_pubmed_text_topicTestData = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestActions();
            this.dev_ufn_sec_text_topicTestData = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestActions();
            this.dev_ufn_web_text_topicTestData = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestActions();
            this.dev_company_basicTestData = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestActions();
            this.dev_applicantTestData = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestActions();
            this.dev_applicant_bvd_idTestData = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestActions();
            this.dev_applicant_family_class_dateTestData = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestActions();
            this.dev_calendarTestData = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestActions();
            this.dev_calendar_attribute_numericTestData = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestActions();
            this.dev_company_financialTestData = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestActions();
            this.dev_company_financial_ratioTestData = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestActions();
            this.dev_company_ip_timeTestData = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestActions();
            this.dev_company_patent_familyTestData = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestActions();
            this.dev_company_textTestData = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestActions();
            this.dev_company_websiteTestData = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestActions();
            this.dev_deal_acquirerTestData = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestActions();
            this.dev_deal_overviewTestData = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestActions();
            this.dev_deal_structureTestData = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestActions();
            this.dev_deal_targetTestData = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestActions();
            this.dev_deal_textTestData = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestActions();
            this.dev_family_appln_date_classTestData = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestActions();
            this.dev_industry_codeTestData = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestActions();
            this.dev_patent_classTestData = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestActions();
            this.dev_patent_class_lineageTestData = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestActions();
            this.dev_patent_class_metricTestData = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestActions();
            this.dev_patent_family_classTestData = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestActions();
            this.dev_company_retrieved_secTestData = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestActions();
            this.dev_company_retrieved_orbisTestData = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestActions();
            this.dev_company_retrieved_webTestData = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestActions();
            this.dev_company_retrieved_patentTestData = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestActions();
            this.dev_company_tickerTestData = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestActions();
            this.dev_get_source_versionTestData = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestActions();
            dev_ufn_company_textTest_TestAction = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction();
            notEmptyResultSetCondition1 = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.NotEmptyResultSetCondition();
            dev_ufn_company_text_topicTest_TestAction = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction();
            notEmptyResultSetCondition2 = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.NotEmptyResultSetCondition();
            dev_ufn_keyword_patent_class_profileTest_TestAction = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction();
            notEmptyResultSetCondition4 = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.NotEmptyResultSetCondition();
            dev_ufn_patent_text_topicTest_TestAction = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction();
            notEmptyResultSetCondition5 = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.NotEmptyResultSetCondition();
            dev_ufn_pubmed_text_topicTest_TestAction = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction();
            notEmptyResultSetCondition7 = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.NotEmptyResultSetCondition();
            dev_ufn_sec_text_topicTest_TestAction = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction();
            notEmptyResultSetCondition8 = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.NotEmptyResultSetCondition();
            dev_ufn_web_text_topicTest_TestAction = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction();
            notEmptyResultSetCondition9 = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.NotEmptyResultSetCondition();
            dev_company_basicTest_TestAction = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction();
            notEmptyResultSetCondition3 = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.NotEmptyResultSetCondition();
            dev_applicantTest_TestAction = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction();
            notEmptyResultSetCondition10 = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.NotEmptyResultSetCondition();
            dev_applicant_bvd_idTest_TestAction = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction();
            notEmptyResultSetCondition11 = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.NotEmptyResultSetCondition();
            dev_applicant_family_class_dateTest_TestAction = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction();
            notEmptyResultSetCondition12 = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.NotEmptyResultSetCondition();
            dev_calendarTest_TestAction = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction();
            notEmptyResultSetCondition13 = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.NotEmptyResultSetCondition();
            dev_calendar_attribute_numericTest_TestAction = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction();
            notEmptyResultSetCondition14 = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.NotEmptyResultSetCondition();
            dev_company_financialTest_TestAction = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction();
            notEmptyResultSetCondition15 = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.NotEmptyResultSetCondition();
            dev_company_financial_ratioTest_TestAction = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction();
            notEmptyResultSetCondition16 = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.NotEmptyResultSetCondition();
            dev_company_ip_timeTest_TestAction = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction();
            notEmptyResultSetCondition17 = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.NotEmptyResultSetCondition();
            dev_company_patent_familyTest_TestAction = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction();
            notEmptyResultSetCondition18 = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.NotEmptyResultSetCondition();
            dev_company_textTest_TestAction = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction();
            notEmptyResultSetCondition19 = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.NotEmptyResultSetCondition();
            dev_company_websiteTest_TestAction = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction();
            notEmptyResultSetCondition20 = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.NotEmptyResultSetCondition();
            dev_deal_acquirerTest_TestAction = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction();
            notEmptyResultSetCondition21 = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.NotEmptyResultSetCondition();
            dev_deal_overviewTest_TestAction = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction();
            notEmptyResultSetCondition22 = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.NotEmptyResultSetCondition();
            dev_deal_structureTest_TestAction = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction();
            notEmptyResultSetCondition23 = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.NotEmptyResultSetCondition();
            dev_deal_targetTest_TestAction = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction();
            notEmptyResultSetCondition24 = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.NotEmptyResultSetCondition();
            dev_deal_textTest_TestAction = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction();
            notEmptyResultSetCondition25 = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.NotEmptyResultSetCondition();
            dev_family_appln_date_classTest_TestAction = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction();
            notEmptyResultSetCondition26 = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.NotEmptyResultSetCondition();
            dev_industry_codeTest_TestAction = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction();
            notEmptyResultSetCondition27 = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.NotEmptyResultSetCondition();
            dev_patent_classTest_TestAction = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction();
            notEmptyResultSetCondition28 = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.NotEmptyResultSetCondition();
            dev_patent_class_lineageTest_TestAction = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction();
            notEmptyResultSetCondition29 = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.NotEmptyResultSetCondition();
            dev_patent_class_metricTest_TestAction = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction();
            notEmptyResultSetCondition30 = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.NotEmptyResultSetCondition();
            dev_patent_family_classTest_TestAction = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction();
            notEmptyResultSetCondition31 = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.NotEmptyResultSetCondition();
            dev_company_retrieved_secTest_TestAction = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction();
            notEmptyResultSetCondition6 = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.NotEmptyResultSetCondition();
            dev_company_retrieved_orbisTest_TestAction = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction();
            dev_company_retrieved_webTest_TestAction = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction();
            dev_company_retrieved_patentTest_TestAction = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction();
            dev_company_tickerTest_TestAction = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction();
            notEmptyResultSetCondition32 = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.NotEmptyResultSetCondition();
            dev_get_source_versionTest_TestAction = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.SqlDatabaseTestAction();
            notEmptyResultSetCondition33 = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.NotEmptyResultSetCondition();
            notEmptyResultSetCondition34 = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.NotEmptyResultSetCondition();
            notEmptyResultSetCondition35 = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.NotEmptyResultSetCondition();
            notEmptyResultSetCondition36 = new Microsoft.Data.Tools.Schema.Sql.UnitTesting.Conditions.NotEmptyResultSetCondition();
            // 
            // dev_ufn_company_textTest_TestAction
            // 
            dev_ufn_company_textTest_TestAction.Conditions.Add(notEmptyResultSetCondition1);
            resources.ApplyResources(dev_ufn_company_textTest_TestAction, "dev_ufn_company_textTest_TestAction");
            // 
            // notEmptyResultSetCondition1
            // 
            notEmptyResultSetCondition1.Enabled = true;
            notEmptyResultSetCondition1.Name = "notEmptyResultSetCondition1";
            notEmptyResultSetCondition1.ResultSet = 1;
            // 
            // dev_ufn_company_text_topicTest_TestAction
            // 
            dev_ufn_company_text_topicTest_TestAction.Conditions.Add(notEmptyResultSetCondition2);
            resources.ApplyResources(dev_ufn_company_text_topicTest_TestAction, "dev_ufn_company_text_topicTest_TestAction");
            // 
            // notEmptyResultSetCondition2
            // 
            notEmptyResultSetCondition2.Enabled = true;
            notEmptyResultSetCondition2.Name = "notEmptyResultSetCondition2";
            notEmptyResultSetCondition2.ResultSet = 1;
            // 
            // dev_ufn_keyword_patent_class_profileTest_TestAction
            // 
            dev_ufn_keyword_patent_class_profileTest_TestAction.Conditions.Add(notEmptyResultSetCondition4);
            resources.ApplyResources(dev_ufn_keyword_patent_class_profileTest_TestAction, "dev_ufn_keyword_patent_class_profileTest_TestAction");
            // 
            // notEmptyResultSetCondition4
            // 
            notEmptyResultSetCondition4.Enabled = true;
            notEmptyResultSetCondition4.Name = "notEmptyResultSetCondition4";
            notEmptyResultSetCondition4.ResultSet = 1;
            // 
            // dev_ufn_patent_text_topicTest_TestAction
            // 
            dev_ufn_patent_text_topicTest_TestAction.Conditions.Add(notEmptyResultSetCondition5);
            resources.ApplyResources(dev_ufn_patent_text_topicTest_TestAction, "dev_ufn_patent_text_topicTest_TestAction");
            // 
            // notEmptyResultSetCondition5
            // 
            notEmptyResultSetCondition5.Enabled = true;
            notEmptyResultSetCondition5.Name = "notEmptyResultSetCondition5";
            notEmptyResultSetCondition5.ResultSet = 1;
            // 
            // dev_ufn_pubmed_text_topicTest_TestAction
            // 
            dev_ufn_pubmed_text_topicTest_TestAction.Conditions.Add(notEmptyResultSetCondition7);
            resources.ApplyResources(dev_ufn_pubmed_text_topicTest_TestAction, "dev_ufn_pubmed_text_topicTest_TestAction");
            // 
            // notEmptyResultSetCondition7
            // 
            notEmptyResultSetCondition7.Enabled = true;
            notEmptyResultSetCondition7.Name = "notEmptyResultSetCondition7";
            notEmptyResultSetCondition7.ResultSet = 1;
            // 
            // dev_ufn_sec_text_topicTest_TestAction
            // 
            dev_ufn_sec_text_topicTest_TestAction.Conditions.Add(notEmptyResultSetCondition8);
            resources.ApplyResources(dev_ufn_sec_text_topicTest_TestAction, "dev_ufn_sec_text_topicTest_TestAction");
            // 
            // notEmptyResultSetCondition8
            // 
            notEmptyResultSetCondition8.Enabled = true;
            notEmptyResultSetCondition8.Name = "notEmptyResultSetCondition8";
            notEmptyResultSetCondition8.ResultSet = 1;
            // 
            // dev_ufn_web_text_topicTest_TestAction
            // 
            dev_ufn_web_text_topicTest_TestAction.Conditions.Add(notEmptyResultSetCondition9);
            resources.ApplyResources(dev_ufn_web_text_topicTest_TestAction, "dev_ufn_web_text_topicTest_TestAction");
            // 
            // notEmptyResultSetCondition9
            // 
            notEmptyResultSetCondition9.Enabled = true;
            notEmptyResultSetCondition9.Name = "notEmptyResultSetCondition9";
            notEmptyResultSetCondition9.ResultSet = 1;
            // 
            // dev_company_basicTest_TestAction
            // 
            dev_company_basicTest_TestAction.Conditions.Add(notEmptyResultSetCondition3);
            resources.ApplyResources(dev_company_basicTest_TestAction, "dev_company_basicTest_TestAction");
            // 
            // notEmptyResultSetCondition3
            // 
            notEmptyResultSetCondition3.Enabled = true;
            notEmptyResultSetCondition3.Name = "notEmptyResultSetCondition3";
            notEmptyResultSetCondition3.ResultSet = 1;
            // 
            // dev_applicantTest_TestAction
            // 
            dev_applicantTest_TestAction.Conditions.Add(notEmptyResultSetCondition10);
            resources.ApplyResources(dev_applicantTest_TestAction, "dev_applicantTest_TestAction");
            // 
            // notEmptyResultSetCondition10
            // 
            notEmptyResultSetCondition10.Enabled = true;
            notEmptyResultSetCondition10.Name = "notEmptyResultSetCondition10";
            notEmptyResultSetCondition10.ResultSet = 1;
            // 
            // dev_applicant_bvd_idTest_TestAction
            // 
            dev_applicant_bvd_idTest_TestAction.Conditions.Add(notEmptyResultSetCondition11);
            resources.ApplyResources(dev_applicant_bvd_idTest_TestAction, "dev_applicant_bvd_idTest_TestAction");
            // 
            // notEmptyResultSetCondition11
            // 
            notEmptyResultSetCondition11.Enabled = true;
            notEmptyResultSetCondition11.Name = "notEmptyResultSetCondition11";
            notEmptyResultSetCondition11.ResultSet = 1;
            // 
            // dev_applicant_family_class_dateTest_TestAction
            // 
            dev_applicant_family_class_dateTest_TestAction.Conditions.Add(notEmptyResultSetCondition12);
            resources.ApplyResources(dev_applicant_family_class_dateTest_TestAction, "dev_applicant_family_class_dateTest_TestAction");
            // 
            // notEmptyResultSetCondition12
            // 
            notEmptyResultSetCondition12.Enabled = true;
            notEmptyResultSetCondition12.Name = "notEmptyResultSetCondition12";
            notEmptyResultSetCondition12.ResultSet = 1;
            // 
            // dev_calendarTest_TestAction
            // 
            dev_calendarTest_TestAction.Conditions.Add(notEmptyResultSetCondition13);
            resources.ApplyResources(dev_calendarTest_TestAction, "dev_calendarTest_TestAction");
            // 
            // notEmptyResultSetCondition13
            // 
            notEmptyResultSetCondition13.Enabled = true;
            notEmptyResultSetCondition13.Name = "notEmptyResultSetCondition13";
            notEmptyResultSetCondition13.ResultSet = 1;
            // 
            // dev_calendar_attribute_numericTest_TestAction
            // 
            dev_calendar_attribute_numericTest_TestAction.Conditions.Add(notEmptyResultSetCondition14);
            resources.ApplyResources(dev_calendar_attribute_numericTest_TestAction, "dev_calendar_attribute_numericTest_TestAction");
            // 
            // notEmptyResultSetCondition14
            // 
            notEmptyResultSetCondition14.Enabled = true;
            notEmptyResultSetCondition14.Name = "notEmptyResultSetCondition14";
            notEmptyResultSetCondition14.ResultSet = 1;
            // 
            // dev_company_financialTest_TestAction
            // 
            dev_company_financialTest_TestAction.Conditions.Add(notEmptyResultSetCondition15);
            resources.ApplyResources(dev_company_financialTest_TestAction, "dev_company_financialTest_TestAction");
            // 
            // notEmptyResultSetCondition15
            // 
            notEmptyResultSetCondition15.Enabled = true;
            notEmptyResultSetCondition15.Name = "notEmptyResultSetCondition15";
            notEmptyResultSetCondition15.ResultSet = 1;
            // 
            // dev_company_financial_ratioTest_TestAction
            // 
            dev_company_financial_ratioTest_TestAction.Conditions.Add(notEmptyResultSetCondition16);
            resources.ApplyResources(dev_company_financial_ratioTest_TestAction, "dev_company_financial_ratioTest_TestAction");
            // 
            // notEmptyResultSetCondition16
            // 
            notEmptyResultSetCondition16.Enabled = true;
            notEmptyResultSetCondition16.Name = "notEmptyResultSetCondition16";
            notEmptyResultSetCondition16.ResultSet = 1;
            // 
            // dev_company_ip_timeTest_TestAction
            // 
            dev_company_ip_timeTest_TestAction.Conditions.Add(notEmptyResultSetCondition17);
            resources.ApplyResources(dev_company_ip_timeTest_TestAction, "dev_company_ip_timeTest_TestAction");
            // 
            // notEmptyResultSetCondition17
            // 
            notEmptyResultSetCondition17.Enabled = true;
            notEmptyResultSetCondition17.Name = "notEmptyResultSetCondition17";
            notEmptyResultSetCondition17.ResultSet = 1;
            // 
            // dev_company_patent_familyTest_TestAction
            // 
            dev_company_patent_familyTest_TestAction.Conditions.Add(notEmptyResultSetCondition18);
            resources.ApplyResources(dev_company_patent_familyTest_TestAction, "dev_company_patent_familyTest_TestAction");
            // 
            // notEmptyResultSetCondition18
            // 
            notEmptyResultSetCondition18.Enabled = true;
            notEmptyResultSetCondition18.Name = "notEmptyResultSetCondition18";
            notEmptyResultSetCondition18.ResultSet = 1;
            // 
            // dev_company_textTest_TestAction
            // 
            dev_company_textTest_TestAction.Conditions.Add(notEmptyResultSetCondition19);
            resources.ApplyResources(dev_company_textTest_TestAction, "dev_company_textTest_TestAction");
            // 
            // notEmptyResultSetCondition19
            // 
            notEmptyResultSetCondition19.Enabled = true;
            notEmptyResultSetCondition19.Name = "notEmptyResultSetCondition19";
            notEmptyResultSetCondition19.ResultSet = 1;
            // 
            // dev_company_websiteTest_TestAction
            // 
            dev_company_websiteTest_TestAction.Conditions.Add(notEmptyResultSetCondition20);
            resources.ApplyResources(dev_company_websiteTest_TestAction, "dev_company_websiteTest_TestAction");
            // 
            // notEmptyResultSetCondition20
            // 
            notEmptyResultSetCondition20.Enabled = true;
            notEmptyResultSetCondition20.Name = "notEmptyResultSetCondition20";
            notEmptyResultSetCondition20.ResultSet = 1;
            // 
            // dev_deal_acquirerTest_TestAction
            // 
            dev_deal_acquirerTest_TestAction.Conditions.Add(notEmptyResultSetCondition21);
            resources.ApplyResources(dev_deal_acquirerTest_TestAction, "dev_deal_acquirerTest_TestAction");
            // 
            // notEmptyResultSetCondition21
            // 
            notEmptyResultSetCondition21.Enabled = true;
            notEmptyResultSetCondition21.Name = "notEmptyResultSetCondition21";
            notEmptyResultSetCondition21.ResultSet = 1;
            // 
            // dev_deal_overviewTest_TestAction
            // 
            dev_deal_overviewTest_TestAction.Conditions.Add(notEmptyResultSetCondition22);
            resources.ApplyResources(dev_deal_overviewTest_TestAction, "dev_deal_overviewTest_TestAction");
            // 
            // notEmptyResultSetCondition22
            // 
            notEmptyResultSetCondition22.Enabled = true;
            notEmptyResultSetCondition22.Name = "notEmptyResultSetCondition22";
            notEmptyResultSetCondition22.ResultSet = 1;
            // 
            // dev_deal_structureTest_TestAction
            // 
            dev_deal_structureTest_TestAction.Conditions.Add(notEmptyResultSetCondition23);
            resources.ApplyResources(dev_deal_structureTest_TestAction, "dev_deal_structureTest_TestAction");
            // 
            // notEmptyResultSetCondition23
            // 
            notEmptyResultSetCondition23.Enabled = true;
            notEmptyResultSetCondition23.Name = "notEmptyResultSetCondition23";
            notEmptyResultSetCondition23.ResultSet = 1;
            // 
            // dev_deal_targetTest_TestAction
            // 
            dev_deal_targetTest_TestAction.Conditions.Add(notEmptyResultSetCondition24);
            resources.ApplyResources(dev_deal_targetTest_TestAction, "dev_deal_targetTest_TestAction");
            // 
            // notEmptyResultSetCondition24
            // 
            notEmptyResultSetCondition24.Enabled = true;
            notEmptyResultSetCondition24.Name = "notEmptyResultSetCondition24";
            notEmptyResultSetCondition24.ResultSet = 1;
            // 
            // dev_deal_textTest_TestAction
            // 
            dev_deal_textTest_TestAction.Conditions.Add(notEmptyResultSetCondition25);
            resources.ApplyResources(dev_deal_textTest_TestAction, "dev_deal_textTest_TestAction");
            // 
            // notEmptyResultSetCondition25
            // 
            notEmptyResultSetCondition25.Enabled = true;
            notEmptyResultSetCondition25.Name = "notEmptyResultSetCondition25";
            notEmptyResultSetCondition25.ResultSet = 1;
            // 
            // dev_family_appln_date_classTest_TestAction
            // 
            dev_family_appln_date_classTest_TestAction.Conditions.Add(notEmptyResultSetCondition26);
            resources.ApplyResources(dev_family_appln_date_classTest_TestAction, "dev_family_appln_date_classTest_TestAction");
            // 
            // notEmptyResultSetCondition26
            // 
            notEmptyResultSetCondition26.Enabled = true;
            notEmptyResultSetCondition26.Name = "notEmptyResultSetCondition26";
            notEmptyResultSetCondition26.ResultSet = 1;
            // 
            // dev_industry_codeTest_TestAction
            // 
            dev_industry_codeTest_TestAction.Conditions.Add(notEmptyResultSetCondition27);
            resources.ApplyResources(dev_industry_codeTest_TestAction, "dev_industry_codeTest_TestAction");
            // 
            // notEmptyResultSetCondition27
            // 
            notEmptyResultSetCondition27.Enabled = true;
            notEmptyResultSetCondition27.Name = "notEmptyResultSetCondition27";
            notEmptyResultSetCondition27.ResultSet = 1;
            // 
            // dev_patent_classTest_TestAction
            // 
            dev_patent_classTest_TestAction.Conditions.Add(notEmptyResultSetCondition28);
            resources.ApplyResources(dev_patent_classTest_TestAction, "dev_patent_classTest_TestAction");
            // 
            // notEmptyResultSetCondition28
            // 
            notEmptyResultSetCondition28.Enabled = true;
            notEmptyResultSetCondition28.Name = "notEmptyResultSetCondition28";
            notEmptyResultSetCondition28.ResultSet = 1;
            // 
            // dev_patent_class_lineageTest_TestAction
            // 
            dev_patent_class_lineageTest_TestAction.Conditions.Add(notEmptyResultSetCondition29);
            resources.ApplyResources(dev_patent_class_lineageTest_TestAction, "dev_patent_class_lineageTest_TestAction");
            // 
            // notEmptyResultSetCondition29
            // 
            notEmptyResultSetCondition29.Enabled = true;
            notEmptyResultSetCondition29.Name = "notEmptyResultSetCondition29";
            notEmptyResultSetCondition29.ResultSet = 1;
            // 
            // dev_patent_class_metricTest_TestAction
            // 
            dev_patent_class_metricTest_TestAction.Conditions.Add(notEmptyResultSetCondition30);
            resources.ApplyResources(dev_patent_class_metricTest_TestAction, "dev_patent_class_metricTest_TestAction");
            // 
            // notEmptyResultSetCondition30
            // 
            notEmptyResultSetCondition30.Enabled = true;
            notEmptyResultSetCondition30.Name = "notEmptyResultSetCondition30";
            notEmptyResultSetCondition30.ResultSet = 1;
            // 
            // dev_patent_family_classTest_TestAction
            // 
            dev_patent_family_classTest_TestAction.Conditions.Add(notEmptyResultSetCondition31);
            resources.ApplyResources(dev_patent_family_classTest_TestAction, "dev_patent_family_classTest_TestAction");
            // 
            // notEmptyResultSetCondition31
            // 
            notEmptyResultSetCondition31.Enabled = true;
            notEmptyResultSetCondition31.Name = "notEmptyResultSetCondition31";
            notEmptyResultSetCondition31.ResultSet = 1;
            // 
            // dev_company_retrieved_secTest_TestAction
            // 
            dev_company_retrieved_secTest_TestAction.Conditions.Add(notEmptyResultSetCondition6);
            resources.ApplyResources(dev_company_retrieved_secTest_TestAction, "dev_company_retrieved_secTest_TestAction");
            // 
            // notEmptyResultSetCondition6
            // 
            notEmptyResultSetCondition6.Enabled = true;
            notEmptyResultSetCondition6.Name = "notEmptyResultSetCondition6";
            notEmptyResultSetCondition6.ResultSet = 1;
            // 
            // dev_company_retrieved_orbisTest_TestAction
            // 
            dev_company_retrieved_orbisTest_TestAction.Conditions.Add(notEmptyResultSetCondition34);
            resources.ApplyResources(dev_company_retrieved_orbisTest_TestAction, "dev_company_retrieved_orbisTest_TestAction");
            // 
            // dev_company_retrieved_webTest_TestAction
            // 
            dev_company_retrieved_webTest_TestAction.Conditions.Add(notEmptyResultSetCondition36);
            resources.ApplyResources(dev_company_retrieved_webTest_TestAction, "dev_company_retrieved_webTest_TestAction");
            // 
            // dev_company_retrieved_patentTest_TestAction
            // 
            dev_company_retrieved_patentTest_TestAction.Conditions.Add(notEmptyResultSetCondition35);
            resources.ApplyResources(dev_company_retrieved_patentTest_TestAction, "dev_company_retrieved_patentTest_TestAction");
            // 
            // dev_company_tickerTest_TestAction
            // 
            dev_company_tickerTest_TestAction.Conditions.Add(notEmptyResultSetCondition32);
            resources.ApplyResources(dev_company_tickerTest_TestAction, "dev_company_tickerTest_TestAction");
            // 
            // notEmptyResultSetCondition32
            // 
            notEmptyResultSetCondition32.Enabled = true;
            notEmptyResultSetCondition32.Name = "notEmptyResultSetCondition32";
            notEmptyResultSetCondition32.ResultSet = 1;
            // 
            // dev_get_source_versionTest_TestAction
            // 
            dev_get_source_versionTest_TestAction.Conditions.Add(notEmptyResultSetCondition33);
            resources.ApplyResources(dev_get_source_versionTest_TestAction, "dev_get_source_versionTest_TestAction");
            // 
            // notEmptyResultSetCondition33
            // 
            notEmptyResultSetCondition33.Enabled = true;
            notEmptyResultSetCondition33.Name = "notEmptyResultSetCondition33";
            notEmptyResultSetCondition33.ResultSet = 1;
            // 
            // dev_ufn_company_textTestData
            // 
            this.dev_ufn_company_textTestData.PosttestAction = null;
            this.dev_ufn_company_textTestData.PretestAction = null;
            this.dev_ufn_company_textTestData.TestAction = dev_ufn_company_textTest_TestAction;
            // 
            // dev_ufn_company_text_topicTestData
            // 
            this.dev_ufn_company_text_topicTestData.PosttestAction = null;
            this.dev_ufn_company_text_topicTestData.PretestAction = null;
            this.dev_ufn_company_text_topicTestData.TestAction = dev_ufn_company_text_topicTest_TestAction;
            // 
            // dev_ufn_keyword_patent_class_profileTestData
            // 
            this.dev_ufn_keyword_patent_class_profileTestData.PosttestAction = null;
            this.dev_ufn_keyword_patent_class_profileTestData.PretestAction = null;
            this.dev_ufn_keyword_patent_class_profileTestData.TestAction = dev_ufn_keyword_patent_class_profileTest_TestAction;
            // 
            // dev_ufn_patent_text_topicTestData
            // 
            this.dev_ufn_patent_text_topicTestData.PosttestAction = null;
            this.dev_ufn_patent_text_topicTestData.PretestAction = null;
            this.dev_ufn_patent_text_topicTestData.TestAction = dev_ufn_patent_text_topicTest_TestAction;
            // 
            // dev_ufn_pubmed_text_topicTestData
            // 
            this.dev_ufn_pubmed_text_topicTestData.PosttestAction = null;
            this.dev_ufn_pubmed_text_topicTestData.PretestAction = null;
            this.dev_ufn_pubmed_text_topicTestData.TestAction = dev_ufn_pubmed_text_topicTest_TestAction;
            // 
            // dev_ufn_sec_text_topicTestData
            // 
            this.dev_ufn_sec_text_topicTestData.PosttestAction = null;
            this.dev_ufn_sec_text_topicTestData.PretestAction = null;
            this.dev_ufn_sec_text_topicTestData.TestAction = dev_ufn_sec_text_topicTest_TestAction;
            // 
            // dev_ufn_web_text_topicTestData
            // 
            this.dev_ufn_web_text_topicTestData.PosttestAction = null;
            this.dev_ufn_web_text_topicTestData.PretestAction = null;
            this.dev_ufn_web_text_topicTestData.TestAction = dev_ufn_web_text_topicTest_TestAction;
            // 
            // dev_company_basicTestData
            // 
            this.dev_company_basicTestData.PosttestAction = null;
            this.dev_company_basicTestData.PretestAction = null;
            this.dev_company_basicTestData.TestAction = dev_company_basicTest_TestAction;
            // 
            // dev_applicantTestData
            // 
            this.dev_applicantTestData.PosttestAction = null;
            this.dev_applicantTestData.PretestAction = null;
            this.dev_applicantTestData.TestAction = dev_applicantTest_TestAction;
            // 
            // dev_applicant_bvd_idTestData
            // 
            this.dev_applicant_bvd_idTestData.PosttestAction = null;
            this.dev_applicant_bvd_idTestData.PretestAction = null;
            this.dev_applicant_bvd_idTestData.TestAction = dev_applicant_bvd_idTest_TestAction;
            // 
            // dev_applicant_family_class_dateTestData
            // 
            this.dev_applicant_family_class_dateTestData.PosttestAction = null;
            this.dev_applicant_family_class_dateTestData.PretestAction = null;
            this.dev_applicant_family_class_dateTestData.TestAction = dev_applicant_family_class_dateTest_TestAction;
            // 
            // dev_calendarTestData
            // 
            this.dev_calendarTestData.PosttestAction = null;
            this.dev_calendarTestData.PretestAction = null;
            this.dev_calendarTestData.TestAction = dev_calendarTest_TestAction;
            // 
            // dev_calendar_attribute_numericTestData
            // 
            this.dev_calendar_attribute_numericTestData.PosttestAction = null;
            this.dev_calendar_attribute_numericTestData.PretestAction = null;
            this.dev_calendar_attribute_numericTestData.TestAction = dev_calendar_attribute_numericTest_TestAction;
            // 
            // dev_company_financialTestData
            // 
            this.dev_company_financialTestData.PosttestAction = null;
            this.dev_company_financialTestData.PretestAction = null;
            this.dev_company_financialTestData.TestAction = dev_company_financialTest_TestAction;
            // 
            // dev_company_financial_ratioTestData
            // 
            this.dev_company_financial_ratioTestData.PosttestAction = null;
            this.dev_company_financial_ratioTestData.PretestAction = null;
            this.dev_company_financial_ratioTestData.TestAction = dev_company_financial_ratioTest_TestAction;
            // 
            // dev_company_ip_timeTestData
            // 
            this.dev_company_ip_timeTestData.PosttestAction = null;
            this.dev_company_ip_timeTestData.PretestAction = null;
            this.dev_company_ip_timeTestData.TestAction = dev_company_ip_timeTest_TestAction;
            // 
            // dev_company_patent_familyTestData
            // 
            this.dev_company_patent_familyTestData.PosttestAction = null;
            this.dev_company_patent_familyTestData.PretestAction = null;
            this.dev_company_patent_familyTestData.TestAction = dev_company_patent_familyTest_TestAction;
            // 
            // dev_company_textTestData
            // 
            this.dev_company_textTestData.PosttestAction = null;
            this.dev_company_textTestData.PretestAction = null;
            this.dev_company_textTestData.TestAction = dev_company_textTest_TestAction;
            // 
            // dev_company_websiteTestData
            // 
            this.dev_company_websiteTestData.PosttestAction = null;
            this.dev_company_websiteTestData.PretestAction = null;
            this.dev_company_websiteTestData.TestAction = dev_company_websiteTest_TestAction;
            // 
            // dev_deal_acquirerTestData
            // 
            this.dev_deal_acquirerTestData.PosttestAction = null;
            this.dev_deal_acquirerTestData.PretestAction = null;
            this.dev_deal_acquirerTestData.TestAction = dev_deal_acquirerTest_TestAction;
            // 
            // dev_deal_overviewTestData
            // 
            this.dev_deal_overviewTestData.PosttestAction = null;
            this.dev_deal_overviewTestData.PretestAction = null;
            this.dev_deal_overviewTestData.TestAction = dev_deal_overviewTest_TestAction;
            // 
            // dev_deal_structureTestData
            // 
            this.dev_deal_structureTestData.PosttestAction = null;
            this.dev_deal_structureTestData.PretestAction = null;
            this.dev_deal_structureTestData.TestAction = dev_deal_structureTest_TestAction;
            // 
            // dev_deal_targetTestData
            // 
            this.dev_deal_targetTestData.PosttestAction = null;
            this.dev_deal_targetTestData.PretestAction = null;
            this.dev_deal_targetTestData.TestAction = dev_deal_targetTest_TestAction;
            // 
            // dev_deal_textTestData
            // 
            this.dev_deal_textTestData.PosttestAction = null;
            this.dev_deal_textTestData.PretestAction = null;
            this.dev_deal_textTestData.TestAction = dev_deal_textTest_TestAction;
            // 
            // dev_family_appln_date_classTestData
            // 
            this.dev_family_appln_date_classTestData.PosttestAction = null;
            this.dev_family_appln_date_classTestData.PretestAction = null;
            this.dev_family_appln_date_classTestData.TestAction = dev_family_appln_date_classTest_TestAction;
            // 
            // dev_industry_codeTestData
            // 
            this.dev_industry_codeTestData.PosttestAction = null;
            this.dev_industry_codeTestData.PretestAction = null;
            this.dev_industry_codeTestData.TestAction = dev_industry_codeTest_TestAction;
            // 
            // dev_patent_classTestData
            // 
            this.dev_patent_classTestData.PosttestAction = null;
            this.dev_patent_classTestData.PretestAction = null;
            this.dev_patent_classTestData.TestAction = dev_patent_classTest_TestAction;
            // 
            // dev_patent_class_lineageTestData
            // 
            this.dev_patent_class_lineageTestData.PosttestAction = null;
            this.dev_patent_class_lineageTestData.PretestAction = null;
            this.dev_patent_class_lineageTestData.TestAction = dev_patent_class_lineageTest_TestAction;
            // 
            // dev_patent_class_metricTestData
            // 
            this.dev_patent_class_metricTestData.PosttestAction = null;
            this.dev_patent_class_metricTestData.PretestAction = null;
            this.dev_patent_class_metricTestData.TestAction = dev_patent_class_metricTest_TestAction;
            // 
            // dev_patent_family_classTestData
            // 
            this.dev_patent_family_classTestData.PosttestAction = null;
            this.dev_patent_family_classTestData.PretestAction = null;
            this.dev_patent_family_classTestData.TestAction = dev_patent_family_classTest_TestAction;
            // 
            // dev_company_retrieved_secTestData
            // 
            this.dev_company_retrieved_secTestData.PosttestAction = null;
            this.dev_company_retrieved_secTestData.PretestAction = null;
            this.dev_company_retrieved_secTestData.TestAction = dev_company_retrieved_secTest_TestAction;
            // 
            // dev_company_retrieved_orbisTestData
            // 
            this.dev_company_retrieved_orbisTestData.PosttestAction = null;
            this.dev_company_retrieved_orbisTestData.PretestAction = null;
            this.dev_company_retrieved_orbisTestData.TestAction = dev_company_retrieved_orbisTest_TestAction;
            // 
            // dev_company_retrieved_webTestData
            // 
            this.dev_company_retrieved_webTestData.PosttestAction = null;
            this.dev_company_retrieved_webTestData.PretestAction = null;
            this.dev_company_retrieved_webTestData.TestAction = dev_company_retrieved_webTest_TestAction;
            // 
            // dev_company_retrieved_patentTestData
            // 
            this.dev_company_retrieved_patentTestData.PosttestAction = null;
            this.dev_company_retrieved_patentTestData.PretestAction = null;
            this.dev_company_retrieved_patentTestData.TestAction = dev_company_retrieved_patentTest_TestAction;
            // 
            // dev_company_tickerTestData
            // 
            this.dev_company_tickerTestData.PosttestAction = null;
            this.dev_company_tickerTestData.PretestAction = null;
            this.dev_company_tickerTestData.TestAction = dev_company_tickerTest_TestAction;
            // 
            // dev_get_source_versionTestData
            // 
            this.dev_get_source_versionTestData.PosttestAction = null;
            this.dev_get_source_versionTestData.PretestAction = null;
            this.dev_get_source_versionTestData.TestAction = dev_get_source_versionTest_TestAction;
            // 
            // notEmptyResultSetCondition34
            // 
            notEmptyResultSetCondition34.Enabled = true;
            notEmptyResultSetCondition34.Name = "notEmptyResultSetCondition34";
            notEmptyResultSetCondition34.ResultSet = 1;
            // 
            // notEmptyResultSetCondition35
            // 
            notEmptyResultSetCondition35.Enabled = true;
            notEmptyResultSetCondition35.Name = "notEmptyResultSetCondition35";
            notEmptyResultSetCondition35.ResultSet = 1;
            // 
            // notEmptyResultSetCondition36
            // 
            notEmptyResultSetCondition36.Enabled = true;
            notEmptyResultSetCondition36.Name = "notEmptyResultSetCondition36";
            notEmptyResultSetCondition36.ResultSet = 1;
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
        public void dev_ufn_company_textTest()
        {
            SqlDatabaseTestActions testActions = this.dev_ufn_company_textTestData;
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
        public void dev_ufn_company_text_topicTest()
        {
            SqlDatabaseTestActions testActions = this.dev_ufn_company_text_topicTestData;
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
        public void dev_ufn_keyword_patent_class_profileTest()
        {
            SqlDatabaseTestActions testActions = this.dev_ufn_keyword_patent_class_profileTestData;
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
        public void dev_ufn_patent_text_topicTest()
        {
            SqlDatabaseTestActions testActions = this.dev_ufn_patent_text_topicTestData;
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
        public void dev_ufn_pubmed_text_topicTest()
        {
            SqlDatabaseTestActions testActions = this.dev_ufn_pubmed_text_topicTestData;
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
        public void dev_ufn_sec_text_topicTest()
        {
            SqlDatabaseTestActions testActions = this.dev_ufn_sec_text_topicTestData;
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
        public void dev_ufn_web_text_topicTest()
        {
            SqlDatabaseTestActions testActions = this.dev_ufn_web_text_topicTestData;
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
        public void dev_company_basicTest()
        {
            SqlDatabaseTestActions testActions = this.dev_company_basicTestData;
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
        public void dev_applicantTest()
        {
            SqlDatabaseTestActions testActions = this.dev_applicantTestData;
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
        public void dev_applicant_bvd_idTest()
        {
            SqlDatabaseTestActions testActions = this.dev_applicant_bvd_idTestData;
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
        public void dev_applicant_family_class_dateTest()
        {
            SqlDatabaseTestActions testActions = this.dev_applicant_family_class_dateTestData;
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
        public void dev_calendarTest()
        {
            SqlDatabaseTestActions testActions = this.dev_calendarTestData;
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
        public void dev_calendar_attribute_numericTest()
        {
            SqlDatabaseTestActions testActions = this.dev_calendar_attribute_numericTestData;
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
        public void dev_company_financialTest()
        {
            SqlDatabaseTestActions testActions = this.dev_company_financialTestData;
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
        public void dev_company_financial_ratioTest()
        {
            SqlDatabaseTestActions testActions = this.dev_company_financial_ratioTestData;
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
        public void dev_company_ip_timeTest()
        {
            SqlDatabaseTestActions testActions = this.dev_company_ip_timeTestData;
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
        public void dev_company_patent_familyTest()
        {
            SqlDatabaseTestActions testActions = this.dev_company_patent_familyTestData;
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
        public void dev_company_textTest()
        {
            SqlDatabaseTestActions testActions = this.dev_company_textTestData;
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
        public void dev_company_websiteTest()
        {
            SqlDatabaseTestActions testActions = this.dev_company_websiteTestData;
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
        public void dev_deal_acquirerTest()
        {
            SqlDatabaseTestActions testActions = this.dev_deal_acquirerTestData;
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
        public void dev_deal_overviewTest()
        {
            SqlDatabaseTestActions testActions = this.dev_deal_overviewTestData;
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
        public void dev_deal_structureTest()
        {
            SqlDatabaseTestActions testActions = this.dev_deal_structureTestData;
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
        public void dev_deal_targetTest()
        {
            SqlDatabaseTestActions testActions = this.dev_deal_targetTestData;
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
        public void dev_deal_textTest()
        {
            SqlDatabaseTestActions testActions = this.dev_deal_textTestData;
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
        public void dev_family_appln_date_classTest()
        {
            SqlDatabaseTestActions testActions = this.dev_family_appln_date_classTestData;
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
        public void dev_industry_codeTest()
        {
            SqlDatabaseTestActions testActions = this.dev_industry_codeTestData;
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
        public void dev_patent_classTest()
        {
            SqlDatabaseTestActions testActions = this.dev_patent_classTestData;
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
        public void dev_patent_class_lineageTest()
        {
            SqlDatabaseTestActions testActions = this.dev_patent_class_lineageTestData;
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
        public void dev_patent_class_metricTest()
        {
            SqlDatabaseTestActions testActions = this.dev_patent_class_metricTestData;
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
        public void dev_patent_family_classTest()
        {
            SqlDatabaseTestActions testActions = this.dev_patent_family_classTestData;
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
        public void dev_company_retrieved_secTest()
        {
            SqlDatabaseTestActions testActions = this.dev_company_retrieved_secTestData;
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
        public void dev_company_retrieved_orbisTest()
        {
            SqlDatabaseTestActions testActions = this.dev_company_retrieved_orbisTestData;
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
        public void dev_company_retrieved_webTest()
        {
            SqlDatabaseTestActions testActions = this.dev_company_retrieved_webTestData;
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
        public void dev_company_retrieved_patentTest()
        {
            SqlDatabaseTestActions testActions = this.dev_company_retrieved_patentTestData;
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
        public void dev_company_tickerTest()
        {
            SqlDatabaseTestActions testActions = this.dev_company_tickerTestData;
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
        public void dev_get_source_versionTest()
        {
            SqlDatabaseTestActions testActions = this.dev_get_source_versionTestData;
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





























        private SqlDatabaseTestActions dev_ufn_company_textTestData;
        private SqlDatabaseTestActions dev_ufn_company_text_topicTestData;
        private SqlDatabaseTestActions dev_ufn_keyword_patent_class_profileTestData;
        private SqlDatabaseTestActions dev_ufn_patent_text_topicTestData;
        private SqlDatabaseTestActions dev_ufn_pubmed_text_topicTestData;
        private SqlDatabaseTestActions dev_ufn_sec_text_topicTestData;
        private SqlDatabaseTestActions dev_ufn_web_text_topicTestData;
        private SqlDatabaseTestActions dev_company_basicTestData;
        private SqlDatabaseTestActions dev_applicantTestData;
        private SqlDatabaseTestActions dev_applicant_bvd_idTestData;
        private SqlDatabaseTestActions dev_applicant_family_class_dateTestData;
        private SqlDatabaseTestActions dev_calendarTestData;
        private SqlDatabaseTestActions dev_calendar_attribute_numericTestData;
        private SqlDatabaseTestActions dev_company_financialTestData;
        private SqlDatabaseTestActions dev_company_financial_ratioTestData;
        private SqlDatabaseTestActions dev_company_ip_timeTestData;
        private SqlDatabaseTestActions dev_company_patent_familyTestData;
        private SqlDatabaseTestActions dev_company_textTestData;
        private SqlDatabaseTestActions dev_company_websiteTestData;
        private SqlDatabaseTestActions dev_deal_acquirerTestData;
        private SqlDatabaseTestActions dev_deal_overviewTestData;
        private SqlDatabaseTestActions dev_deal_structureTestData;
        private SqlDatabaseTestActions dev_deal_targetTestData;
        private SqlDatabaseTestActions dev_deal_textTestData;
        private SqlDatabaseTestActions dev_family_appln_date_classTestData;
        private SqlDatabaseTestActions dev_industry_codeTestData;
        private SqlDatabaseTestActions dev_patent_classTestData;
        private SqlDatabaseTestActions dev_patent_class_lineageTestData;
        private SqlDatabaseTestActions dev_patent_class_metricTestData;
        private SqlDatabaseTestActions dev_patent_family_classTestData;
        private SqlDatabaseTestActions dev_company_retrieved_secTestData;
        private SqlDatabaseTestActions dev_company_retrieved_orbisTestData;
        private SqlDatabaseTestActions dev_company_retrieved_webTestData;
        private SqlDatabaseTestActions dev_company_retrieved_patentTestData;
        private SqlDatabaseTestActions dev_company_tickerTestData;
        private SqlDatabaseTestActions dev_get_source_versionTestData;
    }
}

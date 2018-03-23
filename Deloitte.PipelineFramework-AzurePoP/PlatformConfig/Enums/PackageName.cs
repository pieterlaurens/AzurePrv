using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Deloitte.PipelineFramework.PlatformConfig.Enums
{
    /// <summary>
    /// Contains all available package names.
    /// <para>Theses names correspond with the available components.</para>
    /// </summary>
    public enum PackageName
    {
        #region techanalytics
        #region general
        /// <summary>
        /// The component that creates the project database and with it the standard tables that are used in the various sub components. It only creates objects when they do not already exist.
        /// </summary>
        CreatePrepareEnvironment,
        /// <summary>
        /// The component that (re-)creates the views that are accessed by the front-end
        /// </summary>
        PrepareForVisualization,
        /// <summary>
        /// The component that loads the SDI product category and scores.
        /// </summary>
        ImportProjectScoreTable,
        #endregion

        #region landscape
        SelectLandscapeNodes,
        ScoreLandscapeNodes,
        GetNodeProperties,
        CalculateLandscapeDistances,
        ApproximateDistanceIn2D,
        #endregion

        #region longlist
        /// <summary>
        /// Component responsible for retrieving companies that will appear on the long list. Takes a list-parameter where each element reflects a method to search for companies.
        /// </summary>
        CompanyRetrieval,
        /// <summary>
        /// Component responsible for scoring the companies in the longlist. The input list parameter will be reflected in the columns of the longlist table.
        /// </summary>
        CompanyScoring,
        /// <summary>
        /// Same component as above, with a subset of functionality. However, it does not require the reset of the visualization and is therefore more suitable for execution in interactie settings.
        /// </summary>
        CompanyScoringSynchronous,
        /// <summary>
        /// Component responsible for 'post processing' of scores; or scoring of scores. Most notably, transforming a continuous score into baskets e.g. for use in filters High, Medium, Low.
        /// </summary>
        GroupScoresInBaskets,
        /// <summary>
        /// Component responsible for transforming the data currently in the project into a form that is useful for Matlab analysis. In addition, financial attributes ove rtime can be added in a pivoted form (one column per attribute per year).
        /// </summary>
        GenerateMatlabTable,
        /// <summary>
        /// Component adds a new focuslist with companies similar to the set of positive instances supplied in its configuration
        /// </summary>
        MakeCompanySuggestion,
        /// <summary>
        /// Package that takes a list of company-question-answer triplets, and writes them to the appropriate tables in the project database (i.e. longlist, tiles and questionnaire tables).
        /// </summary>
        StoreAnswer,
        #endregion
        #endregion

        #region wsfocusreports
        #region loaddatamart
        #region dimensions
        /// <summary>
        /// Webshop / FocusReports: Generates calendar data from year to year
        /// </summary>
        LoadCalendar,
        /// <summary>
        /// Webshop / FocusReports: Loads company data from strategic datamart scd.
        /// The companies loaded are limited to the set of companies that appear in a certain score set
        /// </summary>
        LoadCompanies,
        /// <summary>
        /// Webshop / FocusReports: Loads industry data from strategic datamart nace_code.
        /// </summary>
        LoadIndustries,
        /// <summary>
        /// Webshop / FocusReports: Loads tree (metatopic / topic) data from a certain topic database.
        /// </summary>
        LoadSubjects,
        /// <summary>
        /// Webshop / FocusReports: Loads sources (connection strings) where scores are loaded from.
        /// Necessary to enable incremental / partial refresh of scores.
        /// </summary>
        LoadSubjectScoreSources,
        /// <summary>
        /// Webshop / FocusReports: Loads paragraph data (currently obsolete)
        /// </summary>
        LoadParagraphs,
        /// <summary>
        /// Webshop / FocusReports: Loads document data (currently only filing_year)
        /// </summary>
        LoadDocuments,
        /// <summary>
        /// Webshop / FocusReports: Loads country data from strategic datamart country_code.
        /// </summary>
        LoadCountries,
        /// <summary>
        /// Webshop / FocusReports: Loads deal data from strategic datamart sdd.
        /// </summary>
        LoadDeals,
        #endregion

        #region facts
        /// <summary>
        /// Webshop / FocusReports: Loads scores from topic database
        /// </summary>
        LoadSubjectScores,
        /// <summary>
        /// Webshop / FocusReports: Loads scores from strategic datamart sdd (Zephyr)
        /// </summary>
        LoadDealScores,
        /// <summary>
        /// Webshop / FocusReports: Loads scores from patent (works) database
        /// </summary>
        LoadTechnologyScores,
        #endregion
        #endregion

        #region publishdatamart
        /// <summary>
        /// Webshop / FocusReports: Publishes a previously generated scores datamart to the Web-db
        /// </summary>
        RefreshWebData,
        #endregion

        #region peergroups
        /// <summary>
        /// Component to calculate user-defined peer group statistics, version 0
        /// </summary>
        AddScoresForRiskText,
        /// <summary>
        /// Component to calculate user-defined peer group statistics, version 1
        /// </summary>
        CreateStatsOverTopicsForCompanies,
        /// <summary>
        /// Component to calculate user-defined peer group statistics, version 2
        /// </summary>
        AddGroupStatistics,
        #endregion
        #endregion

        #region idresolving
        #region processinput
        /// <summary>
        /// The component that (re-)creates the views that are accessed by the front-end
        /// </summary>
        importMatchingSoftwareFile,
        #endregion
        #endregion

        /// <summary>
        /// Component to compute a suggested operationalization of a (bag of) keywords in a classification system, e.g. CPC.
        /// </summary>
        GetKeywordProfile,
        /// <summary>
        /// Component with various functionalities to test the end-to-end working of the data, pipeline, framework and website.
        /// </summary>
        End2EndIntegrationTest,
    }
}

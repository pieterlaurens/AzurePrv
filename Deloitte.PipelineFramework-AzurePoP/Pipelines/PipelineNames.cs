using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Deloitte.PipelineFramework.Pipelines
{
    /// <summary>
    /// Container to hold the names of all the available pipelines.
    /// </summary>
    public enum PipelineNames
    {
        /// <summary>
        /// API used for technology analytics - longlist / landscape
        /// </summary>
        GetKeywordProfile,
        /// <summary>
        /// Creates a longlist, based on parameters for the rows (how to retrieve companies) and columns (how to score them).
        /// </summary>
        CreateLonglist,
        /// <summary>
        /// Creates a landscape based on a selection of ndoes (CPC classes), and parameters that determine which overlays and bubble sizes to show.
        /// </summary>
        CreateLandscape,
        /// <summary>
        /// Adding one or more columns to an existing longlist.
        /// </summary>
        AddScoreToLonglist,
        /// <summary>
        /// Translates an existing longlist as used in the web to a Matlab-suitable data structure for further analysis.
        /// </summary>
        PublishMatlabResources,
        /// <summary>
        /// For an existing Landscape, leaving the topology intact, but replacing the bubble sizes and overlays.
        /// </summary>
        RescoreLandscape,
        MatlabDataGenerator,
        /// <summary>
        /// Pipeline that is used to answer a set of questions for companies; called primarily from the Questionnaire app.
        /// </summary>
        AnswerQuestion,
        SetManualScore,
        TestEndToEnd,
        /// <summary>
        /// API to update the scores and product categories in a project datamart from a source Excel.
        /// </summary>
        UpdateScoreTable,
        ExpandCompanyList, // <- Deze ;)
        /// <summary>
        /// Webshop / FocusReports: Load topic scores and dimensions from source
        /// </summary>
        LoadTopicScoresDatamart,
        /// <summary>
        /// Webshop / FocusReports: Load deal scores and dimensions from source
        /// </summary>
        LoadDealScoresDatamart,
        /// <summary>
        /// Webshop / FocusReports: Load patent scores and dimensions from source
        /// </summary>
        LoadTechnologyScoresDatamart,
        /// <summary>
        /// Webshop / FocusReports: Publish categories and metrics
        /// </summary>
        PublishTopicScoresDatamart,
        /// <summary>
        /// Webshop / FocusReports: Reload topic scores only and then publish to web
        /// </summary>
        RefreshTopicScores,
        /// <summary>
        /// Webshop / FocusReports: Incrementally load first new topic scores and then publish them to web
        /// </summary>
        RefreshDealScores,
        /// <summary>
        /// Webshop / FocusReports: Incrementally load first new patent scores and then publish them to web
        /// </summary>
        RefreshTechnologyScores,
        /// <summary>
        /// Webshop / FocusReports: Incrementally load first deal scores and then publish them to web
        /// </summary>
        PublishAdditionalDocuments,
        /// <summary>
        /// Webshop / FocusReports: Generate peer group data version 1
        /// Previously know as GetStatsForScores.
        /// </summary>
        CreateUserStats,
        /// <summary>
        /// Webshop / FocusReports: Generate peer group data version 2
        /// </summary>
        GeneratePeerGroupData,

        /// <summary>
        /// ID Resolving
        /// </summary>
        ImportMatchingSoftwareFiles,


        /// <summary>
        /// Legacy: do not use, only available for backward compatibility. 
        /// </summary>
        End2EndIntegrationTest,
        Landscape,
        ScoreRiskText,
    }
}

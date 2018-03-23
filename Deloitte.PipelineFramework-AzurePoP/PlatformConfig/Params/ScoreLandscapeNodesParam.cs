using Deloitte.PipelineFramework.PlatformConfig.Enums;
using Newtonsoft.Json;
using Newtonsoft.Json.Converters;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Deloitte.PipelineFramework.PlatformConfig.Params
{
    /// <summary>
    /// Configuration object for the component that scores nodes in a landscape. Typically part of a list that represents the various scoring methods that make up a set of overlays in a landscape.
    /// </summary>
    public class ScoreLandscapeNodesParam : DeloitteObject
    {

        /// <summary>
        /// The algorithm used to score the nodes in a landscape, typically feeding the bubble size.
        /// </summary>
        [JsonConverter(typeof(StringEnumConverter))]
        [Required]
        public NodeScoringType ScoringType { get; set; }

        /// <summary>
        /// The label for the score. The label is used in solution configurations to assign it to a column in the standard landscape tables.
        /// </summary>
        public string ScoringLabel { get; set; }

        /// <summary>
        /// The type of score the values belong to. All scored within a score group should be meaningfully comparable. Current examples are Weight and Relevance.
        /// </summary>
        public string ScoreGroup { get; set; }
        
        /// <summary>
        /// The group of series this score belongs to. It ends up as a group of filters in the front end.
        /// </summary>
        public string SeriesGroup { get; set; }

        /// <summary>
        /// How to normalize the scores of the nodes.
        ///    - 'None': Raw counts
        ///    - 'Class': Relative to the class size
        ///    - 'Series': Relative to the word or company portfolio as a whole (summing to one)
        ///    - 'ClassSeries': Relative to the class size, and summing to one
        /// </summary>
        public string Normalize { get; set; }

        /// <summary>
        /// The list of companies to score on the nodes. As in, for which companies to evaluate their portfolio in the nodes of the landscape.
        /// </summary>
        public string CompanyId { get; set; }

        /// <summary>
        /// The bag of words to score on the nodes. For each node, the score reflects the number of times one of the words in the bag is mentioned.
        /// </summary>
        public string BagOfWords { get; set; }

        /// <summary>
        /// The name of the topic to score the classes on.
        /// </summary>
        public string TopicName { get; set; }

        /// <summary>
        /// The bag of classes to score on the nodes as co-filing. For each node, the score reflects the number of times a patent in that node ALSO has a class from this bag.
        /// </summary>
        public string BagOfClasses { get; set; }
        
        /// <summary>
        /// This parameter indicates whether for the scoring to incorporate the underlying classes (=True) or only the class itself (=False, default!)
        /// </summary>
        public bool Aggregate { get; set; }

    }
}

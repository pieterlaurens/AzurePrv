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
    /// Configuration object for the component that scores companies in a longlist. Typically part of a list that represents 
    /// the various scoring methods that make up a set of columns in a longlist.
    /// </summary>
    public class ScoringParam : DeloitteObject
    {

        /// <summary>
        /// Sets whether all existing values for a score are truncated (Append=false) before calculation, or whether existing
        /// values are left intact. The latter is only desirable behavior when additional companies are being scored; as of
        /// this writing (2017) that is an uncommon use-case.
        /// </summary>
        public bool? Append { get; set; } = false;

        /// <summary>
        /// The algorithm used for this type of scoring.
        /// </summary>
        [JsonConverter(typeof(StringEnumConverter))]
        [Required]
        public CompanyScoringType ScoringType { get; set; }

        /// <summary>
        /// For Manual scoring (where the user is allowed to enter score values that are passed to the back end) the data type
        /// must be provided at project initialization. Can be the usual SQL types int, real and nvarchar.
        /// </summary>
        public string ScoreDataType { get; set; }
        
        /// <summary>
        /// The manual scoring in format NL1234:Cool|NL54334:Awesome|NL54533:Shitty|NL442323:Shitty etc.
        /// <remarks>Should be implemented similar to <see cref="BagOfWords"/>.</remarks>
        /// </summary>
        public string CompanyScore { get; set; }

        /// <summary>
        /// This is the label of the score. This has to be unique between scores. It is used to identify scores internally. 
        /// It is also the name reported as the column header in the longlist.
        /// </summary>
        [Required]
        public string ScoringLabel { get; set; }

        /// <summary>
        /// The name of the topic as used in ES
        /// </summary>
        public string TopicName { get; set; }

        /// <summary>
        /// The name of the corpus as used in the data handler; this abstracts away from the index names in ES
        /// </summary>
        public string TopicCorpus { get; set; }

        /// <summary>
        /// Most scoring algorithms have an option for normalizing the score. Depending on the algorithm different values are permitted.
        /// PatentClassProfile:
        ///    - 'None': Raw counts
        ///    - 'Class': Relative to the class size
        /// BagOfWords
        ///    - 'None': Raw counts
        /// </summary>
        public string Normalize { get; set; }
        /// <summary>
        /// For Bag-of-word based scores. A set of pipe-separated contains() clauses. AND can be implemented within the clause
        /// as a NEAR statement (3d~printing), and the OR with separate statements (3d~printing|additive~manufacturing). 
        /// Currently its not possible to use double quotes in the contains clauses.
        /// 
        /// <remark>Work is being done on a word parser that generates more elaborate Contains statements (Sanne)</remark>
        /// </summary>
        public string BagOfWords
        {
            get
            {
                return _BagOfWords == null ? null : _BagOfWords.Aggregate((a, b) => a + "|" + b);
            }
            set
            {
                _BagOfWords = value == null ? null : value.Split('|');
            }
        }
        
        /// <summary>
        /// For patent or other classification-based scores. The parameter contains a bag of weighted 
        /// CPC codes. Each code is accompanied by a weight, A21B 02/03:.04, where A21B 02/03 is a valid 
        /// CPC code, and .04 is its weight. A bag of codes is constructed by combining these pairs, separated by pipes.
        /// </summary>
        public string ClassProfile
        {
            get {
                return _ClassProfiles == null ? null : _ClassProfiles
                        .Select(p => p.Identifier + ":" + p.Weight.ToString())
                        .Aggregate((a, b) => a + "|" + b);
            }
            set {
                _ClassProfiles = value == null ? null : value.Split('|')
                    .Select(v => {
                        var s = v.Split(':');
                        return s.Length == 2 ?
                            new ClassProfileParam { Identifier = s[0], Weight = Convert.ToDouble(s[1]) } :
                            (s.Length == 1 ?
                                new ClassProfileParam { Identifier = s[0], Weight = 0 } :
                                new ClassProfileParam()
                            );
                    }).ToList();
            }
        }

        /// <summary>
        /// For orbis or other precalculated attributes. The name of the attribute in the Data Handler.
        /// </summary>
        public string AttributeName { get; set; }
        
        /// <summary>
        /// For time attributes, the range over which the attribute is reported. The value of the 
        /// parameter should be start-end; e.g. 2005-2010 for financials from 2005 through 2010 (i.e. 6 years in total).
        /// </summary>
        public string TimeRange { get; set; }

        /// <summary>
        /// Can be set to Yes (default is No). In that case for each time point in the results, the preceding time point is used.
        /// </summary>
        public string IsPredictor { get; set; } = "No";

        /// <summary>
        /// For time attributes: Attribute in the data handler that contains the time dimension. 
        /// For the financials and ratios, this is typically y (for year).
        /// </summary>
        public string TimeAttribute { get; set; }

        /// <summary>
        /// For time attributes: Type of the time attribute. Currently the type is always int, but in 
        /// future this could easily be string (Q1, Q2,...), date or datetime.
        /// </summary>
        public string TimeAttributeType { get; set; }

        #region GroupScoringParams
        /// <summary>
        /// The source score that this grouping is based on.
        /// </summary>
        public string SourceScoringLabel { get; set; }

        /// <summary>
        /// The number of baskets that should be created for percentile grouping.
        /// </summary>
        public int? NumberOfBaskets { get; set; }

        /// <summary>
        /// The bounds of the baskets for CustomBasketBounds. There are k+1 baskets for any number of bounds given. Bounds a to b are interpreted larger than or equal to a, and smaller than b.
        /// </summary>
        public string BasketBounds { get; set; }

        /// <summary>
        /// The values that belong to each basket for CustomBasketValues.
        /// </summary>
        public string BasketValues { get; set; }

        /// <summary>
        /// The method used for grouping of scores.
        /// </summary>
        public CompanyScoreGroupingType GroupingType { get; set; }
        #endregion
        #region private:not serialized
        private IEnumerable<ClassProfileParam> _ClassProfiles = null;
        private IEnumerable<string> _BagOfWords = null;
        /// <summary>
        /// Method to parse a text form of the bag of words into the internal list structure. 
        /// String should be pipe-separated bag of words. e.g. "word|first phrase|second phrase|near~statement"
        /// </summary>
        /// <param name="words">List of words</param>
        /// <returns>The updated Configuration object.</returns>
        public ScoringParam SetBagOfWords(IEnumerable<string> words)
        {
            _BagOfWords = words;
            return this;
        }

        /// <summary>
        /// Method to parse a text for of a class profile. e.g. "A21B 02/01:.03|A53C 01/2345:.7"
        /// </summary>
        /// <param name="profiles">The text format of the class profile</param>
        /// <returns>The updated Configuration object.</returns>
        public ScoringParam SetClassProfile(IEnumerable<ClassProfileParam> profiles)
        {
            _ClassProfiles = profiles;
            return this;
        }
        #endregion
    }
}

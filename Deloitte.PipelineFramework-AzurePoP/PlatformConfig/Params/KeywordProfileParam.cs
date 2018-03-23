using Deloitte.PipelineFramework.PlatformConfig.Enums;
using Newtonsoft.Json;
using Newtonsoft.Json.Converters;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Deloitte.PipelineFramework.PlatformConfig.Params
{
    /// <summary>
    /// The parameters used by the GetKeywordProfile pipelines.
    /// </summary>
    public class KeywordProfileParam
    {
        /// <summary>
        /// The set of words (in SQL FT syntax) for calculating bag of word profiles in a classification scheme, notably CPC.
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
        /// The maximum number of classes returned in the profile
        /// </summary>
        public int? NumberOfClasses { get; set; }

        /// <summary>
        /// When true, will limit the results to the nodes in the project landscape.
        /// </summary>
        public bool? ScopeToProject { get; set; }

        /// <summary>
        /// The parameters used by the GetKeywordProfile pipelines.
        /// </summary>
        public KeywordProfileParam GetKeywordProfileParams { get; set; }

        /// <summary>
        /// The minimal number of documents in a class to be considered for the profile.
        /// </summary>
        public int MinimalClassSize { get; set; }

        /// <summary>
        /// Whether to consider documents assigned to subclasses, also members of the super class.
        /// </summary>
        public string Aggregate { get; set; }

        /// <summary>
        /// Whether to score the keyword profile results in the project database. Either for user-tracking
        /// purposes, or for (integration) testing purposes.
        /// </summary>
        public bool? StoreInProject { get; set; }

        /// <summary>
        /// The type profile that is to be made, from what. A profile represents an operationalization from one domain into another; for instance, a set of keywords operationalized in CPC clases.
        /// </summary>
        [JsonConverter(typeof(StringEnumConverter))]
        public ProfileType ProfileType { get; set; }

        /// <summary>
        /// Which metric to use for weighing and sorting the classes in the profile: Count, Representativeness.
        /// </summary>
        public string ProfileCriterion { get; set; }

        private IEnumerable<string> _BagOfWords = null;

        /// <summary>
        /// For Bag-of-word based retrieval, currently only on company text. A set of pipe-separated contains() clauses. AND can be implemented within the clause as a NEAR statement (3d~printing), and the OR with separate statements (3d~printing|additive~manufacturing).
        /// <para>Currently its not possible to use double quotes in the contains clauses.</para>
        /// <para>Work is being done on a word parser that generates more elaborate Contains statements (Sanne)</para>
        /// <seealso cref="BagOfWords"/>
        /// </summary>
        public IEnumerable<string> GetBagOfWords()
        {
            return _BagOfWords;
        }
        /// <summary>
        /// For Bag-of-word based retrieval, currently only on company text. A set of pipe-separated contains() clauses. AND can be implemented within the clause as a NEAR statement (3d~printing), and the OR with separate statements (3d~printing|additive~manufacturing).
        /// <para>Currently its not possible to use double quotes in the contains clauses.</para>
        /// <para>Work is being done on a word parser that generates more elaborate Contains statements (Sanne)</para>
        /// <seealso cref="BagOfWords"/>
        /// </summary>
        public KeywordProfileParam SetBagOfWords(IEnumerable<string> words)
        {
            _BagOfWords = words;
            return this;
        }
    }
}

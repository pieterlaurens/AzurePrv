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
    /// Configuration object for the component that retrieves companies for a longlist. Typically part of a list that represents the various retrieval methods that make up a set of groups of rows in a longlist.
    /// </summary>
    public class RetrievalParam : DeloitteObject
    {
        
        /// <summary>
        /// The algorithm used for retrieving companies.
        /// </summary>
        [JsonConverter(typeof(StringEnumConverter))]
        [Required]
        public CompanyRetrievalType RetrievalType { get; set; }

        /// <summary>
        /// This is the label of the retrieval operation. It is used to identify how a company was retrieved.
        /// </summary>
        [Required]
        public string RetrievalLabel { get; set; }

        /// <summary>
        /// The maximum number of companies to be retrieved in this way. Companies are scored descending on the score.
        /// </summary>
        public int? NumberOfCompanies { get; set; }

        /// <summary>
        /// When a maximum number of companies is entered, companies are sorted on a score. The score can be normalized:
        ///    - 'None': Raw counts
        ///    - 'Class': Relative to the class size
        /// </summary>
        public string Normalize { get; set; }

        /// <summary>
        /// The name of the topic as used in ES
        /// </summary>
        public string TopicName { get; set; }

        /// <summary>
        /// The name of the corpus as used in the data handler; this abstracts away from the index names in ES
        /// </summary>
        public string TopicCorpus { get; set; }
        /// <summary>
        /// For Bag-of-word based retrieval, currently only on company text. A set of pipe-separated contains() clauses. AND can be implemented within the clause as a NEAR statement (3d~printing), and the OR with separate statements (3d~printing|additive~manufacturing).
        /// <para>Currently its not possible to use double quotes in the contains clauses.</para>
        /// <para>Work is being done on a word parser that generates more elaborate Contains statements (Sanne)</para>
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
        /// A set of additional constraints. Each constraint is separated by a pipe. Each constraint is constructed as constraining_attribute:values.
        /// for example, retrieving only medium sized companies from some EU countries would require company_category:Medium sized company|country:NL,BE,DE,FR,GB,ES,IT
        /// </summary>
        public string Constraints { get; set; }

        /// <summary>
        /// A profile of Classes, most notably Patent Classes (CPC).
        /// <para>It is a set of identifier/weight pairs. It is common practice to make profiles where Weights add up to one.</para>
        /// <para>
        /// The profile is often used to calculate an inner product with other profiles, for instance company profiles 
        /// or subject profiles, that are expressed in the same form, and where absent Identifiers are taken as Weight=0.0
        /// </para>
        /// <para>
        /// For patent or other classification-based retrieval. The parameter contains a bag of weighted CPC codes. 
        /// Each code is accompanied by a weight, A21B 02/03:.04, where A21B 02/03 is a valid CPC code, and .04 is its weight. 
        /// A bag of codes is constructed by combining these pairs, separated by pipes.
        /// </para>
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
                        return new ClassProfileParam { Identifier = s[0], Weight = Convert.ToDouble(s[1]) };
                    }).ToList();
            }
        }

        /// <summary>
        /// A set of company IDs that are forced to be on the long list, regardless of their scores. IDs separated by pipes.
        /// </summary>
        public string CompanyId {
            get {
                return _CompanyIds == null ? null : _CompanyIds.Aggregate((a, b) => a + "|" + b);
            }
            set {
                _CompanyIds = value == null ? null : value.Split('|');
            }
        }

        #region not serialized
        private IEnumerable<ClassProfileParam> _ClassProfiles = null;
        private IEnumerable<string> _BagOfWords = null;
        private IEnumerable<string> _CompanyIds = null;

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
        public RetrievalParam SetBagOfWords(IEnumerable<string> words)
        {
            _BagOfWords = words;
            return this;
        }
        /// <summary>
        /// A set of company IDs that are forced to be on the long list, regardless of their scores. IDs separated by pipes.
        /// <seealso cref="CompanyId"/>
        /// </summary>
        public RetrievalParam SetCompanyId(IEnumerable<string> ids)
        {
            _CompanyIds = ids;
            return this;
        }
        /// <summary>
        /// For patent or other classification-based retrieval. The parameter contains a bag of weighted CPC codes. Each code is accompanied by a weight, A21B 02/03:.04, where A21B 02/03 is a valid CPC code, and .04 is its weight. A bag of codes is constructed by combining these pairs, separated by pipes.
        /// <seealso cref="ClassProfile"/>
        /// </summary>
        public IEnumerable<ClassProfileParam> GetClassProfiles() {
            return _ClassProfiles;
        }
        /// <summary>
        /// For patent or other classification-based retrieval. The parameter contains a bag of weighted CPC codes. Each code is accompanied by a weight, A21B 02/03:.04, where A21B 02/03 is a valid CPC code, and .04 is its weight. A bag of codes is constructed by combining these pairs, separated by pipes.
        /// <seealso cref="ClassProfile"/>
        /// </summary>
        public RetrievalParam SetClassProfile(IEnumerable<ClassProfileParam> profiles)
        {
            _ClassProfiles = profiles;
            return this;
        }
        #endregion
    }
}

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
    public class LoadParagraphsParams
    {
        //public List<DocumentType> ParagraphsToLoad { get; set; }
        public string ParagraphsToLoad
        {
            get
            {
                return _ParagraphsToLoad == null ? null : _ParagraphsToLoad
                                                                .Select<DocumentSelectionType, string>(a => a.ToString())
                                                                .Aggregate((a, b) => a + "|" + b);
            }
            set
            {
                _ParagraphsToLoad = value == null ? null : value
                                                            .Split('|')
                                                            .Select(a => (DocumentSelectionType)Enum.Parse(typeof(DocumentSelectionType), a))
                                                            .ToList();
            }
        }

        public string AnnualReportsDataSource { get; set; }
        public string AnnualReportsCatalog { get; set; }
        public string SecFilingsDataSource { get; set; }
        public string SecFilingsCatalog { get; set; }

        [JsonConverter(typeof(StringEnumConverter))]
        [Required]
        public SecParagraphTables SecParagraphSource { get; set; }
        public bool? TruncateBeforeLoad { get; set; }
 
        
        #region not serialized
        private IEnumerable<DocumentSelectionType> _ParagraphsToLoad = null;

        public IEnumerable<DocumentSelectionType> GetParagraphsToLoad()
        {
            return _ParagraphsToLoad;
        }

        public LoadParagraphsParams SetParagraphsToLoad(IEnumerable<DocumentSelectionType> paragraphSources)
        {
            _ParagraphsToLoad = paragraphSources;
            return this;
        }
        #endregion
    }
}

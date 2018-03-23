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
    public class LoadDocumentsParams
    {
        //public List<DocumentType> DocumentsToLoad { get; set; }
        public string DocumentsToLoad
        {
            get
            {
                return _DocumentsToLoad == null ? null : _DocumentsToLoad
                                                                .Select<DocumentSelectionType, string>(a => a.ToString())
                                                                .Aggregate((a, b) => a + "|" + b);
            }
            set
            {
                _DocumentsToLoad = value == null ? null : value
                                                            .Split('|')
                                                            .Select(a => (DocumentSelectionType)Enum.Parse(typeof(DocumentSelectionType), a))
                                                            .ToList();
            }
        }

        public string AnnualReportsDataSource { get; set; }
        public string AnnualReportsCatalog { get; set; }
        public string SecFilingsDataSource { get; set; }
        public string SecFilingsCatalog { get; set; }
        public string WebDataSource { get; set; }
        public string WebCatalog { get; set; }
        public bool? TruncateBeforeLoad { get; set; }
 
        
        #region not serialized
        private IEnumerable<DocumentSelectionType> _DocumentsToLoad = null;

        public IEnumerable<DocumentSelectionType> GetDocumentsToLoad()
        {
            return _DocumentsToLoad;
        }

        public LoadDocumentsParams SetDocumentsToLoad(IEnumerable<DocumentSelectionType> documentSources)
        {
            _DocumentsToLoad = documentSources;
            return this;
        }
        #endregion
    }
}

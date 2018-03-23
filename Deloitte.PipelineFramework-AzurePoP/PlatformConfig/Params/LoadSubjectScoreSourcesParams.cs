using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Deloitte.PipelineFramework.PlatformConfig.Enums;

namespace Deloitte.PipelineFramework.PlatformConfig.Params
{
    public class LoadSubjectScoreSourcesParams
    {
        public string SourceDescriptionSetsToLoad
        {
            get
            {
                return _SourceDescriptionSetsToLoad == null ? null : _SourceDescriptionSetsToLoad.Aggregate((a, b) => a + "|" + b);
            }
            set
            {
                _SourceDescriptionSetsToLoad = value == null ? null : value.Split('|');
            }
        }
        public string TopicScoresDataSource { get; set; }
        public string TopicScoresCatalog { get; set; }
        public bool? TruncateBeforeLoad { get; set; }

        #region not serialized
        private IEnumerable<string> _SourceDescriptionSetsToLoad = null;

        public IEnumerable<string> GetSourceDescriptionSetsToLoad()
        {
            return _SourceDescriptionSetsToLoad;
        }

        public LoadSubjectScoreSourcesParams SetSourceDescriptionSetsToLoad(IEnumerable<string> sourceDescriptionSets)
        {
            _SourceDescriptionSetsToLoad = sourceDescriptionSets;
            return this;
        }
        #endregion
    }
}

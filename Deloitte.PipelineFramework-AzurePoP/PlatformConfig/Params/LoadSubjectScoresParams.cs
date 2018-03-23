using Deloitte.PipelineFramework.PlatformConfig.Enums;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Deloitte.PipelineFramework.PlatformConfig.Params
{
    public class LoadSubjectScoresParams
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

        public string SubjectLevelsToCalculate
        {
            get
            {
                return _SubjectLevelsToCalculate == null ? null : _SubjectLevelsToCalculate
                                                                .Select(a => a.ToString())
                                                                .Aggregate((a, b) => a + "|" + b);
            }
            set
            {
                _SubjectLevelsToCalculate = value == null ? null : value
                                                            .Split('|')
                                                            .Select(a => Int16.Parse(a))
                                                            .ToList();
            }
        }

        public string IndustryLevelsToCalculate
        {
            get
            {
                return _IndustryLevelsToCalculate == null ? null : _IndustryLevelsToCalculate
                                                                .Select(a => a.ToString())
                                                                .Aggregate((a, b) => a + "|" + b);
            }
            set
            {
                _IndustryLevelsToCalculate = value == null ? null : value
                                                            .Split('|')
                                                            .Select(a => Int16.Parse(a))
                                                            .ToList();
            }
        }

        public int MinimumNumberOfTopicMatchesRequired { get; set; }
        public double? MinimumTopicScoreRequired { get; set; }
        public double? MinimumVarianceForTrendChange { get; set; }
        public bool? MultipleDocumentTypesPerCompany { get; set; }
        public string TopicScoresDataSource { get; set; }
        public string TopicScoresCatalog { get; set; }
        public int? TrendEndYear { get; set; }
        public int? TrendStartYear { get; set; }
        public bool? TruncateBeforeLoad { get; set; }

        #region not serialized
        private IEnumerable<DocumentSelectionType> _DocumentsToLoad = null;
        private IEnumerable<Int16> _SubjectLevelsToCalculate = null;
        private IEnumerable<Int16> _IndustryLevelsToCalculate = null;

        public IEnumerable<DocumentSelectionType> GetDocumentsToLoad()
        {
            return _DocumentsToLoad;
        }

        public LoadSubjectScoresParams SetDocumentsToLoad(IEnumerable<DocumentSelectionType> documentSources)
        {
            _DocumentsToLoad = documentSources;
            return this;
        }

        private IEnumerable<string> _SourceDescriptionSetsToLoad = null;

        public IEnumerable<string> GetSourceDescriptionSetsToLoad()
        {
            return _SourceDescriptionSetsToLoad;
        }

        public LoadSubjectScoresParams SetSourceDescriptionSetsToLoad(IEnumerable<string> sourceDescriptionSets)
        {
            _SourceDescriptionSetsToLoad = sourceDescriptionSets;
            return this;
        }

        public IEnumerable<Int16> GetSubjectLevelsToCalculate()
        {
            return _SubjectLevelsToCalculate;
        }

        public LoadSubjectScoresParams SetSubjectLevelsToCalculate(IEnumerable<Int16> subjectLevels)
        {
            _SubjectLevelsToCalculate = subjectLevels;
            return this;
        }

        public IEnumerable<Int16> GetIndustryLevelsToCalculate()
        {
            return _IndustryLevelsToCalculate;
        }

        public LoadSubjectScoresParams SetIndustryLevelsToCalculate(IEnumerable<Int16> industryLevels)
        {
            _IndustryLevelsToCalculate = industryLevels;
            return this;
        }
        #endregion
    }
}

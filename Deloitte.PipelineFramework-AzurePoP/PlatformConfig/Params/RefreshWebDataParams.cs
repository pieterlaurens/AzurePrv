using Deloitte.PipelineFramework.PlatformConfig.Enums;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Deloitte.PipelineFramework.PlatformConfig.Params
{
    public class RefreshWebDataParams
    {
        public string SubjectTreesToPublish
        {
            get
            {
                return _SubjectTreesToPublish == null ? null : String.Join("|", _SubjectTreesToPublish
                                                                .Select(a => a.ToString()));
            }
            set
            {
                _SubjectTreesToPublish = value == null ? null : value
                                                            .Split('|')
                                                            .Select(a => (SubjectTreeType)Enum.Parse(typeof(SubjectTreeType), a))
                                                            .ToList();
            }
        }
        public string SubjectLevelsToPublish
        {
            get
            {
                return _SubjectLevelsToPublish == null ? null : _SubjectLevelsToPublish
                                                                .Select(a => a.ToString())
                                                                .Aggregate((a, b) => a + "|" + b);
            }
            set
            {
                _SubjectLevelsToPublish = value == null ? null : value
                                                            .Split('|')
                                                            .Select(a => Int16.Parse(a))
                                                            .ToList();
            }
        }

        public string IndustryLevelsToPublish
        {
            get
            {
                return _IndustryLevelsToPublish == null ? null : _IndustryLevelsToPublish
                                                                .Select(a => a.ToString())
                                                                .Aggregate((a, b) => a + "|" + b);
            }
            set
            {
                _IndustryLevelsToPublish = value == null ? null : value
                                                            .Split('|')
                                                            .Select(a => Int16.Parse(a))
                                                            .ToList();
            }
        }

        public string PublishDataSource { get; set; }
        public string PublishCatalog { get; set; }
        public int? TrendEndYear { get; set; }
        public int? TrendStartYear { get; set; }
        public double? MinimumVarianceForTrendChange { get; set; }
        public bool? TruncateBeforeLoad { get; set; }


        #region not serialized
        private IEnumerable<SubjectTreeType> _SubjectTreesToPublish = null;
        private IEnumerable<Int16> _SubjectLevelsToPublish = null;
        private IEnumerable<Int16> _IndustryLevelsToPublish = null;

        public IEnumerable<SubjectTreeType> GetSubjectTreesToPublish()
        {
            return _SubjectTreesToPublish;
        }

        public RefreshWebDataParams SetSubjectTreesToPublish(IEnumerable<SubjectTreeType> subjectTreeTypes)
        {
            _SubjectTreesToPublish = subjectTreeTypes;
            return this;
        }

        public IEnumerable<Int16> GetSubjectLevelsToPublish()
        {
            return _SubjectLevelsToPublish;
        }

        public RefreshWebDataParams SetSubjectLevelsToPublish(IEnumerable<Int16> subjectLevels)
        {
            _SubjectLevelsToPublish = subjectLevels;
            return this;
        }

        public IEnumerable<Int16> GetIndustryLevelsToPublish()
        {
            return _IndustryLevelsToPublish;
        }

        public RefreshWebDataParams SetIndustryLevelsToPublish(IEnumerable<Int16> industryLevels)
        {
            _IndustryLevelsToPublish = industryLevels;
            return this;
        }

        #endregion
    }
}

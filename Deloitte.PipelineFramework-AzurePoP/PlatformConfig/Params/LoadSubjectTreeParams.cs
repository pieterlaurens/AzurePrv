using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Deloitte.PipelineFramework.PlatformConfig.Enums;

namespace Deloitte.PipelineFramework.PlatformConfig.Params
{
    public class LoadSubjectTreeParams
    {
        public string SubjectTreesToLoad
        {
            get
            {
                return _SubjectTreesToLoad == null ? null : _SubjectTreesToLoad
                                                                .Select<SubjectTreeType, string>(a => a.ToString())
                                                                .Aggregate((a, b) => a + "|" + b);
            }
            set
            {
                _SubjectTreesToLoad = value == null ? null : value
                                                            .Split('|')
                                                            .Select(a => (SubjectTreeType)Enum.Parse(typeof(SubjectTreeType), a))
                                                            .ToList();
            }
        }
        public string TopicDefinitionDataSource { get; set; }
        public string TopicDefinitionCatalog { get; set; }
        public bool? TruncateBeforeLoad { get; set; }

        #region not serialized
        private IEnumerable<SubjectTreeType> _SubjectTreesToLoad = null;

        public IEnumerable<SubjectTreeType> GetSubjectTreesToLoad()
        {
            return _SubjectTreesToLoad;
        }

        public LoadSubjectTreeParams SetSubjectTreesToLoad(IEnumerable<SubjectTreeType> subjectTreeTypes)
        {
            _SubjectTreesToLoad = subjectTreeTypes;
            return this;
        }
        #endregion
    }
}

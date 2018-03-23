using Deloitte.PipelineFramework.PlatformConfig.Enums;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Deloitte.PipelineFramework.PlatformConfig.Params
{
    public class LoadCpcScoresParams
    {
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

        public double? MinimumVarianceForTrendChange { get; set; }
        public string PatentScoresDataSource { get; set; }
        public string PatentScoresCatalog { get; set; }
        public string PatentCompaniesDataSource { get; set; }
        public string PatentCompaniesCatalog { get; set; }
        public int? TrendEndYear { get; set; }
        public int? TrendStartYear { get; set; }
        public bool? TruncateBeforeLoad { get; set; }

        #region not serialized
        private IEnumerable<Int16> _SubjectLevelsToCalculate = null;
        private IEnumerable<Int16> _IndustryLevelsToCalculate = null;

        public IEnumerable<Int16> GetSubjectLevelsToCalculate()
        {
            return _SubjectLevelsToCalculate;
        }

        public LoadCpcScoresParams SetSubjectLevelsToCalculate(IEnumerable<Int16> subjectLevels)
        {
            _SubjectLevelsToCalculate = subjectLevels;
            return this;
        }

        public IEnumerable<Int16> GetIndustryLevelsToCalculate()
        {
            return _IndustryLevelsToCalculate;
        }

        public LoadCpcScoresParams SetIndustryLevelsToCalculate(IEnumerable<Int16> industryLevels)
        {
            _IndustryLevelsToCalculate = industryLevels;
            return this;
        }
        #endregion
    }
}

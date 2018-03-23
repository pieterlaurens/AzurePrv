using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Deloitte.PipelineFramework.PlatformConfig.Enums;

namespace Deloitte.PipelineFramework.PlatformConfig.Params
{
    public class LoadDealScoresParams
    {
        public string DealStatusToLoad
        {
            get
            {
                return _DealStatusToLoad == null ? null : _DealStatusToLoad
                                                                .Select<DealStatus, string>(a => a.ToString().Replace("_", " "))
                                                                .Aggregate((a, b) => a + "|" + b);
            }
            set
            {
                _DealStatusToLoad = value == null ? null : value
                                                            .Replace(" ", "_")
                                                            .Split('|')
                                                            .Select(a => (DealStatus)Enum.Parse(typeof(DealStatus), a))
                                                            .ToList();
            }
        }
        public string DealTypesToLoad
        {
            get
            {
                return _DealTypesToLoad == null ? null : _DealTypesToLoad
                                                                .Select<DealType, string>(a => a.ToString().Replace("_", " "))
                                                                .Aggregate((a, b) => a + "|" + b);
            }
            set
            {
                _DealTypesToLoad = value == null ? null : value
                                                            .Replace(" ", "_")
                                                            .Split('|')
                                                            .Select(a => (DealType)Enum.Parse(typeof(DealType), a))
                                                            .ToList();
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

        public string CompanyOwnershipDataSource { get; set; }
        public string CompanyOwnershipCatalog { get; set; }
        public string DealsDataSource { get; set; }
        public string DealsCatalog { get; set; }
        public double? MinimumVarianceForTrendChange { get; set; }
        public int? TrendEndYear { get; set; }
        public int? TrendStartYear { get; set; }
        public bool? TruncateBeforeLoad{ get; set; }

        #region not serialized
        private IEnumerable<DealStatus> _DealStatusToLoad = null;
        private IEnumerable<Int16> _SubjectLevelsToCalculate = null;
        private IEnumerable<Int16> _IndustryLevelsToCalculate = null;

        public IEnumerable<DealStatus> GetDealStatusToLoad()
        {
            return _DealStatusToLoad;
        }

        public LoadDealScoresParams SetDealStatusToLoad(IEnumerable<DealStatus> dealStatus)
        {
            _DealStatusToLoad = dealStatus;
            return this;
        }

        private IEnumerable<DealType> _DealTypesToLoad = null;

        public IEnumerable<DealType> GetDealTypesToLoad()
        {
            return _DealTypesToLoad;
        }

        public LoadDealScoresParams SetDealTypesToLoad(IEnumerable<DealType> dealTypes)
        {
            _DealTypesToLoad = dealTypes;
            return this;
        }

        public IEnumerable<Int16> GetSubjectLevelsToCalculate()
        {
            return _SubjectLevelsToCalculate;
        }

        public LoadDealScoresParams SetSubjectLevelsToCalculate(IEnumerable<Int16> subjectLevels)
        {
            _SubjectLevelsToCalculate = subjectLevels;
            return this;
        }

        public IEnumerable<Int16> GetIndustryLevelsToCalculate()
        {
            return _IndustryLevelsToCalculate;
        }

        public LoadDealScoresParams SetIndustryLevelsToCalculate(IEnumerable<Int16> industryLevels)
        {
            _IndustryLevelsToCalculate = industryLevels;
            return this;
        }
        #endregion
    }
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Deloitte.PipelineFramework.PlatformConfig.Enums;

namespace Deloitte.PipelineFramework.PlatformConfig.Params
{
    public class LoadDealsParams
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

        public string DealsDataSource { get; set; }
        public string DealsCatalog { get; set; }
        public int? TrendEndYear { get; set; }
        public int? TrendStartYear { get; set; }
        public bool? TruncateBeforeLoad { get; set; }

        #region not serialized
        private IEnumerable<DealStatus> _DealStatusToLoad = null;

        public IEnumerable<DealStatus> GetDealStatusToLoad()
        {
            return _DealStatusToLoad;
        }

        public LoadDealsParams SetDealStatusToLoad(IEnumerable<DealStatus> dealStatus)
        {
            _DealStatusToLoad = dealStatus;
            return this;
        }

        private IEnumerable<DealType> _DealTypesToLoad = null;

        public IEnumerable<DealType> GetDealTypesToLoad()
        {
            return _DealTypesToLoad;
        }

        public LoadDealsParams SetDealTypesToLoad(IEnumerable<DealType> dealTypes)
        {
            _DealTypesToLoad = dealTypes;
            return this;
        }
        #endregion
    }
}

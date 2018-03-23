using Deloitte.PipelineFramework.PlatformConfig.Enums;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


namespace Deloitte.PipelineFramework.PlatformConfig.Params
{
    public class LoadCompaniesParams
    {
        public string CompaniesToLoad
        {
            get
            {
                return _CompaniesToLoad == null ? null : _CompaniesToLoad
                                                                .Select(a => a.ToString())
                                                                .Aggregate((a, b) => a + "|" + b);
            }
            set
            {
                _CompaniesToLoad = value == null ? null : value
                                                            .Split('|')
                                                            .Select(a => (CompanySelectionType)Enum.Parse(typeof(CompanySelectionType), a))
                                                            .ToList();
            }
        }
        public string EntityTypesToLoad
        {
            get
            {
                return _EntityTypesToLoad == null ? null : _EntityTypesToLoad
                                                                .Select(a => a.ToString().Replace("_", " "))
                                                                .Aggregate((a, b) => a + "|" + b);
            }
            set
            {
                _EntityTypesToLoad = value == null ? null : value
                                                            .Replace(" ", "_")
                                                            .Split('|')
                                                            .Select(a => (CompanyEntityType)Enum.Parse(typeof(CompanyEntityType), a))
                                                            .ToList();
            }
        }
        public string CompanyOwnershipDataSource { get; set; }
        public string CompanyOwnershipCatalog { get; set; }
        public string DealsDataSource { get; set; }
        public string DealsCatalog { get; set; }
        public string OrbisDataSource { get; set; }
        public string OrbisCatalog { get; set; }
        public string PatentsDataSource { get; set; }
        public string PatentsCatalog { get; set; }
        public bool? TruncateBeforeLoad { get; set; }

        #region not serialized
        private IEnumerable<CompanySelectionType> _CompaniesToLoad = null;

        public IEnumerable<CompanySelectionType> GetCompaniesToLoad()
        {
            return _CompaniesToLoad;
        }

        public LoadCompaniesParams SetCompaniesToLoad(IEnumerable<CompanySelectionType> companySelectionTypes)
        {
            _CompaniesToLoad = companySelectionTypes;
            return this;
        }


        private IEnumerable<CompanyEntityType> _EntityTypesToLoad = null;

        public IEnumerable<CompanyEntityType> GetEntityTypesToLoad()
        {
            return _EntityTypesToLoad;
        }

        public LoadCompaniesParams SetEntityTypesToLoad(IEnumerable<CompanyEntityType> companyEntityTypes)
        {
            _EntityTypesToLoad = companyEntityTypes;
            return this;
        }
        
        #endregion
    }
}

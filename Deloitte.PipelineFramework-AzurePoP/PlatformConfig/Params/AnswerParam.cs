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
    /// <summary>
    /// Configuration object for the data that represents one answer, to one question for one company.
    /// </summary>
    public class AnswerParam : DeloitteObject
    {

        /// <summary>
        /// The integer identifier for the question that is being answered.
        /// </summary>
        public int? QuestionId { get; set; }

        /// <summary>
        /// The string identifier for the question that is being answered.
        /// </summary>
        public string QuestionName { get; set; }= "";

        /// <summary>
        /// The id (BvD ID) of the company for which the question is being answered.
        /// </summary>
        [Required]
        public string CompanyId { get; set; }

        /// <summary>
        /// The answer to the question for this company.
        /// <para>This field is set when SingleLine or FreeInput types are answered.</para>
        /// </summary>
        public string Answer { get; set; } = "";

        /// <summary>
        /// A text describing the origin of the information in the answer (web-address, database etc.)
        /// </summary>
        public string Reference { get; set; } = "";

        /// <summary>
        /// User comments about the answer given.
        /// </summary>
        public string Comment { get; set; } = "";

        /// <summary>
        /// The set of answers that is checked, in case of a SingleSelect or MultiSelect.
        /// </summary>
        public ICollection<CheckedAnswer> CheckedAnswers { get; set; }
    }

    /// <summary>
    /// When a user checks one or more of the possible options, they have the opportunity 
    /// to add a reference and / or a comment to each.
    /// </summary>
    public class CheckedAnswer : DeloitteObject {
        
        /// <summary>
        /// The id of the answer
        /// </summary>
        public int Id { get; set; }

        /// <summary>
        /// The value associated with the answer.
        /// </summary>
        public string Value { get; set; } = "";

        /// <summary>
        /// The reference value entered into the text input box.
        /// </summary>
        public string Reference { get; set; } = "";

        /// <summary>
        /// The comment value entered into the text input box.
        /// </summary>
        public string Comment { get; set; } = "";
    }
}

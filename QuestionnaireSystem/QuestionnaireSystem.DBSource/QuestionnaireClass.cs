using QuestionnaireSystem.ORM.DBModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace QuestionnaireSystem.DBSource
{
    public class QuestionnaireClass
    {
        public string QuestionnaireTitle { get; set; }
        public string Description { get; set; }
        public string StartDate { get; set; }
        public string EndDate { get; set; }
        public int Active { get; set; }
        public QuestionClass[] Questions { get; set; }
    }

    public class QuestionClass
    {
        public string QuestionID { get; set; }
        public string QuestionTitle { get; set; }
        public int QuestionType { get; set; }
        public int QuestionRequired { get; set; }
        public int QuestionNumber { get; set; }
        public string FAQName { get; set; }
        public OptionClass[] Options { get; set; }
        public string Modified { get; set; }
    }

    public class OptionClass
    {
        public string OptionContent { get; set; }
        public int OptionNumber { get; set; }
    }
}

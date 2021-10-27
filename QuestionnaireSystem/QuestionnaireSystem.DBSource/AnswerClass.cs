using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace QuestionnaireSystem.DBSource
{
    public class AnswerClass
    {
        public string QuestionID { get; set; }
        public int Type { get; set; }
        public string[] Answer { get; set; }
    }
}

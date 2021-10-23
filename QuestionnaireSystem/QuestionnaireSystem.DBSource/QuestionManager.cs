using QuestionnaireSystem.ORM.DBModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace QuestionnaireSystem.DBSource
{
    class QuestionManager
    {
        private static List<Question> GetQuestionList()
        {
            try
            {
                using(ContextModel context = new ContextModel())
                {
                    return context.Questions.Select(obj => obj).ToList();
                }
            }
            catch(Exception e)
            {
                return null;
            }
        }
    }
}

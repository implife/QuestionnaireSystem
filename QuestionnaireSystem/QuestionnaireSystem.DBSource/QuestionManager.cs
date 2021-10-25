using QuestionnaireSystem.ORM.DBModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace QuestionnaireSystem.DBSource
{
    public class QuestionManager
    {
        public static List<Questionnaire> GetQuestionnaireList()
        {
            try
            {
                using (ContextModel context = new ContextModel())
                {
                    return context.Questionnaires.Select(obj => obj).ToList();
                }
            }
            catch (Exception e)
            {
                return null;
            }
        }

        public static List<Questionnaire> SearchQuestionnaire(string title, DateTime? startDate, DateTime? endDate)
        {
            List<Questionnaire> temp = new List<Questionnaire>();
            List<Questionnaire> result = new List<Questionnaire>();

            try
            {
                using(ContextModel context = new ContextModel())
                {
                    if(startDate != null && endDate == null)
                        temp = context.Questionnaires.Where(item => item.StartDate >= startDate).ToList();
                    else if(startDate == null && endDate != null)
                        temp = context.Questionnaires.Where(item => item.StartDate <= endDate).ToList();
                    else if(startDate != null && endDate != null)
                        temp = context.Questionnaires.Where(item => (item.StartDate >= startDate) && (item.StartDate <= endDate)).ToList();
                    else
                        temp = context.Questionnaires.ToList();

                    if(title != null && title != "")
                    {
                        foreach (Questionnaire item in temp)
                        {
                            if (item.Title.IndexOf(title) != -1)
                                result.Add(item);
                        }
                    }
                    else
                    {
                        result = temp;
                    }

                    return result;
                }
            }
            catch (Exception)
            {
                return null;
            }
        }

        public static Questionnaire GetQuestionnaireByID(Guid guid)
        {
            try
            {
                using (ContextModel context = new ContextModel())
                {
                    return context.Questionnaires.Where(item => item.QuestionnaireID.Equals(guid)).FirstOrDefault();
                }
            }
            catch (Exception)
            {
                return null;
            }
        }

        public static List<Question> GetQuestionsByQuestionnaireID(Guid guid)
        {
            try
            {
                using (ContextModel context = new ContextModel())
                {
                    return context.Questions.Where(item => item.QuestionnaireID.Equals(guid)).OrderBy(item => item.Number).ToList();
                }
            }
            catch (Exception)
            {
                return null;
            }
            
        }

        public static List<Option> GetOptionsByQuestionID(Guid guid)
        {
            try
            {
                using (ContextModel context = new ContextModel())
                {
                    return context.Options.Where(item => item.QuestionID.Equals(guid)).OrderBy(item => item.Number).ToList();
                }
            }
            catch (Exception)
            {
                return null;
            }
        }
    }
}

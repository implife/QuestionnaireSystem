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
                using (ContextModel context = new ContextModel())
                {
                    if (startDate != null && endDate == null)
                        temp = context.Questionnaires.Where(item => item.StartDate >= startDate).ToList();
                    else if (startDate == null && endDate != null)
                        temp = context.Questionnaires.Where(item => item.StartDate <= endDate).ToList();
                    else if (startDate != null && endDate != null)
                        temp = context.Questionnaires.Where(item => (item.StartDate >= startDate) && (item.StartDate <= endDate)).ToList();
                    else
                        temp = context.Questionnaires.ToList();

                    if (title != null && title != "")
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

        public static Questionnaire GetQuestionnaireByQuestion(Question qu)
        {
            try
            {
                using (ContextModel context = new ContextModel())
                {
                    return context.Questionnaires.Where(item => item.QuestionnaireID.Equals(qu.QuestionnaireID)).FirstOrDefault();
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

        public static Question GetQuestionByQuestionID(Guid guid)
        {
            try
            {
                using (ContextModel context = new ContextModel())
                {
                    return context.Questions.Where(item => item.QuestionID.Equals(guid)).FirstOrDefault();
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

        public static Option GetOptionByOptionID(Guid guid)
        {
            try
            {
                using (ContextModel context = new ContextModel())
                {
                    return context.Options.Where(item => item.OptionID.Equals(guid)).FirstOrDefault();
                }
            }
            catch (Exception)
            {
                return null;
            }
        }

        /// <summary>
        /// private method. 跟AddRangeNewAnswer搭配，ContextModel中新增一題份量的答案，可能是文字方塊、單選或多選
        /// </summary>
        /// <param name="voter"></param>
        /// <param name="guidQuestion"></param>
        /// <param name="guidOptions">是single或multi時非必填時為null或空陣列</param>
        /// <param name="textAns">不是必填而留空時應是空字串</param>
        /// <param name="context"></param>
        private static void AddNewAnswer(Voter voter, Guid guidQuestion, Guid[] guidOptions, string textAns, ContextModel context)
        {
            // check question
            Question question = GetQuestionByQuestionID(guidQuestion);
            if (question == null)
                throw new Exception("Question doesn't exist.");

            if (question.Type == 0)     // 文字方塊
            {
                if (textAns == null)
                    throw new NullReferenceException("textAns should not be null.");

                context.Answers.Add(new Answer()
                {
                    VoterID = voter.VoterID,
                    QuestionID = question.QuestionID,
                    TextboxContent = textAns,
                    Timestamp = DateTime.Now
                });
            }
            else if (question.Type == 1 || question.Type == 2) // 單選或複選
            {
                // 如果options為null或為空陣列
                if (guidOptions == null || guidOptions.Length == 0)
                {
                    if (question.Required == 0)
                        throw new Exception("Question is required but there's no option.");

                    context.Answers.Add(new Answer()
                    {
                        VoterID = voter.VoterID,
                        QuestionID = question.QuestionID,
                        OptionID = null,
                        Timestamp = DateTime.Now
                    });
                }
                else
                {
                    // 做成Option陣列
                    Option[] options = new Option[guidOptions.Length];
                    int i = 0;
                    foreach (Guid item in guidOptions)
                    {
                        Option optionTemp = GetOptionByOptionID(item);
                        if (optionTemp == null)
                            throw new Exception("Option doesn't exist.");

                        if (!optionTemp.QuestionID.Equals(question.QuestionID))
                            throw new Exception("Option and Question is different.");

                        options[i] = optionTemp;
                        i++;
                    }

                    // 做成Answer陣列
                    Answer[] answers = new Answer[options.Length];
                    int j = 0;
                    foreach (Option item in options)
                    {
                        answers[j] = new Answer()
                        {
                            VoterID = voter.VoterID,
                            QuestionID = question.QuestionID,
                            OptionID = item.OptionID,
                            TextboxContent = "",
                            Timestamp = DateTime.Now
                        };
                        j++;
                    }

                    context.Answers.AddRange(answers);
                }
            }
        }

        /// <summary>
        /// 新增一張問卷份量的答案
        /// </summary>
        /// <param name="voter"></param>
        /// <param name="answers">QuestionnaireSystem.DBSource.AnswerClass陣列</param>
        /// <returns>成功時回傳true，反之回傳false</returns>
        public static bool AddRangeNewAnswer(Voter voter, AnswerClass[] answers)
        {
            try
            {
                // Check voter
                if (string.IsNullOrWhiteSpace(voter.Name))
                    throw new Exception("Voter's name is empty.");
                if (string.IsNullOrWhiteSpace(voter.Phone))
                    throw new Exception("Voter's phone is empty.");
                if (string.IsNullOrWhiteSpace(voter.Email))
                    throw new Exception("Voter's Email is empty.");
                if (voter.Age <= 0 || voter.Age >= 150)
                    throw new Exception("Voter's age is not valid.");

                using (ContextModel context = new ContextModel())
                {
                    voter.VoterID = Guid.NewGuid();
                    context.Voters.Add(voter);

                    // 以題為單位呼叫AddNewAnswer()
                    foreach (AnswerClass item in answers)
                    {
                        if (item.Type == 0)
                            AddNewAnswer(voter, Guid.Parse(item.QuestionID), null, item.Answer[0], context);
                        else
                        {
                            Guid[] guidOptions = item.Answer.Select(obj => Guid.Parse(obj)).ToArray();
                            AddNewAnswer(voter, Guid.Parse(item.QuestionID), guidOptions, "", context);
                        }
                    }

                    context.SaveChanges();
                    return true;
                }
            }
            catch (Exception e)
            {
                return false;
            }

        }

        
    }
}

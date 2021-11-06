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

        public static Questionnaire GetQuestionnaireByID(Guid QuestionnaireGuid)
        {
            try
            {
                using (ContextModel context = new ContextModel())
                {
                    return context.Questionnaires.Where(item => item.QuestionnaireID.Equals(QuestionnaireGuid)).FirstOrDefault();
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

        public static List<Question> GetQuestionsByQuestionnaireID(Guid QuestionnaireGuid)
        {
            try
            {
                using (ContextModel context = new ContextModel())
                {
                    return context.Questions.Where(item => item.QuestionnaireID.Equals(QuestionnaireGuid)).OrderBy(item => item.Number).ToList();
                }
            }
            catch (Exception)
            {
                return null;
            }

        }

        public static Question GetQuestionByQuestionID(Guid QuestionGuid)
        {
            try
            {
                using (ContextModel context = new ContextModel())
                {
                    return context.Questions.Where(item => item.QuestionID.Equals(QuestionGuid)).FirstOrDefault();
                }
            }
            catch (Exception)
            {
                return null;
            }
        }

        /// <summary>
        /// 輸入QuestionID回傳該問題的選項List,問題為文字方塊時List為空
        /// </summary>
        /// <param name="QuestionGuid"></param>
        /// <returns></returns>
        public static List<Option> GetOptionsByQuestionID(Guid QuestionGuid)
        {
            try
            {
                using (ContextModel context = new ContextModel())
                {
                    return context.Options.Where(item => item.QuestionID.Equals(QuestionGuid)).OrderBy(item => item.Number).ToList();
                }
            }
            catch (Exception)
            {
                return null;
            }
        }

        public static Option GetOptionByOptionID(Guid OptionGuid)
        {
            try
            {
                using (ContextModel context = new ContextModel())
                {
                    return context.Options.Where(item => item.OptionID.Equals(OptionGuid)).FirstOrDefault();
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

        public static int GetTotalVoterQuantity(Guid QuestionnaireGuid)
        {
            try
            {
                using (ContextModel context = new ContextModel())
                {
                    Guid firstGuid = GetQuestionsByQuestionnaireID(QuestionnaireGuid)[0].QuestionID; ;

                    return context.Answers.Where(obj => obj.QuestionID.Equals(firstGuid))
                        .Select(obj => obj.VoterID).Distinct().Count();
                }
            }
            catch (Exception)
            {
                return -1;
            }
        }

        /// <summary>
        /// 取得特定問題的各個選項得票數，文字方塊則回傳空的List
        /// </summary>
        /// <param name="questionGuid"></param>
        /// <returns></returns>
        public static List<int> GetVotersCountOfEveryOption(Guid questionGuid)
        {
            try
            {
                using (ContextModel context = new ContextModel())
                {
                    List<Option> options = GetOptionsByQuestionID(questionGuid);
                    return options.Select(item =>
                        {
                            return context.Answers.Where(obj => obj.OptionID == item.OptionID).Count();
                        }).ToList();
                }
            }
            catch (Exception)
            {
                return null;
            }
        }

        public static bool CheckStatus()
        {
            try
            {
                using (ContextModel context = new ContextModel())
                {
                    // 檢查未開放的問卷
                    List<Questionnaire> listNotStart = context.Questionnaires.Where(item => item.Status == 0).ToList();
                    foreach (Questionnaire item in listNotStart)
                    {
                        if(item.StartDate.Date <= DateTime.Now.Date)
                        {
                            context.Questionnaires.Where(obj => obj.QuestionnaireID == item.QuestionnaireID)
                                .FirstOrDefault().Status = 1;
                        }
                    }

                    // 檢查投票中的問卷
                    List<Questionnaire> listVoting = context.Questionnaires.Where(item => item.Status == 1).ToList();
                    foreach (Questionnaire item in listVoting)
                    {
                        if (item.EndDate == null)
                            continue;

                        if (((DateTime)item.EndDate).Date <= DateTime.Now.Date)
                        {
                            context.Questionnaires.Where(obj => obj.QuestionnaireID == item.QuestionnaireID)
                                .FirstOrDefault().Status = 2;
                        }
                    }
                    context.SaveChanges();
                    return true;
                }
            }
            catch (Exception)
            {
                return false;
            }
        }

        public static bool CreateNewQuestionnaire(QuestionnaireClass questionnaire )
        {
            try
            {
                using (ContextModel context = new ContextModel())
                {
                    // 處理開始日期、結束日期
                    string[] sDate = questionnaire.StartDate.Split('-');
                    DateTime startDate = new DateTime(Convert.ToInt32(sDate[0]), Convert.ToInt32(sDate[1]), Convert.ToInt32(sDate[2]));
                    string[] eDate = questionnaire.EndDate.Split('-');
                    DateTime? endDate;
                    if (eDate.Length != 3)
                        endDate = null;
                    else
                        endDate = new DateTime(Convert.ToInt32(eDate[0]), Convert.ToInt32(eDate[1]), Convert.ToInt32(eDate[2]));

                    // 處理Status
                    int status;
                    if(questionnaire.Active == 0)
                    {
                        if (startDate == DateTime.Now.Date)
                            status = 1;
                        else
                            status = 0;
                    }
                    else
                    {
                        status = 3;
                    }

                    // 問卷
                    Guid currentQuestionnaireID = Guid.NewGuid();
                    context.Questionnaires.Add(new Questionnaire()
                    {
                        QuestionnaireID = currentQuestionnaireID,
                        Title = questionnaire.QuestionnaireTitle,
                        Discription = questionnaire.Description,
                        StartDate = startDate,
                        EndDate = endDate,
                        Status = status
                    });

                    foreach (QuestionClass item in questionnaire.Questions)
                    {
                        // 問題
                        Guid currentQuestionID = Guid.NewGuid();
                        context.Questions.Add(new Question()
                        {
                            QuestionID = currentQuestionID,
                            QuestionnaireID = currentQuestionnaireID,
                            Title = item.QuestionTitle,
                            Type = item.QuestionType,
                            Required = item.QuestionRequired,
                            Number = item.QuestionNumber
                        });

                        foreach (OptionClass opt in item.Options)
                        {
                            // 選項
                            context.Options.Add(new Option()
                            {
                                OptionID = Guid.NewGuid(),
                                QuestionID = currentQuestionID,
                                OptionContent = opt.OptionContent,
                                Number = opt.OptionNumber
                            });
                        }
                    }
                    context.SaveChanges();
                    return true;
                }
            }
            catch (Exception ex)
            {
                return false;
            }
        }
    }
}

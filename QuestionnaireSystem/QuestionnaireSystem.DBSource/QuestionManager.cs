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
            catch (Exception ex)
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
            catch (Exception ex)
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
            catch (Exception ex)
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
            catch (Exception ex)
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
                    return context.Questions.Where(item => item.QuestionnaireID == QuestionnaireGuid).OrderBy(item => item.Number).ToList();
                }
            }
            catch (Exception ex)
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
            catch (Exception ex)
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
            catch (Exception ex)
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
            catch (Exception ex)
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

                    //context.Answers.Add(new Answer()
                    //{
                    //    VoterID = voter.VoterID,
                    //    QuestionID = question.QuestionID,
                    //    OptionID = null,
                    //    Timestamp = DateTime.Now
                    //});
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
                            Guid[] guidOptions;
                            if (item.Answer[0] == "")
                                guidOptions = new Guid[0];
                            else
                                guidOptions = item.Answer.Select(obj => Guid.Parse(obj)).ToArray();
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
            catch (Exception ex)
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
            catch (Exception ex)
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
                    // 檢查未開始的問卷
                    List<Questionnaire> listNotStart = context.Questionnaires.Where(item => item.Status == 0).ToList();
                    foreach (Questionnaire item in listNotStart)
                    {
                        if (item.StartDate.Date <= DateTime.Now.Date)
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

        public static bool CreateNewQuestionnaire(QuestionnaireClass questionnaire)
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
                    if (questionnaire.Active == 0)
                    {
                        if (startDate <= DateTime.Now.Date)
                        {
                            if (endDate == null || endDate > DateTime.Now.Date)
                                status = 1;
                            else
                                status = 2;

                        }
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
                            Number = item.QuestionNumber,
                            FAQName = item.FAQName == "" ? null : item.FAQName
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

        public static QuestionClass[] GetFAQList()
        {
            try
            {
                using (ContextModel context = new ContextModel())
                {
                    List<Question> FAQs = context.Questions.Where(obj => obj.QuestionnaireID == null && obj.FAQName != null).ToList();
                    QuestionClass[] result = new QuestionClass[FAQs.Count];

                    int i = 0;
                    foreach (Question item in FAQs)
                    {
                        QuestionClass temp = new QuestionClass()
                        {
                            QuestionTitle = item.Title,
                            QuestionType = item.Type,
                            QuestionRequired = item.Required,
                            QuestionNumber = -1,
                            FAQName = item.FAQName
                        };
                        temp.Options = GetOptionsByQuestionID(item.QuestionID).Select(obj => new OptionClass()
                        {
                            OptionContent = obj.OptionContent,
                            OptionNumber = obj.Number
                        }).ToArray();
                        result[i++] = temp;
                    }

                    return result;
                }
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public static List<Voter> GetAllVotersByQuestionnaire(Questionnaire questionnaire)
        {
            List<Question> questions = GetQuestionsByQuestionnaireID(questionnaire.QuestionnaireID);
            List<Voter> voters = new List<Voter>();

            try
            {
                using (ContextModel context = new ContextModel())
                {
                    foreach (Question item in questions)
                    {
                        var temp = context.Answers.Where(obj => obj.QuestionID == item.QuestionID)
                            .Select(obj => obj.Voter).Distinct();
                        voters = voters.Concat(temp).Distinct().ToList();
                    }
                    return voters;
                }
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        /// <summary>
        /// 輸入Voter和Question，回傳相對應的答案List(可能是多選)，若不傳入Question，則回傳該投票者的所有回答(也只會有同一張問卷的)
        /// </summary>
        /// <param name="voter"></param>
        /// <param name="question">若為null，責尋找同張問卷的所有答案</param>
        /// <returns></returns>
        public static List<Answer> GetAnswerByVoterAndQuestion(Voter voter, Question question = null)
        {
            try
            {
                using (ContextModel context = new ContextModel())
                {
                    if (question == null)
                    {
                        return context.Answers.Where(obj => obj.Voter.VoterID == voter.VoterID).ToList();
                    }
                    else
                    {
                        return context.Answers.Where(obj => obj.Voter.VoterID == voter.VoterID
                            && obj.Question.QuestionID == question.QuestionID).ToList();
                    }
                }
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public static Voter GetVoterByVoterID(Guid voterGuid)
        {
            try
            {
                using (ContextModel context = new ContextModel())
                {
                    return context.Voters.Where(item => item.VoterID.Equals(voterGuid)).FirstOrDefault();
                }
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public static DateTime? GetTimeStampByVoter(Voter voter)
        {
            try
            {
                using (ContextModel context = new ContextModel())
                {
                    Answer ans = context.Answers.Where(obj => obj.Voter.VoterID == voter.VoterID).FirstOrDefault();
                    if (ans == null)
                        return null;
                    else
                        return ans.Timestamp;
                }
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public static bool UpdateQuestionnaire(Questionnaire modifiedQuestionnaire)
        {
            if (GetQuestionnaireByID(modifiedQuestionnaire.QuestionnaireID) == null)
                throw new Exception("Questionnaire ID Error.");
            if (modifiedQuestionnaire.Status < 0 || modifiedQuestionnaire.Status > 3)
                throw new Exception("Questionnaire status is not valid.");
            if (modifiedQuestionnaire.EndDate != null)
            {
                if (modifiedQuestionnaire.EndDate <= modifiedQuestionnaire.StartDate)
                    throw new Exception("End Date is less than or equal to Start Date.");
            }
            if (modifiedQuestionnaire.Title == "")
                throw new Exception("Title can not be empty.");


            try
            {
                using (ContextModel context = new ContextModel())
                {
                    Questionnaire target = context.Questionnaires.Where(obj => obj.QuestionnaireID == modifiedQuestionnaire.QuestionnaireID)
                        .FirstOrDefault();
                    target.Title = modifiedQuestionnaire.Title;
                    target.Discription = modifiedQuestionnaire.Discription;
                    target.StartDate = modifiedQuestionnaire.StartDate;
                    target.EndDate = modifiedQuestionnaire.EndDate;
                    target.Status = modifiedQuestionnaire.Status;

                    context.SaveChanges();
                    return true;
                }
            }
            catch (Exception ex)
            {
                return false;
            }
        }

        public static bool UpdateQuestions(QuestionClass[] modifiedQuestions, Questionnaire questionnaire)
        {
            try
            {
                using (ContextModel context = new ContextModel())
                {
                    List<Question> originalQuestions = context.Questions.Where(obj => obj.QuestionnaireID == questionnaire.QuestionnaireID).ToList();
                    List<string> modifiedGuid = modifiedQuestions.Select(obj => obj.QuestionID).ToList();
                    List<Question> delQ = originalQuestions.Where(obj => modifiedGuid.IndexOf(obj.QuestionID.ToString()) == -1).ToList();

                    // 從資料庫刪除不在modifiedQuestions裡的問題
                    foreach (Question item in delQ)
                    {
                        DeleteAnswersByQuestionID(item.QuestionID, context);
                        DeleteOptionsByQuestionID(item.QuestionID, context);
                        DeleteQuestionByQuestionID(item.QuestionID, context);
                    }

                    // 修改及新增問題
                    foreach (QuestionClass item in modifiedQuestions)
                    {
                        if(item.QuestionTitle == null || item.QuestionTitle == "")
                            throw new Exception($"Question [{item.QuestionID}] title is null or empty.");
                        if(item.QuestionType < 0 || item.QuestionType > 2)
                            throw new Exception($"Question [{item.QuestionID}] type is not valid.");
                        if(item.QuestionRequired < 0 || item.QuestionRequired > 1)
                            throw new Exception($"Question [{item.QuestionID}] require is not valid.");


                        // 修改問題
                        if (item.QuestionID != "NewItem")
                        {
                            Question targetQ = originalQuestions.Where(obj => obj.QuestionID == Guid.Parse(item.QuestionID)).FirstOrDefault();
                            if (targetQ == null)
                                throw new Exception("No Question Found.");

                            // 原本是文字方塊
                            if (targetQ.Type == 0)  
                            {
                                // 改成單選或多選
                                if (item.QuestionType != 0)
                                {
                                    if(item.Options == null)
                                        throw new Exception("Change Type but there's no option.");
                                    if(item.Options.Length == 0)
                                        throw new Exception("Change Type but there's no option.");

                                    Option[] newOptions = item.Options.Select(obj =>
                                    {
                                        if (obj.OptionContent == "")
                                            throw new Exception("Change Type but there's no option.");
                                        return new Option
                                        {
                                            QuestionID = targetQ.QuestionID,
                                            OptionID = Guid.NewGuid(),
                                            OptionContent = obj.OptionContent,
                                            Number = obj.OptionNumber
                                        };
                                    }).ToArray();

                                    context.Options.AddRange(newOptions);

                                    // 刪除原本文字方塊的所有答案
                                    DeleteAnswersByQuestionID(targetQ.QuestionID, context);
                                }
                            }
                            // 原本是單選或多選
                            else    
                            {
                                // 改成文字方塊
                                if (item.QuestionType == 0)
                                {
                                    DeleteAnswersByQuestionID(targetQ.QuestionID, context);
                                    DeleteOptionsByQuestionID(targetQ.QuestionID, context);
                                }
                                // 單選或多選
                                else
                                {
                                    List<Option> originalOptions = context.Options.Where(obj => obj.QuestionID == targetQ.QuestionID)
                                        .OrderBy(obj => obj.Number).ToList();

                                    if (item.Options == null)
                                        throw new Exception("There's no option.");
                                    if(item.Options.Length < originalOptions.Count)
                                        throw new Exception("Options' quantity is not correct.");

                                    int deleteCount = 0;
                                    int originalSize = originalOptions.Count;
                                    bool hasNewOption = false;
                                    if (item.Options.Length > originalSize)
                                        hasNewOption = true;

                                    // 原本的選項部分
                                    for (int i = 0; i < originalSize; i++)
                                    {
                                        // option內容為空，刪除該選項
                                        if(item.Options[i].OptionContent == "")
                                        {
                                            Option temp = originalOptions.Where(obj => obj.Number == (i + 1)).FirstOrDefault();
                                            DeleteAnswersByOptionID(temp.OptionID, context);
                                            originalOptions.Remove(temp);

                                            Option delItem = context.Options.Where(obj => obj.OptionID == temp.OptionID).FirstOrDefault();
                                            context.Options.Remove(delItem);

                                            deleteCount++;
                                        }
                                        // option內容不為空，更改option內容
                                        else
                                        {
                                            Option temp = originalOptions.Where(obj => obj.Number == (i + 1)).FirstOrDefault();
                                            temp.OptionContent = item.Options[i].OptionContent;

                                            context.Options.Where(obj => obj.OptionID == temp.OptionID)
                                                .FirstOrDefault().OptionContent = item.Options[i].OptionContent;
                                        }
                                    }

                                    // 新增的選項部分
                                    if (hasNewOption)
                                    {
                                        for (int i = originalSize; i < item.Options.Length; i++)
                                        {
                                            Option newOpt = new Option()
                                            {
                                                QuestionID = targetQ.QuestionID,
                                                OptionID = Guid.NewGuid(),
                                                OptionContent = item.Options[i].OptionContent,
                                                Number = i - deleteCount + 1
                                            };
                                            context.Options.Add(newOpt);
                                        }
                                    }


                                    // 重編選項順序(不包含新增的)
                                    for (int i = 0; i < originalOptions.Count; i++)
                                    {
                                        Guid tempGuid = originalOptions[i].OptionID;
                                        var temp = context.Options.Where(obj => obj.OptionID == tempGuid)
                                            .FirstOrDefault();
                                        temp.Number = i + 1;
                                        originalOptions[i].Number = i + 1;
                                        
                                    }
                                }
                            }
                            targetQ.Title = item.QuestionTitle;
                            targetQ.Type = item.QuestionType;
                            targetQ.Required = item.QuestionRequired;
                            targetQ.Number = item.QuestionNumber;
                            targetQ.FAQName = item.FAQName;
                        }
                        // 新增問題
                        else
                        {
                            Guid newID = Guid.NewGuid();
                            context.Questions.Add(new Question
                            {
                                QuestionnaireID = questionnaire.QuestionnaireID,
                                QuestionID = newID,
                                Title = item.QuestionTitle,
                                Type = item.QuestionType,
                                Required = item.QuestionRequired,
                                Number = item.QuestionNumber,
                                FAQName = item.FAQName
                            });

                            // 新增選項
                            if (item.QuestionType != 0)
                            {
                                foreach (OptionClass opt in item.Options)
                                {
                                    context.Options.Add(new Option
                                    {
                                        OptionID = Guid.NewGuid(),
                                        QuestionID = newID,
                                        OptionContent = opt.OptionContent,
                                        Number = opt.OptionNumber
                                    });
                                }
                            }
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

        private static void DeleteAnswersByQuestionID(Guid questionID, ContextModel context)
        {
            var delAnswers = context.Answers.Where(obj => obj.QuestionID == questionID);
            context.Answers.RemoveRange(delAnswers);
        }

        private static void DeleteAnswersByOptionID(Guid optionID, ContextModel context)
        {
            var delAnswers = context.Answers.Where(obj => obj.OptionID == optionID);
            context.Answers.RemoveRange(delAnswers);
        }

        /// <summary>
        /// 刪除特定問題的所有Options，必須先刪除跟這個問題有關的所有Answer才能執行
        /// </summary>
        /// <param name="questionID"></param>
        /// <param name="context"></param>
        private static void DeleteOptionsByQuestionID(Guid questionID, ContextModel context)
        {
            var delOptions = context.Options.Where(obj => obj.QuestionID == questionID);
            if (delOptions == null)
                throw new Exception("No Options Found.");

            context.Options.RemoveRange(delOptions);
        }

        /// <summary>
        /// 刪除特定問題，必須先刪除跟這個問題有關的所有Option和Answer才能執行
        /// </summary>
        /// <param name="questionID"></param>
        /// <param name="context"></param>
        private static void DeleteQuestionByQuestionID(Guid questionID, ContextModel context)
        {
            var delQuestion = context.Questions.Where(obj => obj.QuestionID == questionID).FirstOrDefault();
            
            context.Questions.Remove(delQuestion);
        }

        public static bool DeleteQuestionnaireByID(Guid questionnaireGuid)
        {
            try
            {
                using (ContextModel context = new ContextModel())
                {
                    Questionnaire targetQuestionnaire = context.Questionnaires.Where(obj => obj.QuestionnaireID == questionnaireGuid)
                        .FirstOrDefault();
                    if (targetQuestionnaire == null)
                        throw new Exception("Questionnaire not found.");

                    List<Question> questions = GetQuestionsByQuestionnaireID(targetQuestionnaire.QuestionnaireID).ToList();
                    foreach (Question item in questions)
                    {
                        DeleteAnswersByQuestionID(item.QuestionID, context);
                        DeleteOptionsByQuestionID(item.QuestionID, context);
                        DeleteQuestionByQuestionID(item.QuestionID, context);
                    }

                    context.Questionnaires.Remove(targetQuestionnaire);
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

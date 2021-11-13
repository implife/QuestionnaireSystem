using QuestionnaireSystem.Auth;
using QuestionnaireSystem.DBSource;
using QuestionnaireSystem.ORM.DBModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Web;
using System.Net;
using CsvHelper.Configuration;
using System.IO;
using CsvHelper;
using System.Globalization;
using System.Web.SessionState;

namespace QuestionnaireSystem.Handler
{
    /// <summary>
    /// Summary description for DetailHandler
    /// </summary>
    public class DetailHandler : IHttpHandler, IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            string action = context.Request.QueryString["Action"];

            // 填寫答案分頁的觀看細節
            if (string.Compare(action, "AnswerDetail") == 0)
            {
                // check voter ID
                string strVoterID = context.Request.Form["VoterID"];
                string errMsg;
                Voter currentVoter = AuthManager.AuthVoterGuid(strVoterID, out errMsg);
                if (currentVoter == null)
                {
                    context.Response.StatusCode = 400;
                    context.Response.Write(errMsg);
                    context.Response.End();
                }

                // check questionnaire ID
                string strQuestionnaireID = context.Request.Form["QuestionnaireID"];
                Questionnaire currentQuestionnaire = AuthManager.AuthQuestionnaireGuid(strQuestionnaireID, out errMsg);
                if (currentQuestionnaire == null)
                {
                    context.Response.StatusCode = 400;
                    context.Response.Write(errMsg);
                    context.Response.End();
                }

                // check questions
                List<Question> currentQuestions = QuestionManager.GetQuestionsByQuestionnaireID(currentQuestionnaire.QuestionnaireID);
                if (currentQuestions == null || currentQuestions.Count == 0)
                {
                    context.Response.StatusCode = 400;
                    context.Response.Write("Error. No Question in this Questionnaire.");
                    context.Response.End();
                }

                // check Answers
                List<Answer> currentAnswers = QuestionManager.GetAnswerByVoterAndQuestion(currentVoter);
                if (currentAnswers == null || currentAnswers.Count == 0)
                {
                    context.Response.StatusCode = 400;
                    context.Response.Write("Error. No Answer.");
                    context.Response.End();
                }

                string result =
                    $"<div class='mb-3 row'>" +
                    $"<label for='answerName' class='col-auto col-form-label'>姓名：</label>" +
                    $"<div class='col-sm-4'>" +
                    $"<input type='text' readonly class='form-control-plaintext' id='answerName' value='{currentVoter.Name}'>" +
                    $"</div>" +
                    $"<label for='answerPhone' class='col-auto col-form-label' style='margin-left: calc(var(--bs-gutter-x) * .25);'>手機：</label>" +
                    $"<div class='col-auto'>" +
                    $"<input type='text' readonly class='form-control-plaintext' id='answerPhone' value='{currentVoter.Phone}'>" +
                    $"</div></div>" +
                    $"<div class='mb-3 row'>" +
                    $"<label for='answerEmail' class='col-auto col-form-label'>Email：</label>" +
                    $"<div class='col-sm-4'>" +
                    $"<input type='text' readonly class='form-control-plaintext' id='answerEmail' value='{currentVoter.Email}'>" +
                    $"</div>" +
                    $"<label for='answerAge' class='col-auto col-form-label'>年齡：</label>" +
                    $"<div class='col-auto'>" +
                    $"<input type='text' readonly class='form-control-plaintext' id='answerAge' value='{currentVoter.Age}'>" +
                    $"</div></div>" +
                    $"<div class='mb-3 row'>" +
                    $"<div class='offset-6 col-auto'>填寫時間：{currentAnswers[0].Timestamp.ToString("yyyy-MM-dd HH:mm:ss")}</div>" +
                    $"</div>";

                foreach (Question item in currentQuestions)
                {
                    var ans = currentAnswers.Where(obj => obj.QuestionID == item.QuestionID);
                    if (item.Type == 0)  // 文字方塊
                    {
                        result +=
                            $"<div class='mt-4 QContainer text_input'>" +
                            $"<h5>{item.Number}. {item.Title}{(item.Required == 0 ? "<span class='required_mark'>*</span>" : "")}</h5>" +
                            $"<div class='option_div'>" +
                            $"<input type='text' readonly class='form-control-plaintext' value='{(ans == null ? "" : ans.FirstOrDefault().TextboxContent)}'>" +
                            $"</div></div>";
                    }
                    else if (item.Type == 1)  // 單選(Radiobutton)
                    {
                        result +=
                            $"<div class='mt-4 QContainer single required'>" +
                            $"<h5>{item.Number}. {item.Title}{(item.Required == 0 ? "<span class='required_mark'>*</span>" : "")}</h5>" +
                            $"<div class='option_div'>";

                        List<Option> optionList = QuestionManager.GetOptionsByQuestionID(item.QuestionID);
                        if (optionList == null || optionList.Count == 0)
                        {
                            result += "<span style='color:#dc3545'>錯誤，無選項</span></div></div>";
                        }
                        else
                        {
                            foreach (Option opt in optionList)
                            {
                                string isChecked = "";
                                if (ans.FirstOrDefault() != null)
                                {
                                    isChecked = ans.FirstOrDefault().OptionID == opt.OptionID ? " checked" : "";
                                }

                                result +=
                                    $"<div class='form-check'>" +
                                    $"<input class='form-check-input' disabled{isChecked} type='radio' id='ID{opt.OptionID}'>" +
                                    $"<label class='form-check-label' for='ID{opt.OptionID}'>{opt.OptionContent}</label></div>";
                            }
                            result += $"</div></div>";
                        }
                    }
                    else if (item.Type == 2) // 複選(checkbox)
                    {
                        result += $"<div class='mt-4 QContainer multi'>" +
                            $"<h5>{item.Number}. {item.Title}(複選){(item.Required == 0 ? "<span class='required_mark'>*</span>" : "")}</h5>" +
                            $"<div class='option_div'>";

                        List<Option> optionList = QuestionManager.GetOptionsByQuestionID(item.QuestionID);
                        if (optionList == null || optionList.Count == 0)
                        {
                            result += "<span style='color:#dc3545'>錯誤，無選項</span></div></div>";
                        }
                        else
                        {
                            foreach (Option opt in optionList)
                            {
                                string isChecked = "";

                                if (ans.FirstOrDefault() != null)
                                {
                                    isChecked = ans.Where(obj => obj.OptionID == opt.OptionID).FirstOrDefault() == null ? "" : " checked";
                                }

                                result +=
                                    $"<div class='form-check'>" +
                                    $"<input class='form-check-input'{isChecked} disabled type='checkbox' value='' id='ID{opt.OptionID}'>" +
                                    $"<label class='form-check-label'for='ID{opt.OptionID}'>{opt.OptionContent}</label></div>";
                            }
                            result += $"</div></div>";
                        }
                    }
                    else
                    {
                        result += "<span style='color:#dc3545'>錯誤，Question Type Error.</span>";
                    }

                }

                result +=
                    "<div class='mt-5'><button type='button' class='btn btn-secondary' onclick='AnswerDetailReturn()'>返回</button></div>";

                context.Response.ContentType = "text/html";
                context.Response.Write(result);
            }
            // 匯出csv檔
            else if (string.Compare(action, "AnswerDownload") == 0)
            {

                string strQID = context.Request.QueryString["QID"];

                // check questionnaireID
                string errMsg;
                Questionnaire currentQuestionnaire = AuthManager.AuthQuestionnaireGuid(strQID, out errMsg);
                if (currentQuestionnaire == null)
                {
                    string a = $"<br><a href='/Default.aspx'>返回</a>";
                    context.Response.StatusCode = 400;
                    context.Response.Write(errMsg + a);
                    context.Response.End();
                }

                List<Voter> voters = QuestionManager.GetAllVotersByQuestionnaire(currentQuestionnaire);
                List<VoterCsv> records = new List<VoterCsv>();

                // 建立records
                foreach (Voter vo in voters)
                {
                    DateTime? answerTime = QuestionManager.GetTimeStampByVoter(vo);

                    List<Question> questions = QuestionManager.GetQuestionsByQuestionnaireID(currentQuestionnaire.QuestionnaireID);
                    foreach (Question ques in questions)
                    {
                        List<Answer> ans = QuestionManager.GetAnswerByVoterAndQuestion(vo, ques);
                        string strAns = "";
                        if (ans.Count != 0)
                        {
                            if (ques.Type == 0)
                                strAns = ans[0].TextboxContent;
                            else if (ques.Type == 1)
                                strAns = QuestionManager.GetOptionByOptionID((Guid)ans[0].OptionID).OptionContent;
                            else
                            {
                                string[] temp = ans.Select(obj =>
                                {
                                    return QuestionManager.GetOptionByOptionID((Guid)obj.OptionID).OptionContent;
                                }).ToArray();
                                strAns = String.Join(" ; ", temp);
                            }

                        }
                        records.Add(new VoterCsv
                        {
                            Name = vo.Name,
                            Phone = vo.Phone,
                            Email = vo.Email,
                            Age = vo.Age,
                            Question = new QuestionCsv
                            {
                                QuestionTitle = ques.Title,
                                QuestionType = ques.Type == 0
                                    ? "文字方塊"
                                    : ques.Type == 1 ? "單選" : "複選",
                                QuestionRequired = ques.Required == 0 ? "必填" : "非必填",
                                QuestionNumber = ques.Number,
                                TimeStamp = answerTime,
                                Answer = new AnswerCsv
                                {
                                    Answer = strAns
                                }
                            }
                        });
                    }
                }

                records = records.OrderByDescending(obj => obj.Question.TimeStamp).ToList();

                // 利用StringWriter寫成csv字串
                StringWriter sWriter = new StringWriter();
                using (CsvWriter csv = new CsvWriter(sWriter, CultureInfo.InvariantCulture))
                {
                    csv.Context.RegisterClassMap<VoterCsvMap>();
                    csv.WriteRecords<VoterCsv>(records);
                }

                context.Response.ContentType = "application/octet-stream";
                context.Response.AddHeader("Content-Disposition", $"attachment; filename={currentQuestionnaire.Title}_回答.csv");
                context.Response.Write(sWriter.ToString());
                context.Response.End();
            }
            // 問卷編輯
            else if (string.Compare(action, "QuestionnaireModify") == 0)
            {
                // check questionnaireID
                string errMsg;
                string strQuestionnaireID = context.Request.QueryString["QID"];
                Questionnaire currentQuestionnaire = AuthManager.AuthQuestionnaireGuid(strQuestionnaireID, out errMsg);
                if (currentQuestionnaire == null)
                {
                    context.Response.StatusCode = 400;
                    context.Response.Write(errMsg);
                    context.Response.End();
                }

                context.Session["QuestionnaireM" + strQuestionnaireID] = new QuestionnaireClass
                {
                    QuestionnaireTitle = context.Request.Form["QuestionnaireTitle"],
                    Description = context.Request.Form["Description"],
                    StartDate = context.Request.Form["StartDate"],
                    EndDate = context.Request.Form["EndDate"],
                    Active = Convert.ToInt32(context.Request.Form["Active"])
                };

                context.Response.ContentType = "text/plain";
                context.Response.Write("Success.");
            }
            // 問題編輯
            else if (string.Compare(action, "QuestionModify") == 0)
            {
                // check questionnaireID
                string errMsg;
                string strQuestionnaireID = context.Request.QueryString["QID"];
                Questionnaire currentQuestionnaire = AuthManager.AuthQuestionnaireGuid(strQuestionnaireID, out errMsg);
                if (currentQuestionnaire == null)
                {
                    context.Response.StatusCode = 400;
                    context.Response.Write(errMsg);
                    context.Response.End();
                }

                QuestionClass[] modifyQuestions = Newtonsoft.Json.JsonConvert.DeserializeObject<QuestionClass[]>(context.Request.Form["questionJSON"]);

                if (modifyQuestions == null)
                {
                    context.Response.StatusCode = 400;
                    context.Response.Write("Json Error.");
                    context.Response.End();
                }

                context.Session["QuestionM" + strQuestionnaireID] = modifyQuestions;

                context.Response.ContentType = "text/plain";
                context.Response.Write("Success.");
            }
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }

        class VoterCsvMap : ClassMap<VoterCsv>
        {
            public VoterCsvMap()
            {
                Map(m => m.Name).Index(0).Name("姓名");
                Map(m => m.Phone).Index(1).Name("電話");
                Map(m => m.Email).Index(2).Name("Emai");
                Map(m => m.Age).Index(3).Name("年齡");
                Map(m => m.Question.QuestionNumber).Index(4).Name("題號");
                Map(m => m.Question.QuestionTitle).Index(5).Name("問題");
                Map(m => m.Question.QuestionType).Index(6).Name("問題類型");
                Map(m => m.Question.QuestionRequired).Index(7).Name("必填");
                Map(m => m.Question.Answer.Answer).Index(8).Name("答案");
                Map(m => m.Question.TimeStamp).Index(9).Name("填寫時間");
            }
        }

        class VoterCsv
        {
            public string Name { get; set; }
            public string Phone { get; set; }
            public string Email { get; set; }
            public int Age { get; set; }
            public QuestionCsv Question { get; set; }
        }
        class QuestionCsv
        {
            public string QuestionTitle { get; set; }
            public string QuestionType { get; set; }
            public string QuestionRequired { get; set; }
            public int QuestionNumber { get; set; }
            public DateTime? TimeStamp { get; set; }
            public AnswerCsv Answer { get; set; }
        }

        class AnswerCsv
        {
            public string Answer { get; set; }
        }
    }
}
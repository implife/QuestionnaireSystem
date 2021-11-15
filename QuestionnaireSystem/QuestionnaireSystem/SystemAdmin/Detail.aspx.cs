using QuestionnaireSystem.Auth;
using QuestionnaireSystem.DBSource;
using QuestionnaireSystem.ORM.DBModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace QuestionnaireSystem.SystemAdmin
{
    public partial class Detail : System.Web.UI.Page
    {
        public string UserName { get; set; } = "";
        public string questionnaireTabStatus { get; set; } = "active";
        public string questionTabStatus { get; set; } = "";
        public string answerTabStatus { get; set; } = "";
        public string statisticTabStatus { get; set; } = "";
        public string questionnaireTabContentStatus { get; set; } = "show active";
        public string questionTabContentStatus { get; set; } = "";
        public string answerTabContentStatus { get; set; } = "";
        public string statisticTabContentStatus { get; set; } = "";
        public string activeCheck { get; set; } = "checked";
        public string FAQJSONString { get; set; } = "";
        public string QuestionnaireID { get; set; } = "";
        public string questionnaireTabModifiedSvg { get; set; } = "";
        public string questionTabModifiedSvg { get; set; } = "";
        public string optionExplanationStyle { get; set; } = "style='display:none;'";

        protected void Page_Load(object sender, EventArgs e)
        {
            // 處理登入使用者
            string strId = (HttpContext.Current.User.Identity as FormsIdentity).Ticket.UserData;
            string errMsg;
            UserInfo currentUser = AuthManager.AuthUserInfo(strId, out errMsg);
            if (currentUser != null)
                this.UserName = currentUser.Name;

            this.btnQuestionnaireModify.Attributes.Add("data-bs-dismiss", "modal");


            // 處理QueryString
            Guid? queryGuid;
            if (this.Request.QueryString["QID"] == null || this.Request.QueryString["QID"] == "") // 新增模式
            {
                this.linkQuestionnaireCancel.Visible = false;
                this.btnQuestionnaireValidate.Visible = false;
                this.linkQuestionCancel.Visible = false;
                this.btnQuestionValidate.Visible = false;
                this.btnNewQuestionnaire.Visible = true;
                this.answerTabStatus = "disabled";
                this.statisticTabStatus = "disabled";

                this.ltlDescription.Text = "<textarea class='form-control' id='description' rows='5'></textarea>";
                this.ltlStartDate.Text =
                    $"<input type='date' class='form-control myValidation' id='startDate' value='{DateTime.Now.ToString("yyyy-MM-dd")}'/>";
                this.ltlEndDate.Text = "<input type='date' class='form-control myValidation' id='endDate' />";
            }
            else
            {
                try
                {
                    queryGuid = Guid.Parse(this.Request.QueryString["QID"]);
                }
                catch (Exception)
                {
                    queryGuid = null;
                }
                if (queryGuid == null)
                {
                    ForbiddenElement();
                    this.ltlErrMsg.Text = "<span id='errMag'>問卷ID錯誤</span>";
                    return;
                }

                Questionnaire currentQuestionnaire;
                // 從資料庫找出該問卷
                currentQuestionnaire = QuestionManager.GetQuestionnaireByID((Guid)queryGuid);
                if (currentQuestionnaire == null)
                {
                    ForbiddenElement();
                    this.ltlErrMsg.Text = "<span id='errMsg'>無此問卷</span>";
                    return;
                }

                //從資料庫找出問題
                List<Question> currentQuestions = QuestionManager.GetQuestionsByQuestionnaireID(currentQuestionnaire.QuestionnaireID);
                if(currentQuestions == null || currentQuestions.Count == 0)
                {
                    ForbiddenElement();
                    this.ltlErrMsg.Text = "<span id='errMsg'>錯誤，無問題</span>";
                    return;
                }

                /* ------------- 修改模式 ------------- */

                this.linkQuestionnaireCancel.Visible = true;
                this.btnQuestionnaireValidate.Visible = true;
                this.btnQuestionnaireValidate.Enabled = false;
                this.linkQuestionCancel.Visible = true;
                this.btnQuestionValidate.Visible = true;
                this.btnQuestionValidate.Enabled = false;
                this.btnNewQuestionnaire.Visible = false;
                this.optionExplanationStyle = "style='display:inline-block;'";
                if (this.Request.QueryString["Page"] != null)
                {
                    this.questionnaireTabStatus = "";
                    this.answerTabStatus = "active";
                    this.questionnaireTabContentStatus = "";
                    this.answerTabContentStatus = "show active";
                }

                // 問卷分頁
                if (this.Session["QuestionnaireM" + currentQuestionnaire.QuestionnaireID] != null)
                {
                    this.questionnaireTabModifiedSvg = "<img src='../img/modified.svg'>";
                    this.btnQuestionnaireValidate.Enabled = true;

                    QuestionnaireClass sessionQuestionnaire = (QuestionnaireClass)this.Session["QuestionnaireM" + currentQuestionnaire.QuestionnaireID];

                    this.questionnaireName.Text = sessionQuestionnaire.QuestionnaireTitle;
                    this.ltlDescription.Text =
                        $"<textarea class='form-control' id='description' rows='5'>{sessionQuestionnaire.Description}</textarea>";
                    this.ltlStartDate.Text =
                        $"<input type='date' class='form-control myValidation' id='startDate' value='{sessionQuestionnaire.StartDate}'/>";
                    this.ltlEndDate.Text = $"<input type='date' class='form-control myValidation' id='endDate' value='{sessionQuestionnaire.EndDate}' />";
                    this.activeCheck = sessionQuestionnaire.Active == 0 ? "checked" : "";
                }
                else
                {
                    this.questionnaireName.Text = currentQuestionnaire.Title;
                    this.ltlDescription.Text =
                        $"<textarea class='form-control' id='description' rows='5'>{currentQuestionnaire.Discription}</textarea>";
                    this.ltlStartDate.Text =
                        $"<input type='date' class='form-control myValidation' id='startDate' value='{currentQuestionnaire.StartDate.ToString("yyyy-MM-dd")}'/>";
                    string endDateStr = currentQuestionnaire.EndDate == null
                        ? ""
                        : ((DateTime)currentQuestionnaire.EndDate).ToString("yyyy-MM-dd");
                    this.ltlEndDate.Text = $"<input type='date' class='form-control myValidation' id='endDate' value='{endDateStr}' />";
                    this.activeCheck = currentQuestionnaire.Status == 3 ? "" : "checked";
                }

                // 問題分頁
                QuestionClass[] faq = QuestionManager.GetFAQList();
                this.ltlQuestionTbody.Text = "";

                if (this.Session["QuestionM" + currentQuestionnaire.QuestionnaireID] != null)
                {
                    this.questionTabModifiedSvg = "<img src='../img/modified.svg'>";
                    this.btnQuestionValidate.Enabled = true;

                    QuestionClass[] sessionQuestions = (QuestionClass[])this.Session["QuestionM" + currentQuestionnaire.QuestionnaireID];
                    foreach (QuestionClass item in sessionQuestions)
                    {
                        string type = item.QuestionType == 0
                            ? "文字方塊"
                            : item.QuestionType == 1 ? "單選" : "複選";
                        string faqIndex = "-1";
                        if (item.FAQName != null && item.FAQName != "")
                        {
                            for (int i = 0; i < faq.Length; i++)
                            {
                                if (faq[i].FAQName == item.FAQName)
                                {
                                    faqIndex = $"{i}";
                                    break;
                                }
                            }
                        }
                        string optionStr = "";
                        if (item.QuestionType != 0)
                        {
                            OptionClass[] opts = item.Options;
                            for (int i = 0; i < opts.Length; i++)
                            {
                                optionStr += opts[i].OptionContent;
                                if (i != opts.Length - 1)
                                    optionStr += " ; ";
                            }
                        }
                        string fromDatabase = item.QuestionID == "NewItem" ? "" : "fromDatabase";

                        // 若不是新增的，原本是文字方塊td為空，單複選要把資料庫原本的選項寫入
                        string originalTd = "";
                        if (item.QuestionID != "NewItem")
                        {
                            int originalType = QuestionManager.GetQuestionByQuestionID(Guid.Parse(item.QuestionID)).Type;
                            if (originalType == 0)
                            {
                                originalTd = $"<td class='questionOriginalOptionHidden'></td>";
                            }
                            else
                            {
                                string OriginalOptionStr = "";
                                List<Option> opts = QuestionManager.GetOptionsByQuestionID(Guid.Parse(item.QuestionID));
                                if (opts == null || opts.Count == 0)
                                {
                                    originalTd = $"<td class='questionOriginalOptionHidden'>error</td>";
                                }
                                else
                                {
                                    for (int i = 0; i < opts.Count; i++)
                                    {
                                        OriginalOptionStr += opts[i].OptionContent;
                                        if (i != opts.Count - 1)
                                            OriginalOptionStr += " ; ";
                                    }
                                    originalTd = $"<td class='questionOriginalOptionHidden'>{OriginalOptionStr}</td>";
                                }
                            }
                        }

                        this.ltlQuestionTbody.Text +=
                            $"<tr class='{fromDatabase}' data-ID='{item.QuestionID}'>" +
                            $"<th scope='row'> <input class='form-check-input' type='checkbox' value='' onchange='deleteCheckboxCheck()'> </th>" +
                            $"<td>{item.QuestionNumber}</td>" +
                            $"<td style='width:48%;'>{item.QuestionTitle}</td>" +
                            $"<td>{type}</td>" +
                            $"<td>{(item.QuestionRequired == 0 ? "<img src='../img/check-lg.svg'>" : "")}</td>" +
                            $"<td><a href='javascript:void(0)' onclick='QListModify(this)'>編輯</a></td>" +
                            $"<td class='questionModeHidden'>{faqIndex}</td>" +
                            $"<td class='questionOptionHidden'>{optionStr}</td>" +
                            originalTd +
                            $"</tr>";
                    }
                }
                else
                {
                    foreach (Question item in currentQuestions)
                    {
                        string type = item.Type == 0
                            ? "文字方塊"
                            : item.Type == 1 ? "單選" : "複選";
                        string faqIndex = "-1";
                        if (item.FAQName != null)
                        {
                            for (int i = 0; i < faq.Length; i++)
                            {
                                if (faq[i].FAQName == item.FAQName)
                                {
                                    faqIndex = $"{i}";
                                    break;
                                }
                            }
                        }
                        string optionStr = "";
                        if (item.Type != 0)
                        {
                            List<Option> opts = QuestionManager.GetOptionsByQuestionID(item.QuestionID);
                            for (int i = 0; i < opts.Count; i++)
                            {
                                optionStr += opts[i].OptionContent;
                                if (i != opts.Count - 1)
                                    optionStr += " ; ";
                            }
                        }

                        this.ltlQuestionTbody.Text +=
                            $"<tr class='fromDatabase' data-ID='{item.QuestionID}'>" +
                            $"<th scope='row'> <input class='form-check-input' type='checkbox' value='' onchange='deleteCheckboxCheck()'> </th>" +
                            $"<td>{item.Number}</td>" +
                            $"<td style='width:48%;'>{item.Title}</td>" +
                            $"<td>{type}</td>" +
                            $"<td>{(item.Required == 0 ? "<img src='../img/check-lg.svg'>" : "")}</td>" +
                            $"<td><a href='javascript:void(0)' onclick='QListModify(this)'>編輯</a></td>" +
                            $"<td class='questionModeHidden'>{faqIndex}</td>" +
                            $"<td class='questionOptionHidden'>{optionStr}</td>" +
                            $"<td class='questionOriginalOptionHidden'>{optionStr}</td>" +
                            $"</tr>";
                    }
                }
                

                // 答案分頁
                this.QuestionnaireID = currentQuestionnaire.QuestionnaireID.ToString();

                List<Voter> voters = QuestionManager.GetAllVotersByQuestionnaire(currentQuestionnaire);

                this.ucPager.Url = "Detail.aspx?QID=" + currentQuestionnaire.QuestionnaireID;
                this.ucPager.TotalItemSize = voters.Count;
                int currentPage = this.ucPager.GetCurrentPage();
                int sizeInPage = this.ucPager.ItemSizeInPage;
                int startIndex = sizeInPage * (currentPage - 1);
                this.ucPager.Bind();

                var votersAndTime = voters.Select(obj =>
                {
                    Answer first = QuestionManager.GetAnswerByVoterAndQuestion(obj).FirstOrDefault();
                    return new
                    {
                        Voter = obj,
                        TimeStamp = first.Timestamp
                    };
                }).OrderByDescending(obj => obj.TimeStamp).Skip(startIndex).Take(sizeInPage);

                this.ltlAnswerTbody.Text = "";
                int count = voters.Count() - sizeInPage * (currentPage - 1);
                if (voters.Count() == 0)
                {
                    this.ltlAnswerTbody.Text += "<tr><td colspan='4' style='text-align:center'><span style='color:#dc3545'>無資料</span></td></tr>";
                }
                else
                {
                    foreach (var item in votersAndTime)
                    {
                        this.ltlAnswerTbody.Text +=
                            $"<tr data-voterid='{item.Voter.VoterID}' data-questionnaireid='{currentQuestionnaire.QuestionnaireID}'>" +
                            $"<th scope='row'>{count--}</th>" +
                            $"<td>{item.Voter.Name}</td>" +
                            $"<td>{item.TimeStamp.ToString("yyyy-MM-dd HH:mm:ss")}</td>" +
                            $"<td><a href='javascript:void(0)' onclick='AnswerDetail(this)'>前往</a></td>" +
                            $"</tr>";
                    }
                }

                // 統計分頁
                int totalVotersCount = QuestionManager.GetTotalVoterQuantity(currentQuestionnaire.QuestionnaireID);
                foreach (Question item in currentQuestions)
                {
                    if (item.Type == 0)  // 文字方塊
                    {
                        this.ltlStatisticPane.Text +=
                            $"<div class='mt-4'>" +
                            $"<h5>{item.Number}. {item.Title}</h5>" +
                            $"<div class='option_div'>--</div>" +
                            $"</div>";
                    }
                    else
                    {
                        this.ltlStatisticPane.Text +=
                            $"<div class='mt-4'>" +
                            $"<h5>{item.Number}. {item.Title} {(item.Type == 2 ? "(複選)" : "")}</h5>" +
                            $"<div class='option_div'>";

                        List<Option> options = QuestionManager.GetOptionsByQuestionID(item.QuestionID);
                        List<int> countEveryOption = QuestionManager.GetVotersCountOfEveryOption(item.QuestionID);

                        int i = 0;
                        foreach (int countOpt in countEveryOption)
                        {
                            string strCount = ((double)countOpt * 100 / totalVotersCount).ToString("0.##");
                            strCount = (strCount == "" || strCount == "NaN") ? "0" : strCount;
                            this.ltlStatisticPane.Text +=
                                $"<div class='myOption'>" +
                                $"<div class='option_content'>{options[i].OptionContent}</div>" +
                                $"<div class='row'>" +
                                $"<div class='progress col-md-4'>" +
                                $"<div class='progress-bar progress-bar-striped' role='progressbar' " +
                                    $"style='width: {strCount}%'></div>" +
                                $"</div>" +
                                $"<div class='col-md-4 progress_text'>{strCount}% ({countOpt})</div>" +
                                $"</div>" +
                                $"</div>";
                            i++;
                        }

                        this.ltlStatisticPane.Text += $"</div></div>";
                    }
                }
            }

            // FAQ資料
            QuestionClass[] FAQData = QuestionManager.GetFAQList();
            if (FAQData == null)
                return;
            else
            {
                this.FAQJSONString = Newtonsoft.Json.JsonConvert.SerializeObject(FAQData);

                this.ltlFAQdropdown.Text = "";
                for (int i = 0; i < FAQData.Length; i++)
                {
                    this.ltlFAQdropdown.Text += $"<option value='{i}'>{FAQData[i].FAQName}</option>";
                }
            }
        }

        protected void btnNewQuestionnaire_Click(object sender, EventArgs e)
        {
            QuestionnaireClass newQuestionnaire = null;
            try
            {
                newQuestionnaire = Newtonsoft.Json.JsonConvert.DeserializeObject<QuestionnaireClass>(this.HFNewQuestionnaire.Value);
                
            }
            catch (Exception ex)
            {}
            bool isSuccess = QuestionManager.CreateNewQuestionnaire(newQuestionnaire);
            if (isSuccess)
            {
                this.Response.Redirect("QuestionnaireList.aspx");
            }
            else
            {
                this.ltlModalFailed.Text = "<script>\n$(function(){\n";
                this.ltlModalFailed.Text += "CreateFailedModal.show();\n";
                this.ltlModalFailed.Text += "})\n</script>\n";
            }
        }

        private void ForbiddenElement()
        {
            this.linkQuestionnaireCancel.Visible = false;
            this.btnQuestionnaireValidate.Visible = false;
            this.linkQuestionCancel.Visible = false;
            this.btnQuestionModify.Visible = false;
            this.btnNewQuestionnaire.Visible = false;
            this.questionnaireTabStatus = "disabled";
            this.questionTabStatus = "disabled";
            this.answerTabStatus = "disabled";
            this.statisticTabStatus = "disabled";
            this.questionnaireTabContentStatus = "";
            this.questionTabContentStatus = "";
            this.answerTabContentStatus = "";
            this.statisticTabContentStatus = "";
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            FormsAuthentication.SignOut();
            this.Response.Redirect("/Default.aspx");
        }
    }
}
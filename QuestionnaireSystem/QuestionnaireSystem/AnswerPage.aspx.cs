using QuestionnaireSystem.DBSource;
using QuestionnaireSystem.ORM.DBModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace QuestionnaireSystem
{
    public partial class AnswerPage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            this.input_phone.Attributes.Add("min", "10");
            this.input_phone.Attributes.Add("max", "10");
            this.input_age.Attributes.Add("min", "1");
            this.input_age.Attributes.Add("max", "3");

            Guid? queryGuid;
            Questionnaire currentQuestionnaire;

            // 處理QueryString
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
                Response.StatusCode = 400;
                Response.End();
                return;
            }

            // 從資料庫找出該問卷
            currentQuestionnaire = QuestionManager.GetQuestionnaireByID((Guid)queryGuid);
            if (currentQuestionnaire == null)
            {
                this.ltlQuestionnaireTitle.Text = "<span style='color:#dc3545'>無此問卷</span>";
                ForbiddenElement();
                return;
            }

            // 確認Status
            if (currentQuestionnaire.Status != 1)
            {
                this.ltlQuestionnaireTitle.Text = "<span style='color:#dc3545'>問卷不開放回答</span>";
                ForbiddenElement();
                return;
            }

            // Render 標題及狀態時間及說明
            this.ltlQuestionnaireTitle.Text = currentQuestionnaire.Title;
            this.ltlQuestionnaireStatusTime.Text = $"投票中<br>" +
                $"{currentQuestionnaire.StartDate.ToString("yyyy-MM-dd")} ~ " +
                $"{(currentQuestionnaire.EndDate == null ? "無期限" : ((DateTime)currentQuestionnaire.EndDate).ToString("yyyy-MM-dd"))}";
            this.ltlQuestionnaireDiscription.Text = currentQuestionnaire.Discription;

            // 從資料庫找出問題
            List<Question> questionList = QuestionManager.GetQuestionsByQuestionnaireID(currentQuestionnaire.QuestionnaireID);

            if (questionList == null || questionList.Count == 0)
            {
                this.ltlQuestionList.Text = "<div class='offset-md-2'><span style='color:#dc3545'>錯誤，無題目</span></div>";
                ForbiddenElement();
                return;
            }

            // Render題目及選項
            this.ltlQuestionList.Text = "";
            foreach (Question item in questionList)
            {
                if (item.Type == 0)  // 文字方塊
                {
                    this.ltlQuestionList.Text +=
                        $"<div class='offset-md-2 mt-4 QContainer text_input{(item.Required == 0 ? " required" : "")}' id='ID{item.QuestionID}'>" +
                        $"<h5>{item.Number}. {item.Title}{(item.Required == 0 ? "<span class='required_mark'>*</span><span class='required_msg'>此為必填欄位!</span>" : "")}</h5>" +
                        $"<div class='option_div'>" +
                        $"<input class='form-control' type='text' value='' size='50' id='ID{item.QuestionID}'>" +
                        $"</div></div>";
                }
                else if (item.Type == 1)  // 單選(Radiobutton)
                {
                    this.ltlQuestionList.Text +=
                        $"<div class='offset-md-2 mt-4 QContainer single{(item.Required == 0 ? " required" : "")}' id='ID{item.QuestionID}'>" +
                        $"<h5>{item.Number}. {item.Title}{(item.Required == 0 ? "<span class='required_mark'>*</span><span class='required_msg'>此為必填欄位!</span>" : "")}</h5>" +
                        $"<div class='option_div'>";

                    List<Option> optionList = QuestionManager.GetOptionsByQuestionID(item.QuestionID);
                    if (optionList == null || optionList.Count == 0)
                    {
                        this.ltlQuestionList.Text += "<span style='color:#dc3545'>錯誤，無選項</span></div></div>";
                        ForbiddenElement();
                    }
                    else
                    {
                        foreach (Option opt in optionList)
                        {
                            this.ltlQuestionList.Text +=
                                $"<div class='form-check'>" +
                                $"<input class='form-check-input' type='radio' name='name{item.QuestionID}' id='ID{opt.OptionID}'>" +
                                $"<label class='form-check-label' for='ID{opt.OptionID}'>{opt.OptionContent}</label>" +
                                $"</div>";
                        }
                        this.ltlQuestionList.Text += $"</div></div>";
                    }
                }
                else if (item.Type == 2) // 複選(checkbox)
                {
                    this.ltlQuestionList.Text +=
                        $"<div class='offset-md-2 mt-4 QContainer multi{(item.Required == 0 ? " required" : "")}' id='ID{item.QuestionID}'>" +
                        $"<h5>{item.Number}. {item.Title}{(item.Required == 0 ? "<span class='required_mark'>*</span><span class='required_msg'>此為必填欄位!</span>" : "")}</h5>" +
                        $"<div class='option_div'>";

                    List<Option> optionList = QuestionManager.GetOptionsByQuestionID(item.QuestionID);
                    if (optionList == null || optionList.Count == 0)
                    {
                        this.ltlQuestionList.Text += "<span style='color:#dc3545'>錯誤，無選項</span></div></div>";
                        ForbiddenElement();
                    }
                    else
                    {
                        foreach (Option opt in optionList)
                        {
                            this.ltlQuestionList.Text +=
                                $"<div class='form-check'>" +
                                $"<input class='form-check-input' type='checkbox' value='' id='ID{opt.OptionID}'>" +
                                $"<label class='form-check-label' for='ID{opt.OptionID}'>{opt.OptionContent}</label>" +
                                $"</div>";
                        }
                        this.ltlQuestionList.Text += $"</div></div>";
                    }
                }
                else
                {
                    this.ltlQuestionList.Text += "<span style='color:#dc3545'>錯誤，Question Type Error.</span>";
                    ForbiddenElement();
                }
            }

            this.ltlQuestionCount.Text = $"共 {questionList.Count} 個問題";


            // 是否為確認頁返回
            bool bName = String.IsNullOrEmpty(this.Session["sessionName"]?.ToString());
            bool bPhone = String.IsNullOrEmpty(this.Session["sessionPhone"]?.ToString());
            bool bEmail = String.IsNullOrEmpty(this.Session["sessionEmail"]?.ToString());
            bool bAge = String.IsNullOrEmpty(this.Session["sessionAge"]?.ToString());
            bool bAnswer = this.Session["sessionAnswer"] == null;

            if (bName || bPhone || bEmail || bAge || bAnswer)
            {
                this.Session["sessionName"] = null;
                this.Session["sessionPhone"] = null;
                this.Session["sessionEmail"] = null;
                this.Session["sessionAge"] = null;
                this.Session["sessionAnswer"] = null;

                return;
            }

            // 若Session裡的題目跟問卷對不上
            AnswerClass[] voterAnswer = Newtonsoft.Json.JsonConvert.DeserializeObject<AnswerClass[]>(this.Session["sessionAnswer"] as string);
            Question tempQ = QuestionManager.GetQuestionByQuestionID(Guid.Parse(voterAnswer[0].QuestionID));
            if(QuestionManager.GetQuestionnaireByQuestion(tempQ) == null)
            {
                this.Session["sessionName"] = null;
                this.Session["sessionPhone"] = null;
                this.Session["sessionEmail"] = null;
                this.Session["sessionAge"] = null;
                this.Session["sessionAnswer"] = null;

                return;
            }

            // 基本資料還原
            this.input_name.Text = this.Session["sessionName"] as string;
            this.input_phone.Text = this.Session["sessionPhone"] as string;
            this.input_Email.Text = this.Session["sessionEmail"] as string;
            this.input_age.Text = this.Session["sessionAge"] as string;

            // 答案還原(利用jQuery)
            this.ltlQuestionList.Text += "<script>$(function () {\n";
            foreach (AnswerClass item in voterAnswer)
            {
                if (item.Type == 0)
                {
                    this.ltlQuestionList.Text += $"$('input[type=text][id=ID{item.QuestionID}]').val('{item.Answer[0]}');\n";
                }
                else
                {
                    if (item.Answer[0] != "")
                    {
                        foreach (string strAns in item.Answer)
                        {
                            this.ltlQuestionList.Text += $"$('input[id=ID{strAns}]').prop('checked', true);\n";
                        }
                    }
                }
                
            }
            this.ltlQuestionList.Text += "})</script>";
        }

        private void ForbiddenElement()
        {
            this.input_name.Enabled = false;
            this.input_phone.Enabled = false;
            this.input_Email.Enabled = false;
            this.input_age.Enabled = false;
            this.btnConfirm.Enabled = false;
            this.btnConfirm.Visible = false;
        }

        protected void btnConfirm_Click(object sender, EventArgs e)
        {
            this.Session["sessionName"] = this.input_name.Text;
            this.Session["sessionPhone"] = this.input_phone.Text;
            this.Session["sessionEmail"] = this.input_Email.Text;
            this.Session["sessionAge"] = this.input_age.Text;
            
            this.Session["sessionAnswer"] = this.HFAnswer.Value;

            Response.Redirect("ConfirmPage.aspx?QID=" + this.Request.QueryString["QID"]);
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            this.Session["sessionName"] = null;
            this.Session["sessionPhone"] = null;
            this.Session["sessionEmail"] = null;
            this.Session["sessionAge"] = null;
            this.Session["sessionAnswer"] = null;

            this.Response.Redirect("Default.aspx");
        }
    }
}
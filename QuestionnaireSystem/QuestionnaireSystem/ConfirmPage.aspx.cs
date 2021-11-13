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
    public partial class ConfirmPage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // 處理Session
            bool bName = String.IsNullOrEmpty(this.Session["sessionName"]?.ToString());
            bool bPhone = String.IsNullOrEmpty(this.Session["sessionPhone"]?.ToString());
            bool bEmail = String.IsNullOrEmpty(this.Session["sessionEmail"]?.ToString());
            bool bAge = String.IsNullOrEmpty(this.Session["sessionAge"]?.ToString());
            bool bAnswer = this.Session["sessionAnswer"] == null;

            if (bName || bPhone || bEmail || bAge || bAnswer)
            {
                this.ltlQuestionnaireTitle.Text = "<span style='color:#dc3545'>錯誤</span>";
                ForbiddenElement();
                this.Session["sessionName"] = null;
                this.Session["sessionPhone"] = null;
                this.Session["sessionEmail"] = null;
                this.Session["sessionAge"] = null;
                this.Session["sessionAnswer"] = null;

                return;
            }


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
                this.ltlQuestionnaireTitle.Text = "<span style='color:#dc3545'>錯誤</span>";
                ForbiddenElement();
                return;
            }

            // 確認Status
            if (currentQuestionnaire.Status != 1)
            {
                this.ltlQuestionnaireTitle.Text = "<span style='color:#dc3545'>錯誤</span>";
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
                this.ltlQuestionList.Text = "<div class='offset-md-2'><span style='color:#dc3545'>錯誤</span></div>";
                ForbiddenElement();
                return;
            }

            // Render基本資料內容
            this.ltlName.Text = this.Session["sessionName"].ToString();
            this.ltlPhone.Text = this.Session["sessionPhone"].ToString();
            this.ltlEmail.Text = this.Session["sessionEmail"].ToString();
            this.ltlAge.Text = this.Session["sessionAge"].ToString();

            // Render題目答案
            this.ltlQuestionList.Text = "";
            AnswerClass[] voterAnswer = Newtonsoft.Json.JsonConvert.DeserializeObject<AnswerClass[]>(this.Session["sessionAnswer"] as string);

            foreach (AnswerClass item in voterAnswer)
            {
                Question tempQ = QuestionManager.GetQuestionByQuestionID(Guid.Parse(item.QuestionID));
                this.ltlQuestionList.Text +=
                    $"<div class='offset-md-2 mt-4 QContainer id='ID{item.QuestionID}'>" +
                    $"<h5>{tempQ.Number}. {tempQ.Title} {(tempQ.Type == 2 ? " (複選)" : "")}</h5>" +
                    $"<div class='option_div'>";

                if(item.Answer[0] == "")
                {
                    this.ltlQuestionList.Text += "--";
                }
                else
                {
                    if(item.Type == 0)
                    {
                        this.ltlQuestionList.Text += item.Answer[0];
                    }
                    else
                    {
                        int i = 0;
                        foreach (string strAns in item.Answer)
                        {
                            if (i != 0)
                                this.ltlQuestionList.Text += ", ";

                            this.ltlQuestionList.Text += QuestionManager.GetOptionByOptionID(Guid.Parse(strAns)).OptionContent;
                            i++;
                        }
                    }
                }
                this.ltlQuestionList.Text += $"</div></div>";
            }
        }

        private void ForbiddenElement()
        {
            this.btnConfirm.Enabled = false;
            this.btnConfirm.Visible = false;
            this.btnModify.Enabled = false;
            this.btnModify.Visible = false;
            this.btnReturn.Visible = true;
        }
        

        protected void btnModify_Click(object sender, EventArgs e)
        {
            this.Response.Redirect("AnswerPage.aspx?QID=" + this.Request.QueryString["QID"]);
        }

        protected void btnReturn_Click(object sender, EventArgs e)
        {
            this.Response.Redirect("Default.aspx");
        }

        protected void btnConfirm_Click(object sender, EventArgs e)
        {
            Voter voter = new Voter()
            {
                Name = this.Session["sessionName"] as string,
                Phone = this.Session["sessionPhone"] as string,
                Email = this.Session["sessionEmail"] as string,
                Age = Convert.ToInt32(this.Session["sessionAge"])
            };

            AnswerClass[] voterAnswer = Newtonsoft.Json.JsonConvert.DeserializeObject<AnswerClass[]>(this.Session["sessionAnswer"] as string);
            bool isSuccess = QuestionManager.AddRangeNewAnswer(voter, voterAnswer);

            if (isSuccess)  // 修改資料庫成功
            {
                this.Session["sessionName"] = null;
                this.Session["sessionPhone"] = null;
                this.Session["sessionEmail"] = null;
                this.Session["sessionAge"] = null;
                this.Session["sessionAnswer"] = null;

                this.Response.Redirect("Default.aspx");
            }
            else// 修改資料庫失敗
            {
                this.ltlFailedModal.Text = "<script>\n$(function(){\n";

                this.ltlFailedModal.Text +=
                    "var FailedModal = new bootstrap.Modal(document.getElementById('CreateAnswerFailedModal'), {keyboard: false});" +
                    "FailedModal.show();\n";

                this.ltlFailedModal.Text += "})\n</script>";
            }
        }
    }
}
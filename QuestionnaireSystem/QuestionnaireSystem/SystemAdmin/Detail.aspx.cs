using QuestionnaireSystem.DBSource;
using QuestionnaireSystem.ORM.DBModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace QuestionnaireSystem.SystemAdmin
{
    public partial class Detail : System.Web.UI.Page
    {
        public string questionnaireTabStatus { get; set; } = "active";
        public string questionTabStatus { get; set; } = "";
        public string answerTabStatus { get; set; } = "";
        public string statisticTabStatus { get; set; } = "";
        public string questionnaireTabContentStatus { get; set; } = "show active";
        public string questionTabContentStatus { get; set; } = "";
        public string answerTabContentStatus { get; set; } = "";
        public string statisticTabContentStatus { get; set; } = "";
        public string activeCheck { get; set; } = "checked";


        protected void Page_Load(object sender, EventArgs e)
        {
            this.btnQuestionnaireModify.Attributes.Add("data-bs-toggle", "modal");
            this.btnQuestionnaireModify.Attributes.Add("data-bs-target", "#QuestionnaireModifyCheckModal");
            this.btnQuestionModify.Attributes.Add("data-bs-toggle", "modal");
            this.btnQuestionModify.Attributes.Add("data-bs-target", "#QuestionnaireModifyCheckModal");



            // 處理QueryString
            Guid? queryGuid;
            if (this.Request.QueryString["QID"] == null || this.Request.QueryString["QID"] == "") // 新增模式
            {
                this.btnQuestionnaireCancel.Visible = false;
                this.btnQuestionnaireModify.Visible = false;
                this.btnQuestionCancel.Visible = false;
                this.btnQuestionModify.Visible = false;
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
                    this.btnQuestionnaireCancel.Visible = false;
                    this.btnQuestionnaireModify.Visible = false;
                    this.btnQuestionCancel.Visible = false;
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
                    this.ltlErrMsg.Text = "<span id='errMag'>問卷ID錯誤</span>";
                    return;
                }

                Questionnaire currentQuestionnaire;
                // 從資料庫找出該問卷
                currentQuestionnaire = QuestionManager.GetQuestionnaireByID((Guid)queryGuid);
                if (currentQuestionnaire == null)
                {
                    this.btnQuestionnaireCancel.Visible = false;
                    this.btnQuestionnaireModify.Visible = false;
                    this.btnQuestionCancel.Visible = false;
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
                    this.ltlErrMsg.Text = "<span id='errMsg'>無此問卷</span>";
                    return;
                }

                // 修改模式





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
                this.ltlCreateFailed.Text = "<script>\n$(function(){\n";
                this.ltlCreateFailed.Text += "CreateFailedModal.show();\n";
                this.ltlCreateFailed.Text += "})\n</script>\n";
            }
        }
    }
}
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
    public partial class Statistic : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
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
                return;
            }

            // 確認Status
            if (currentQuestionnaire.Status != 1 && currentQuestionnaire.Status != 2)
            {
                this.ltlQuestionnaireTitle.Text = "<span style='color:#dc3545'>錯誤</span>";
                return;
            }

            
            // 從資料庫找出問題
            List<Question> questionList = QuestionManager.GetQuestionsByQuestionnaireID(currentQuestionnaire.QuestionnaireID);

            if (questionList == null || questionList.Count == 0)
            {
                this.ltlQuestionList.Text = "<div class='offset-md-2'><span style='color:#dc3545'>錯誤</span></div>";
                return;
            }

            this.ltlQuestionnaireTitle.Text = currentQuestionnaire.Title;

            this.ltlQuestionList.Text = "";
            int totalVotersCount = QuestionManager.GetTotalVoterQuantity(currentQuestionnaire.QuestionnaireID);

            // Render 統計
            foreach (Question item in questionList)
            {
                if(item.Type == 0)  // 文字方塊
                {
                    this.ltlQuestionList.Text +=
                        $"<div class='offset-md-4 mt-4' id='ID{item.QuestionID}'>" +
                        $"<h5>{item.Number}. {item.Title}</h5>" +
                        $"<div class='option_div'>--</div>" +
                        $"</div>";
                }
                else
                {
                    this.ltlQuestionList.Text +=
                        $"<div class='offset-md-4 mt-4' id='ID{item.QuestionID}'>" +
                        $"<h5>{item.Number}. {item.Title} {(item.Type == 2 ? "(複選)" : "")}</h5>" +
                        $"<div class='option_div'>";

                    List<Option> options = QuestionManager.GetOptionsByQuestionID(item.QuestionID);
                    List<int> countEveryOption = QuestionManager.GetVotersCountOfEveryOption(item.QuestionID);

                    int i = 0;
                    foreach (int count in countEveryOption)
                    {
                        string strCount = ((double)count * 100 / totalVotersCount).ToString("0.##");
                        strCount = (strCount == "" || strCount == "NaN") ? "0" : strCount;
                        this.ltlQuestionList.Text +=
                            $"<div class='myOption'>" +
                            $"<div class='option_content'>{options[i].OptionContent}</div>" +
                            $"<div class='row'>" +
                            $"<div class='progress col-md-4'>" +
                            $"<div class='progress-bar progress-bar-striped' role='progressbar' " +
                                $"style='width: {strCount}%'></div>" +
                            $"</div>" +
                            $"<div class='col-md-4 progress_text'>{strCount}% ({count})</div>" +
                            $"</div>" +
                            $"</div>";
                        i++;
                    }

                    this.ltlQuestionList.Text += $"</div></div>";
                }
            }
        }
    }
}
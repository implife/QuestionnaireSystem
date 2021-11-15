using QuestionnaireSystem.Auth;
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
        public string pieChartData { get; set; } = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            string strQID = this.Request.QueryString["QID"];
            string errMsg;
            Questionnaire currentQuestionnaire = AuthManager.AuthQuestionnaireGuid(strQID, out errMsg);

            if (currentQuestionnaire == null)
            {
                this.ltlQuestionnaireTitle.Text = $"<span style='color:#dc3545'>{errMsg}</span>";
                return;
            }

            // 確認Status
            if (currentQuestionnaire.Status != 1 && currentQuestionnaire.Status != 2)
            {
                this.ltlQuestionnaireTitle.Text = "<span style='color:#dc3545'>問卷未開放</span>";
                return;
            }


            // 從資料庫找出問題
            List<Question> questionList = QuestionManager.GetQuestionsByQuestionnaireID(currentQuestionnaire.QuestionnaireID);

            if (questionList == null || questionList.Count == 0)
            {
                this.ltlProgress.Text = "<div class='offset-md-2'><span style='color:#dc3545'>錯誤，無問題</span></div>";
                this.ltlPieChart.Text = "<div class='offset-md-2'><span style='color:#dc3545'>錯誤，無問題</span></div>";
                return;
            }

            this.ltlQuestionnaireTitle.Text = currentQuestionnaire.Title;

            // PieChart所需的JSON Object
            List<Rootobject> pieChartData = new List<Rootobject>();

            this.ltlProgress.Text = "";
            this.ltlPieChart.Text = "";
            int totalVotersCount = QuestionManager.GetTotalVoterQuantity(currentQuestionnaire.QuestionnaireID);

            // Render Progress統計
            foreach (Question item in questionList)
            {
                if (item.Type == 0)  // 文字方塊
                {
                    this.ltlProgress.Text +=
                        $"<div class='mt-4' id='ID{item.QuestionID}'>" +
                        $"<h5>{item.Number}. {item.Title}</h5>" +
                        $"<div class='option_div'>--</div>" +
                        $"</div>";

                    this.ltlPieChart.Text +=
                        $"<div id='chart_{item.QuestionID}'>" +
                        $"<h5>{item.Number}. {item.Title}</h5>" +
                        $"<div class='option_div'>--</div>" +
                        $"</div>";
                }
                else
                {
                    // PieChart部分
                    this.ltlPieChart.Text += $"<div id='chart_{item.QuestionID}'></div>";
                    Rootobject temp = new Rootobject
                    {
                        title = $"{item.Number}. {item.Title} {(item.Type == 2 ? "(複選)" : "")}",
                        ID = item.QuestionID.ToString()
                    };

                    // Progress部分
                    this.ltlProgress.Text +=
                        $"<div class='mt-4' id='ID{item.QuestionID}'>" +
                        $"<h5>{item.Number}. {item.Title} {(item.Type == 2 ? "(複選)" : "")}</h5>" +
                        $"<div class='option_div'>";

                    List<Option> options = QuestionManager.GetOptionsByQuestionID(item.QuestionID);
                    List<int> countEveryOption = QuestionManager.GetVotersCountOfEveryOption(item.QuestionID);

                    int i = 0;
                    Column[] cols = new Column[options.Count];
                    foreach (int count in countEveryOption)
                    {
                        // PieChart部分, JSON
                        for (int j = 0; j < options.Count; j++)
                        {
                            cols[j] = new Column
                            {
                                optionName = options[j].OptionContent,
                                votes = countEveryOption[j]
                            };
                        }

                        // Progress部分
                        string strCount = ((double)count * 100 / totalVotersCount).ToString("0.##");
                        strCount = (strCount == "" || strCount == "NaN") ? "0" : strCount;
                        this.ltlProgress.Text +=
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

                    // Progress部分
                    this.ltlProgress.Text += $"</div></div>";

                    // PieChart部分, JSON
                    temp.columns = cols;
                    pieChartData.Add(temp);
                }
            }

            string pieChartJSON = Newtonsoft.Json.JsonConvert.SerializeObject(pieChartData);
            this.pieChartData = pieChartJSON;

        }


        public class Rootobject
        {
            public Column[] columns { get; set; }
            public string title { get; set; }
            public string ID { get; set; }
        }

        public class Column
        {
            public string optionName { get; set; }
            public int votes { get; set; }
        }


    }
}
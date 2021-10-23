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
    public partial class Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            this.input_search_title.Attributes.Add("placeholder", "問卷標題");
            this.ltlStartDate.Text = "<input type='date' class='form-control myValidation' id='input_search_start' />";
            this.ltlEndDate.Text = "<input type='date' class='form-control myValidation' id='input_search_end' />";

            if (this.IsPostBack)
            {
                // 日期搜尋狀態還原
                this.ltlStartDate.Text = $"<input type='date' class='form-control myValidation' id='input_search_start' " +
                    $"value={this.HFStartDate.Value} />";
                this.ltlEndDate.Text = $"<input type='date' class='form-control myValidation' id='input_search_end' " +
                    $"value={this.HFEndDate.Value} />";

            }
            else
            {
                this.ltlQList.Text = "";
                List<Question> Qlist = QuestionManager.GetQuestionList();
                if (Qlist == null)
                {
                    this.ltlQList.Text = "錯誤";
                    return;
                }

                Qlist = Qlist.Where(obj => obj.Status != 3).ToList();

                foreach (Question item in Qlist)
                {
                    string Qtitle = item.Status == 1 
                        ? $"<a href='{this.Request.Path + "?QID=" + item.QuestionID}'>{item.Title}</a>" 
                        : item.Title;
                    string endDate = item.EndDate != null ? item.EndDate?.ToString("yyyy-MM-dd") : "--";

                this.ltlQList.Text += 
                        $"<tr>" +
                        $"<th scope='row'>{item.QuestionID.ToString().Split('-')[0]}</th>" +
                        $"<td>{Qtitle}</td>" +
                        $"<td>{this.GetStatusString(item.Status)}</td>" +
                        $"<td>{item.StartDate?.ToString("yyyy-MM-dd")}</td>" +
                        $"<td>{endDate}</td>" +
                        $"<td><a href='#'>前往</a></td>" +
                        $"</tr>";
                }
            }
        }

        private string GetStatusString(int status)
        {
            switch (status)
            {
                case 0:
                    return "未開始";
                case 1:
                    return "投票中";
                case 2:
                    return "已結束";
                case 3:
                    return "關閉中";
                default:
                    return "--";
            }
        }
    }
}
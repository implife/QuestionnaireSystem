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
    public partial class QuestionnaireList : System.Web.UI.Page
    {
        public string UserName { get; set; } = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            // 處理登入使用者
            string strId = (HttpContext.Current.User.Identity as FormsIdentity).Ticket.UserData;
            string errMsg;
            UserInfo currentUser = AuthManager.AuthUserInfo(strId, out errMsg);
            if (currentUser != null)
                this.UserName = currentUser.Name;


            this.input_search_title.Attributes.Add("placeholder", "問卷標題");
            this.ltlStartDate.Text = "<input type='date' class='form-control myValidation' id='input_search_start' />";
            this.ltlEndDate.Text = "<input type='date' class='form-control myValidation' id='input_search_end' />";

            if (this.IsPostBack)
            {
                
            }
            else
            {
                this.ltlQList.Text = "";
                bool isSearch = false;

                // 處理QueryString
                string strQueryTitle = this.Request.QueryString["SearchTitle"];
                string strQueryStartDate = this.Request.QueryString["sDate"];
                string strQueryEndDate = this.Request.QueryString["eDate"];

                DateTime? queryStartDate = this.CheckDateQuery(strQueryStartDate);
                DateTime? queryEndDate = this.CheckDateQuery(strQueryEndDate);

                if (strQueryTitle != null || queryStartDate != null || queryEndDate != null)
                    isSearch = true;

                if (strQueryTitle == "" && queryStartDate == null && queryEndDate == null)
                    isSearch = false;

                // 狀態還原
                this.input_search_title.Text = strQueryTitle;
                if (queryStartDate != null)
                    this.ltlStartDate.Text = $"<input type='date' class='form-control myValidation' id='input_search_start' " +
                        $"value={queryStartDate?.ToString("yyyy-MM-dd")} />";
                if (queryEndDate != null)
                    this.ltlEndDate.Text = $"<input type='date' class='form-control myValidation' id='input_search_end' " +
                        $"value={queryEndDate?.ToString("yyyy-MM-dd")} />";

                // 建立等等要Render的Qlist;
                List<Questionnaire> Qlist = new List<Questionnaire>();

                if (isSearch)
                {
                    Qlist = QuestionManager.SearchQuestionnaire(strQueryTitle, queryStartDate, queryEndDate);
                }
                else
                {
                    Qlist = QuestionManager.GetQuestionnaireList();
                }

                if (Qlist == null)
                {
                    this.ltlQList.Text = "<tr><td colspan='6' class='no_data_msg'>錯誤</td></tr>";
                    return;
                }
                else if (Qlist.Count == 0)
                {
                    this.ltlQList.Text = "<tr><td colspan='6' class='no_data_msg'>無結果</td></tr>";
                    return;
                }

                this.ucPager.TotalItemSize = Qlist.Count;
                int currentPage = this.ucPager.GetCurrentPage();
                int sizeInPage = this.ucPager.ItemSizeInPage;
                int startIndex = sizeInPage * (currentPage - 1);

                // 按開始日期排序，再按所在頁數切割
                Qlist = Qlist.OrderBy(item => item.StartDate).Skip(startIndex).Take(sizeInPage).ToList();

                // Render Qlist
                foreach (Questionnaire item in Qlist)
                {
                    string Qtitle =
                        $"<a href='/SystemAdmin/Detail.aspx?QID={item.QuestionnaireID}'>{item.Title}</a>";
                    string endDate = item.EndDate != null ? item.EndDate?.ToString("yyyy-MM-dd") : "--";

                    this.ltlQList.Text +=
                        $"<th scope='row'>" +
                            $"<div class='form-check'><input class='form-check-input' type='checkbox' id='ID{item.QuestionnaireID}'></div>" +
                        $"</th>" +
                        $"<td>{item.QuestionnaireID.ToString().Split('-')[0]}</td>" +
                        $"<td>{Qtitle}</td>" +
                        $"<td>{this.GetStatusString(item.Status)}</td>" +
                        $"<td>{item.StartDate.ToString("yyyy-MM-dd")}</td>" +
                        $"<td>{endDate}</td>" +
                        $"</tr>";
                }

                this.ucPager.Bind();
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

        private DateTime? CheckDateQuery(string strDate)
        {
            try
            {
                if (strDate == null)
                    throw new NullReferenceException();
                string[] strStart = strDate.Split('-');
                if (strStart.Length != 3)
                    throw new Exception("StartDate bad Query.");
                int sy = Convert.ToInt32(strStart[0]);
                int sm = Convert.ToInt32(strStart[1]);
                int sd = Convert.ToInt32(strStart[2]);
                return new DateTime(sy, sm, sd);
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        protected void btnQuestionnaireDelete_Click(object sender, EventArgs e)
        {
            string strHF = this.HFDeleteID.Value;
            string[] deleteIdAry = Newtonsoft.Json.JsonConvert.DeserializeObject<string[]>(strHF);

            string failedMsg = "";
            int failedCount = 0;
            foreach (string id in deleteIdAry)
            {
                string errMsg;
                Questionnaire target = AuthManager.AuthQuestionnaireGuid(id, out errMsg);
                if(target == null)
                {
                    failedMsg += $"Failed: [{id}], {errMsg}<br />";
                    failedCount++;
                    continue;
                }

                bool isSuccess = QuestionManager.DeleteQuestionnaireByID(target.QuestionnaireID);
                if (!isSuccess)
                {
                    failedMsg += $"Failed: [{target.Title}], Database Error.<br />";
                    failedCount++;
                }
            }

            this.ltlFailedMsg.Text = $"共 {deleteIdAry.Length - failedCount} 個成功，{failedCount} 個失敗<br />";
            this.ltlFailedMsg.Text += failedMsg;

            this.ltlFailedMsg.Text += "\n<script>\n$(function(){\n";
            this.ltlFailedMsg.Text += "DeleteFailedModal.show();\n";
            this.ltlFailedMsg.Text += "})\n</script>\n";


        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            this.Response.Redirect($"/SystemAdmin/QuestionnaireList.aspx?SearchTitle={this.input_search_title.Text}" +
                    $"&sDate={this.HFStartDate.Value}&eDate={this.HFEndDate.Value}");
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            FormsAuthentication.SignOut();
            this.Response.Redirect("/Default.aspx");
        }
    }
}
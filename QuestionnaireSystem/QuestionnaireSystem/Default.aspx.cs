using QuestionnaireSystem.DBSource;
using QuestionnaireSystem.ORM.DBModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
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

            //檢查登入狀態
            if (this.Request.IsAuthenticated)
            {
                string id = (HttpContext.Current.User.Identity as FormsIdentity).Ticket.UserData;
                Guid logInUserGuid;
                try
                {
                    logInUserGuid = Guid.Parse(id);
                    UserInfo currentUser = UserInfoManager.GetUserInfoByUserID(logInUserGuid);

                    this.ltlLogin.Text = $"<a class='btn btn-outline-info' href='/SystemAdmin/QuestionnaireList.aspx' role='button'>後台管理</a>";
                }
                catch (Exception ex)
                {
                    this.ltlLogin.Text = "<a class='btn btn-info' href='Login.aspx' role='button'>登入</a>";
                }
                
            }
            else
            {
                this.ltlLogin.Text = "<a class='btn btn-info' href='Login.aspx' role='button'>登入</a>";
            }


            if (this.IsPostBack)
            {
                this.Response.Redirect($"Default.aspx?SearchTitle={this.input_search_title.Text}" +
                    $"&sDate={this.HFStartDate.Value}&eDate={this.HFEndDate.Value}");
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
                if(queryStartDate != null)
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
                else if(Qlist.Count == 0)
                {
                    this.ltlQList.Text = "<tr><td colspan='6' class='no_data_msg'>無結果</td></tr>";
                    return;
                }

                Qlist = Qlist.Where(obj => obj.Status != 3).ToList();
                this.ucPager.TotalItemSize = Qlist.Count;
                int currentPage = this.ucPager.GetCurrentPage();
                int sizeInPage = this.ucPager.ItemSizeInPage;
                int startIndex = sizeInPage * (currentPage - 1);

                // 按開始日期排序，再按所在頁數切割
                Qlist = Qlist.OrderBy(item => item.StartDate).Skip(startIndex).Take(sizeInPage).ToList();

                // Render Qlist
                foreach (Questionnaire item in Qlist)
                {
                    string Qtitle = item.Status == 1 
                        ? $"<a href='{"AnswerPage.aspx?QID=" + item.QuestionnaireID}'>{item.Title}</a>" 
                        : item.Title;
                    string endDate = item.EndDate != null ? item.EndDate?.ToString("yyyy-MM-dd") : "--";
                    string link = (item.Status == 1 || item.Status == 2)
                        ? $"<a href='Statistic.aspx?QID={item.QuestionnaireID.ToString()}'>前往</a>"
                        : "前往";

                    this.ltlQList.Text += 
                        $"<tr>" +
                        $"<th scope='row'>{item.QuestionnaireID.ToString().Split('-')[0]}</th>" +
                        $"<td>{Qtitle}</td>" +
                        $"<td>{this.GetStatusString(item.Status)}</td>" +
                        $"<td>{item.StartDate.ToString("yyyy-MM-dd")}</td>" +
                        $"<td>{endDate}</td>" +
                        $"<td>{link}</td>" +
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
    }
}
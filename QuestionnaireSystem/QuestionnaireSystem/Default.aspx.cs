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
        }
    }
}
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
    public partial class FAQPage : System.Web.UI.Page
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

            if (this.IsPostBack)
                return;

            QuestionClass[] FAQData = QuestionManager.GetFAQList();
            if (FAQData == null)
                return;

            this.ltlQuestionTbody.Text = "";
            foreach (QuestionClass item in FAQData)
            {
                string type = item.QuestionType == 0
                    ? "文字方塊"
                    : item.QuestionType == 1 ? "單選" : "複選";

                string optionStr = "";
                if (item.QuestionType != 0)
                {
                    List<Option> opts = QuestionManager.GetOptionsByQuestionID(Guid.Parse(item.QuestionID));
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
                    $"<td>{item.FAQName}</td>" +
                    $"<td style='width:48%;'>{item.QuestionTitle}</td>" +
                    $"<td>{type}</td>" +
                    $"<td>{(item.QuestionRequired == 0 ? "<img src='../img/check-lg.svg'>" : "")}</td>" +
                    $"<td><a href='javascript:void(0)' onclick='QListModify(this)'>編輯</a></td>" +
                    $"<td class='questionHadModifiedHidden'>flase</td>" +
                    $"<td class='questionOptionHidden'>{optionStr}</td>" +
                    $"<td class='questionOriginalOptionHidden'>{optionStr}</td>" +
                    $"</tr>";
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            FormsAuthentication.SignOut();
            this.Response.Redirect("/Default.aspx");
        }

        protected void btnModifyConfirm_Click(object sender, EventArgs e)
        {
            string jsonModifiedData = this.HFModifiedData.Value;
            QuestionClass[] modifiedData = Newtonsoft.Json.JsonConvert.DeserializeObject<QuestionClass[]>(jsonModifiedData);
            int modifiedCount = modifiedData.Where(obj => obj.Modified == "Delete" || obj.Modified == "NewItem" || obj.Modified == "true").Count();

            string failedMsg = "";
            int failedCount = 0;
            foreach (QuestionClass item in modifiedData)
            {
                bool isSuccess = QuestionManager.UpdateFAQ(item);
                if (!isSuccess)
                {
                    failedMsg += $"Failed: [{item.FAQName}], Database Error.<br />";
                    failedCount++;
                }
            }

            this.ltlResultMsg.Text = $"共 {modifiedCount - failedCount} 個成功，{failedCount} 個失敗<br />";
            this.ltlResultMsg.Text += failedMsg;

            this.ltlResultMsg.Text += "\n<script>\n$(function(){\n";
            this.ltlResultMsg.Text += "ResultModal.show();\n";
            this.ltlResultMsg.Text += "})\n</script>\n";
        }
    }
}
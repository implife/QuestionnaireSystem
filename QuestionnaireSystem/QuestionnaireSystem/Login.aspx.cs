using QuestionnaireSystem.DBSource;
using QuestionnaireSystem.ORM.DBModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Principal;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace QuestionnaireSystem
{
    public partial class Login : System.Web.UI.Page
    {

        protected void Page_Load(object sender, EventArgs e)
        {
            this.login_account.Attributes.Add("min", "5");
            this.login_account.Attributes.Add("max", "15");
            this.login_PWD.Attributes.Add("min", "6");
            this.login_PWD.Attributes.Add("max", "20");

        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string txtAccount = this.login_account.Text;
            string txtPWD = this.login_PWD.Text;

            UserInfo user = UserInfoManager.GetUserInfoByAccountPWD(txtAccount, txtPWD);

            if (user != null)
            {
                bool isPersistent = false;
                FormsAuthenticationTicket ticket = new FormsAuthenticationTicket(
                    1,                              // 版本
                    user.Account,                   // 使用者名稱
                    DateTime.Now,                   // issueDate
                    DateTime.Now.AddHours(1),       // expiration
                    isPersistent,                   // 是否永久存在
                    user.UserID.ToString());        // UserData(UserID)

                string encTicket = FormsAuthentication.Encrypt(ticket);

                // 將加密後的ticket放進cookie
                HttpCookie httpCookie = new HttpCookie(FormsAuthentication.FormsCookieName, encTicket);
                httpCookie.HttpOnly = true;
                HttpContext.Current.Response.Cookies.Add(httpCookie);

                // 建立Principal並放進HttpContext.Current.User
                string[] roles = { "Admin" };

                FormsIdentity identity = new FormsIdentity(ticket);
                GenericPrincipal myPrincipal = new GenericPrincipal(identity, roles);
                HttpContext.Current.User = myPrincipal;

                this.Response.Redirect("/SystemAdmin/QuestionnaireList.aspx");

            }
            else
            {
                this.lblMsg.Text = "帳號或密碼錯誤";
                return;
            }
        }
    }
}
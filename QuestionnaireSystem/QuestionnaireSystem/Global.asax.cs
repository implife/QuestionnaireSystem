using QuestionnaireSystem.DBSource;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.SessionState;

namespace QuestionnaireSystem
{
    public class Global : System.Web.HttpApplication
    {

        protected void Application_Start(object sender, EventArgs e)
        {

        }

        protected void Session_Start(object sender, EventArgs e)
        {

        }

        protected void Application_BeginRequest(object sender, EventArgs e)
        {

        }

        protected void Application_AuthenticateRequest(object sender, EventArgs e)
        {
            // 檢查問卷的開始及結束日期
            bool isSuccess = QuestionManager.CheckStatus();

            // SystemAdmin要檢查是否登入
            var request = HttpContext.Current.Request;
            var response = HttpContext.Current.Response;
            string path = request.Url.PathAndQuery;

            


            // SystemAdmin下的頁面都要經過登入檢查
            if (path.StartsWith("/SystemAdmin", StringComparison.InvariantCultureIgnoreCase) ||
                path.StartsWith("/Handler", StringComparison.InvariantCultureIgnoreCase))
            {
                var user = HttpContext.Current.User;
                if (!request.IsAuthenticated || user == null)
                {
                    response.StatusCode = 401;
                    response.End();
                    return;
                }

                FormsIdentity identity = user.Identity as FormsIdentity;

                if (identity == null)
                {
                    response.StatusCode = 401;
                    response.End();
                    return;
                }
            }
        }

        protected void Application_AcquireRequestState(object sender, EventArgs e)
        {
            var request = HttpContext.Current.Request;
            string path = request.Url.PathAndQuery;

            if (!path.StartsWith("/SystemAdmin/Detail.aspx", StringComparison.InvariantCultureIgnoreCase) &&
                !path.StartsWith("/Handler", StringComparison.InvariantCultureIgnoreCase))
            {
                List<string> tempList = new List<string>();
                if (HttpContext.Current.Session == null)
                    return;
                foreach (string item in HttpContext.Current.Session.Keys)
                {
                    if (item.StartsWith("QuestionnaireM") || item.StartsWith("QuestionM"))
                    {
                        
                        tempList.Add(item);
                    }
                }
                foreach (var item in tempList)
                {
                    HttpContext.Current.Session[item] = null;
                }
            }
        }

        protected void Application_Error(object sender, EventArgs e)
        {

        }

        protected void Session_End(object sender, EventArgs e)
        {
            
        }

        protected void Application_End(object sender, EventArgs e)
        {

        }
    }
}
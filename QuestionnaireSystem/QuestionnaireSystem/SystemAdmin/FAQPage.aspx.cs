using QuestionnaireSystem.DBSource;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace QuestionnaireSystem.SystemAdmin
{
    public partial class FAQPage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            QuestionClass[] FAQData = QuestionManager.GetFAQList();
            if (FAQData == null)
                return;
            
        }
    }
}
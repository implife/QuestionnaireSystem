using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace QuestionnaireSystem
{
    public partial class AnswerPage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            this.input_phone.Attributes.Add("min", "10");
            this.input_phone.Attributes.Add("max", "10");
            this.input_age.Attributes.Add("min", "1");
            this.input_age.Attributes.Add("max", "3");
        }
    }
}
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace QuestionnaireSystem.UserControl
{
    public partial class ucPager : System.Web.UI.UserControl
    {
        public string Url { get; set; } = String.Empty;
        public int TotalItemSize { get; set; } = -1;
        public int ItemSizeInPage { get; set; } = 10;
        public int CurrentPage { get; set; } = -1;
        public int AllowPageCount { get; set; } = 9;
        public bool isSearch { get; set; } = false;

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        public void Bind()
        {
            if (this.Url == string.Empty)
                throw new Exception("URL haven't set yet");

            this.CurrentPage = this.GetCurrentPage();
            int totalPages = this.GetTotalPage();

            // 設定HLPre
            if (this.CurrentPage > 1)
            {
                if (isSearch)
                    this.HLPre.Attributes.Add("href", this.Url + $"?Action=Search&Page={CurrentPage - 1}");
                else
                    this.HLPre.Attributes.Add("href", this.Url + $"?Page={CurrentPage - 1}");
            }
            else
            {
                this.HLPre.Attributes.Add("href", "#");
                this.HLPre.Attributes.Add("tabindex", "-1");
            }

            // 設定HLNext
            if (this.CurrentPage < totalPages)
            {
                if (isSearch)
                    this.HLNext.Attributes.Add("href", this.Url + $"?Action=Search&Page={CurrentPage + 1}");
                else
                    this.HLNext.Attributes.Add("href", this.Url + $"?Page={CurrentPage + 1}");
            }
            else
            {
                this.HLNext.Attributes.Add("href", "#");
                this.HLNext.Attributes.Add("tabindex", "-1");
            }

            // 迴圈的startPage & endPage
            int startPage, endPage;
            int allowFront = this.AllowPageCount / 2;
            int allowBack = this.AllowPageCount % 2 == 0 ? this.AllowPageCount / 2 - 1 : this.AllowPageCount / 2;

            if (this.AllowPageCount >= totalPages)
            {
                startPage = 1;
                endPage = totalPages;
            }
            else
            {
                if (this.CurrentPage <= allowFront)
                {
                    startPage = 1;
                    endPage = this.AllowPageCount;
                }
                else if (this.CurrentPage + allowBack >= totalPages)
                {
                    startPage = totalPages - this.AllowPageCount + 1;
                    endPage = totalPages;
                }
                else
                {
                    startPage = this.CurrentPage - allowFront;
                    endPage = this.CurrentPage + allowBack;
                }
            }

            // 建立 Pager
            for (int i = startPage; i <= endPage; i++)
            {
                if (i == this.CurrentPage)
                    this.ltlPages.Text += $"<li class='page-item active'><a class='page-link' href='#'>{i}</a></li>";
                else
                {
                    if (isSearch)
                        this.ltlPages.Text += $"<li class='page-item'><a class='page-link' href='{this.Url}?Action=Search&Page={i}'>{i}</a></li>";
                    else
                        this.ltlPages.Text += $"<li class='page-item'><a class='page-link' href='{this.Url}?Page={i}'>{i}</a></li>";
                }
            }
        }

        public int GetTotalPage()
        {
            int pages = this.TotalItemSize / this.ItemSizeInPage;
            if (this.TotalItemSize % this.ItemSizeInPage > 0)
                pages += 1;
            return pages;
        }

        public int GetCurrentPage()
        {
            // 使用GetCurrentPage知欠必須設定TotalItemSize
            if (this.TotalItemSize == -1)
                throw new Exception("TotalItemSize haven't set yet");

            if (this.CurrentPage == -1)
            {
                string pageText = Request.QueryString["Page"];

                if (string.IsNullOrWhiteSpace(pageText))
                    return 1;

                int intPage;
                if (!int.TryParse(pageText, out intPage))
                    return 1;

                if (intPage <= 0 || intPage > this.GetTotalPage())
                    return 1;

                return intPage;
            }
            else
            {
                return this.CurrentPage;
            }
        }
    }
}
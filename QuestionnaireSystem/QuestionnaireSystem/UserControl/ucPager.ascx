<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ucPager.ascx.cs" Inherits="QuestionnaireSystem.UserControl.ucPager" %>
<nav>
    <ul class="pagination">
        <li class="page-item">
            <asp:HyperLink ID="HLPre" runat="server" CssClass="page-link"><span>&laquo;</span></asp:HyperLink>
        </li>

        <asp:Literal ID="ltlPages" runat="server" EnableViewState="false"></asp:Literal>

        <li class="page-item">
            <asp:HyperLink ID="HLNext" runat="server" CssClass="page-link"><span>&raquo;</span></asp:HyperLink>
        </li>
    </ul>
</nav>
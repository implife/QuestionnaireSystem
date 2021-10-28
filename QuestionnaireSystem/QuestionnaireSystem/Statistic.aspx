<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Statistic.aspx.cs" Inherits="QuestionnaireSystem.Statistic" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>統計頁</title>
    <link href="CSS/bootstrap.min.css" rel="stylesheet" />

    <script src="Scripts/bootstrap.js"></script>

    <style>
        h3 {
            text-align: center;
            padding: 10px;
        }

        .option_div {
            margin-left: 1.5rem;
        }

        .progress {
            padding: 0;
        }

        .progress_text{
            margin-top: -5px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <h3>
            <asp:Literal ID="ltlQuestionnaireTitle" runat="server"></asp:Literal>
        </h3>

        <asp:Literal ID="ltlQuestionList" runat="server"></asp:Literal>

        <div class="row mt-3 mb-5">
            <div class="col-md-3 offset-md-5">
                <a class="btn btn-secondary" href="Default.aspx" role="button">返回列表</a>
            </div>
        </div>
    </form>
</body>
</html>

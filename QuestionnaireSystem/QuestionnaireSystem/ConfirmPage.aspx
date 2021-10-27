<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ConfirmPage.aspx.cs" Inherits="QuestionnaireSystem.ConfirmPage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>確認頁</title>

    <link href="CSS/bootstrap.min.css" rel="stylesheet" />
    <link href="CSS/MainStyle.css" rel="stylesheet" />

    <script src="Scripts/bootstrap.js"></script>
    <script src="Scripts/jquery-3.6.0.min.js"></script>

    <style>
        h3 {
            text-align: center;
            padding: 10px;
        }

        .status_time {
            padding: 10px 0px;
        }

        .discription {
            padding: 10px 15%;
        }

        .option_div {
            margin-left: 1.5rem;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="row">
            <div class="col-md-4 offset-md-4">

                <h3>
                    <asp:Literal ID="ltlQuestionnaireTitle" runat="server"></asp:Literal></h3>

            </div>
            <div class="col-md-4 status_time">

                <asp:Literal ID="ltlQuestionnaireStatusTime" runat="server"></asp:Literal>

            </div>
        </div>
        <p class="discription">

            <asp:Literal ID="ltlQuestionnaireDiscription" runat="server"></asp:Literal>

        </p>
        <div class="col-md-4 offset-md-4">
            <div class="row g-3 align-items-center">
                <div class="col-auto ms-5">
                    <span>姓名</span>
                </div>
                <div class="col-auto">

                    <asp:Literal ID="ltlName" runat="server"></asp:Literal>

                </div>
            </div>
            <div class="row g-3 align-items-center mt-2">
                <div class="col-auto ms-5">
                    <span>手機</span>
                </div>
                <div class="col-auto">

                    <asp:Literal ID="ltlPhone" runat="server"></asp:Literal>

                </div>
            </div>
            <div class="row g-3 align-items-center mt-2">
                <div class="col-auto ms-5">
                    <span>Email</span>
                </div>
                <div class="col-auto">

                    <asp:Literal ID="ltlEmail" runat="server"></asp:Literal>

                </div>
            </div>
            <div class="row g-3 align-items-center mt-2">
                <div class="col-auto ms-5">
                    <span>年齡</span>
                </div>
                <div class="col-auto">

                    <asp:Literal ID="ltlAge" runat="server"></asp:Literal>

                </div>
            </div>
        </div>

        <asp:Literal ID="ltlQuestionList" runat="server"></asp:Literal>


        <div class="row mt-3 mb-5">
            <div class="col-md-1 offset-md-7">
                <asp:Button ID="btnModify" runat="server" Text="修改" CssClass="btn btn-secondary" OnClick="btnModify_Click" />
                <asp:Button ID="btnReturn" runat="server" CssClass="btn btn-secondary" Text="回到列表頁" Visible="false" OnClick="btnReturn_Click" />
            </div>
            <div class="col-md-1">
                <asp:Button ID="btnConfirm" runat="server" Text="確認送出" CssClass="btn btn-success" OnClick="btnConfirm_Click" />
            </div>
        </div>

        <!-- 送出回答失敗Modal -->
        <div class="modal fade" id="CreateAnswerFailedModal" data-bs-keyboard="false" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-body">
                        <div class="alert alert-danger" role="alert">
                            送出失敗!
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal" onclick="FailedModal.hide()">關閉</button>
                    </div>
                </div>
            </div>
        </div>

        <asp:Literal ID="ltlFailedModal" runat="server"></asp:Literal>

    </form>
</body>
</html>

<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="QuestionnaireSystem.Login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>登入</title>
    <link href="CSS/bootstrap.min.css" rel="stylesheet" />
    <link href="CSS/MainStyle.css" rel="stylesheet" />

    <script src="Scripts/bootstrap.js"></script>
    <script src="Scripts/jquery-3.6.0.min.js"></script>
    <script src="Scripts/validation.js"></script>

    <style>
        .goToList_div {
            position: fixed;
            top: 15px;
            right: 8%;
        }

        h3 {
            text-align: center;
            padding: 10px;
            margin-top: 5%;
        }
    </style>
    <script>
        $(function () {
            $('form').submit(function (event) {
                if (!$('input.myValidation').toArray().every(CheckHasValid)) {
                    event.preventDefault()
                    event.stopPropagation()
                }
            })
        })
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div class="goToList_div">
            <a class="btn btn-light" href="Default.aspx" role="button">回列表</a>
        </div>

        <h3>使用者登入</h3>
        <div class="col-md-4 offset-md-4">
            <div class="row g-3 align-items-center mt-3 mb-3">
                <div class="col-2 ms-5">
                    <label for="login_account" class="col-form-label">使用者</label>
                </div>
                <div class="col-auto">
                    <asp:TextBox ID="login_account" runat="server" CssClass="form-control myValidation validateNullWhiteSpace validateTextLength"></asp:TextBox>
                    <div class="invalid-feedback">
                    </div>
                    <div class="valid-feedback">
                    </div>
                </div>
            </div>

            <div class="row g-3 align-items-center mt-2 mb-2">
                <div class="col-2 ms-5">
                    <label for="login_PWD" class="col-form-label">密碼</label>
                </div>
                <div class="col-auto">
                    <asp:TextBox ID="login_PWD" runat="server" TextMode="Password" CssClass="form-control myValidation validateNullWhiteSpace validateTextLength validateAlphNumOnly"></asp:TextBox>
                    <div class="invalid-feedback">
                    </div>
                    <div class="valid-feedback">
                    </div>
                </div>
            </div>
        </div>

        <div class="row mt-3 mb-5">
            <div class="col-3 offset-md-5" style="padding-left:6%">
                <asp:Button ID="btnLogin" runat="server" Text="登入" CssClass="btn btn-outline-primary" OnClick="btnLogin_Click"/>
                <asp:Literal ID="ltlMsg" runat="server" EnableViewState="false"></asp:Literal>
            </div>
        </div>
    </form>
</body>
</html>

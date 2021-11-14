<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FAQPage.aspx.cs" Inherits="QuestionnaireSystem.SystemAdmin.FAQPage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>FAQ頁</title>
    <link href="../CSS/bootstrap.min.css" rel="stylesheet" />
    <link href="../CSS/MainStyle.css" rel="stylesheet" />

    <script src="../Scripts/bootstrap.js"></script>
    <script src="../Scripts/jquery-3.6.0.min.js"></script>
    <script src="../Scripts/validation.js"></script>

    <style>
        .front_div {
            position: fixed;
            top: 15px;
            right: 8%;
        }

        .mySideBar {
            padding-top: 150px;
            padding-left: 30px;
        }

            .mySideBar > a {
                margin: 10px 0;
                white-space: nowrap;
            }

        h3 {
            text-align: center;
            padding: 10px;
        }

        #btnQuestionReturn {
            visibility: hidden;
        }

        .questionTrash {
            border: none;
        }

            .questionTrash:hover {
                border: none;
                background-color: #ffb3b3;
            }

            .questionTrash:active {
                border: none;
                background-color: #ffb3b3;
            }

            .questionTrash:focus {
                box-shadow: none;
            }


        .table_container {
            min-height: 350px;
        }

        thead th:first-child {
            padding-top: 0;
            padding-bottom: 4px;
        }

        tbody th:first-child {
            padding-left: 20px;
        }

        .NoQuestionMsg {
            text-align: center;
            color: #dc3545;
            box-shadow: none !important;
        }

            .NoQuestionMsg > img {
                width: calc(.75em + .375rem);
                height: calc(.75em + .375rem);
            }

        .invalid-tr {
            display: none;
        }

        .btn-div-question {
            padding-left: calc(50% - 29px);
        }
    </style>
    <script>

</script>
</head>
<body>
    <form id="form1" runat="server">
        <div class="front_div">
            <a class="btn btn-info" href="/Default.aspx" role="button">前台</a>
        </div>

        <h3>後台-常用問題管理</h3>
        <div class="row">
            <div class="col-2 mySideBar">
                <a class="btn btn-link" href="QuestionnaireList.aspx" role="button">問卷管理</a>
                <br />
                <a class="btn btn-link" href="#" role="button">常用問題管理</a>
            </div>
            <div class="col-7 offset-1 mt-5">
                <%--<div class="mb-3 row">
                    <label class="col-sm-1 col-form-label">常用問題</label>
                    <div class="col-sm-3">
                        <select class="form-select col-sm-10">
                            
                        </select>
                    </div>
                </div>--%>
                <div class="mb-3 row">
                    <label for="question_title" class="col-sm-1 col-form-label">問題</label>
                    <div class="col-5">

                        <asp:TextBox ID="question_title" runat="server" CssClass="form-control QValidation"></asp:TextBox>
                        <div class="invalid-feedback">
                        </div>
                        <div class="valid-feedback">
                        </div>

                    </div>
                    <div class="col-sm-3">
                        <select class="form-select col-sm-10" id="questionType">
                            <option value="text" selected>文字方塊</option>
                            <option value="single">單選</option>
                            <option value="multi">複選</option>
                        </select>
                    </div>
                    <div class="col-sm-3 mt-2">
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" value="" id="requiredCheck" />
                            <label class="form-check-label" for="requiredCheck">
                                必填
                            </label>
                        </div>
                    </div>
                </div>
                <div class="mb-3 row">
                    <label for="question_option" class="col-sm-1 col-form-label">選項</label>
                    <div class="col-5">

                        <asp:TextBox ID="question_option" runat="server" CssClass="form-control QValidation"></asp:TextBox>
                        <div class="invalid-feedback">
                        </div>
                        <div class="valid-feedback">
                        </div>

                    </div>
                    <div class="col-3 mt-2">
                        多個選項以 ； 分隔
                    </div>
                    <div class="col-3" style="overflow: visible">
                        <button type="button" class="btn btn-outline-success" onclick="btnQuestionAddClick()" id="btnQuestionAdd">送出</button>
                        <button type="button" class="btn btn-outline-warning" onclick="btnQuestionReturnClick()" style="padding: 0.375rem 0.475rem;" id="btnQuestionReturn">
                            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="currentColor">
                                <path d="M9 12l-4.463 4.969-4.537-4.969h3c0-4.97 4.03-9 9-9 2.395 0 4.565.942 6.179 2.468l-2.004 2.231c-1.081-1.05-2.553-1.699-4.175-1.699-3.309 0-6 2.691-6 6h3zm10.463-4.969l-4.463 4.969h3c0 3.309-2.691 6-6 6-1.623 0-3.094-.65-4.175-1.699l-2.004 2.231c1.613 1.526 3.784 2.468 6.179 2.468 4.97 0 9-4.03 9-9h3l-4.537-4.969z" />
                            </svg>
                        </button>
                    </div>
                </div>

                <div class="mb-3 table_container">
                    <table class="table table-striped col-7">
                        <thead>
                            <tr>
                                <th scope="col">
                                    <button type="button" class="btn btn-outline-danger questionTrash notActive"
                                        data-bs-toggle="" data-bs-target="#FAQDeleteCheckModal">
                                        <img src="../img/trash.svg" />
                                    </button>
                                </th>
                                <th scope="col">名稱</th>
                                <th scope="col">問題</th>
                                <th scope="col">種類</th>
                                <th scope="col">必填</th>
                                <th scope="col">編輯</th>
                            </tr>
                        </thead>
                        <tbody id="questionTbody">

                            <asp:Literal ID="ltlQuestionTbody" runat="server"></asp:Literal>

                            <%--<tr>
                                <th scope="row">
                                    <input class="form-check-input" type="checkbox" value="" id="optionDelete1">
                                </th>
                                <td>喜愛甜食</td>
                                <td>請問你最喜愛的甜食是?</td>
                                <td>文字方塊</td>
                                <td></td>
                                <td><a href="#">編輯</a></td>
                            </tr>--%>
                        </tbody>
                        <tbody>
                            <tr class="invalid-tr">
                                <td colspan="6" class="NoQuestionMsg">
                                    無資料
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div class="mb-3 btn-div-question">
                    <asp:HyperLink ID="linkCancel" runat="server" CssClass="btn btn-secondary" NavigateUrl="~/SystemAdmin/QuestionnaireList.aspx">取消</asp:HyperLink>
                    <asp:Button ID="btnValidate" runat="server" Text="修改" CssClass="btn btn-primary" />
                </div>

            </div>
        </div>
        <!-- 問題刪除確認Modal -->
        <div class="modal fade" id="FAQDeleteCheckModal" data-bs-keyboard="false" tabindex="-1"
            aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-body">
                        <div class="alert alert-danger" role="alert">
                            確定刪除嗎？
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
                        <button type="button" class="btn btn-primary">確定</button>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>

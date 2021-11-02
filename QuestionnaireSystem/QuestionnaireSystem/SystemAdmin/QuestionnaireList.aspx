<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="QuestionnaireList.aspx.cs" Inherits="QuestionnaireSystem.SystemAdmin.QuestionnaireList" %>

<%@ Register Src="~/UserControl/ucPager.ascx" TagPrefix="uc1" TagName="ucPager" %>


<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>問卷管理</title>
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

        .all_blank_msg {
            padding-top: 17px;
            color: red;
            visibility: hidden;
        }

        .no_data_msg {
            text-align: center;
            color: red;
            box-shadow: none !important;
        }

        #input_search_start {
            position: relative;
            overflow: visible;
        }

            #input_search_start::after {
                content: "~";
                position: absolute;
                left: calc(100% + var(--bs-gutter-x) * .25);
                font-size: 22px;
            }

        .delete_add_div {
            padding: 8px 0;
        }

            .delete_add_div button {
                border: none;
            }
            .delete_add_div > .btn-outline-success:hover {
                background-color: #1cb01c;
                border-color: #1cb01c;
            }
    </style>

    <script>
        var allowValidate = false;


        $(function () {
            $('form').submit(function (event) {
                $('.all_blank_msg').css('visibility', 'hidden');
                $('#input_search_end').removeClass('myInvalid').siblings('.invalid-feedback').css('display', 'none');


                let txtTitle = $('#input_search_title').val().trim();
                let txtStart = $('#input_search_start').val();
                let txtEnd = $('#input_search_end').val();

                if (txtTitle == '' && txtStart == '' && txtEnd == '') {
                    $('.all_blank_msg').css('visibility', 'visible');
                    allowValidate = false;
                }
                else if (txtStart != '' && txtEnd != '') {
                    let dateStart = new Date(txtStart);
                    let dateEnd = new Date(txtEnd);
                    if (dateEnd <= dateStart) {
                        allowValidate = false;
                        $('#input_search_end').siblings('.invalid-feedback').html("不可等於或小於起始日期");
                        $('#input_search_end').addClass('myInvalid').siblings('.invalid-feedback').css('display', 'block');
                    }
                    else
                        allowValidate = true;
                }
                else
                    allowValidate = true;

                // 確認是否通過
                if (!allowValidate) {
                    event.preventDefault();
                    event.stopPropagation();
                }
                else {
                    $('input[type=hidden][id$=HFStartDate]').val($('#input_search_start').val());
                    $('input[type=hidden][id$=HFEndDate]').val($('#input_search_end').val());
                }
            })

        });



    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div class="front_div">
            <a class="btn btn-info" href="/Default.aspx" role="button">前台</a>
        </div>

        <h3>後台-問卷管理</h3>
        <div class="row">
            <div class="col-2 mySideBar">
                <a class="btn btn-outline-primary" href="/SystemAdmin/QuestionnaireList.aspx" role="button">問卷管理</a>
                <br />
                <a class="btn btn-outline-primary" href="#" role="button">常用問題管理</a>
            </div>
            <div class="col" style="padding-left:7%">
                <div class="search_div">
                    <div class="row">
                        <div class="form-floating col-3 offset-1">
                            <asp:TextBox ID="input_search_title" runat="server" CssClass="form-control myValidation"></asp:TextBox>
                            <label for="input_search_title">問卷標題</label>
                            <div class="invalid-feedback">
                                請輸入標題
                            </div>
                            <div class="valid-feedback">
                            </div>
                        </div>
                        <div class="col-md-4 all_blank_msg">
                            請輸入標題查詢或利用日期區間查詢!
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-2 offset-1">
                            <label for="input_search_start" class="col-form-label">開始日</label>

                            <asp:Literal ID="ltlStartDate" runat="server"></asp:Literal>
                            <asp:HiddenField ID="HFStartDate" runat="server" />

                            <div class="invalid-feedback">
                                請輸入開始日
                            </div>
                            <div class="valid-feedback">
                            </div>
                        </div>
                        <div class="col-md-2">
                            <label for="input_search_end" class="col-form-label">&#x2004;</label>

                            <asp:Literal ID="ltlEndDate" runat="server"></asp:Literal>
                            <asp:HiddenField ID="HFEndDate" runat="server" />

                            <div class="invalid-feedback">
                                請輸入結束日
                            </div>
                            <div class="valid-feedback">
                            </div>
                        </div>
                        <div class="col-md-2" style="margin-top: 37px;">
                            <asp:Button ID="btnSearch" runat="server" Text="搜尋" CssClass="btn btn-primary" />
                        </div>
                    </div>
                </div>
                <div class="row Qtable">
                    <div class="col-8">
                        <div class="delete_add_div">
                            <button type="button" class="btn btn-outline-danger">
                                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-trash" viewBox="0 0 16 16">
                                    <path d="M5.5 5.5A.5.5 0 0 1 6 6v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5zm2.5 0a.5.5 0 0 1 .5.5v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5zm3 .5a.5.5 0 0 0-1 0v6a.5.5 0 0 0 1 0V6z" />
                                    <path fill-rule="evenodd" d="M14.5 3a1 1 0 0 1-1 1H13v9a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V4h-.5a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1H6a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1h3.5a1 1 0 0 1 1 1v1zM4.118 4 4 4.059V13a1 1 0 0 0 1 1h6a1 1 0 0 0 1-1V4.059L11.882 4H4.118zM2.5 3V2h11v1h-11z" />
                                </svg>
                            </button>
                            <button type="button" class="btn btn-outline-success">
                                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-plus-lg" viewBox="0 0 16 16">
                                    <path fill-rule="evenodd" d="M8 2a.5.5 0 0 1 .5.5v5h5a.5.5 0 0 1 0 1h-5v5a.5.5 0 0 1-1 0v-5h-5a.5.5 0 0 1 0-1h5v-5A.5.5 0 0 1 8 2Z" />
                                </svg>
                            </button>
                        </div>
                        <table class="table table-striped">
                            <thead>
                                <tr>
                                    <th scope="col"></th>
                                    <th scope="col">#</th>
                                    <th scope="col">問卷</th>
                                    <th scope="col">狀態</th>
                                    <th scope="col">開始時間</th>
                                    <th scope="col">結束時間</th>
                                </tr>
                            </thead>
                            <tbody>
                                <asp:Literal ID="ltlQList" runat="server"></asp:Literal>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

        </div>
        <div class="offset-md-5">
            <uc1:ucPager runat="server" ID="ucPager" Url="SystemAdmin/QuestionnaireList.aspx" AllowPageCount="5" />
        </div>

    </form>
</body>
</html>

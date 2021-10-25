<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AnswerPage.aspx.cs" Inherits="QuestionnaireSystem.AnswerPage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>作答頁</title>

    <link href="CSS/bootstrap.min.css" rel="stylesheet" />
    <link href="CSS/MainStyle.css" rel="stylesheet" />

    <script src="Scripts/bootstrap.js"></script>
    <script src="Scripts/jquery-3.6.0.min.js"></script>
    <script src="Scripts/validation.js"></script>

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

            .option_div > input[type=text] {
                width: auto;
            }

        h5 > span {
            margin-left: 10px;
        }

        span.required_mark {
            color: #dc3545;
            font-size: 1.2rem !important;
        }

        span.required_msg {
            color: #dc3545;
            font-size: .75em !important;
            visibility: hidden;
        }
        span.required_msg.myShow {
            visibility: visible;
        }
    </style>

    <script>
        $(function () {
            $('form').submit(function (event) {

                // radiobutton validation
                $('div.QContainer.required.single input[type=radio]').on('change', function () {
                    let count = $(this).parent().parent().find('input[type=radio]:checked').length;

                    if (count == 0) {
                        $(this).parent().parent().siblings('h5').children('span.required_msg').addClass('myShow')
                            .parent().parent().removeClass('myValid');
                    } else {
                        $(this).parent().parent().siblings('h5').children('span.required_msg').removeClass('myShow')
                            .parent().parent().addClass('myValid');
                    }
                }).trigger('change');

                // checkbox validation
                $('div.QContainer.required.multi input[type=checkbox]').on('change', function () {
                    let count = $(this).parent().parent().find('input[type=checkbox]:checked').length;

                    if (count == 0) {
                        $(this).parent().parent().siblings('h5').children('span.required_msg').addClass('myShow')
                            .parent().parent().removeClass('myValid');
                    } else {
                        $(this).parent().parent().siblings('h5').children('span.required_msg').removeClass('myShow')
                            .parent().parent().addClass('myValid');
                    }
                }).trigger('change');

                // textbox validation
                $('div.QContainer.required.text_input input[type=text]').on('keyup', function () {
                    $(this).val($(this).val().trim());
                    if ($(this).val().length < 1) {
                        $(this).parent().siblings('h5').children('span.required_msg').addClass('myShow')
                            .parent().parent().removeClass('myValid');
                    }
                    else {
                        $(this).parent().siblings('h5').children('span.required_msg').removeClass('myShow')
                            .parent().parent().addClass('myValid');
                    }


                }).trigger('keyup');



                // 基本資料驗證
                if (!$('input.myValidation').toArray().every(CheckHasValid)) {
                    event.preventDefault()
                    event.stopPropagation()
                }

                // 問題驗證
                if (!$('div.QContainer.required').toArray().every(CheckHasValid)) {
                    event.preventDefault()
                    event.stopPropagation()
                }
            })
        })
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div class="row">
            <div class="col-md-4 offset-md-4">
                <h3>程式語言票選</h3>
            </div>
            <div class="col-md-4 status_time">
                投票中<br>
                2021-08-23 ~ 2021-11-01
            </div>
        </div>
        <p class="discription">
            It is an error to use a backslash prior to any alphabetic character that does not denote an escaped construct;
        these are reserved for future extensions to the regular-expression language. A backslash may be used prior to a
        non-alphabetic character regardless of whether that character is part of an unescaped construct.
        <br>
            故此進行投票。
        </p>
        <div class="col-md-4 offset-md-4">
            <div class="row g-3 align-items-center">
                <div class="col-auto ms-5">
                    <label for="input_name" class="col-form-label">姓名</label>
                </div>
                <div class="col-auto">
                    <asp:TextBox ID="input_name" runat="server" CssClass="form-control myValidation validateNullWhiteSpace"></asp:TextBox>
                    <div class="invalid-feedback">
                    </div>
                    <div class="valid-feedback">
                    </div>
                </div>
                <div class="col-auto">
                    <span class="required_mark">*</span>
                </div>
            </div>
            <div class="row g-3 align-items-center mt-2">
                <div class="col-auto ms-5">
                    <label for="input_phone" class="col-form-label">手機</label>
                </div>
                <div class="col-auto">
                    <asp:TextBox ID="input_phone" runat="server" CssClass="form-control myValidation validateNumOnly validateTextLength"></asp:TextBox>
                    <div class="invalid-feedback">
                    </div>
                    <div class="valid-feedback">
                    </div>
                </div>
                <div class="col-auto">
                    <span class="required_mark">*</span>
                </div>
            </div>
            <div class="row g-3 align-items-center mt-2">
                <div class="col-auto ms-5">
                    <label for="input_Email" class="col-form-label">Email</label>
                </div>
                <div class="col-auto" style="padding-left: calc(var(--bs-gutter-x) * .1)">
                    <asp:TextBox ID="input_Email" runat="server" CssClass="form-control myValidation validateEmail"></asp:TextBox>
                    <div class="invalid-feedback">
                    </div>
                    <div class="valid-feedback">
                    </div>
                </div>
                <div class="col-auto">
                    <span class="required_mark">*</span>
                </div>
            </div>
            <div class="row g-3 align-items-center mt-2">
                <div class="col-auto ms-5">
                    <label for="input_age" class="col-form-label">年齡</label>
                </div>
                <div class="col-auto">
                    <asp:TextBox ID="input_age" runat="server" CssClass="form-control myValidation validateNumOnly validateTextLength"></asp:TextBox>
                    <div class="invalid-feedback">
                    </div>
                    <div class="valid-feedback">
                    </div>
                </div>
                <div class="col-auto">
                    <span class="required_mark">*</span>
                </div>
            </div>
        </div>

        <div class="offset-md-2 mt-4 required QContainer single" id="a487b572-d71d-4498-b0d2-2b01550662fc">
            <h5>1. 你最喜歡以下哪種程式語言?<span class="required_mark">*</span><span class="required_msg">此為必填欄位!</span></h5>
            <div class="option_div">
                <div class="form-check">
                    <input class="form-check-input" type="radio" name="a487b572-d71d-4498-b0d2-2b01550662fc"
                        id="IDe11799a9">
                    <label class="form-check-label" for="IDe11799a9">
                        Java
                    </label>
                </div>
                <div class="form-check">
                    <input class="form-check-input" type="radio" name="a487b572-d71d-4498-b0d2-2b01550662fc"
                        id="ID786205aa">
                    <label class="form-check-label" for="ID786205aa">
                        C#
                    </label>
                </div>
                <div class="form-check">
                    <input class="form-check-input" type="radio" name="a487b572-d71d-4498-b0d2-2b01550662fc"
                        id="ID057d9ae2">
                    <label class="form-check-label" for="ID057d9ae2">
                        Python
                    </label>
                </div>
                <div class="form-check">
                    <input class="form-check-input" type="radio" name="a487b572-d71d-4498-b0d2-2b01550662fc"
                        id="ID87020e8b">
                    <label class="form-check-label" for="ID87020e8b">
                        Ruby
                    </label>
                </div>
                <div class="form-check">
                    <input class="form-check-input" type="radio" name="a487b572-d71d-4498-b0d2-2b01550662fc"
                        id="IDc9d30018">
                    <label class="form-check-label" for="IDc9d30018">
                        JavaScript
                    </label>
                </div>
            </div>
        </div>

        <div class="offset-md-2 mt-4 required QContainer multi" id="37db47da-2fe4-435c-8e99-90679b214a0e">
            <h5>2. 想去哪個國家旅遊? (複選) <span class="required_mark">*</span><span class="required_msg">此為必填欄位!</span></h5>
            <div class="option_div">
                <div class="form-check">
                    <input class="form-check-input" type="checkbox" value="" id="ID856db2b6">
                    <label class="form-check-label" for="ID856db2b6">
                        日本
                    </label>
                </div>
                <div class="form-check">
                    <input class="form-check-input" type="checkbox" value="" id="ID918b7892">
                    <label class="form-check-label" for="ID918b7892">
                        韓國
                    </label>
                </div>
                <div class="form-check">
                    <input class="form-check-input" type="checkbox" value="" id="ID61caa7c3">
                    <label class="form-check-label" for="ID61caa7c3">
                        德國
                    </label>
                </div>
                <div class="form-check">
                    <input class="form-check-input" type="checkbox" value="" id="IDedc6446f">
                    <label class="form-check-label" for="IDedc6446f">
                        芬蘭
                    </label>
                </div>
                <div class="form-check">
                    <input class="form-check-input" type="checkbox" value="" id="IDda7d0c36">
                    <label class="form-check-label" for="IDda7d0c36">
                        英國
                    </label>
                </div>
                <div class="form-check">
                    <input class="form-check-input" type="checkbox" value="" id="ID8546d1be">
                    <label class="form-check-label" for="ID8546d1be">
                        瑞士
                    </label>
                </div>
                <div class="form-check">
                    <input class="form-check-input" type="checkbox" value="" id="IDb531733c">
                    <label class="form-check-label" for="IDb531733c">
                        韓國
                    </label>
                </div>
            </div>
        </div>

        <div class="offset-md-2 mt-4 QContainer text_input required" id="37db47da-2fe4-435c-8e99-90679b214a0">
            <h5>3. 給我說喔，你住哪? <span class="required_mark">*</span><span class="required_msg">此為必填欄位!</span></h5>
            <div class="option_div">
                <input class="form-control" type="text" value="" id="IDe5412ed9" size="50">
            </div>
        </div>

        <div class="offset-md-8 col-md-4 mt-5 mb-3">
            <span>共 3 個問題</span>
        </div>

        <div class="row mt-3 mb-5">
            <div class="col-md-1 offset-md-7">
                <a class="btn btn-secondary" href="#" role="button">取消</a>
            </div>
            <div class="col-md-1">
                <asp:Button ID="btnConfirm" runat="server" Text="送出" CssClass="btn btn-success" />
            </div>
        </div>
    </form>
</body>
</html>

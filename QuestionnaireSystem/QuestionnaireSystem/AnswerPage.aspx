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
        var allowNoValidation = false;

        function cancelFun() {
            allowNoValidation = true;
        }


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
                if (!$('input.myValidation').toArray().every(CheckHasValid) && !allowNoValidation) {
                    event.preventDefault()
                    event.stopPropagation()
                }

                // 問題驗證
                if (!$('div.QContainer.required').toArray().every(CheckHasValid) && !allowNoValidation) {
                    event.preventDefault()
                    event.stopPropagation()
                }

                // 將題目與解答作成Object，每一題做成陣列，以JSON格式放進HiddenField
                $('input[type=hidden][id$=HFAnswer]').val("");
                var aryAnswer = new Array();

                for (let item of $('div.QContainer')) {
                    // 題目類型
                    let type;
                    if ($(item).hasClass('text_input'))
                        type = 0;
                    else if ($(item).hasClass('single'))
                        type = 1;
                    else if ($(item).hasClass('multi'))
                        type = 2;
                    else
                        type = -1;

                    // 該題答案，都做成陣列形式
                    let tempAns = new Array();
                    if (type == 0)
                        tempAns = [$(item).find('input[type=text]').val()];
                    else if (type == 1) {
                        if ($(item).find('input[type=radio]:checked').length == 0)
                            tempAns = [""];
                        else
                            tempAns = [$(item).find('input[type=radio]:checked').attr('id').slice(2)];
                    }
                    else if (type == 2) {
                        if ($(item).find('input[type=checkbox]:checked').length == 0)
                            tempAns = [""];
                        else {
                            for (let opt of $(item).find('input[type=checkbox]:checked')) {
                                tempAns.push($(opt).attr('id').slice(2));
                            }
                        }
                    }
                    else
                        tempAns = [""];

                    var objAnswer = {
                        QuestionID: $(item).attr('id').slice(2),
                        Type: type,
                        Answer: tempAns
                    }

                    aryAnswer.push(objAnswer);
                }

                $('input[type=hidden][id$=HFAnswer]').val(JSON.stringify(aryAnswer));
            })
        })
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div class="row">
            <div class="col-md-4 offset-md-4">

                <h3><asp:Literal ID="ltlQuestionnaireTitle" runat="server"></asp:Literal></h3>

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

        <asp:Literal ID="ltlQuestionList" runat="server"></asp:Literal>

        <div class="offset-md-8 col-md-4 mt-5 mb-3">
            <asp:Literal ID="ltlQuestionCount" runat="server"></asp:Literal>
        </div>

        <div class="row mt-3 mb-5">
            <div class="col-md-1 offset-md-7">
                <asp:Button ID="btnCancel" runat="server" Text="取消" CssClass="btn btn-secondary" OnClick="btnCancel_Click" OnClientClick="cancelFun()" />
            </div>
            <div class="col-md-1">
                <asp:Button ID="btnConfirm" runat="server" Text="送出" CssClass="btn btn-success" OnClick="btnConfirm_Click" />
            </div>
        </div>

        <asp:HiddenField ID="HFAnswer" runat="server" />
    </form>
</body>
</html>

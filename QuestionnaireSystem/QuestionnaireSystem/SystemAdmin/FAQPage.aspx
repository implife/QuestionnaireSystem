<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FAQPage.aspx.cs" Inherits="QuestionnaireSystem.SystemAdmin.FAQPage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>FAQ頁</title>
    <link href="../CSS/bootstrap.min.css" rel="stylesheet" />
    <link href="../CSS/MainStyle.css" rel="stylesheet" />

    <script src="../Scripts/bootstrap.js"></script>
    <script src="../Scripts/jquery-3.6.0.min.js"></script>
    <%--<script src="../Scripts/validation.js"></script>--%>

    <style>
        .front_div {
            position: fixed;
            top: 15px;
            right: 3%;
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

        .option_explain_div {
            display: inline-block;
            position: relative;
        }

            .option_explain_div > img {
                cursor: pointer;
                margin-bottom: 4px;
            }

        .explain_popup {
            visibility: hidden;
            width: 330px;
            height: 170px;
            background-color: rgba(116, 110, 111, 0.9);
            color: #fff;
            text-align: left;
            border-radius: 6px;
            padding: 12px 10px;
            position: absolute;
            z-index: 1000;
            left: -141px;
            bottom: calc(100% + 10px);
        }

            .explain_popup::after {
                content: "";
                position: absolute;
                top: 100%;
                left: 45%;
                margin-left: -5px;
                border-width: 5px;
                border-style: solid;
                border-color: rgba(116, 110, 111, 0.9) transparent transparent transparent;
            }

            .explain_popup.myShow {
                visibility: visible;
                -webkit-animation: fadeIn .8s;
                animation: fadeIn .8s;
            }

        @-webkit-keyframes fadeIn {
            from {
                opacity: 0;
            }

            to {
                opacity: 1;
            }
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
            }

            to {
                opacity: 1;
            }
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

        .questionTrash.notActive:active,
        .questionTrash.notActive:focus,
        .questionTrash.notActive:focus-visible,
        .questionTrash.notActive:active:focus,
        .questionTrash.notActive:hover {
            background-color: #fff;
            box-shadow: none;
            cursor: initial !important;
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

        .invalid-tr {
            display: none;
        }

        .questionHadModifiedHidden,
        .questionOptionHidden,
        .questionOriginalOptionHidden {
            display: none;
        }

        tr.questionSelected {
            background-color: #6495ed;
            box-shadow: rgb(100 149 237 / 40%) 0px 2px 4px, rgb(100 149 237 / 30%) 0px 7px 13px -3px, rgb(100 149 237 / 20%) 0px -3px 0px inset;
        }

        .btn-div-question {
            padding-left: calc(50% - 29px);
        }
    </style>
    <script>
        var QDeleteModal, LeavePageModal, ResultModal;
        var ModifiedArray = new Array();
        var isModified = false;

        // 選項欄位輸入檢查用
        function optionStringTest(txt) {
            let pattern = /\S/;
            if (txt.match(pattern) == undefined)
                return false;
            else
                return true;
        }

        // Type中轉英
        function TypeToEnglish(txt) {
            if (txt == '文字方塊')
                return 'text';
            else if (txt == '單選')
                return 'single';
            else
                return 'multi';
        }

        // Type英轉中
        function TypeToChinese(txt) {
            if (txt == 'text')
                return '文字方塊';
            else if (txt == 'single')
                return '單選';
            else
                return '複選';
        }

        // Type轉數字
        function TypeToNumber(txt) {
            if (txt == 'text' || txt == '文字方塊')
                return 0;
            else if (txt == 'single' || txt == '單選')
                return 1;
            else
                return 2;
        }

        // Type數字轉英文
        function TypeNumToEnglish(num) {
            if (num == 0)
                return 'text';
            else if (num == 1)
                return 'single';
            else
                return 'multi';
        }

        // 問題的編輯紐
        function QListModify(ele) {
            let $tr = $(ele).parent().parent();
            let FAQName = $tr.find('td').eq(0).text();
            let questionTitle = $tr.find('td').eq(1).text();
            let questionType = TypeToEnglish($tr.find('td').eq(2).text());
            let questionRequired = $tr.find('td').eq(3).html() == '' ? false : true;
            let optionStr = $tr.find('td').eq(6).text();

            $('input#FAQ_Name').val(FAQName);
            $('input#question_title').val(questionTitle);
            $('select#questionType > option:selected').prop('selected', false);
            $('select#questionType > option[value=' + questionType + ']').prop('selected', true);
            $('select#questionType').trigger('change');
            $('#requiredCheck').prop('checked', questionRequired);
            $('input#question_option').val(optionStr);

            $('#btnQuestionAdd').text('修改');
            $('#btnQuestionReturn').css('visibility', 'visible');

            $('#questionTbody > tr.questionSelected').removeClass('questionSelected');
            $tr.addClass('questionSelected');
        }

        // 從編輯模式返回新增模式按鈕
        function btnQuestionReturnClick() {
            // 清空所有欄位
            $('input#FAQ_Name').val('');
            $('input#question_title').val('');
            $('select#questionType > option:selected').prop('selected', false);
            $('select#questionType > option[value=text]').prop('selected', true);
            $('select#questionType').trigger('change');
            $('#requiredCheck').prop('checked', false);
            $('input#question_option').val('');

            $('#questionTbody > tr.questionSelected').removeClass('questionSelected');
            $('#btnQuestionAdd').text('送出');
            $('#btnQuestionReturn').css('visibility', 'hidden');
        }

        // 新增(修改)問題的送出紐
        function btnQuestionAddClick() {
            let fromDatabase = $('#questionTbody').children('tr.questionSelected').length == 0
                ? false
                : $('#questionTbody').children('tr.questionSelected').hasClass('fromDatabase');
            let faqName = $('#FAQ_Name').val().trim();
            let questionTitle = $('#question_title').val().trim();
            let questionType = $('select#questionType option:selected').val();
            let questionRequired = $('#requiredCheck').prop('checked');
            let optionStr = $('#question_option').val();

            // 檢查名稱
            $('#FAQ_Name').val(faqName);
            if (faqName.length < 1) {
                $('input#FAQ_Name').addClass('QInvalid').removeClass('QValid');

                $('input#FAQ_Name').siblings('.invalid-feedback').html('輸入欄不可為空').css('display', 'block');
            } else {
                $('input#FAQ_Name').addClass('QValid').removeClass('QInvalid');

                $('input#FAQ_Name').siblings('.invalid-feedback').html('').css('display', 'none');
            }

            // 檢查問題Title
            $('#question_title').val(questionTitle);
            if (questionTitle.length < 1) {
                $('input#question_title').addClass('QInvalid').removeClass('QValid');

                $('input#question_title').siblings('.invalid-feedback').html('輸入欄不可為空').css('display', 'block');
            } else {
                $('input#question_title').addClass('QValid').removeClass('QInvalid');

                $('input#question_title').siblings('.invalid-feedback').html('').css('display', 'none');
            }


            // 檢查option
            if (questionType != 'text') {
                // 編輯模式並且編輯的問題是從資料庫來的
                if (fromDatabase) {
                    let $target = $('#questionTbody').children('tr.questionSelected');
                    let originalOptions = $target.find('td').eq(7).text();
                    let originalSize = originalOptions.split(';').length;
                    let optionAry = optionStr.split(';');

                    if (optionAry.length < originalSize) {
                        $('input#question_option').addClass('QInvalid').removeClass('QValid');

                        $('input#question_option').siblings('.invalid-feedback').html('分號數量須至少' + (originalSize - 1) + '個').css('display', 'block');
                    }
                    else {
                        optionAry.splice(0, originalSize);
                        let result = optionAry.every(optionStringTest); // 後半為空(數量跟原來一樣)為空的話一定是true

                        if (result) {  // 格式正確
                            $('input#question_option').addClass('QValid').removeClass('QInvalid');

                            $('input#question_option').siblings('.invalid-feedback').html('').css('display', 'none');
                        } else {  // 格式錯誤
                            $('input#question_option').addClass('QInvalid').removeClass('QValid');

                            $('input#question_option').siblings('.invalid-feedback').html('第' + originalSize + '個分號開始前後不可為空').css('display', 'block');
                        }
                    }

                    if (originalSize == 1) {
                        if (optionStr.trim() == '') {
                            $('input#question_option').addClass('QInvalid').removeClass('QValid');
                            $('input#question_option').siblings('.invalid-feedback').html('須至少輸入一個選項').css('display', 'block');
                        }
                    }
                }
                // 編輯的問題不是從資料庫來的, 或新增問題
                else {
                    let result = optionStr.split(';').every(optionStringTest);

                    if (result) {  // 格式正確
                        $('input#question_option').addClass('QValid').removeClass('QInvalid');

                        $('input#question_option').siblings('.invalid-feedback').html('').css('display', 'none');
                    } else {  // 格式錯誤
                        $('input#question_option').addClass('QInvalid').removeClass('QValid');

                        $('input#question_option').siblings('.invalid-feedback').html('格式不正確').css('display', 'block');
                    }
                }
            } else {    // 文字方塊不必檢查
                $('input#question_option').addClass('QValid').removeClass('QInvalid');

                $('input#question_option').siblings('.invalid-feedback').html('').css('display', 'none');
            }

            // 檢查是否通過
            if ($('input#FAQ_Name').hasClass('QValid') && $('input#question_title').hasClass('QValid') && $('input#question_option').hasClass('QValid')) {
                isModified = true;
                $('#btnValidate').prop('disabled', false);

                // 判斷是新增問題還是修改問題
                if ($('#questionTbody').children('tr.questionSelected').length == 0) {  // 新增問題模式
                    let typeChinese = TypeToChinese(questionType);

                    let originalHtml = $('#questionTbody').html();
                    originalHtml += '<tr data-ID="NewItem">\
                        <th scope = "row">\
                            <input class="form-check-input" type="checkbox" value="" onchange="deleteCheckboxCheck()">\
                        </th>\
                        <td>' + faqName + '</td>\
                        <td style="width:48%;">' + questionTitle + '</td>\
                        <td>' + typeChinese + '</td>\
                        <td>' + (questionRequired ? '<img src="../img/check-lg.svg" />' : '') + '</td>\
                        <td><a href="javascript:void(0)" onclick="QListModify(this)">編輯</a></td>\
                        <td class="questionHadModifiedHidden">NewItem</td>\
                        <td class="questionOptionHidden">' + (questionType == "text" ? "" : optionStr) + '</td>\
                    </tr >';
                    $('#questionTbody').html(originalHtml);
                }
                else {  // 修改問題模式
                    let $target = $('#questionTbody').children('tr.questionSelected');

                    $('#btnQuestionAdd').text('送出');
                    $('#btnQuestionReturn').css('visibility', 'hidden');

                    $target.removeClass('questionSelected');

                    // 修改target tr的內容
                    $target.find('td').eq(0).text(faqName);
                    $target.find('td').eq(1).text(questionTitle);
                    $target.find('td').eq(2).text(TypeToChinese(questionType));
                    $target.find('td').eq(3).html(questionRequired ? '<img src="../img/check-lg.svg" />' : '');
                    $target.find('td').eq(6).text(questionType == "text" ? "" : optionStr);

                    // 原本資料庫的資料，狀態改成修改過
                    if ($target.find('td').eq(5).text() != 'NewItem')
                        $target.find('td').eq(5).text('true');
                }

                // 清空所有欄位
                $('input#FAQ_Name').val('');
                $('input#question_title').val('');
                $('select#questionType > option:selected').prop('selected', false);
                $('select#questionType > option[value=text]').prop('selected', true);
                $('select#questionType').trigger('change');
                $('#requiredCheck').prop('checked', false);
                $('input#question_option').val('');
            }
        }

        // 刪除checkbox檢查，有勾選垃圾桶才能按
        function deleteCheckboxCheck() {
            let count = $('#questionTbody input[type=checkbox]:checked').length;

            if (count == 0)
                $('.questionTrash').addClass('notActive').attr('data-bs-toggle', '');
            else
                $('.questionTrash').removeClass('notActive').attr('data-bs-toggle', 'modal');
        }

        // 刪除問題確認紐
        function btnQuestionDeleteConfirm() {
            for (let item of $('#questionTbody input[type=checkbox]:checked')) {
                let $targetTr = $(item).parent().parent();

                // 若是編輯狀態先呼叫btnQuestionReturnClick()
                if ($targetTr.hasClass('questionSelected')) {
                    btnQuestionReturnClick();
                }

                // DB來的話要存起來
                if ($targetTr.hasClass('fromDatabase')) {
                    let QuestionObj = {
                        QuestionID: $targetTr.attr('data-ID'),
                        Modified: "Delete"
                    }

                    ModifiedArray.push(QuestionObj);
                }
                $targetTr.remove();
            }

            QDeleteModal.hide();
            isModified = true;
            $('#btnValidate').prop('disabled', false);
        }

        // 修改送出紐
        function modifyConfirm_Click() {
            var count = 1;
            for (let item of $('#questionTbody > tr')) {
                let qType = TypeToNumber($(item).find('td').eq(2).text());
                let QuestionObj = {
                    QuestionID: $(item).attr('data-ID'),
                    QuestionTitle: $(item).find('td').eq(1).text(),
                    QuestionType: qType,
                    QuestionRequired: $(item).find('td').eq(3).find('img').length == 0 ? 1 : 0,
                    QuestionNumber: count,
                    FAQName: $(item).find('td').eq(0).text(),
                    Modified: $(item).find('td').eq(5).text()
                }

                // 選項Object
                let OptionArray = new Array();
                if (qType != 0) {
                    let optionStrAry = $(item).find('td').eq(6).text().split(';');
                    for (let i = 1; i <= optionStrAry.length; i++) {
                        OptionArray.push({
                            OptionContent: optionStrAry[i - 1].trim(),
                            OptionNumber: i
                        });
                    }
                }

                QuestionObj.Options = OptionArray;
                ModifiedArray.push(QuestionObj);
                count++;
            }

            $('#HFModifiedData').val(JSON.stringify(ModifiedArray));
        }

        $(function () {
            // Modal變數
            QDeleteModal = new bootstrap.Modal(document.getElementById('FAQDeleteCheckModal'), {
                keyboard: false
            });
            LeavePageModal = new bootstrap.Modal(document.getElementById('LeavePageModal'), {
                keyboard: false
            });
            ResultModal = new bootstrap.Modal(document.getElementById('ResultModal'), {
                keyboard: false
            });

            // 問題類型檢查，文字方塊不需要填選項的欄位
            $('select#questionType').change(function () {
                if ($(this).val() == 'text') {
                    $('#question_option').prop('disabled', true).removeClass('QInvalid')
                        .siblings('.invalid-feedback').html('').css('display', 'none');;
                }
                else {
                    $('#question_option').prop('disabled', false);
                }
            }).trigger('change');

            // 刪除checkbox註冊事件
            $('#questionTabContent tbody input[type=checkbox]').on('change', deleteCheckboxCheck);

            // 選項欄位說明的tooltip
            $('#question_svg').bind({
                mouseenter: function () {
                    $('.explain_popup').addClass('myShow');
                },
                mouseleave: function () {
                    $('.explain_popup').removeClass('myShow');
                }
            });

            // 離開頁面的三個按鈕要判斷是否呼叫Modal
            $('#btnFront, #backList_link, #linkCancel').click(function (event) {
                if (isModified) {
                    event.preventDefault();
                    event.stopPropagation();
                    $('#LeavePageModalLink').attr('href', $(this).attr('href'));
                    LeavePageModal.show();
                }
            })

            $(document).on("keydown", "form", function (event) {
                return event.key != "Enter";
            });

        });
    </script>
</head>
<body>
    <form id="form1" runat="server">

        <asp:HiddenField ID="HFModifiedData" runat="server" />

        <div class="front_div">
            使用者：<%= this.UserName %>
            <a class="btn btn-info" href="/Default.aspx" role="button" id="btnFront">前台</a>
        </div>

        <h3>後台-常用問題管理</h3>
        <div class="row">
            <div class="col-2 mySideBar">
                <a class="btn btn-link" href="QuestionnaireList.aspx" role="button" id="backList_link">問卷管理</a>
                <br />
                <a class="btn btn-link" href="#" role="button">常用問題管理</a>
                <br />
                <button type="button" class="btn btn-link" data-bs-toggle="modal" data-bs-target="#logoutModal">登出</button>
            </div>
            <div class="col-7 offset-1 mt-5">
                <div class="mb-3 row">
                    <label for="FAQ_Name" class="col-sm-1 col-form-label">名稱</label>
                    <div class="col-5">

                        <asp:TextBox ID="FAQ_Name" runat="server" CssClass="form-control"></asp:TextBox>
                        <div class="invalid-feedback">
                        </div>
                        <div class="valid-feedback">
                        </div>

                    </div>

                    <label for="" class="col-sm-6 col-form-label">※ 盡可能簡短，具有代表性</label>
                </div>
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
                        <div class="option_explain_div">
                            <img src="../img/question-circle.svg" id="question_svg" />
                            <div class="explain_popup">
                                <p>
                                    1. 如欲修改選項內容，請直接更改，並確保被分號分隔在同一位置<br />
                                    2. 如欲刪除，請保留分號讓該位置留白<br />
                                    3. 原本有x選項就請保留x-1個分號，多出來的會被視為新增<br />
                                    4. 如有x個選項，第x+1個開始會被視為新增
                                </p>
                            </div>
                        </div>
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

                            <asp:Literal ID="ltlQuestionTbody" runat="server" EnableViewState="false"></asp:Literal>

                        </tbody>
                        <tbody>
                            <tr class="invalid-tr">
                                <td colspan="6" class="NoQuestionMsg">無資料
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div class="mb-3 btn-div-question">
                    <asp:HyperLink ID="linkCancel" runat="server" CssClass="btn btn-secondary" NavigateUrl="~/SystemAdmin/QuestionnaireList.aspx">返回</asp:HyperLink>
                    <button class="btn btn-primary" type="button" id="btnValidate" disabled data-bs-toggle="modal" data-bs-target="#ModifyCheckModal">修改</button>
                </div>

            </div>
        </div>
        <%--問題刪除確認Modal--%>
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
                        <button type="button" class="btn btn-primary" onclick="btnQuestionDeleteConfirm()">確定</button>
                    </div>
                </div>
            </div>
        </div>
        <%--離開頁面Modal--%>
        <div class="modal fade" id="LeavePageModal" data-bs-keyboard="false" tabindex="-1"
            aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-body">
                        <div class="alert alert-danger" role="alert">
                            離開頁面修改的資料將不會儲存，確定繼續嗎？
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
                        <a class="btn btn-primary" role="button" href="#" id="LeavePageModalLink">確定</a>
                    </div>
                </div>
            </div>
        </div>
        <%--登出Modal--%>
        <div class="modal fade" id="logoutModal" data-bs-keyboard="false" tabindex="-1"
            aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-body">
                        <div class="alert alert-danger" role="alert">
                            確定登出嗎？
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
                        <asp:Button ID="btnLogout" runat="server" Text="確定" CssClass="btn btn-primary" OnClick="btnLogout_Click" />
                    </div>
                </div>
            </div>
        </div>
        <%--問題修改確認Modal--%>
        <div class="modal fade" id="ModifyCheckModal" data-bs-keyboard="false" tabindex="-1"
            aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-body">
                        <div class="alert alert-danger" role="alert">
                            確定修改嗎？
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
                        <asp:Button ID="btnModifyConfirm" runat="server" Text="確定" CssClass="btn btn-primary" OnClick="btnModifyConfirm_Click" OnClientClick="modifyConfirm_Click()" />
                        <%--<button type="button" class="btn btn-primary" onclick="btnQuestionDeleteConfirm()">確定</button>--%>
                    </div>
                </div>
            </div>
        </div>
        <%--修改結果Modal--%>
        <div class="modal fade" id="ResultModal" data-bs-keyboard="false" tabindex="-1" data-bs-backdrop="static" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-body">
                        <div class="alert alert-warning" role="alert">
                            <asp:Literal ID="ltlResultMsg" runat="server"></asp:Literal>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <a class="btn btn-primary" role="button" href="QuestionnaireList.aspx">確定</a>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>

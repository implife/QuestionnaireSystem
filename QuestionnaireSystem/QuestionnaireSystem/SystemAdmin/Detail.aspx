<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Detail.aspx.cs" Inherits="QuestionnaireSystem.SystemAdmin.Detail" %>

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

        #errMsg {
            color: #dc3545;
            margin-left: 40%;
            font-size: 24px;
        }

        #questionnaireTabContent,
        #questionTabContent,
        #voteTabContent,
        #statisticTabContent {
            padding: 15px 20px;
        }

        .table_container {
            min-height: 350px;
        }

        /*#region 問卷分頁 */
        #questionnaireTabContent input[type=date] {
            width: 200px;
        }

        #questionnaireTabContent input[type=text] {
            min-width: 200px;
            max-width: 400px;
        }

        #questionnaireTabContent textarea {
            min-width: 200px;
            max-width: 400px;
        }

        #questionTabContent .btn-div {
            padding-left: 35%;
        }

        #questionTabContent thead th:first-child {
            padding-top: 0;
            padding-bottom: 4px;
        }

        #questionTabContent tbody th:first-child {
            padding-left: 20px;
        }

        /*#endregion 問卷分頁 */

        /*#region 問題分頁 */
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

        input.QValidation.QInvalid {
            border-color: #ffb3b3;
            padding-right: calc(1.5em + .75rem);
            background-image: url('../img/exclamation-lg.svg');
            background-repeat: no-repeat;
            background-position: right calc(.375em + .1875rem) center;
            background-size: calc(.75em + .375rem) calc(.75em + .375rem);
        }

        input.QValidation + div.invalid-feedback {
            color: #ff8080;
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

        #validateMsg {
            color: #dc3545;
            visibility: hidden;
            margin-left: 8px;
        }

        .questionModeHidden {
            display: none;
        }

        #btnQuestionReturn {
            visibility: hidden;
        }

        tr.questionSelected {
            background-color: #6495ed;
            box-shadow: rgb(100 149 237 / 40%) 0px 2px 4px, rgb(100 149 237 / 30%) 0px 7px 13px -3px, rgb(100 149 237 / 20%) 0px -3px 0px inset;
        }
        /*#endregion 問題分頁 */

        /*#region 回答分頁 */
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

        /*#endregion 回答分頁 */

        /*#region 統計分頁 */
        .progress {
            padding: 0;
        }

        .progress_text {
            margin-top: -5px;
        }

        /*#endregion 統計分頁 */
    </style>

    <script>
        var QDeleteModal;
        var CreateFailedModal;


        // 選項欄位輸入檢查用
        function optionStringTest(txt) {
            let pattern = /\S/;
            if (txt.match(pattern) == undefined)
                return false;
            else
                return true;
        }

        // 新增問題的送出紐
        function btnQuestionAddClick() {
            let questionMode = $('#questionMode > option:selected').val();
            let questionTitle = $('#question_title').val().trim();
            let questionType = $('select#questionType option:selected').val();
            let questionRequired = $('#requiredCheck').prop('checked');
            let optionStr = $('#question_option').val();

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
                let result = optionStr.split(';').every(optionStringTest);

                if (result) {  // 格式正確
                    $('input#question_option').addClass('QValid').removeClass('QInvalid');

                    $('input#question_option').siblings('.invalid-feedback').html('').css('display', 'none');
                } else {  // 格式錯誤
                    $('input#question_option').addClass('QInvalid').removeClass('QValid');

                    $('input#question_option').siblings('.invalid-feedback').html('格式不正確').css('display', 'block');
                }
            } else {    // 文字方塊不必檢查
                $('input#question_option').addClass('QValid').removeClass('QInvalid');

                $('input#question_option').siblings('.invalid-feedback').html('').css('display', 'none');
            }

            // 檢查是否通過
            if ($('input#question_title').hasClass('QValid') && $('input#question_option').hasClass('QValid')) {

                // 判斷是新增問題還是修改問題
                if ($('#questionTbody').children('tr.questionSelected').length == 0) {  // 新增問題模式
                    let count = $('#questionTbody').children('tr').length;
                    let typeChinese = TypeToChinese(questionType);

                    let originalHtml = $('#questionTbody').html();
                    originalHtml += '<tr>\
                        <th scope = "row">\
                            <input class="form-check-input" type="checkbox" value="" onchange="deleteCheckboxCheck()" id="optionDelete' + ++count + '">\
                        </th>\
                        <td>' + count + '</td>\
                        <td style="width:48%;">' + questionTitle + '</td>\
                        <td>' + typeChinese + '</td>\
                        <td>' + (questionRequired ? '<img src="../img/check-lg.svg" />' : '') + '</td>\
                        <td><a href="javascript:void(0)" onclick="QListModify(this)">編輯</a></td>\
                        <td class="questionModeHidden">' + questionMode + '</td>\
                        <td class="questionModeHidden">' + (questionType == "text" ? "" : optionStr) + '</td>\
                    </tr >';
                    $('#questionTbody').html(originalHtml);
                }
                else {  // 修改問題模式
                    let $target = $('#questionTbody').children('tr.questionSelected');

                    $('#btnQuestionAdd').text('送出');
                    $('#btnQuestionReturn').css('visibility', 'hidden');
                    $target.removeClass('questionSelected');

                    // 修改target tr的內容
                    $target.find('td').eq(1).text(questionTitle);
                    $target.find('td').eq(2).text(TypeToChinese(questionType));
                    $target.find('td').eq(3).html(questionRequired ? '<img src="../img/check-lg.svg" />' : '');
                    $target.find('td').eq(5).text(questionMode);
                    $target.find('td').eq(6).text(questionType == "text" ? "" : optionStr);
                }

                // 清空所有欄位
                $('#questionMode > option:selected').prop('selected', false);
                $('#questionMode > option[value=0]').prop('selected', true);
                $('input#question_title').val('');
                $('select#questionType > option:selected').prop('selected', false);
                $('select#questionType > option[value=text]').prop('selected', true);
                $('select#questionType').trigger('change');
                $('#requiredCheck').prop('checked', false);
                $('input#question_option').val('');
            }
        }

        // 從編輯模式返回新增模式按鈕
        function btnQuestionReturnClick() {
            // 清空所有欄位
            $('#questionMode > option:selected').prop('selected', false);
            $('#questionMode > option[value=0]').prop('selected', true);
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

        // 檢查問題列表是否有問題，沒有輸入問題回傳false
        function checkQuestionTbody() {
            if ($('#questionTbody').children('tr').length == 0) {
                $('.invalid-tr').css('display', 'contents');
                return false;
            } else {
                $('.invalid-tr').css('display', 'none');
                return true;
            }
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

        // 問題的編輯紐
        function QListModify(ele) {
            let $tr = $(ele).parent().parent();
            let questionMode = $tr.find('td').eq(5).text();
            let questionTitle = $tr.find('td').eq(1).text();
            let questionType = TypeToEnglish($tr.find('td').eq(2).text());
            let questionRequired = $tr.find('td').eq(3).html() == '' ? false : true;
            let optionStr = $tr.find('td').eq(6).text();

            $('#questionMode > option:selected').prop('selected', false);
            $('#questionMode > option[value=' + questionMode + ']').prop('selected', true);
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
                $targetTr.remove();
            }

            // 重編題號
            let count = 1;
            for (let item of $('#questionTbody > tr')) {
                $(item).find('td').eq(0).text(count);
                count++;
            }

            QDeleteModal.hide();
        }

        $(function () {
            QDeleteModal = new bootstrap.Modal(document.getElementById('QuestionDeleteCheckModal'), {
                keyboard: false
            });
            CreateFailedModal = new bootstrap.Modal(document.getElementById('CreateFailedModal'), {
                keyboard: false
            });

            // 刪除checkbox註冊事件
            $('#questionTabContent tbody input[type=checkbox]').on('change', deleteCheckboxCheck);

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

            // form submit event
            $('form').submit(function (event) {

                $('input#startDate').on('change', function () {
                    if ($(this).val() == '') {
                        ChangeInvalid($(this));
                        $(this).siblings('.invalid-feedback').html('請輸入日期');
                    }
                    // 若現在時間大於輸入時間，new Date().toISOString().slice(0, 10)會是yyyy-MM-dd，同一天也會是false
                    else if (new Date(new Date().toISOString().slice(0, 10)) > new Date($(this).val())) {
                        ChangeInvalid($(this));
                        $(this).siblings('.invalid-feedback').html('開始日不可小於今天');
                    }
                    else {
                        ChangeValid($(this));
                    }

                    $('input#endDate').trigger('change');
                }).trigger('change');

                $('input#endDate').on('change', function () {

                    // 結束時間不可小於今天
                    if (new Date(new Date().toISOString().slice(0, 10)).getTime() >= new Date($(this).val()).getTime()) {
                        ChangeInvalid($(this));
                        $(this).siblings('.invalid-feedback').html('結束日不可小於或等於今天');
                    }
                    // 結束時間不可小於開始時間
                    else if (new Date($(this).val()).getTime() <= new Date($('input#startDate').val()).getTime()) {
                        ChangeInvalid($(this));
                        $(this).siblings('.invalid-feedback').html('結束日不可小於或等於開始日');
                    }
                    else {
                        ChangeValid($(this));
                    }
                }).trigger('change');

                // 檢查問題列表
                let tbodyValidate = checkQuestionTbody();

                if (!$('input.myValidation').toArray().every(CheckHasValid) || !tbodyValidate) {
                    if (!CheckHasValid($('#questionnaireName')) || !CheckHasValid($('#startDate')) || !CheckHasValid($('#endDate'))) {
                        $('#validateMsg').css('visibility', 'visible');
                    } else {
                        $('#validateMsg').css('visibility', 'hidden');
                    }
                    event.preventDefault()
                    event.stopPropagation()
                } else {
                    // 要傳輸到後台的Object
                    let QuestionnaireObj = {
                        QuestionnaireTitle: $('input#questionnaireName').val(),
                        Description: $('#description').val(),
                        StartDate: $('input#startDate').val(),
                        EndDate: $('input#endDate').val(),
                        Active: $('#activeCheck').prop('checked') ? 0 : 1
                    }

                    // 問題Object
                    let QuestionAry = new Array();
                    for (let item of $('#questionTbody > tr')) {
                        let qType = TypeToNumber($(item).find('td').eq(2).text());
                        let QuestionObj = {
                            QuestionTitle: $(item).find('td').eq(1).text(),
                            QuestionType: qType,
                            QuestionRequired: $(item).find('td').eq(3).find('img').length == 0 ? 1 : 0,
                            QuestionNumber: Number($(item).find('td').eq(0).text())
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
                        QuestionAry.push(QuestionObj);
                    }

                    QuestionnaireObj.Questions = QuestionAry;

                    // 放進HiddenField
                    $('input[id$=HFNewQuestionnaire]').val(JSON.stringify(QuestionnaireObj));
                    console.log(JSON.stringify(QuestionnaireObj))
                }
            })

        })
    </script>
</head>
<body>
    <form id="form1" runat="server">

        <asp:HiddenField ID="HFNewQuestionnaire" runat="server" EnableViewState="false" />

        <asp:Literal ID="ltlCreateFailed" runat="server"></asp:Literal>

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
            <div class="col-7 offset-1">

                <asp:Literal ID="ltlErrMsg" runat="server"></asp:Literal>

                <ul class="nav nav-tabs" id="questionnaireTab" role="tablist">
                    <li class="nav-item" role="presentation">
                        <button class="nav-link <%= questionnaireTabStatus %>" id="questionnaire-tab" data-bs-toggle="tab"
                            data-bs-target="#questionnaireTabContent" type="button" role="tab">
                            問卷</button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link <%= questionTabStatus %>" id="question-tab" data-bs-toggle="tab"
                            data-bs-target="#questionTabContent" type="button" role="tab">
                            問題</button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link <%= answerTabStatus %>" id="vote-tab" data-bs-toggle="tab" data-bs-target="#voteTabContent"
                            type="button" role="tab">
                            填寫資料</button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link <%= statisticTabStatus %>" id="statistic-tab" data-bs-toggle="tab"
                            data-bs-target="#statisticTabContent" type="button" role="tab">
                            統計</button>
                    </li>
                </ul>
                <div class="tab-content">
                    <div class="tab-pane fade <%= questionnaireTabContentStatus %>" id="questionnaireTabContent" role="tabpanel">
                        <div class="mb-3">
                            <label for="questionnaireName" class="form-label">問卷名稱</label>
                            <asp:TextBox ID="questionnaireName" runat="server" CssClass="form-control myValidation validateNullWhiteSpace"></asp:TextBox>
                            <div class="invalid-feedback">
                            </div>
                            <div class="valid-feedback">
                            </div>
                        </div>
                        <div class="mb-3">
                            <label for="ltlDescription" class="form-label">描述內容</label>
                            <asp:Literal ID="ltlDescription" runat="server"></asp:Literal>
                        </div>
                        <div class="mb-3">
                            <label for="ltlStartDate" class="form-label">開始日</label>
                            <asp:Literal ID="ltlStartDate" runat="server"></asp:Literal>
                            <div class="invalid-feedback">
                            </div>
                            <div class="valid-feedback">
                            </div>
                        </div>
                        <div class="mb-3">
                            <label for="ltlEndDate" class="form-label">結束日</label>
                            <asp:Literal ID="ltlEndDate" runat="server"></asp:Literal>
                            <div class="invalid-feedback">
                            </div>
                            <div class="valid-feedback">
                            </div>
                        </div>
                        <div class="mb-3">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" value="" id="activeCheck" <%= activeCheck %> />
                                <label class="form-check-label" for="activeCheck">
                                    啟用
                                </label>
                            </div>
                        </div>

                        <div class="mb-3 btn-div">
                            <asp:Button ID="btnQuestionnaireCancel" runat="server" Text="取消" CssClass="btn btn-secondary" />
                            <asp:Button ID="btnQuestionnaireModify" runat="server" Text="修改" CssClass="btn btn-primary" />
                            <%--<button type="button" class="btn btn-secondary">取消</button>
                            <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#QuestionnaireModifyCheckModal">修改</button>--%>
                        </div>

                        <%--問卷修改確認Modal--%>
                        <div class="modal fade" id="QuestionnaireModifyCheckModal" data-bs-keyboard="false" tabindex="-1"
                            aria-hidden="true">
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <div class="modal-body">
                                        <div class="alert alert-warning" role="alert">
                                            即將修改問卷內容，確定執行嗎?
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
                                        <button type="button" class="btn btn-primary">確定</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="tab-pane fade <%= questionTabContentStatus %> " id="questionTabContent" role="tabpanel">
                        <div class="mb-3 row">
                            <label class="col-sm-1 col-form-label">種類</label>
                            <div class="col-sm-3">
                                <select class="form-select col-sm-10" id="questionMode">
                                    <option value="0" selected>自訂</option>
                                    <option value="1">One</option>
                                    <option value="2">Two</option>
                                    <option value="3">Three</option>
                                </select>
                            </div>
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
                                                data-bs-toggle="" data-bs-target="#QuestionDeleteCheckModal">
                                                <img src="../img/trash.svg" />
                                            </button>
                                        </th>
                                        <th scope="col">#</th>
                                        <th scope="col">問題</th>
                                        <th scope="col">種類</th>
                                        <th scope="col">必填</th>
                                        <th scope="col">編輯</th>
                                    </tr>
                                </thead>
                                <tbody id="questionTbody">
                                    <%--
                                    <tr>
                                        <th scope="row">
                                            <input class="form-check-input" type="checkbox" value=""
                                                id="optionDelete2"></th>
                                        <td>2</td>
                                        <td>你對下列哪個程式語言有興趣?</td>
                                        <td>複選</td>
                                        <td>
                                            <img src="../img/check-lg.svg" /></td>
                                        <td><a href="#">編輯</a></td>
                                    </tr>--%>
                                </tbody>
                                <tbody>
                                    <tr class="invalid-tr">
                                        <td colspan="6" class="NoQuestionMsg">
                                            <img src="../img/invalid_mark.svg" />
                                            須建立至少一個問題！</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <div class="mb-3 btn-div-question">
                            <asp:Button ID="btnNewQuestionnaire" runat="server" Text="建立" CssClass="btn btn-success" OnClick="btnNewQuestionnaire_Click" />
                            <span id="validateMsg">請確認問卷分頁的輸入欄！</span>

                            <asp:Button ID="btnQuestionCancel" runat="server" Text="取消" CssClass="btn btn-secondary" />
                            <asp:Button ID="btnQuestionModify" runat="server" Text="修改" CssClass="btn btn-primary" />
                            <%--<button type="button" class="btn btn-secondary">取消</button>
                            <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#QuestionModifyCheckModal">修改</button>--%>
                        </div>
                    </div>
                    <div class="tab-pane fade <%= answerTabContentStatus %>" id="voteTabContent" role="tabpanel">
                        <div class="mb-3">
                            <button type="button" class="btn btn-outline-primary">匯出</button>
                        </div>
                        <div class="mb-3 table_container">
                            <table class="table table-striped col-7">
                                <thead>
                                    <tr>
                                        <th scope="col">#</th>
                                        <th scope="col">姓名</th>
                                        <th scope="col">填寫時間</th>
                                        <th scope="col">觀看細節</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <th scope="row">4</th>
                                        <td>Robert</td>
                                        <td>2021-11-1 09:30</td>
                                        <td><a href="#">前往</a></td>
                                    </tr>
                                    <tr>
                                        <th scope="row">3</th>
                                        <td>Robert</td>
                                        <td>2021-11-1 09:30</td>
                                        <td><a href="#">前往</a></td>
                                    </tr>
                                    <tr>
                                        <th scope="row">2</th>
                                        <td>Robert</td>
                                        <td>2021-11-1 09:30</td>
                                        <td><a href="#">前往</a></td>
                                    </tr>
                                    <tr>
                                        <th scope="row">1</th>
                                        <td>Robert</td>
                                        <td>2021-11-1 09:30</td>
                                        <td><a href="#">前往</a></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <div class="mb-3 row">
                            <div class="pagena">pagination</div>
                        </div>

                        <!-- 觀看細節 -->
                        <!-- <div class="mb-3 row">
                        <label for="answerName" class="col-auto col-form-label">姓名：</label>
                        <div class="col-sm-4">
                            <input type="text" readonly class="form-control-plaintext" id="answerName" value="Monica">
                        </div>
                        <label for="answerPhone" class="col-auto col-form-label"
                            style="margin-left: calc(var(--bs-gutter-x) * .25);">手機：</label>
                        <div class="col-auto">
                            <input type="text" readonly class="form-control-plaintext" id="answerPhone"
                                value="0955777889">
                        </div>
                    </div>
                    <div class="mb-3 row">
                        <label for="answerEmail" class="col-auto col-form-label">Email：</label>
                        <div class="col-sm-4">
                            <input type="text" readonly class="form-control-plaintext" id="answerEmail"
                                value="Monica151225@gmail.com">
                        </div>
                        <label for="answerAge" class="col-auto col-form-label">年齡：</label>
                        <div class="col-auto">
                            <input type="text" readonly class="form-control-plaintext" id="answerAge" value="22">
                        </div>
                    </div>
                    <div class="mb-3 row">
                        <div class="offset-6 col-auto">填寫時間：2021-11-02 21:25</div>
                    </div>

                    <div class="mt-4 QContainer multi required" id="ID5dff9795-09a3-4a59-8746-6660f6e67c3a">
                        <h5>1. 你玩過什麼線上遊戲? (複選)<span class="required_mark">*</span></h5>
                        <div class="option_div">
                            <div class="form-check"><input class="form-check-input" checked disabled type="checkbox" value=""
                                    id="ID14655798-5fab-4092-a56d-8a339a954b76"><label class="form-check-label"
                                    for="ID14655798-5fab-4092-a56d-8a339a954b76">LOL</label></div>
                            <div class="form-check"><input class="form-check-input" disabled type="checkbox" value=""
                                    id="IDe7ca9da4-0fa4-4402-8a10-ba5bc2b5bbd4"><label class="form-check-label"
                                    for="IDe7ca9da4-0fa4-4402-8a10-ba5bc2b5bbd4">薩爾達傳說</label></div>
                            <div class="form-check"><input class="form-check-input" disabled type="checkbox" value=""
                                    id="IDbd1d9b93-6a70-4eb8-853b-f49ecac23733"><label class="form-check-label"
                                    for="IDbd1d9b93-6a70-4eb8-853b-f49ecac23733">Minecraft</label></div>
                            <div class="form-check"><input class="form-check-input" checked disabled type="checkbox" value=""
                                    id="IDcd528b5a-85a5-4a6b-9919-a2496599caa5"><label class="form-check-label"
                                    for="IDcd528b5a-85a5-4a6b-9919-a2496599caa5">GTA</label></div>
                            <div class="form-check"><input class="form-check-input" checked disabled type="checkbox" value=""
                                    id="IDb266b8ef-d795-4d21-ab7a-03f8ff579626"><label class="form-check-label"
                                    for="IDb266b8ef-d795-4d21-ab7a-03f8ff579626">大亂鬥</label></div>
                            <div class="form-check"><input class="form-check-input" disabled type="checkbox" value=""
                                    id="ID5322f39f-3834-4fc0-851c-c6e59c2e4d63"><label class="form-check-label"
                                    for="ID5322f39f-3834-4fc0-851c-c6e59c2e4d63">楓之谷</label></div>
                        </div>
                    </div>

                    <div class="mt-4 QContainer text_input" id="ID3fd8e3fc-b72d-4b29-954d-2ed7a611cfe3">
                        <h5>2. 你玩遊戲最大的理由是?</h5>
                        <div class="option_div">
                            <input type="text" readonly class="form-control-plaintext" id="ID3fd8e3f" value="開心啦!">
                        </div>
                    </div>

                    <div class="mt-4 QContainer single required"
                        id="ID81ecc6d2-42c3-450e-b63c-6587b4bf9fb3">
                        <h5>3. 你到目前為止大約看了幾年的動漫?<span class="required_mark">*</span></h5>
                        <div class="option_div">
                            <div class="form-check"><input class="form-check-input" disabled type="radio"
                                    name="name81ecc6d2-42c3-450e-b63c-6587b4bf9fb3"
                                    id="ID879deec3-b95c-4dac-bb56-1e1ff627adf1"><label class="form-check-label"
                                    for="ID879deec3-b95c-4dac-bb56-1e1ff627adf1">0 年</label></div>
                            <div class="form-check"><input class="form-check-input" checked disabled type="radio"
                                    name="name81ecc6d2-42c3-450e-b63c-6587b4bf9fb3"
                                    id="IDbd181019-e37e-4eb8-9307-db1c49fc90d8"><label class="form-check-label"
                                    for="IDbd181019-e37e-4eb8-9307-db1c49fc90d8">0 ~ 1 年</label></div>
                            <div class="form-check"><input class="form-check-input" disabled type="radio"
                                    name="name81ecc6d2-42c3-450e-b63c-6587b4bf9fb3"
                                    id="ID528d05d5-f7eb-49f8-a415-9183606accdd"><label class="form-check-label"
                                    for="ID528d05d5-f7eb-49f8-a415-9183606accdd">1 ~ 3 年</label></div>
                            <div class="form-check"><input class="form-check-input" disabled type="radio"
                                    name="name81ecc6d2-42c3-450e-b63c-6587b4bf9fb3"
                                    id="ID1164355d-b3e8-47f0-ae76-c314e77de73b"><label class="form-check-label"
                                    for="ID1164355d-b3e8-47f0-ae76-c314e77de73b">3 ~ 5 年</label></div>
                            <div class="form-check"><input class="form-check-input" disabled type="radio"
                                    name="name81ecc6d2-42c3-450e-b63c-6587b4bf9fb3"
                                    id="ID3496d767-ac58-492a-bec5-0c3f26aacf18"><label class="form-check-label"
                                    for="ID3496d767-ac58-492a-bec5-0c3f26aacf18">5 年以上</label></div>
                        </div>
                    </div>

                    <div class="mt-5">
                        <button type="button" class="btn btn-secondary">返回</button>
                    </div> -->
                    </div>
                    <div class="tab-pane fade <%= statisticTabContentStatus %>" id="statisticTabContent" role="tabpanel">
                        <div class="mt-4" id="a487b572-d71d-4498-b0d2-2b01550662fc">
                            <h5>1. 你最喜歡以下哪種程式語言?</h5>
                            <div class="option_div">
                                <div class="myOption">
                                    <div class="option_content">
                                        C#
                                    </div>
                                    <div class="row">
                                        <div class="progress col-md-4">
                                            <div class="progress-bar progress-bar-striped" role="progressbar" style="width: 25%"></div>
                                        </div>
                                        <div class="col-md-4 progress_text">
                                            25% (224)
                                        </div>
                                    </div>
                                </div>
                                <div class="myOption">
                                    <div class="option_content">
                                        Java
                                    </div>
                                    <div class="row">
                                        <div class="progress col-md-4">
                                            <div class="progress-bar progress-bar-striped" role="progressbar" style="width: 20.2%"></div>
                                        </div>
                                        <div class="col-md-4 progress_text">
                                            20.2% (205)
                                        </div>
                                    </div>
                                </div>
                                <div class="myOption">
                                    <div class="option_content">
                                        JavaScript
                                    </div>
                                    <div class="row">
                                        <div class="progress col-md-4">
                                            <div class="progress-bar progress-bar-striped" role="progressbar" style="width: 42.5%"></div>
                                        </div>
                                        <div class="col-md-4 progress_text">
                                            42.5% (486)
                                        </div>
                                    </div>
                                </div>
                                <div class="myOption">
                                    <div class="option_content">
                                        Python
                                    </div>
                                    <div class="row">
                                        <div class="progress col-md-4">
                                            <div class="progress-bar progress-bar-striped" role="progressbar" style="width: 8.7%"></div>
                                        </div>
                                        <div class="col-md-4 progress_text">
                                            8.7% (51)
                                        </div>
                                    </div>
                                </div>
                                <div class="myOption">
                                    <div class="option_content">
                                        SQL
                                    </div>
                                    <div class="row">
                                        <div class="progress col-md-4">
                                            <div class="progress-bar progress-bar-striped" role="progressbar" style="width: 11.6%"></div>
                                        </div>
                                        <div class="col-md-4 progress_text">
                                            11.6% (72)
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 問題刪除確認Modal -->
        <div class="modal fade" id="QuestionDeleteCheckModal" data-bs-keyboard="false" tabindex="-1"
            aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-body">
                        <div class="alert alert-danger" role="alert">
                            確定刪除問題嗎?
                                            <%--問題以及所有相關回答將會刪除，無法回復，確定執行嗎?--%>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
                        <button type="button" class="btn btn-primary" onclick="btnQuestionDeleteConfirm()">確定</button>
                    </div>
                </div>
            </div>
        </div>
        <!-- 問題修改確認Modal -->
        <div class="modal fade" id="QuestionModifyCheckModal" data-bs-keyboard="false" tabindex="-1"
            aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-body">
                        <div class="alert alert-warning" role="alert">
                            即將修改問題內容，有可能造成回答資料遺失無法復原，確定執行嗎?
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
                        <button type="button" class="btn btn-primary">確定</button>
                    </div>
                </div>
            </div>
        </div>
        <!-- 新增失敗Modal -->
        <div class="modal fade" id="CreateFailedModal" data-bs-keyboard="false" tabindex="-1"
            aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-body">
                        <div class="alert alert-danger" role="alert">
                            新增失敗!
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
                        <button type="button" class="btn btn-primary" data-bs-dismiss="modal">確定</button>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>

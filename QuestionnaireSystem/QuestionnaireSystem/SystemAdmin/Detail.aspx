<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Detail.aspx.cs" Inherits="QuestionnaireSystem.SystemAdmin.Detail" %>

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

        ul.nav img {
            margin-bottom: 3px;
            margin-right: 3px;
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

        .questionModeHidden,
        .questionOptionHidden,
        .questionOriginalOptionHidden {
            display: none;
        }

        #btnQuestionReturn {
            visibility: hidden;
        }

        tr.questionSelected {
            background-color: #6495ed;
            box-shadow: rgb(100 149 237 / 40%) 0px 2px 4px, rgb(100 149 237 / 30%) 0px 7px 13px -3px, rgb(100 149 237 / 20%) 0px -3px 0px inset;
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

        #voteTabContent a > svg {
            margin-bottom: 4px;
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
        var QDeleteModal, CreateFailedModal, ModifyFailedModal, QuestionnaireModifyModal, QuestionModifyModal, LeavePageModal;
        var FAQJSONObj = JSON.parse('<%= this.FAQJSONString %>');
        var currentQuestionnaireID = '<%= QuestionnaireID %>';
        var AnswerTabContent;   // 儲存回答分頁的HTML
        var QuestionnaireTabModify = '';    // 問卷分頁變更時Session的值
        var QuestionTabModify = '';
        var SubmitStatus = 'QuestionnaireModify'; // 分成New、QuestionnaireModify、QuestionModify
        var AllowSubmit = false;

        // 選項欄位輸入檢查用
        function optionStringTest(txt) {
            let pattern = /\S/;
            if (txt.match(pattern) == undefined)
                return false;
            else
                return true;
        }

        // 新增(修改)問題的送出紐
        function btnQuestionAddClick() {
            let fromDatabase = $('#questionTbody').children('tr.questionSelected').length == 0
                ? false
                : $('#questionTbody').children('tr.questionSelected').hasClass('fromDatabase');
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
            if ($('input#question_title').hasClass('QValid') && $('input#question_option').hasClass('QValid')) {

                // 判斷是新增問題還是修改問題
                if ($('#questionTbody').children('tr.questionSelected').length == 0) {  // 新增問題模式
                    let count = $('#questionTbody').children('tr').length;
                    let typeChinese = TypeToChinese(questionType);

                    let originalHtml = $('#questionTbody').html();
                    originalHtml += '<tr data-ID="NewItem">\
                        <th scope = "row">\
                            <input class="form-check-input" type="checkbox" value="" onchange="deleteCheckboxCheck()">\
                        </th>\
                        <td>' + ++count + '</td>\
                        <td style="width:48%;">' + questionTitle + '</td>\
                        <td>' + typeChinese + '</td>\
                        <td>' + (questionRequired ? '<img src="../img/check-lg.svg" />' : '') + '</td>\
                        <td><a href="javascript:void(0)" onclick="QListModify(this)">編輯</a></td>\
                        <td class="questionModeHidden">' + questionMode + '</td>\
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
                    $target.find('td').eq(1).text(questionTitle);
                    $target.find('td').eq(2).text(TypeToChinese(questionType));
                    $target.find('td').eq(3).html(questionRequired ? '<img src="../img/check-lg.svg" />' : '');
                    $target.find('td').eq(5).text(questionMode);
                    $target.find('td').eq(6).text(questionType == "text" ? "" : optionStr);
                }

                // 清空所有欄位
                $('#questionMode > option:selected').prop('selected', false);
                $('#questionMode > option[value=-1]').prop('selected', true);
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
            $('#questionMode > option[value=-1]').prop('selected', true);
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
            let questionMode = $tr.find('td').eq(5).text();
            let questionTitle = $tr.find('td').eq(1).text();
            let questionType = TypeToEnglish($tr.find('td').eq(2).text());
            let questionRequired = $tr.find('td').eq(3).html() == '' ? false : true;
            let optionStr = $tr.find('td').eq(6).text();

            $('input#question_title').val(questionTitle);
            $('select#questionType > option:selected').prop('selected', false);
            $('select#questionType > option[value=' + questionType + ']').prop('selected', true);
            $('select#questionType').trigger('change');
            $('#requiredCheck').prop('checked', questionRequired);
            $('input#question_option').val(optionStr);
            $('#questionMode > option:selected').prop('selected', false);
            $('#questionMode > option[value=' + questionMode + ']').prop('selected', true);

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

        // SubmitStatus
        function NewOrModifyClick(type) {
            SubmitStatus = type;
        }

        // 觀看細節
        function AnswerDetail(ele) {
            let url = '/Handler/DetailHandler.ashx?Action=AnswerDetail';
            let voterID = $(ele).parent().parent().attr('data-voterid');
            let questionnaireID = $(ele).parent().parent().attr('data-questionnaireid')

            $.ajax({
                url: url,
                type: "POST",
                data: {
                    VoterID: voterID,
                    QuestionnaireID: questionnaireID
                },
                success: function (result, textStatus) {
                    AnswerTabContent = $('#voteTabContent').html();
                    $('#voteTabContent').html(result);
                },
                statusCode: {
                    400: function (result, textStatus) {
                        console.log('400result: ' + result);
                        console.log('400textStatus: ' + textstatus);
                    }
                }
            });
        }

        // 觀看細節中的返回紐
        function AnswerDetailReturn() {
            $('#voteTabContent').html(AnswerTabContent);
        }

        // 開始日change事件的function
        function startDateChange() {
            if ($('input#startDate').val() == '') {
                ChangeInvalid($('input#startDate'));
                $('input#startDate').siblings('.invalid-feedback').html('請輸入日期');
            }
            // 若現在時間大於輸入時間，new Date().toISOString().slice(0, 10)會是yyyy-MM-dd，同一天也會是false
            //else if (new Date(new Date().toISOString().slice(0, 10)) > new Date($(this).val())) {
            //    ChangeInvalid($(this));
            //    $(this).siblings('.invalid-feedback').html('開始日不可小於今天');
            //}
            else {
                ChangeValid($('input#startDate'));
            }

            endDateChange();
        }

        // 結束日change事件的function
        function endDateChange() {
            // 結束時間不可小於今天
            //if (new Date(new Date().toISOString().slice(0, 10)).getTime() >= new Date($(this).val()).getTime()) {
            //    ChangeInvalid($(this));
            //    $(this).siblings('.invalid-feedback').html('結束日不可小於或等於今天');
            //}
            // 結束時間不可小於開始時間
            if (new Date($('input#endDate').val()).getTime() <= new Date($('input#startDate').val()).getTime()) {
                ChangeInvalid($('input#endDate'));
                $('input#endDate').siblings('.invalid-feedback').html('結束日不可小於或等於開始日');
            }
            else {
                ChangeValid($('input#endDate'));
            }
        }

        // 建立列表上的所有問題的Object
        function createQuestionObject() {
            // 問題Object
            let QuestionAry = new Array();
            for (let item of $('#questionTbody > tr')) {
                let qType = TypeToNumber($(item).find('td').eq(2).text());
                let QuestionObj = {
                    QuestionID: $(item).attr('data-ID'),
                    QuestionTitle: $(item).find('td').eq(1).text(),
                    QuestionType: qType,
                    QuestionRequired: $(item).find('td').eq(3).find('img').length == 0 ? 1 : 0,
                    QuestionNumber: Number($(item).find('td').eq(0).text()),
                    FAQName: $(item).find('td').eq(5).text() == '-1' ? '' : FAQJSONObj[Number($(item).find('td').eq(5).text())].FAQName
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

            return QuestionAry;
        }

        // 問卷修改按鈕，修改資料庫
        function btnQuestionnaireModify_Click() {
            let url = '/Handler/DetailHandler.ashx?QID=' + currentQuestionnaireID + '&Action=QuestionnaireModifyConfirm';
            $.ajax({
                url: url,
                type: "POST",
                data: {},
                success: function (result, textStatus) {
                    console.log("Questionnaire Modify Confirm: " + textStatus);
                    $('#questionnaire-tab').html('問卷');
                    $('#btnQuestionnaireValidate').prop('disabled', true);
                },
                statusCode: {
                    400: function (result, textStatus) {
                        $('#modifyFailedMsg').text(result.responseText);
                        ModifyFailedModal.show();
                    }
                }
            });
        }

        // 問題修改按鈕，修改資料庫
        function btnQuestionModify_Click() {
            let url = '/Handler/DetailHandler.ashx?QID=' + currentQuestionnaireID + '&Action=QuestionModifyConfirm';
            $.ajax({
                url: url,
                type: "POST",
                data: {},
                success: function (result, textStatus) {
                    console.log("Question Modify Confirm: " + textStatus);
                    $('#question-tab').html('問題');
                    $('#btnQuestionnaireValidate').prop('disabled', true);
                },
                statusCode: {
                    400: function (result, textStatus) {
                        console.log(result.responseText)
                        $('#modifyFailedMsg').text(result.responseText);
                        ModifyFailedModal.show();
                    }
                }
            });
        }

        var isQuestionModeChange = false;
        $(function () {
            // Modal變數
            QDeleteModal = new bootstrap.Modal(document.getElementById('QuestionDeleteCheckModal'), {
                keyboard: false
            });
            CreateFailedModal = new bootstrap.Modal(document.getElementById('CreateFailedModal'), {
                keyboard: false
            });
            ModifyFailedModal = new bootstrap.Modal(document.getElementById('ModifyFailedModal'), {
                keyboard: false
            });
            QuestionnaireModifyModal = new bootstrap.Modal(document.getElementById('QuestionnaireModifyCheckModal'), {
                keyboard: false
            });
            QuestionModifyModal = new bootstrap.Modal(document.getElementById('QuestionModifyCheckModal'), {
                keyboard: false
            });
            LeavePageModal = new bootstrap.Modal(document.getElementById('LeavePageModal'), {
                keyboard: false
            });

            // 答案和統計Tab不是Disabled,表示為修改模式
            if (!$('#vote-tab').prop('disabled') && !$('#statistic-tab').prop('disabled')) {

                $('#question-tab').click(function () {
                    SubmitStatus = 'QuestionModify';
                })

                $('#questionnaire-tab').click(function () {
                    SubmitStatus = 'QuestionnaireModify';
                })

                // 問卷頁的輸入欄change，Ajax存入後台Session
                $('#questionnaireTabContent input, #questionnaireTabContent textarea').on('change', function () {
                    let url = '/Handler/DetailHandler.ashx?QID=' + currentQuestionnaireID + '&Action=QuestionnaireModify';
                    $.ajax({
                        url: url,
                        type: "POST",
                        data: {
                            QuestionnaireTitle: $('#questionnaireName').val(),
                            Description: $('#description').val(),
                            StartDate: $('#startDate').val(),
                            EndDate: $('#endDate').val(),
                            Active: $('#activeCheck').prop('checked') ? 0 : 1
                        },
                        success: function (result, textStatus) {
                            console.log("Questionnaire Modify: " + result);
                            $('#questionnaire-tab').html('<img src="../img/modified.svg">問卷');
                            $('#btnQuestionnaireValidate').prop('disabled', false);
                        },
                        statusCode: {
                            400: function (result, textStatus) {
                                console.log('400result: ' + result);
                                console.log('400textStatus: ' + textStatus);
                            }
                        }
                    });
                })

                // 問題頁的加入(變更)紐，Ajax存入後台Session
                $("#btnQuestionAdd").on('click', function () {

                    if ($('input#question_title').hasClass('QValid') && $('input#question_option').hasClass('QValid')) {
                        let url = '/Handler/DetailHandler.ashx?QID=' + currentQuestionnaireID + '&Action=QuestionModify';

                        $.ajax({
                            url: url,
                            type: "POST",
                            data: {
                                questionJSON: JSON.stringify(createQuestionObject())
                            },
                            success: function (result, textStatus) {
                                console.log("Questionnaire Modify: " + result);
                                $('#question-tab').html('<img src="../img/modified.svg">問題');
                                $('#btnQuestionValidate').prop('disabled', false);
                            },
                            statusCode: {
                                400: function (result, textStatus) {
                                    console.log('400result: ' + result);
                                    console.log('400textStatus: ' + textStatus);
                                }
                            }
                        });
                    }
                })

                // 問題頁的刪除紐，Ajax存入後台Session
                $('#btnQuestionDelete').on('click', function () {
                    let url = '/Handler/DetailHandler.ashx?QID=' + currentQuestionnaireID + '&Action=QuestionModify';

                    $.ajax({
                        url: url,
                        type: "POST",
                        data: {
                            questionJSON: JSON.stringify(createQuestionObject())
                        },
                        success: function (result, textStatus) {
                            console.log("Questionnaire Modify: " + result);
                            $('#question-tab').html('<img src="../img/modified.svg">問題');
                            $('#btnQuestionValidate').prop('disabled', false);
                        },
                        statusCode: {
                            400: function (result, textStatus) {
                                console.log('400result: ' + result);
                                console.log('400textStatus: ' + textStatus);
                            }
                        }
                    });
                })
            }

            //新建按鈕
            $('#btnNewQuestionnaire').click(function () {
                SubmitStatus = 'New';
            })

            // 刪除checkbox註冊事件
            $('#questionTabContent tbody input[type=checkbox]').on('change', deleteCheckboxCheck);

            // 常用問題下拉選單事件
            $('select#questionMode').on('change', function () {
                isQuestionModeChange = true;
                if ($(this).val() == '-1') {
                    // 清空所有欄位
                    $('input#question_title').val('');
                    $('select#questionType > option:selected').prop('selected', false);
                    $('select#questionType > option[value=text]').prop('selected', true);
                    $('select#questionType').trigger('change');
                    $('#requiredCheck').prop('checked', false);
                    $('input#question_option').val('');
                } else {
                    // 從FAQJSONObj抓出資料填入
                    let index = Number($(this).val());
                    $('input#question_title').val(FAQJSONObj[index].QuestionTitle);
                    $('select#questionType > option:selected').prop('selected', false);
                    $('select#questionType > option[value=' + TypeNumToEnglish(FAQJSONObj[index].QuestionType) + ']').prop('selected', true);
                    $('select#questionType').trigger('change');
                    $('#requiredCheck').prop('checked', FAQJSONObj[index].QuestionRequired == 0 ? true : false);

                    let optionStr = '';
                    let count = 1;
                    for (let item of FAQJSONObj[index].Options) {
                        optionStr += item.OptionContent;
                        if (count++ != FAQJSONObj[index].Options.length)
                            optionStr += ' ; ';
                    }
                    $('input#question_option').val(optionStr);
                }
                isQuestionModeChange = false;
            })

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

            // 使用常用問題的情況下，有任何input變更就改回自訂
            $('input#question_title, input#requiredCheck, select#questionType, input#question_option').change(function () {
                if ($('select#questionMode option:selected').val() != '-1' && !isQuestionModeChange) {
                    $('#questionMode > option:selected').prop('selected', false);
                    $('#questionMode > option[value=-1]').prop('selected', true);
                }
            })

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
            $('#btnFront, #backList_link, #FAQPage_link, #linkQuestionnaireCancel, #linkQuestionCancel').click(function (event) {
                if ($('#questionnaire-tab').html() == '<img src="../img/modified.svg">問卷' || $('#question-tab').html() == '<img src="../img/modified.svg">問題') {
                    event.preventDefault();
                    event.stopPropagation();
                    $('#LeavePageModalLink').attr('href', $(this).attr('href'));
                    LeavePageModal.show();
                }
            })

            // form submit event
            $('form').submit(function (event) {
                let tbodyValidate = true;

                if (SubmitStatus == 'New' || SubmitStatus == 'QuestionnaireModify') {
                    $('input#questionnaireName').on('keyup', function () {
                        $(this).val($(this).val().trim());
                        let result = validateNullWhiteSpace($(this).val());

                        if (!result.isValid) {
                            $(this).siblings('.invalid-feedback').html(result.msg);
                            ChangeInvalid($(this));
                        } else {
                            ChangeValid($(this));
                        }
                    }).trigger('keyup');

                    $('input#startDate').on('change', startDateChange);
                    startDateChange();

                    $('input#endDate').on('change', endDateChange);
                    endDateChange();
                }


                if (SubmitStatus == 'New' || SubmitStatus == 'QuestionModify') {
                    tbodyValidate = checkQuestionTbody();    // 檢查問題列表
                }

                if (SubmitStatus == 'New') {
                    if (!$('input.myValidation').toArray().every(CheckHasValid) || !tbodyValidate) {
                        if (!CheckHasValid($('#questionnaireName')) || !CheckHasValid($('#startDate')) || !CheckHasValid($('#endDate'))) {
                            $('#validateMsg').css('visibility', 'visible');
                        } else {
                            $('#validateMsg').css('visibility', 'hidden');
                        }
                        event.preventDefault();
                        event.stopPropagation();
                    } else {
                        // 要傳輸到後台的Object
                        let QuestionnaireObj = {
                            QuestionnaireTitle: $('input#questionnaireName').val(),
                            Description: $('#description').val(),
                            StartDate: $('input#startDate').val(),
                            EndDate: $('input#endDate').val(),
                            Active: $('#activeCheck').prop('checked') ? 0 : 1
                        }

                        QuestionnaireObj.Questions = createQuestionObject();

                        // 放進HiddenField
                        $('input[id$=HFNewQuestionnaire]').val(JSON.stringify(QuestionnaireObj));
                        console.log(JSON.stringify(QuestionnaireObj))
                    }
                }
                else if (SubmitStatus == 'QuestionnaireModify') {
                    if (!CheckHasValid($('#questionnaireName')) || !CheckHasValid($('#startDate')) || !CheckHasValid($('#endDate'))) {
                        console.log('Questionnaire Modify Not Passed.')
                        event.preventDefault();
                        event.stopPropagation();
                    }
                    else {
                        QuestionnaireModifyModal.toggle();
                        event.preventDefault();
                        event.stopPropagation();
                    }
                }
                else if (SubmitStatus == 'QuestionModify') {
                    if (!tbodyValidate) {
                        event.preventDefault();
                        event.stopPropagation();
                        console.log('Question Modify Not Passed.')
                    }
                    else {
                        QuestionModifyModal.toggle();
                        event.preventDefault();
                        event.stopPropagation();
                    }
                }
                else {
                    event.preventDefault();
                    event.stopPropagation();
                }
            })

            $(document).on("keydown", "form", function (event) {
                return event.key != "Enter";
            });
        })
    </script>
</head>
<body>
    <form id="form1" runat="server">

        <asp:HiddenField ID="HFNewQuestionnaire" runat="server" EnableViewState="false" />

        <asp:Literal ID="ltlModalFailed" runat="server"></asp:Literal>

        <div class="front_div">
            使用者：<%= this.UserName %>
            <a class="btn btn-info" href="/Default.aspx" role="button" id="btnFront">前台</a>
        </div>

        <h3>後台-問卷管理</h3>
        <div class="row">
            <div class="col-2 mySideBar">
                <a class="btn btn-link" href="/SystemAdmin/QuestionnaireList.aspx" role="button" id="backList_link">問卷管理</a>
                <br />
                <a class="btn btn-link" href="FAQPage.aspx" role="button" id="FAQPage_link">常用問題管理</a>
                <br />
                <button type="button" class="btn btn-link" data-bs-toggle="modal" data-bs-target="#logoutModal">登出</button>
            </div>
            <div class="col-8 offset-1">

                <asp:Literal ID="ltlErrMsg" runat="server"></asp:Literal>

                <ul class="nav nav-tabs" id="questionnaireTab" role="tablist">
                    <li class="nav-item" role="presentation">
                        <button class="nav-link <%= questionnaireTabStatus %>" id="questionnaire-tab" data-bs-toggle="tab"
                            data-bs-target="#questionnaireTabContent" type="button" role="tab">
                            <%= questionnaireTabModifiedSvg %>問卷</button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link <%= questionTabStatus %>" id="question-tab" data-bs-toggle="tab"
                            data-bs-target="#questionTabContent" type="button" role="tab">
                            <%= questionTabModifiedSvg %>問題</button>
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
                            <asp:TextBox ID="questionnaireName" runat="server" CssClass="form-control myValidation"></asp:TextBox>
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
                            <asp:HyperLink ID="linkQuestionnaireCancel" runat="server" CssClass="btn btn-secondary" NavigateUrl="~/SystemAdmin/QuestionnaireList.aspx">取消</asp:HyperLink>
                            <asp:Button ID="btnQuestionnaireValidate" runat="server" Text="修改" CssClass="btn btn-primary" />
                        </div>
                    </div>
                    <div class="tab-pane fade <%= questionTabContentStatus %> " id="questionTabContent" role="tabpanel">
                        <div class="mb-3 row">
                            <label class="col-sm-1 col-form-label">種類</label>
                            <div class="col-sm-3">
                                <select class="form-select col-sm-10" id="questionMode">
                                    <option value="-1" selected>自訂</option>

                                    <asp:Literal ID="ltlFAQdropdown" runat="server" EnableViewState="false"></asp:Literal>

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
                                <div class="option_explain_div" <%= optionExplanationStyle %>>
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

                                    <asp:Literal ID="ltlQuestionTbody" runat="server" EnableViewState="false"></asp:Literal>

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

                            <asp:HyperLink ID="linkQuestionCancel" runat="server" CssClass="btn btn-secondary" NavigateUrl="~/SystemAdmin/QuestionnaireList.aspx">取消</asp:HyperLink>
                            <asp:Button ID="btnQuestionValidate" runat="server" Text="修改" CssClass="btn btn-primary" OnClientClick="NewOrModifyClick('QuestionModify')" />
                        </div>
                    </div>
                    <div class="tab-pane fade <%= answerTabContentStatus %>" id="voteTabContent" role="tabpanel">
                        <div class="mb-3">
                            <a role="button" class="btn btn-outline-info" href="/Handler/DetailHandler.ashx?Action=AnswerDownload&QID=<%= QuestionnaireID %>">
                                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-file-earmark-arrow-down" viewBox="0 0 16 16">
                                    <path d="M8.5 6.5a.5.5 0 0 0-1 0v3.793L6.354 9.146a.5.5 0 1 0-.708.708l2 2a.5.5 0 0 0 .708 0l2-2a.5.5 0 0 0-.708-.708L8.5 10.293V6.5z" />
                                    <path d="M14 14V4.5L9.5 0H4a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h8a2 2 0 0 0 2-2zM9.5 3A1.5 1.5 0 0 0 11 4.5h2V14a1 1 0 0 1-1 1H4a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1h5.5v2z" />
                                </svg>
                                匯出
                            </a>
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

                                    <asp:Literal ID="ltlAnswerTbody" runat="server"></asp:Literal>

                                </tbody>
                            </table>
                        </div>
                        <div class="offset-md-5 mb-3">
                            <uc1:ucPager runat="server" ID="ucPager" Url="Detail.aspx" AllowPageCount="5" />
                        </div>
                    </div>
                    <div class="tab-pane fade <%= statisticTabContentStatus %>" id="statisticTabContent" role="tabpanel">

                        <asp:Literal ID="ltlStatisticPane" runat="server"></asp:Literal>

                    </div>
                </div>
            </div>
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
                        <asp:Button ID="btnQuestionnaireModify" runat="server" CssClass="btn btn-primary" Text="確定" OnClientClick="btnQuestionnaireModify_Click()" />
                    </div>
                </div>
            </div>
        </div>
        <%--問題刪除確認Modal--%>
        <div class="modal fade" id="QuestionDeleteCheckModal" data-bs-keyboard="false" tabindex="-1"
            aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-body">
                        <div class="alert alert-danger" role="alert">
                            確定刪除問題嗎?
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
                        <button type="button" class="btn btn-primary" onclick="btnQuestionDeleteConfirm()" id="btnQuestionDelete">確定</button>
                    </div>
                </div>
            </div>
        </div>
        <%--問題修改確認Modal--%>
        <div class="modal fade" id="QuestionModifyCheckModal" data-bs-keyboard="false" tabindex="-1"
            aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-body">
                        <div class="alert alert-danger" role="alert">
                            即將修改問題內容，有可能造成回答資料遺失無法復原，確定執行嗎?
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
                        <asp:Button ID="btnQuestionModify" runat="server" Text="確定" CssClass="btn btn-primary" OnClientClick="btnQuestionModify_Click()" />
                    </div>
                </div>
            </div>
        </div>
        <%--新增失敗Modal--%>
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
                        <button type="button" class="btn btn-primary" data-bs-dismiss="modal">確定</button>
                    </div>
                </div>
            </div>
        </div>
        <%--修改失敗Modal--%>
        <div class="modal fade" id="ModifyFailedModal" data-bs-keyboard="false" tabindex="-1"
            aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-body">
                        <div class="alert alert-danger" role="alert">
                            修改失敗!<br />
                            <span id="modifyFailedMsg"></span>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-primary" data-bs-dismiss="modal">確定</button>
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
    </form>
</body>
</html>

// 檢查字串長度
function validateTxtWidth(txt, min = 1, max = 999) {
    if (min == max && txt.length != min)
        return { isValid: false, msg: '輸入欄必須是' + min + '個字元', code: 'NotEqualError' };
    if (txt.length < min && min == 1)
        return { isValid: false, msg: '輸入欄不可為空', code: 'EmptyError' };
    if (txt.length < min)
        return { isValid: false, msg: '長度最少要' + min + '個字元', code: 'minError' };
    if (txt.length > max)
        return { isValid: false, msg: '長度最多只能' + max + '個字元', code: 'maxError' };
    return { isValid: true };
}

// 檢查字串內容
function validateTxtContext(txt, alphabet = true, number = true, others = false) {
    if (alphabet && number && !others) {
        let result = txt.match(/[^0-9A-z]/);
        if (result != undefined)
            return { isValid: false, msg: '輸入內容必須是A-z或0-9' };
        return { isValid: true };
    } else if (!alphabet && number && !others) {
        let result = txt.match(/[^0-9]/);
        if (result != undefined)
            return { isValid: false, msg: '輸入內容必須是0-9' };
        return { isValid: true };
    }
}

// 檢查Email
function validateEmail(txt) {
    let result = txt.match(/\s/);
    if (result != undefined)
        return { isValid: false, msg: 'Email不可有空格', code: 'WhiteSpaceError' };

    let result2 = txt.match(/^.+@/);
    if (result2 == undefined)
        return { isValid: false, msg: 'Email格式不正確', code: 'ContentError' };
    return { isValid: true };
}

// 檢查日期
function validateDate(txt) {
    if (txt == '')
        return { isValid: false, msg: '請輸入日期' };

    let inputDate = new Date(txt);
    let year = Number(txt.split('-')[0]);
    if (year < 1940 || inputDate >= new Date(Date.now()))
        return { isValid: false, msg: '請輸入合理日期' };
    return { isValid: true };
}

// 檢查是否為空
function validateNullWhiteSpace(txt) {
    if (txt.length < 1)
        return { isValid: false, msg: '輸入欄不可為空', code: 'NullWhiteSpaceError' };
    return { isValid: true };
}

// 更動input的class和提示訊息
function ChangeInvalid(ele) {
    ele.removeClass('myValid').addClass('myInvalid')
        .siblings('.valid-feedback').css('display', 'none')
        .siblings('.invalid-feedback').css('display', 'block')
}
function ChangeValid(ele) {
    ele.addClass('myValid').removeClass('myInvalid')
        .siblings('.invalid-feedback').css('display', 'none')
        .siblings('.valid-feedback').css('display', 'block')
}

// 檢查原宿是否有myValid class
function CheckHasValid(item) {
    return $(item).hasClass('myValid');
}

/*
 * 1. 在要檢查的input上加上.myValidation，並在同層加上有.invalid-feedback和valid-feedback的div
 * 2. Validation.js要放在JQuery檔案後，並在之後的script裡加上：
 *      $('form').submit(function (event) {
 *          if (!$('input.myValidation').toArray().every(CheckHasValid)) {
 *              event.preventDefault()
 *              event.stopPropagation()
 *          }
 *      })
 * 3. 若有自訂義的規則，也要放在if之前(先判斷後才阻擋Submit)
 * 4. 可直接加入 .validateNullWhiteSpace .validateTextLength .validateEmail .validateDate .validateNumOnly .validateAlphNumOnly
 *    來直接套用規則
 * 5. 可套用複數規則，驗證順序照下面的執行順序
 * 
 *   (利用在input上加入data-validate屬性，並在某規則不通過時改成自身順序編號，達到可同時驗證複數規則)
 */

$(function () {
    $('form').submit(function (event) {

        $('input.myValidation').attr('data-validate', '100');

        // 是否空值
        $('input.myValidation.validateNullWhiteSpace').on('keyup', function () {
            if (Number($(this).attr('data-validate')) < 1)
                return;

            $(this).val($(this).val().trim());
            let result = validateNullWhiteSpace($(this).val());

            if (!result.isValid) {
                $(this).attr('data-validate', '1');

                $(this).siblings('.invalid-feedback').html(result.msg);
                ChangeInvalid($(this));
            } else {
                $(this).attr('data-validate', '100');

                ChangeValid($(this));
            }
        }).trigger('keyup');

        // 長度
        $('input.myValidation.validateTextLength').on('keyup', function () {
            if (Number($(this).attr('data-validate')) < 2)
                return;

            $(this).val($(this).val().trim());
            let min = $(this).attr("min") == undefined ? 1 : Number($(this).attr("min"));
            let max = $(this).attr("max") == undefined ? 999 : Number($(this).attr("max"));

            let result = validateTxtWidth($(this).val(), min, max);

            if (!result.isValid) {
                $(this).attr('data-validate', '2');

                $(this).siblings('.invalid-feedback').html(result.msg);
                ChangeInvalid($(this));
            } else {
                $(this).attr('data-validate', '100');

                ChangeValid($(this));
            }
        }).trigger('keyup');

        // Email
        $('input.myValidation.validateEmail[type=text]').on('keyup', function () {
            if (Number($(this).attr('data-validate')) < 3)
                return;

            let result = validateEmail($(this).val());

            if (!result.isValid) {
                $(this).attr('data-validate', '3');

                $(this).siblings('.invalid-feedback').html(result.msg);
                ChangeInvalid($(this));
            } else {
                $(this).attr('data-validate', '100');

                ChangeValid($(this));
            }

        }).trigger('keyup');

        // 日期
        $('input.myValidation.validateDate[type=date]').on('change', function () {
            if (Number($(this).attr('data-validate')) < 4)
                return;

            let result = validateDate($(this).val());

            if (!result.isValid) {
                $(this).attr('data-validate', '4');

                $(this).siblings('.invalid-feedback').html(result.msg);
                ChangeInvalid($(this));
            } else {
                $(this).attr('data-validate', '100');

                ChangeValid($(this));
            }
        }).trigger('change');

        // Number Only
        $('input.myValidation.validateNumOnly').on('keyup', function () {
            if (Number($(this).attr('data-validate')) < 5)
                return;

            let result = validateTxtContext($(this).val(), alphabet = false);

            if (!result.isValid) {
                $(this).attr('data-validate', '5');

                $(this).siblings('.invalid-feedback').html(result.msg);
                ChangeInvalid($(this));
            } else {
                $(this).attr('data-validate', '100');

                ChangeValid($(this));
            }
        }).trigger('keyup');

        // Alphabet Number Only
        $('input.myValidation.validateAlphNumOnly').on('keyup', function () {
            if (Number($(this).attr('data-validate')) < 6)
                return;

            let result = validateTxtContext($(this).val());

            if (!result.isValid) {
                $(this).attr('data-validate', '6');

                $(this).siblings('.invalid-feedback').html(result.msg);
                ChangeInvalid($(this));
            } else {
                $(this).attr('data-validate', '100');

                ChangeValid($(this));
            }
        }).trigger('keyup');

    });
});
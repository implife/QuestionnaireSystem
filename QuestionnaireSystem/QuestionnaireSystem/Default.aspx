<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="QuestionnaireSystem.Default" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>問卷列表</title>
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
        .all_blank_msg {
            padding-top: 17px;
            color: red;
            visibility: hidden;
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
        <h3>問卷調查</h3>
        <div class="search_div">
            <div class="row">
                <div class="form-floating col-md-3 offset-md-3">
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
                <div class="col-md-2 offset-md-3">
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
                    <label for="input_search_end" class="col-form-label">結束日</label>

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
            <div class="col-md-8 offset-md-2">
                <table class="table table-striped">
                    <thead>
                        <tr>
                            <th scope="col">#</th>
                            <th scope="col">問卷</th>
                            <th scope="col">狀態</th>
                            <th scope="col">開始時間</th>
                            <th scope="col">結束時間</th>
                            <th scope="col">觀看統計</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <th scope="row">543</th>
                            <td><a href="#">舞蹈馬諦斯-2021名人會客室</a></td>
                            <td>投票中</td>
                            <td>2021/09/01</td>
                            <td>2021/09/20</td>
                            <td><a href="#">前往</a></td>
                        </tr>
                        <tr>
                            <th scope="row">544</th>
                            <td><a href="#">舞蹈馬諦斯-2021名人會客室</a></td>
                            <td>投票中</td>
                            <td>2021/09/01</td>
                            <td>2021/09/20</td>
                            <td><a href="#">前往</a></td>
                        </tr>
                        <tr>
                            <th scope="row">545</th>
                            <td>舞蹈馬諦斯-2021名人會客室</td>
                            <td>已完結</td>
                            <td>2021/09/01</td>
                            <td>2021/09/20</td>
                            <td><a href="#">前往</a></td>
                        </tr>
                        <tr>
                            <th scope="row">545</th>
                            <td><a href="#">舞蹈馬諦斯-2021名人會客室</a></td>
                            <td>投票中</td>
                            <td>2021/09/01</td>
                            <td>2021/09/20</td>
                            <td><a href="#">前往</a></td>
                        </tr>
                        <tr>
                            <th scope="row">545</th>
                            <td>舞蹈馬諦斯-2021名人會客室</td>
                            <td>尚未開始</td>
                            <td>2021/09/01</td>
                            <td>2021/09/20</td>
                            <td>前往</td>
                        </tr>
                        <tr>
                            <th scope="row">545</th>
                            <td><a href="#">舞蹈馬諦斯-2021名人會客室</a></td>
                            <td>投票中</td>
                            <td>2021/09/01</td>
                            <td>2021/09/20</td>
                            <td><a href="#">前往</a></td>
                        </tr>
                        <tr>
                            <th scope="row">545</th>
                            <td><a href="#">舞蹈馬諦斯-2021名人會客室</a></td>
                            <td>投票中</td>
                            <td>2021/09/01</td>
                            <td>2021/09/20</td>
                            <td><a href="#">前往</a></td>
                        </tr>
                        <tr>
                            <th scope="row">545</th>
                            <td><a href="#">舞蹈馬諦斯-2021名人會客室</a></td>
                            <td>投票中</td>
                            <td>2021/09/01</td>
                            <td>2021/09/20</td>
                            <td><a href="#">前往</a></td>
                        </tr>
                        <tr>
                            <th scope="row">545</th>
                            <td><a href="#">舞蹈馬諦斯-2021名人會客室</a></td>
                            <td>投票中</td>
                            <td>2021/09/01</td>
                            <td>2021/09/20</td>
                            <td><a href="#">前往</a></td>
                        </tr>
                        <tr>
                            <th scope="row">545</th>
                            <td><a href="#">舞蹈馬諦斯-2021名人會客室</a></td>
                            <td>投票中</td>
                            <td>2021/09/01</td>
                            <td>2021/09/20</td>
                            <td><a href="#">前往</a></td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </form>
</body>
</html>

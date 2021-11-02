<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Detail.aspx.cs" Inherits="QuestionnaireSystem.SystemAdmin.Detail" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>問卷管理</title>
    <link href="../CSS/bootstrap.min.css" rel="stylesheet" />

    <script src="../Scripts/bootstrap.js"></script>
    <script src="../Scripts/jquery-3.6.0.min.js"></script>

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

        .mySideBar>a {
            margin: 10px 0;
            white-space: nowrap;
        }

        h3 {
            text-align: center;
            padding: 10px;
        }

        #questionnaireTabContent,
        #questionTabContent {
            /* border: 1px solid red; */
            padding: 15px 20px;
        }

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

        .btn-div {
            padding-left: 35%;
        }
    </style>
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
        <div class="col-7 offset-1">
            <ul class="nav nav-tabs" id="questionnaireTab" role="tablist">
                <li class="nav-item" role="presentation">
                    <button class="nav-link active" id="questionnaire-tab" data-bs-toggle="tab"
                        data-bs-target="#questionnaireTabContent" type="button" role="tab">問卷</button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" id="question-tab" data-bs-toggle="tab" data-bs-target="#questionTabContent"
                        type="button" role="tab">問題</button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" id="vote-tab" data-bs-toggle="tab" data-bs-target="#voteTabContent"
                        type="button" role="tab">填寫資料</button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" id="statistic-tab" data-bs-toggle="tab"
                        data-bs-target="#statisticTabContent" type="button" role="tab">統計</button>
                </li>
            </ul>
            <div class="tab-content">
                <div class="tab-pane fade show active" id="questionnaireTabContent" role="tabpanel">
                    <div class="mb-3">
                        <label for="questionnaireName" class="form-label">問卷名稱</label>
                        <input type="text" class="form-control" id="questionnaireName">
                    </div>
                    <div class="mb-3">
                        <label for="description" class="form-label">描述內容</label>
                        <textarea class="form-control" id="description" rows="5"></textarea>
                    </div>
                    <div class="mb-3">
                        <label for="startDate" class="form-label">開始日</label>
                        <input type="date" class="form-control" id="startDate">
                    </div>
                    <div class="mb-3">
                        <label for="endDate" class="form-label">結束日</label>
                        <input type="date" class="form-control" id="endDate">
                    </div>
                    <div class="mb-3">
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" value="" id="activeCheck" checked>
                            <label class="form-check-label" for="activeCheck">
                                啟用
                            </label>
                        </div>
                    </div>
                    <div class="mb-3 btn-div">
                        <button type="button" class="btn btn-secondary">取消</button>
                        <button type="button" class="btn btn-primary">修改</button>
                    </div>
                </div>
                <div class="tab-pane fade " id="questionTabContent" role="tabpanel">
                    <div class="mb-3 row">
                        <label id="questionType" class="col-sm-1 col-form-label">種類</label>
                        <div class="col-sm-3">
                            <select class="form-select col-sm-10">
                                <option selected>自訂</option>
                                <option value="1">One</option>
                                <option value="2">Two</option>
                                <option value="3">Three</option>
                            </select>
                        </div>
                    </div>
                    <div class="mb-3 row">
                        <label for="question_title" class="col-sm-1 col-form-label">問題</label>
                        <div class="col-5">
                            <input type="text" class="form-control" id="question_title">
                        </div>
                        <div class="col-sm-3">
                            <select class="form-select col-sm-10">
                                <option value="text" selected>文字方塊</option>
                                <option value="single">單選</option>
                                <option value="multi">複選</option>
                            </select>
                        </div>
                        <div class="col-sm-3 mt-2">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" value="" id="requiredCheck">
                                <label class="form-check-label" for="requiredCheck">
                                    必填
                                </label>
                            </div>
                        </div>
                    </div>
                    <div class="mb-3 row">
                        <label for="question_option" class="col-sm-1 col-form-label">選項</label>
                        <div class="col-5">
                            <input type="text" class="form-control" id="question_option">
                        </div>
                        <div class="col-3 mt-2">
                            多個選項以 ； 分隔
                        </div>
                        <div class="col-3">
                            <button type="button" class="btn btn-outline-success">送出</button>
                        </div>
                    </div>
                    <div class="mb-3 row">
                        <table class="table table-striped col-7">
                            <thead>
                                <tr>
                                    <th scope="col"><img src="../img/trash.svg" /></th>
                                    <th scope="col">#</th>
                                    <th scope="col">問題</th>
                                    <th scope="col">種類</th>
                                    <th scope="col">必填</th>
                                    <th scope="col">編輯</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <th scope="row"><input class="form-check-input" type="checkbox" value="" id="optionDelete1"></th>
                                    <td>1</td>
                                    <td>請問你最喜愛的甜食是?</td>
                                    <td>文字方塊</td>
                                    <td></td>
                                    <td><a href="#">編輯</a></td>
                                </tr>
                                <tr>
                                    <th scope="row"><input class="form-check-input" type="checkbox" value="" id="optionDelete2"></th>
                                    <td>2</td>
                                    <td>你對下列哪個程式語言有興趣?</td>
                                    <td>複選</td>
                                    <td><img src="../img/check-lg.svg" /></td>
                                    <td><a href="#">編輯</a></td>
                                </tr>
                                <tr>
                                    <th scope="row"><input class="form-check-input" type="checkbox" value="" id="optionDelete3"></th>
                                    <td>3</td>
                                    <td>請問你的性別是?</td>
                                    <td>單選</td>
                                    <td><img src="../img/check-lg.svg" /></td>
                                    <td><a href="#">編輯</a></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="tab-pane fade" id="voteTabContent" role="tabpanel">

                </div>
                <div class="tab-pane fade" id="statisticTabContent" role="tabpanel">

                </div>
            </div>
        </div>


    </div>
    </form>
</body>
</html>

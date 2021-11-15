<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Statistic.aspx.cs" Inherits="QuestionnaireSystem.Statistic" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>統計頁</title>
    <link href="CSS/bootstrap.min.css" rel="stylesheet" />

    <script src="Scripts/bootstrap.js"></script>
    <script src="Scripts/jquery-3.6.0.min.js"></script>
    <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>


    <style>
        h3 {
            text-align: center;
            padding: 10px;
        }

        .option_div {
            margin-left: 1.5rem;
        }

        .progress {
            padding: 0;
        }

        .progress_text {
            margin-top: -5px;
        }

        #switch_div_out {
            width: 500px;
            align-items: flex-end;
        }

        #switch_div {
            width: 100px;
            margin-left: auto;
            margin-right: 0px;
        }

        .chartTabContent {
            display: none;
            -webkit-animation: fadeEffect 1s;
            animation: fadeEffect .8s;
        }

        /* Fade in tabs */
        @-webkit-keyframes fadeEffect {
            from {
                opacity: 0;
            }

            to {
                opacity: 1;
            }
        }

        @keyframes fadeEffect {
            from {
                opacity: 0;
            }

            to {
                opacity: 1;
            }
        }
    </style>
    <script>
        var pieChartData = JSON.parse('<%= this.pieChartData %>');

        // AJAX API 下載完後呼叫
        function ParseDataAndDraw() {
            for (var item of pieChartData) {
                // Columns
                let resultCols = new Array();
                for (var col of item.columns) {
                    resultCols.push([col.optionName, col.votes]);
                }

                drawChart(item.title, resultCols, item.ID);
            }
        }

        // 畫Pie Chart
        function drawChart(title, columns, ID) {

            // Create the data table.
            var data = new google.visualization.DataTable();
            data.addColumn('string', 'Option');
            data.addColumn('number', 'vote');
            data.addRows(columns);

            // Set chart options
            var options = {
                'title': title,
                'width': 720,
                'height': 444,
                'is3D': true,
                'titleTextStyle': {
                    fontSize: 18
                }
            };

            // Instantiate and draw our chart, passing in some options.
            var chart = new google.visualization.PieChart(document.getElementById('chart_' + ID));
            chart.draw(data, options);
        }

        $(function () {

            google.charts.load('current', { 'packages': ['corechart'] });
            google.charts.setOnLoadCallback(ParseDataAndDraw);

            $('#PieChartSwitch').on('change', function () {
                if ($(this).prop('checked')) {
                    $('#pie_chart_container').css('display', 'block');
                    $('#progress_container').css('display', 'none');
                } else {
                    $('#pie_chart_container').css('display', 'none');
                    $('#progress_container').css('display', 'block');
                }
            })
        })
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <h3>
            <asp:Literal ID="ltlQuestionnaireTitle" runat="server"></asp:Literal>
        </h3>

        <div class="offset-4 mt-4">
            <div id="switch_div_out">
                <div class="form-check form-switch" id="switch_div">
                    <input class="form-check-input" type="checkbox" id="PieChartSwitch" />
                    <label class="form-check-label" for="PieChartSwitch">圓餅圖</label>
                </div>
            </div>

            <div class="chartTabContent" id="pie_chart_container">

                <asp:Literal ID="ltlPieChart" runat="server"></asp:Literal>

            </div>

            <div class="chartTabContent" id="progress_container" style="display: block">

                <asp:Literal ID="ltlProgress" runat="server"></asp:Literal>

            </div>
        </div>



        <div class="row mt-3 mb-5">
            <div class="col-md-3 offset-md-5">
                <a class="btn btn-secondary" href="Default.aspx" role="button">返回列表</a>
            </div>
        </div>
    </form>
</body>
</html>

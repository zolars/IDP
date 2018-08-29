<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!-- 引入struts的标签库-->
<%@ taglib uri="/struts-tags" prefix="s"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>

<head>
    <title>IDP数据中心动力管控系统</title>

    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0" />
    <meta name="format-detection" content="telephone=no">
    <meta charset="UTF-8">
    <meta name="description" content="Violate Responsive Admin Template">
    <meta name="keywords" content="Super Admin, Admin, Template, Bootstrap">

    <!-- CSS -->
    <link rel="stylesheet" type="text/css" href="css/bootstrap-3.3.4.css">
    <link href="css/animate.min.css" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="css/font-awesome.4.6.0.css">
    <link href="css/form.css" rel="stylesheet">
    <link href="css/media-player.css" rel="stylesheet">
    <link href="css/calendar.css" rel="stylesheet">
    <link href="css/style.css" rel="stylesheet">
    <link href="css/icons.css" rel="stylesheet">
    <link href="css/generics.css" rel="stylesheet">
    <link rel="stylesheet" href="css/jquery.hotspot.css">
    <link href="css/menu.css" rel="stylesheet">
    <link href="css/mycss.css" rel="stylesheet">

</head>
<style type="text/css">
    .r_out {
        width: 120px;
        height: 120px;
        border: 2px solid #d9d9d9;
        background: #fff;
        box-shadow: 3px 3px 5px #bfbfbf;
        -webkit-box-shadow: 3px 3px 5px #bfbfbf;
        -moz-box-shadow: 3px 3px 5px #bfbfbf;
        -ms-box-shadow: 3px 3px 5px #bfbfbf;
        border-radius: 50%;
        -webkit-border-radius: 50%;
        -moz-border-radius: 50%;
        -ms_border-radius: 50%;
        display: inline-block;
        margin-right: 90px;
        position: relative;
    }

    .r_out p {
        position: absolute;
        /**bottom:-50px;*/
        color: #fff;
        text-align: center;
        margin: 0 auto;
        width: 100%;
        font-size: 14px;
        line-height: 1.5;
        font-weight: bold;
    }

    .r_in {
        width: 120px;
        height: 120px;
        border: 10px solid #fff;
        border-radius: 50%;
        -webkit-border-radius: 50%;
        -moz-border-radius: 50%;
        -ms_border-radius: 50%;
        overflow: hidden;
        position: relative;
    }

    .r_c {
        width: 120px;
        height: 120px;
        position: absolute;
        bottom: 0;
        left: 0;
        height: 0;
    }

    .c1 {
        background: #fbad4c;
    }

    .c2 {
        background: #fff143;
    }

    .c3 {
        background: #c9dd22;
    }

    .c4 {
        background: #00e079;
    }

    .c5 {
        background: #0eb83a;
    }

    .r_num {
        color: #404040;
        font-size: 23px;
        line-height: 1.5;
        font-weight: bold;
        position: absolute;
        top: 50%;
        margin-top: -25px;
        text-align: center;
        width: 100%;
    }

    #triangle-right {
        width: 0;
        height: 0;
        border-top: 15px solid transparent;
        border-left: 15px solid #DB241C;
        border-bottom: 15px solid transparent;
    }

    .alert-lost {
        padding: 5px;
        margin-top: 10px;
        margin-bottom: -8px;
        font-size: 14px;
    }
</style>

<body id="skin-blur-blue">

    <header id="header" class="media">
        <a href="" id="menu-toggle"></a>
        <a class="logo pull-left" href="province.jsp">IDP数据中心动力管控系统</a>

        <div class="media-body">
            <div class="media" id="top-menu">
                <div class="pull-left location-select">
                    <select class="form-control location-select-item" id="province_code" name="province_code" onchange="getCity()">
                        <option value="">请选择</option>
                    </select>

                    <select class="form-control location-select-item" id="city_code" name="city_code" onchange="getComproom()">
                        <option value="">请选择</option>
                    </select>

                    <select class="form-control location-select-item" id="comproom_code" name="comproom_code">
                        <option value="">请选择</option>
                    </select>
                </div>

                <div class="pull-right">欢迎用户${username}登录</div>

            </div>
        </div>
    </header>

    <div class="clearfix"></div>

    <section id="main" class="p-relative" role="main">
        <!-- Sidebar -->
        <!-- 动态加载菜单项 -->
        <aside id="sidebar">
            <ul id="ulbar" class="list-unstyled side-menu" style="width: 100%!important;padding-top: 20px;">
            </ul>
        </aside>

        <!-- Content -->
        <section id="content" class="container">

            <!-- Breadcrumb -->

            <!-- Main Widgets -->

            <div class="block-area">
                <div class="row">

                    <div class="col-md-12">
                        <ul class="nav nav-tabs" id="ulItem">
                            <li class="active"  style="width:15%">
                                <a data-toggle="tab" id="subItem2">•事件分析</a>
                            </li>
                            <li style="width:15%">
                                <a data-toggle="tab" id="subItem3">•能效分析</a>
                            </li>
                        </ul>
                    </div>

                    <div id = "item2" class="col-md-2 col-xs-6" style="width:90%; height: 600px;">

                        <button type="button" class="btn btn-sm btn-alt" onClick="getDeviceEvent()" >设备事件</button>
                        <button type="button" class="btn btn-sm btn-alt" onClick="getPowerEvent()" >电能质量事件</button>
                        <button type="button" class="btn btn-sm btn-alt" onClick="getEvironmentEvent()" >环境事件</button>

                        <div class="block-area">
                            <div class="row">
                                <div class="col-md-10">

                                    <table id="event-table-head1">
                                        <thead>
                                        <tr>
                                            <th><img src="/img/setting.jpg" alt="" onClick="settingIcon()" ></th>
                                            <th><img src="/img/refresh.jpg" alt="" onClick="refreshIcon()" ></th>
                                            <th><button type="button" class="btn btn-sm btn-alt" onClick="exportTable()" >导出</button></th>
                                            <th><button type="button" class="btn btn-sm btn-alt" onClick="printTable()" >打印</button></th>
                                        </tr>
                                        </thead>
                                    </table>

                                    <!--startprint-->

                                    <div class="tile">
                                        <h2 class="tile-title">
                                           <%-- <table id="event-table-head2">
                                                <thead>
                                                <tr>
                                                    <th><div style="padding-left:40px;">事件名称</div></th>
                                                    <th><div style="padding-left:20px;">位置</div></th>
                                                    <th><div style="padding-left:40px;">事件类型</div></th>
                                                    <th><div style="padding-left:40px;">事件描述</div></th>
                                                    <th><div style="padding-left:40px;">事件发生时间</div></th>
                                                </tr>
                                                </thead>
                                            </table>--%>
                                            <table id="event-table-body">
                                                <tr>
                                                    <th><div style="padding-left:60px;">事件名称</div></th>
                                                    <th><div style="padding-left:60px;">位置</div></th>
                                                    <th><div style="padding-left:60px;">事件类型</div></th>
                                                    <th><div style="padding-left:60px;">事件描述</div></th>
                                                    <th><div style="padding-left:60px;">事件发生时间</div></th>
                                                </tr>
                                            </table>
                                        </h2>

                                        <table id="event-table-1"></table>
                                        <table id="event-table-2"></table>
                                        <table id="event-table-3"></table>
                                    </div>

                                    <!--endprint-->




                                </div>
                            </div>
                        </div>



                    </div>

                    <div id = "item3" class="col-md-2 col-xs-6" style="width:90%; height: 600px;">
                        能效分析
                    </div>


                </div>
            </div>
        </section>

    </section>

    <!-- Javascript Libraries -->
    <!-- jQuery -->
    <script src="js/jquery-3.3.1.js"></script>

    <!-- Bootstrap -->
    <script src="js/bootstrap.min.js"></script>

    <!-- Charts -->
    <script src="js/charts/jquery.flot.js"></script>
    <!-- Flot Main -->
    <script src="js/charts/jquery.flot.time.js"></script>
    <!-- Flot sub -->
    <script src="js/charts/jquery.flot.animator.min.js"></script>
    <!-- Flot sub -->
    <script src="js/charts/jquery.flot.resize.min.js"></script>
    <!-- Flot sub - for repaint when resizing the screen -->

    <script src="js/sparkline.min.js"></script>
    <!-- Sparkline - Tiny charts -->
    <script src="js/easypiechart.js"></script>
    <!-- EasyPieChart - Animated Pie Charts -->
    <script src="js/charts.js"></script>
    <!-- All the above chart related functions -->
    <!--Media Player-->
    <script src="js/media-player.min.js"></script>
    <!-- USA Map for jVectorMap -->
    <!-- Map -->
    <script src="js/maps/jvectormap.min.js"></script>
    <!-- jVectorMap main library -->
    <script src="js/maps/usa.js"></script>
    <!-- USA Map for jVectorMap -->

    <!--  Form Related -->
    <script src="js/icheck.js"></script>
    <!-- Custom Checkbox + Radio -->

    <!-- UX -->
    <script src="js/scroll.min.js"></script>
    <!-- Custom Scrollbar -->
    <script src="js/select.min.js"></script>
    <!-- Custom Select -->
    <!-- Other -->
    <script src="js/calendar.min.js"></script>
    <!-- Calendar -->
    <script src="assets/amcharts/amcharts.js" type="text/javascript"></script>
    <script src="assets/amcharts/serial.js" type="text/javascript"></script>
    <script src="js/jquery.datetimepicker.js" type="text/javascript"></script>
    <!--  		 <script src="js/feeds.min.js"></script> News Feeds -->
    <!-- All JS functions -->
    <script src="js/functions.js"></script>
    <script src="js/echarts.js"></script>

    <!-- 省\市\机房下拉菜单-->
    <script type="text/javascript">
        /*加载省下拉选*/
        var provinceid="<%=session.getAttribute("probank")%>";
        if(provinceid){
            $('#province_code').append("<option value='" + provinceid + "' >" + provinceid + "</option>");
        }

        /*加载市下拉选*/
        function getCity() {
            var pname="<%=session.getAttribute("probank")%>";

            $("#city_code").empty();
            $("#comproom_code").empty();

            $.ajax({
                type: "post",
                url: "getCityTree",
                data: {provinceid: pname},
                dataType : "json",
                success: function (data) {

                    $('#city_code').append("<option value='' selected='selected' >" + '请选择' + "</option>");
                    $('#comproom_code').append("<option value='' selected='selected' >" + '请选择' + "</option>");

                    var obj = eval("(" + data + ")");
                    for (var i = 0; i < obj.length; i++) {
                        $('#city_code').append("<option value='" + obj[i].cbname + "' >" + obj[i].cbname + "</option>");
                    }
                }
            });
        }

        /*加载机房下拉选*/
        function getComproom() {
            var cname = $("#city_code").val();

            $("#comproom_code").empty();

            $.ajax({
                type: "post",
                url: "getCompTree",
                data: {cityid: cname},
                dataType : "json",
                success: function (data) {
                    var list = data.allcomputerroom;

                    $('#comproom_code').append("<option value='' selected='selected' >" + '请选择' + "</option>");
                    for (var i = 0; i < list.length; i++) {
                        $('#comproom_code').append("<option value='" + list[i].rid + "' >" + list[i].rname + "</option>");
                    }
                }
            });
        }

    </script>

    <!-- 动态加载菜单项 -->
    <script type="text/javascript">
        var menulist="<%=session.getAttribute("menulist")%>";
        var cbidstr = menulist.split(",");
        var isSystemMng = false;
        var isNewSystemMng = false;

        //处理第一个和最后一个
        cbidstr[0] = cbidstr[0].substring(1);
        cbidstr[0] = " " + cbidstr[0];

        var idx = cbidstr.length - 1;
        var len = cbidstr[idx].length;
        cbidstr[idx] = cbidstr[idx].substring(0, len - 1);

        for(var i = 0; i < cbidstr.length; i++){

            var menuname = "";
            if(cbidstr[i] == " province.jsp"){
                isSystemMng = false;
                menuname = "集中监控";
            }
            else if(cbidstr[i] == " efficiencyDevice.jsp"){
                isSystemMng = false;
                menuname = "动力设施";
            }
            else if(cbidstr[i] == " onlineDetect.jsp"){
                isSystemMng = false;
                menuname = "在线监测";
            }
            else if(cbidstr[i] == ' efficiencyAnalysis.jsp'){
                isSystemMng = false;
                menuname = "动力分析";
            }
            else if(cbidstr[i] == ' efficiencyAssessment.jsp'){
                isSystemMng = false;
                menuname = "动力评估";
            }
            else if(cbidstr[i] == ' reportChart.jsp'){
                isSystemMng = false;
                menuname = "报表功能";
            }
            else if(cbidstr[i] == ' history.jsp'){
                isSystemMng = false;
                menuname = "历史曲线";
            }
            else if(cbidstr[i].search('systemMng.jsp')){

                if(!isNewSystemMng)
                {//第一条systemMng的
                    isNewSystemMng = true;
                    menuname = "系统管理";
                    $('#ulbar').append("<li><a href='systemMng.jsp' id='menuurl'><i class='fa fa-calendar-o'></i><span>" + menuname + "</span></a></li>");
                }
                isSystemMng = true;
            }

            if(!isSystemMng) $('#ulbar').append("<li><a href='" + cbidstr[i] + "'  id='menuurl'><i class='fa fa-calendar-o'></i><span>" + menuname + "</span></a></li>");
        }
    </script>

    <!-- 切换子菜单-->
    <script type="text/javascript">
       // $("#item1").show();
        $("#item2").show();
        $("#item3").hide();
        $(document).ready(function() {
           /* $("#subItem1").click(function () {
               // $("#item1").show();
                $("#item2").hide();
                $("#item3").hide();
            });*/
            $("#subItem2").click(function () {
              //  $("#item1").hide();
                $("#item2").show();
                $("#item3").hide();
            });
            $("#subItem3").click(function () {
             //   $("#item1").hide();
                $("#item2").hide();
                $("#item3").show();
            });
        });
    </script>

    <!-- 切换子菜单subItem效果-->
    <script type="text/javascript">
        $(function(){

            $("#ulItem li").click(function() {

                $(this).siblings('li').removeClass('active');  // 删除其他兄弟元素的样式selected

                $(this).addClass('active');                            // 添加当前元素的样式

            });

        });
    </script>

    <!-- 测试 设备事件-->
    <script type="text/javascript">
        function getDeviceEvent(){

            var stime = "2018-08-22 08:00:00";
            var etime = "2018-08-29 08:00:00";
            var rid = "1";

            $.ajax({
                type: "post",
                url: "getDeviceEvent",
                data: {
                    stime: stime,
                    etime: etime,
                    rid: rid
                },
                dataType : "json",
                success: function (data) {
                    var obj = JSON.parse(data);
                    var list = obj['alldelist'];
                    var table = $("#event-table-body");
                    table.empty();
                    table.append('<tr><td style="padding-left:60px;">事件名称</td><td style="padding-left:60px;">位置</td><td style="padding-left:60px;">事件类型</td><td style="padding-left:60px;">事件描述</td><td style="padding-left:60px;">事件发生时间</td></tr>');

                    for (var i = 0; i < list.length; i++) {
                        var name = list[i].type;
                        var location = list[i].mpid;
                        var type = list[i].subtype;
                        var description = list[i].discription;
                        var time = list[i].time;

                        table.append('<tr>' +
                            '<td style="padding-left:60px;">' + name + '</td><td style="padding-left:60px;">' + location + '</td>' +
                            '<td style="padding-left:60px;">' + type + '</td><td style="padding-left:60px;">' + description + '</td>' +
                            '<td style="padding-left:60px;">' + time + '</td><td style="padding-left:60px;">' + '</td></tr>');
                    }
                }
            });
        }
    </script>

    <!-- 测试 电能事件-->
    <script type="text/javascript">
        function getPowerEvent(){

            var stime = "2018-08-22 08:00:00";
            var etime = "2018-08-29 08:00:00";
            var rid = "1";

            $.ajax({
                type: "post",
                url: "getPowerEvent",
                data: {
                    stime: stime,
                    etime: etime,
                    rid: rid
                },
                dataType : "json",
                success: function (data) {
                    var obj = JSON.parse(data);
                    var list = obj['allpelist'];
                    var table = $("#event-table-body");
                    table.empty();
                    table.append('<tr><td style="padding-left:60px;">事件名称</td><td style="padding-left:60px;">位置</td><td style="padding-left:60px;">事件类型</td><td style="padding-left:60px;">事件描述</td><td style="padding-left:60px;">事件发生时间</td></tr>');

                    for (var i = 0; i < list.length; i++) {
                        var name = list[i].type;
                        var location = list[i].mpid;
                        var type = list[i].subtype;
                        var description = list[i].discription;
                        var time = list[i].time;

                        table.append('<tr>' +
                            '<td style="padding-left:60px;">' + name + '</td><td style="padding-left:60px;">' + location + '</td>' +
                            '<td style="padding-left:60px;">' + type + '</td><td style="padding-left:60px;">' + description + '</td>' +
                            '<td style="padding-left:60px;">' + time + '</td><td style="padding-left:60px;">' + '</td></tr>');
                    }
                }
            });
        }
    </script>

    <!-- 测试 环境事件-->
    <script type="text/javascript">
        function getEvironmentEvent(){
            var stime = "2018-08-22 08:00:00";
            var etime = "2018-08-29 08:00:00";
            var rid = "1";

            $.ajax({
                type: "post",
                url: "getEnvironmentEvent",
                data: {
                    stime: stime,
                    etime: etime,
                    rid: rid
                },
                dataType : "json",
                success: function (data) {
                    var obj = JSON.parse(data);
                    var list = obj['alleelist'];
                    var table = $("#event-table-body");
                    table.empty();
                    table.append('<tr><td style="padding-left:60px;">事件名称</td><td style="padding-left:60px;">位置</td><td style="padding-left:60px;">事件类型</td><td style="padding-left:60px;">事件描述</td><td style="padding-left:60px;">事件发生时间</td></tr>');

                    for (var i = 0; i < list.length; i++) {
                        var name = list[i].type;
                        var location = list[i].mpid;
                        var type = list[i].subtype;
                        var description = list[i].discription;
                        var time = list[i].time;

                        table.append('<tr>' +
                            '<td style="padding-left:60px;">' + name + '</td><td style="padding-left:60px;">' + location + '</td>' +
                            '<td style="padding-left:60px;">' + type + '</td><td style="padding-left:60px;">' + description + '</td>' +
                            '<td style="padding-left:60px;">' + time + '</td><td style="padding-left:60px;">' + '</td></tr>');
                    }
                }
            });
        }
    </script>

    <!-- 设置icon-->
    <script type="text/javascript">
        function settingIcon(){
            alert("设置icon");
        }
    </script>

    <!-- 刷新icon-->
    <script type="text/javascript">
        function refreshIcon(){
            alert("刷新icon");
        }
    </script>

    <!-- 导出-->
    <script type="text/javascript">

        function exportTable(){
            alert("导出");
            var tableid = "event-table-body";
            exportToExcel(tableid);
        }

        var idTmr;
        function getExplorer() {
            var explorer = window.navigator.userAgent ;
            //ie
            if (explorer.indexOf("MSIE") >= 0) {
                return 'ie';
            }
            //firefox
            else if (explorer.indexOf("Firefox") >= 0) {
                return 'Firefox';
            }
            //Chrome
            else if(explorer.indexOf("Chrome") >= 0){
                return 'Chrome';
            }
            //Opera
            else if(explorer.indexOf("Opera") >= 0){
                return 'Opera';
            }
            //Safari
            else if(explorer.indexOf("Safari") >= 0){
                return 'Safari';
            }
        }

        function exportToExcel(tableid ) {//整个表格拷贝到EXCEL中
            if(getExplorer()=='ie'){
                var curTbl = document.getElementById(tableid);
                var oXL = new ActiveXObject("Excel.Application");

                //创建AX对象excel
                var oWB = oXL.Workbooks.Add();
                //获取workbook对象
                var xlsheet = oWB.Worksheets(1);
                //激活当前sheet
                var sel = document.body.createTextRange();
                sel.moveToElementText(curTbl);
                //把表格中的内容移到TextRange中
                sel.select;
                //全选TextRange中内容
                sel.execCommand("Copy");
                //复制TextRange中内容
                xlsheet.Paste();
                //粘贴到活动的EXCEL中
                oXL.Visible = true;
                //设置excel可见属性

                try {
                    var fname = oXL.Application.GetSaveAsFilename("Excel.xls", "Excel Spreadsheets (*.xls), *.xls");
                } catch (e) {
                    print("Nested catch caught " + e);
                } finally {
                    oWB.SaveAs(fname);
                    oWB.Close(savechanges = false);
                    //xls.visible = false;
                    oXL.Quit();
                    oXL = null;
                    //结束excel进程，退出完成
                    //window.setInterval("Cleanup();",1);
                    idTmr = window.setInterval("Cleanup();", 1);
                }
            }else{
                tableToExcel(tableid)
            }
        }

        function Cleanup() {
            window.clearInterval(idTmr);
            CollectGarbage();
        }

        var tableToExcel = (function() {
            var uri = 'data:application/vnd.ms-excel;base64,',
                template = '<html xmlns:o="urn:schemas-microsoft-com:office:office" '
                    +'xmlns:x="urn:schemas-microsoft-com:office:excel" '
                    +'xmlns="http://www.w3.org/TR/REC-html40">'
                    +'<head>'
                    +'<!--[if gte mso 9]>'
                    +'<xml>'
                    +'<x:ExcelWorkbook>'
                    +'<x:ExcelWorksheets>'
                    +'<x:ExcelWorksheet>'
                    +'<x:Name>{worksheet}</x:Name>'
                    +'<x:WorksheetOptions><x:DisplayGridlines/></x:WorksheetOptions>'
                    +'</x:ExcelWorksheet>'
                    +'</x:ExcelWorksheets>'
                    +'</x:ExcelWorkbook>'
                    +'</xml>'
                    +'<![endif]-->'
                    +'</head>'
                    +'<body><table>{table}</table></body>'
                    +'</html>',

                base64 = function(s) { return window.btoa(unescape(encodeURIComponent(s))) },
                format = function(s, c) {
                    return s.replace(/{(\w+)}/g,
                        function(m, p) { return c[p]; }) }

            return function(table, name) {
                if (!table.nodeType) table = document.getElementById(table)
                var ctx = {worksheet: name || 'Worksheet', table: table.innerHTML}
                window.location.href = uri + base64(format(template, ctx))
            }
        })()

    </script>

    <!-- 打印-->
    <script type="text/javascript">
        function printTable(){
            window.document.title = "";
            window.document.URL = "";

            bdhtml = window.document.body.innerHTML;
            sprnstr = "<!--startprint-->";
            eprnstr = "<!--endprint-->";
            prnhtml = bdhtml.substr(bdhtml.indexOf(sprnstr) + 17);
            prnhtml = prnhtml.substring(0, prnhtml.indexOf(eprnstr));
            window.document.body.innerHTML = prnhtml;
            window.print();
            setTimeout(location.reload(), 3000);
        }

    </script>

</body>

</html>
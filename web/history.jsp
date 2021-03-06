<%@ page language="java" import="java.util.*" pageEncoding="UTF-8" %>

<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
    <title>IDP数据中心动力管控系统</title>

    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0"/>
    <meta name="format-detection" content="telephone=no">
    <meta charset="UTF-8">
    <meta name="description" content="Violate Responsive Admin Template">
    <meta name="keywords" content="Super Admin, Admin, Template, Bootstrap">

    <!-- CSS -->
    <link rel="stylesheet" type="text/css" href="css/bootstrap-3.3.4.css">
    <link href="css/animate.min.css" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="css/font-awesome.4.6.0.css">
    <link href="css/form.css" rel="stylesheet">
    <link href="css/calendar.css" rel="stylesheet">
    <link href="css/media-player.css" rel="stylesheet">
    <link href="css/style.css" rel="stylesheet">
    <link href="css/icons.css" rel="stylesheet">
    <link href="css/generics.css" rel="stylesheet">
    <link href="css/menu.css" rel="stylesheet">
    <link href="css/mycss.css" rel="stylesheet">
    <link href="css/jstree-default/style.css" rel="stylesheet"/>
    <link rel="stylesheet" href="css/header.css">
    <link href="css/buttons.css" rel="stylesheet">

    <!-- bootstrap datepicker时间选择控件 -->
    <link href="bootstrap-timepicker/css/bootstrap-datetimepicker.min.css" rel="stylesheet" media="screen">

    <!-- jquery -->
    <script type="text/javascript" src="bootstrap-timepicker/js/jquery-1.8.3.min.js" charset="UTF-8"></script>
    <style>
        .datetimepicker {
            background: black!important;
        }
    </style>
</head>

<body id="skin-blur-blue">

<script src="js/jquery-3.3.1.js"></script>
<script src="js/jquery.cookie.js"></script>

<!-- PNotify -->
<script type="text/javascript" src="js/pnotify.custom.min.js"></script>
<link href="css/pnotify.custom.min.css" rel="stylesheet" type="text/css" />

<!--告警弹窗-->
<script type="text/javascript" src = "js/websocketconnect.js"></script>

<!--登陆认证拦截-->
<%
    String userid = (String)session.getAttribute("userid");
    if(userid == null) {
%>
<script>
    alert('您还未登录或您的认证已过期, 请先登陆.');
    window.location.href = <%=basePath%>+'index.jsp';
</script>
<%
    }
%>

<header id="header" class="media">
    <div class="header-left">
        <a href="" id="menu-toggle"></a>
        <img src="img/index/logo.png" alt="" class="header-img">
    </div>
    <div class="header-right">
        <div class="media" id="top-menu">
            <div class="pull-left location-select">
                <select class="form-control location-select-item" id="province_code" name="province_code">
                    <option value="">请选择</option>
                </select>

                <script>
                    $("#province_code").change(function(){
                        var options = $("#province_code option:selected");
                        $. cookie('opinion1', options.text(), {expires: 1, path: '/'});
                        getCity();
                    })
                </script>

                <select class="form-control location-select-item" id="city_code" name="city_code">
                    <option value="">请选择</option>
                </select>

                <script>
                    $("#city_code").change(function(){
                        var options = $("#city_code option:selected");
                        $. cookie('opinion2', options.text(), {expires: 1, path: '/'});
                        getComproom();
                    })

                </script>

                <select class="form-control location-select-item" id="comproom_code" name="comproom_code">
                    <option value="">请选择</option>
                </select>

                <script>
                    $("#comproom_code").change(function(){
                        var options = $("#comproom_code option:selected");
                        $. cookie('opinion3', options.text(), {expires: 1, path: '/'});
                    })
                </script>

            </div>

            <!-- 注销按钮 -->
            <div class="pull-right header-right-text">
                <a class="header-logout" href="index.jsp">注销</a>
            </div>
            <div class="pull-right header-right-text">欢迎用户${username}登录</div>

        </div>
    </div>
</header>

<div class="clearfix"></div>

<section id="main" class="p-relative" role="main">

    <!-- Sidebar -->
    <!-- 动态加载菜单项 -->
    <aside id="sidebar">
        <ul id="ulbar" class="list-unstyled side-menu" style="width: 100%!important;">
        </ul>
    </aside>

    <!-- Content -->
    <section id="content" class="container">
        <!-- Main Widgets -->
        <div class="block-area" style="position:relative;">

            <div class="row" style="position:absolute;z-index: 0;width: 100%;">
                <div class="col-md-12">
                    <ul class="nav nav-tabs" id="ulItem" style="margin-bottom: 20px">
                        <li style="width:50%">
                            <a data-toggle="tab" id="subItem2">•历史曲线</a>
                        </li>
                       <%-- <li style="width:50%">
                            <a data-toggle="tab" id="subItem3">•知识库</a>
                        </li>--%>
                    </ul>

                    <div id="item2" class="col-md-2 col-xs-6" style="width:90%; height: 600px;">
                        <div class="col-md-2">
                            <select id='item2-menu' class="form-control" onchange="showinfo(this[selectedIndex].value)">
                                <option value="item2-1">电压/电流</option>
                                <option value="item2-2">频率</option>
                                <option value="item2-3">功率</option>
                                <option value="item2-4">浪涌/塌陷</option>
                                <option value="item2-5">谐波总畸变率</option>
                                <option value="item2-6">温度</option>
                                <option value="item2-7">湿度</option>
                            </select>
                        </div>
                        <div id = "powermp" class="col-md-2">
                            <select class="form-control" name="his-mpid-select" id="his-mpid-select"
                                    onclick="getMonitorPoints()" value="选择检测点">
                            </select>
                        </div>

                        <div id = "tempmp" class="col-md-2" style="display: none;">
                            <select class="form-control" name="his-temp-mpid-select" id="his-temp-mpid-select"
                                    onclick="getMonitorPointsEnvironment()"  value="选择检测点">
                            </select>
                        </div>

                        <div class="col-md-6">
                            <div class="container">
                                <form action="" class="form-horizontal" role="form">
                                    <div class="form-group">
                                        <label for="dtp_input1" class="control-label">开始日期</label>
                                        <div class="input-group date form_datetime col-md-5"
                                             data-date-format="yyyy-mm-dd hh:ii:ss"
                                             data-link-field="dtp_input1">
                                            <input id="firstDate" class="form-control" size="16" type="text"
                                                   value="" readonly>
                                            <span class="input-group-addon"><span
                                                    class="glyphicon glyphicon-th"></span></span>
                                        </div>
                                        <input type="hidden" id="dtp_input1" value=""/><br/>
                                    </div>

                                    <div class="form-group">
                                        <label for="dtp_input2" class="control-label">结束日期</label>
                                        <div class="input-group date form_datetime col-md-5"
                                             data-date-format="yyyy-mm-dd hh:ii:ss"
                                             data-link-field="dtp_input1">
                                            <input id="lastDate" class="form-control" size="16" type="text" value=""
                                                   readonly>
                                            <span class="input-group-addon"><span
                                                    class="glyphicon glyphicon-th"></span></span>
                                        </div>
                                        <input type="hidden" id="dtp_input2" value=""/><br/>
                                    </div>
                                </form>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <button type="button" class="button-primary button-pill button-small" id="serch-his-button" onclick="searchHis()">查询</button>
                        </div>

                        <div class="clearfix"></div>
                        <ul>
                            <li id='item2-1'>
                                <div id="item2-UI-ctrl">
                                    <ul>
                                        <li class="mark-ctrl">
                                            <input type="checkbox" value='max'>最大值
                                            <input type="checkbox" value='min'>最小值
                                            <input type="checkbox" value='average'>平均值
                                        </li>
                                        <li class="series-ctrl">
                                            <input class="default-show" type="checkbox" name="" value="u1">U1
                                            <input type="checkbox" name="" value="u2">U2
                                            <input type="checkbox" name="" value="u3">U3
                                            <input type="checkbox" name="" value="u4">U4
                                            <input class="default-show" type="checkbox" name="" value="i1">I1
                                            <input type="checkbox" name="" value="i2">I2
                                            <input type="checkbox" name="" value="i3">I3
                                            <input type="checkbox" name="" value="i4">I4
                                        </li>
                                    </ul>
                                </div>
                                <div id='item2-UI' class="chart-item" style='width: 100%;height: 500px;'></div>
                            </li>
                            <li id='item2-2'>
                                <div id='item2-HZ-ctrl'>
                                    <input type="checkbox" value='max'>最大值
                                    <input type="checkbox" value='min'>最小值
                                    <input type="checkbox" value='average'>平均值
                                </div>
                                <div id='item2-HZ' class="chart-item" style='width: 100%;height: 500px;'></div>
                            </li>
                            <li id='item2-3'>
                                <div id='item2-P-ctrl'>
                                    <ul>
                                        <li class="mark-ctrl">
                                            <input type="checkbox" value='max'>最大值
                                            <input type="checkbox" value='min'>最小值
                                            <input type="checkbox" value='average'>平均值
                                        </li>
                                        <li class="series-ctrl">
                                            <input class="default-show" type="checkbox" value='p1'>P1
                                            <input type="checkbox" value='p2'>P2
                                            <input type="checkbox" value='p3'>P3
                                            <input type="checkbox" value='p'>P
                                            <input class="default-show" type="checkbox" value='s1'>S1
                                            <input type="checkbox" value='s2'>S2
                                            <input type="checkbox" value='s3'>S3
                                            <input type="checkbox" value='s'>S
                                            <input type="checkbox" value='q1'>Q1
                                            <input type="checkbox" value='q2'>Q2
                                            <input type="checkbox" value='q3'>Q3
                                            <input type="checkbox" value='q'>Q
                                            <input class="default-show" type="checkbox" value='pf1'>PF1
                                            <input type="checkbox" value='pf2'>PF2
                                            <input type="checkbox" value='pf3'>PF3
                                           <%-- <input type="checkbox" value='pf'>PF--%>
                                        </li>
                                    </ul>
                                </div>
                                <div id='item2-P' class="chart-item" style='width: 100%;height: 500px;'></div>
                            </li>
                            <li id='item2-4'>
                                <div id="item2-LyTx-ctrl">
                                    <input class="default-show" type="checkbox" value="Ua">Ua
                                    <input type="checkbox" value="Ub">Ub
                                    <input type="checkbox" value="Uc">Uc
                                </div>
                                <div id='item2-LyTx' class="chart-item" style='width: 100%;height: 500px;'></div>
                            </li>
                            <li id='item2-5'>
                                <div id="item2-thd-ctrl">
                                    <ul>
                                        <li class="mark-ctrl">
                                            <input type="checkbox" value='max'>最大值
                                            <input type="checkbox" value='min'>最小值
                                            <input type="checkbox" value='average'>平均值
                                        </li>
                                        <li class="series-ctrl">
                                            <input class="default-show" type="checkbox" value="thdi1">THDi1
                                            <input class="default-show" type="checkbox" value="thdi2">THDi2
                                            <input class="default-show" type="checkbox" value="thdi3">THDi3
                                            <input type="checkbox" value="thdu1">THDu1
                                            <input type="checkbox" value="thdu2">THDu2
                                            <input type="checkbox" value="thdu3">THDu3
                                        </li>
                                    </ul>
                                </div>
                                <div id='item2-thd' class="chart-item" style='width: 100%;height: 500px;'></div>
                            </li>
                            <li id='item2-6'>
                                <div id="item2-temp-env">
                                    <ul>
                                        <li class="mark-ctrl">
                                            <input type="checkbox" value='max'>最大值
                                            <input type="checkbox" value='min'>最小值
                                            <input type="checkbox" value='average'>平均值
                                        </li>
                                        <li class="series-ctrl">
                                            <input class="default-show" type="checkbox" value="temp">temp
                                        </li>
                                    </ul>
                                </div>
                                <div id='item2-temp' class="chart-item" style='width: 100%;height: 500px;'></div>
                            </li>
                            <li id='item2-7'>
                                <div id="item2-wet-env">
                                    <ul>
                                        <li class="mark-ctrl">
                                            <input type="checkbox" value='max'>最大值
                                            <input type="checkbox" value='min'>最小值
                                            <input type="checkbox" value='average'>平均值
                                        </li>
                                        <li class="series-ctrl">
                                            <input class="default-show" type="checkbox" value="wet">wet
                                        </li>
                                    </ul>
                                </div>
                                <div id='item2-wet' class="chart-item" style='width: 100%;height: 500px;'></div>
                            </li>
                        </ul>
                    </div>

                    <div id="item3" class="col-md-2 col-xs-6" style="width:90%; height: 600px;">
                        <!-- 动态加载知识库项 -->
                        <div class="row">
                            <div class="col-md-4">
                                <div id="jstree"></div>
                                <div id="nodeid" style="display: none"></div>

                                <div class="btn-group">
                                    <button id="button-update-kl" type="button" class="btn btn-sm btn-alt">修改知识</button>
                                    <button id="button-delete-kl" type="button" class="btn btn-sm btn-alt">删除知识</button>
                                    <button id="button-add-kl" type="button" class="btn btn-sm btn-alt">添加知识</button>
                                    <button id="button-upload-kl" type="button" class="btn btn-sm btn-alt">上传到总服务器
                                    </button>
                                </div>
                                <div class="clearfix"></div>
                                <div class="btn-group">
                                    <button id="button-addtreenode-kl" type="button" class="btn btn-sm btn-alt">添加树节点
                                    </button>
                                    <button id="button-treenode-kl" type="button" class="btn btn-sm btn-alt">修改树节点
                                    </button>
                                    <button id="button-deletetreenode-kl" type="button" class="btn btn-sm btn-alt">删除树节点
                                    </button>
                                </div>
                            </div>

                            <div class=="col-md-8">
                                标题<textarea id='node-tilte-text' style="height: 50px;color: #1c2d3f"></textarea>
                            </div>
                            <div class=="col-md-8">
                                内容<textarea id='content-text' style="height: 120px;color: #1c2d3f"></textarea>
                            </div>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </section>
</section>

<!-- Javascript Libraries -->
<!-- jQuery -->
<!--<script src="js/jquery-3.3.1.js"></script>-->
<!-- jQuery Library -->

<!-- Bootstrap -->
<script src="js/bootstrap.min.js"></script>
<!--Media Player-->
<script src="js/media-player.min.js"></script>
<!-- USA Map for jVectorMap -->
<!-- UX -->
<script src="js/scroll.min.js"></script>
<!-- Custom Scrollbar -->

<!-- Other -->
<script src="js/calendar.min.js"></script>
<!-- Calendar -->
<script src="js/feeds.min.js"></script>
<!-- News Feeds -->

<!-- All JS functions -->
<script src="js/functions.js"></script>

<script src="js/jstree.js"></script>

<!-- 省\市\机房下拉菜单-->
<script type="text/javascript">

    //读取cookie中已存的机房配置
    var opinion1 = $.cookie('province_name');
    $('#province_code').append("<option value='" + opinion1 + "' selected='selected' >" + opinion1 + "</option>");
    getCity();

    /*加载市下拉选*/
    function getCity() {
        var pname = $("#province_code").val();

        //读取cookie中已存的机房配置
        var opinion2 = $.cookie('opinion2');
        var uname = "${username}";

        $("#city_code").empty();
        $("#comproom_code").empty();

        $.ajax({
            type: "post",
            url: "getCityTree",
            data: {
                provinceid: pname,
                uname: uname
            },
            dataType: "json",
            success: function (data) {

                $('#city_code').append("<option value='' selected='selected' >" + '未指定' + "</option>");
                $('#comproom_code').append("<option value='' selected='selected' >" + '未指定' + "</option>");

                var obj = eval("(" + data + ")");
                for (var i = 0; i < obj.length; i++) {
                    if (obj[i].cbname == opinion2 || i == 0) {
                        $('#city_code').append("<option value='" + obj[i].cbname + "' selected='selected' >" + obj[i].cbname + "</option>");
                        getComproom();
                    }
                    else
                        $('#city_code').append("<option value='" + obj[i].cbname + "' >" + obj[i].cbname + "</option>");

                }
            }
        });
    }

    /*加载机房下拉选*/
    function getComproom() {
        var cname = $("#city_code").val();

        //读取cookie中已存的机房配置
        var opinion3 = $.cookie('opinion3');
        var uname = "${username}";

        $("#comproom_code").empty();

        $.ajax({
            type: "post",
            url: "getCompTree",
            data: {
                cityid: cname,
                uname: uname
            },
            dataType: "json",
            success: function (data) {
                var list = data.allcomputerroom;

                $('#comproom_code').append("<option value='' selected='selected' >" + '未指定' + "</option>");
                for (var i = 0; i < list.length; i++) {
                    if (list[i].rname == opinion3 || i == 0) {
                        $('#comproom_code').append("<option value='" + list[i].rid + "' selected='selected'>" + list[i].rname + "</option>");
                        $('#second-page').css('display', 'block');
                        $('#first-page').css('display', 'none');
                    }
                    else
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
    var ulist = new Array();
    var u2list = new Array();

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
        /*else if(cbidstr[i] == ' efficiencyAssessment.jsp'){
            isSystemMng = false;
            menuname = "动力评估";
        }*/
        else if(cbidstr[i] == ' reportChart.jsp'){
            isSystemMng = false;
            menuname = "报表功能";
        }
        else if(cbidstr[i] == ' history.jsp'){
            isSystemMng = false;
            menuname = "历史曲线";
        }
        else if(cbidstr[i].search('systemMng.jsp')){

            //对字符串分段处理（2或3段）
            var substr = cbidstr[i].split("/");

            if(substr.length == 2){
                ulist.push(substr[1]);
            }

            else
            {
                ulist.push(substr[1]);
                u2list.push(substr[2]);
            }

            if(!isNewSystemMng)
            {//第一条systemMng的
                isNewSystemMng = true;
                menuname = "系统管理";
                $('#ulbar').append("<li><a href='systemMng.jsp' id='menuurl'>" + menuname + "</a></li>");
            }
            isSystemMng = true;
        }
        if(!isSystemMng) $('#ulbar').append("<li><a href='" + cbidstr[i] + "'  id='menuurl'>" + menuname + "</a></li>");
    }

    for(var i = 1; i <= 8; i++){
        var ustr = "item" + i;

        for(var j = 0; j < ulist.length; j++){
            if(ustr == ulist[j]){
                break;
            }
            if(j == ulist.length - 1){
                $("#"+ustr+"").remove();
            }
        }
    }

    for(var i = 1; i <= 9; i++){
        var ustr;
        if(i < 7)
            ustr = "secsubItem" + i;
        else
            ustr = "tridsubItem" + i;

        for(var j = 0; j < u2list.length; j++){
            if(ustr == u2list[j]){
                break;
            }
            if(j == u2list.length - 1){
                $("#"+ustr+"").remove();
            }
        }
    }

</script>

<!-- 动态加载检测点(设备)列表 -->
<script type="text/javascript">
    //city 动态改变,computerroom清空
    document.getElementById("comproom_code").addEventListener('change', function () {
        $('#his-mpid-select').empty();
        $('#his-temp-mpid-select').empty();
    });

    //初始化 默认 监测点 start//////////////////
    var flag = 1;
    setInterval(function () {

        var computerroom = $("#comproom_code option:selected").val();
        var mpcname = $("#his-mpid-select").val();

        if(computerroom != undefined && flag == 1) {
            getDefaultMonitorPoints();
            flag = 2;
        }
    }, 500);

    function getDefaultMonitorPoints(){

        var computerroom = $("#comproom_code option:selected").val();
        var mpcname = $("#his-mpid-select").val();
        if (!mpcname) {
            var hisvalue = $('#his-mpid-select').val();

            if(hisvalue == null) {
                $.ajax({
                    type: "post",
                    url: "getMonitorPoints",
                    data: {
                        computerroom: computerroom
                    },
                    dataType: "json",
                    success: function (data) {
                        var obj = JSON.parse(data);
                        var rt = obj.allmpdata;
                        for (var i = 0; i < rt.length; i++) {
                            if (i == 0)
                                $('#his-mpid-select').append("<option value='" + rt[i].did + "' selected='selected'>" + rt[i].name + "</option>");
                            else
                                $('#his-mpid-select').append("<option value='" + rt[i].did + "' >" + rt[i].name + "</option>");
                        }
                    }
                });
            }
        }

        var tempname = $("#his-temp-mpid-select").val();
        if (!tempname) {
            var hisvalue = $('#his-temp-mpid-select').val();

            if(hisvalue == null) {
                $.ajax({
                    type: "post",
                    url: "getMonitorPointsEnvironment",
                    data: {
                        computerroom: computerroom
                    },
                    dataType: "json",
                    success: function (data) {
                        var obj = JSON.parse(data);
                        var rt = obj.allmpdata;
                        for (var i = 0; i < rt.length; i++) {
                            if (i == 0)
                                $('#his-temp-mpid-select').append("<option value='" + rt[i].did + "' selected='selected'>" + rt[i].name + "</option>");
                            else
                                $('#his-temp-mpid-select').append("<option value='" + rt[i].did + "' >" + rt[i].name + "</option>");
                        }
                    }
                });
            }
        }

    }
    //初始化 默认 监测点 end/////////////////

    //获取检测点列表
    function getMonitorPoints() {

        var computerroom = $("#comproom_code option:selected").val();
        var mpcname = $("#his-mpid-select").val();

        if(!computerroom){
            alert("请先选择机房，再选择检测点");
        }
        else if (!mpcname) {
            var hisvalue = $('#his-mpid-select').val();

            if(hisvalue == null) {
                $.ajax({
                    type: "post",
                    url: "getMonitorPoints",
                    data: {
                        computerroom: computerroom
                    },
                    dataType: "json",
                    success: function (data) {
                        var obj = JSON.parse(data);
                        var rt = obj.allmpdata;

                        for (var i = 0; i < rt.length; i++) {

                            if(i == 0)
                                $('#his-mpid-select').append("<option value='" + rt[i].did + "' selected='selected'>" + rt[i].name + "</option>");
                            else
                                $('#his-mpid-select').append("<option value='" + rt[i].did + "' >" + rt[i].name + "</option>");
                        }
                    }
                });
            }
        }
    }

    //获取检测点列表
    function getMonitorPointsEnvironment() {

        var computerroom = $("#comproom_code option:selected").val();
        var mpcname = $("#his-temp-mpid-select").val();

        if(!computerroom){
            alert("请先选择机房，再选择检测点");
        }
        else if (!mpcname) {
            var hisvalue = $('#his-temp-mpid-select').val();

            if(hisvalue == null) {
                $.ajax({
                    type: "post",
                    url: "getMonitorPointsEnvironment",
                    data: {
                        computerroom: computerroom
                    },
                    dataType: "json",
                    success: function (data) {
                        var obj = JSON.parse(data);
                        var rt = obj.allmpdata;

                        for (var i = 0; i < rt.length; i++) {
                            if(i == 0)
                                $('#his-temp-mpid-select').append("<option value='" + rt[i].did + "' selected='selected'>" + rt[i].name + "</option>");
                            else
                                $('#his-temp-mpid-select').append("<option value='" + rt[i].did + "' >" + rt[i].name + "</option>");
                        }
                    }
                });
            }
        }
    }
</script>

<!-- 切换子菜单-->
<script type="text/javascript">
    $("#item2").show();
    $("#item3").hide();

    $(document).ready(function () {
        $("#subItem2").click(function () {
            $("#item2").show();
            $("#item3").hide();
        });
        $("#subItem3").click(function () {
            $("#item2").hide();
            $("#item3").show();
        });

        $("#subItem2").click();
    });
</script>

<!-- 切换子菜单subItem效果-->
<script type="text/javascript">
    $(function () {
        $("#ulItem li").click(function () {
            $(this).siblings('li').removeClass('active');  // 删除其他兄弟元素的样式selected
            $(this).addClass('active');                            // 添加当前元素的样式
        });
    });
</script>

<!-- jstree-->
<script type="text/javascript">

    $(function () {
        $('#jstree').jstree({
            "core": {
                "themes": {
                    "responsive": false
                },
                "check_callback": true,
                'data': function (obj, callback) {
                    var jsonstr = "[]";
                    var jsonarray = eval('(' + jsonstr + ')');
                    $.ajax({
                        url: "getKnowledgeTree",
                        dataType: "json",
                        async: false,
                        success: function (result) {
                            var arrays = result.allkltree;
                            for (var i = 0; i < arrays.length; i++) {
                                var arr = {
                                    "id": arrays[i].kid,
                                    "parent": arrays[i].parentkid == "0" ? "#" : arrays[i].parentkid,
                                    "text": arrays[i].kname
                                }
                                jsonarray.push(arr);
                            }
                        }
                    });
                    callback.call(this, jsonarray);
                },
            }
        })
    });

    $('button').on('click', function () {
        $('#jstree').jstree(true).select_node('child_node_1');
        $('#jstree').jstree('select_node', 'child_node_1');
        $.jstree.reference('#jstree').select_node('child_node_1');
    });

    // 事件处理-查看知识
    $('#jstree').bind("activate_node.jstree", function (obj, e) {
        // 获取当前节点，根据节点kid找到数据库中存储的内容
        var currentNode = e.node;

        $.ajax({
            type: "post",
            url: "getKnowledgeTreeNodeContent",
            data: {kid: currentNode.id},
            dataType: "json",
            success: function (data) {
                var obj = JSON.parse(data);
                var rt = obj.knowledgenode;
                $("#content-text").val("");
                $("#content-text").val(rt.content);
            }
        });
        //当前点击的节点的id存到一个隐藏的div中
        $("#nodeid").val(currentNode.id);
    });

    // 事件处理-修改知识
    $('#button-update-kl').click(function () {

        var tmpcurrentTitle = $("#node-tilte-text").val();
        var tmpcurrentNode = $("#content-text").val();
        var tmpNodeKid = $("#nodeid").val();

        $.ajax({
            type: "post",
            url: "updateKnowledgeTreeNodeContent",
            data: {
                kid: tmpNodeKid,
                tmpTitle: tmpcurrentTitle,
                tmpContent: tmpcurrentNode
            },
            dataType: "json",
            success: function (data) {
                //刷新树
                $('#jstree').jstree(true).refresh();
            }
        });
    });

    // 事件处理-删除知识
    $('#button-delete-kl').click(function () {
        var tmpNodeKid = $("#nodeid").val();

        $.ajax({
            type: "post",
            url: "deleteKnowledgeTreeNodeContent",
            data: {
                kid: tmpNodeKid,
            },
            dataType: "json",
            success: function (data) {
                //刷新树
                $('#jstree').jstree(true).refresh();
            }
        });
    });

    // 事件处理-添加知识
    $('#button-add-kl').click(function () {
        var tmpcurrentTitle = $("#node-tilte-text").val();
        var tmpNodeKid = $("#nodeid").val();
        var tmpcurrentNode = $("#content-text").val();

        $.ajax({
            type: "post",
            url: "addKnowledgeTreeNodeContent",
            data: {
                kid: tmpNodeKid,
                tmpTitle: tmpcurrentTitle,
                tmpContent: tmpcurrentNode
            },
            dataType: "json",
            success: function (data) {
                //刷新树
                $('#jstree').jstree(true).refresh();
            }
        });
    });

    // 事件处理-上传到总服务器
    $('#button-upload-kl').click(function () {
        var tmpNodeKid = $("#nodeid").val();
        var tmpcurrentNode = $("#content-text").val();

        $.ajax({
            type: "post",
            url: "uploadKnowledgeTree",
            data: {
                kid: tmpNodeKid,
                tmpContent: tmpcurrentNode
            },
            dataType: "json",
            success: function (data) {
                alert(data);
                //刷新树
                $('#jstree').jstree(true).refresh();
            },
        });
    });

    // 事件处理-添加树节点,所选节点下尾部追加
    $('#button-addtreenode-kl').click(function () {
        var tmpNodeKid = $("#nodeid").val();
        var tmpcurrentNodeTitle = $("#node-tilte-text").val();
        var tmpcurrentNode = $("#content-text").val();

        $.ajax({
            type: "post",
            url: "addKnowledgeTreeNodeStruct",
            data: {
                kid: tmpNodeKid,
                kname: tmpcurrentNodeTitle,
                kcontent: tmpcurrentNode
            },
            dataType: "json",
            success: function (data) {
                alert(data);
                //刷新树
                $('#jstree').jstree(true).refresh();
            }
        });
    });

    // 事件处理-修改树节点
    $('#button-treenode-kl').click(function () {
        var tmpNodeKid = $("#nodeid").val();
        var tmpcurrentNodeTitle = $("#node-tilte-text").val();

        $.ajax({
            type: "post",
            url: "updateKnowledgeTreeNodeStruct",
            data: {
                kid: tmpNodeKid,
                kname: tmpcurrentNodeTitle
            },
            dataType: "json",
            success: function (data) {
                alert(data);
                //刷新树
                $('#jstree').jstree(true).refresh();
            }
        });
    });

    // 事件处理-删除树节点
    $('#button-deletetreenode-kl').click(function () {
        var tmpNodeKid = $("#nodeid").val();

        $.ajax({
            type: "post",
            url: "deleteKnowledgeTreeNodeStruct",
            data: {
                kid: tmpNodeKid
            },
            dataType: "json",
            success: function (data) {
                alert(data);
                //刷新树
                $('#jstree').jstree(true).refresh();
            }
        });
    });
</script>

<!-- echarts图表绘制 -->
<!-- 时间选择器-->
<script type="text/javascript" src="bootstrap-timepicker/js/bootstrap.min.js"></script>
<script type="text/javascript" src="bootstrap-timepicker/js/bootstrap-datetimepicker.js" charset="UTF-8"></script>
<script type="text/javascript" src="bootstrap-timepicker/js/bootstrap-datetimepicker.fr.js" charset="UTF-8"></script>

<script src="js/echarts.js"></script>
<script>
    //绘制图表需要的全局变量声明
    var eventChart1 = echarts.init(document.getElementById('item2-UI'));
    var eventChart2 = echarts.init(document.getElementById('item2-HZ'));
    var eventChart3 = echarts.init(document.getElementById('item2-P'));
    var eventChart4 = echarts.init(document.getElementById('item2-LyTx'));
    var eventChart5 = echarts.init(document.getElementById('item2-thd'));
    var eventChart6 = echarts.init(document.getElementById('item2-temp'));
    var eventChart7 = echarts.init(document.getElementById('item2-wet'));
    var chart1Legend = ['u1', 'u2', 'u3', 'u4', 'i1', 'i2', 'i3', 'i4'];
    var chart3Legend = ['p1', 'p2', 'p3', 'p', 's1', 's2', 's3', 's', 'q1', 'q2', 'q3', 'q',
        'pf1', 'pf2', 'pf3', 'pf', 'dpf1', 'dpf2', 'dpf3', 'dpf'];
    var chart4Legend = ['Ua','Ub','Uc'];
    var chart5Legend = ['thdu1', 'thdu2', 'thdu3', 'thdu4', 'thdi1', 'thdi2', 'thdi3', 'thdi4'];
    var chart6Legend = ['temp'];
    var chart7Legend = ['wet'];

    var markPointUI = {//电压\电流图最大值、最小值标注点
        label: {formatter: '{a}{b}:{c}'},
        data: []
    };
    var markLineUI = {//电压\电流图平均值标注线
        label: {formatter: '{a}{b}:{c}'},
        data: []
    };
    var markPointHZ = {//频率图最大值、最小值标注点
        label: {formatter: '{a}{b}:{c}'},
        data: []
    };
    var markLineHZ = {//频率图平均值标注线
        label: {formatter: '{a}{b}:{c}'},
        data: []
    };
    var markPointP = {//功率图最大值、最小值标注点
        label: {formatter: '{a}{b}:{c}'},
        data: []
    };
    var markLineP = {//功率图平均值标注线
        label: {formatter: '{a}{b}:{c}'},
        data: []
    };
    var markPointTemp = {//Temp图最大值、最小值标注点
        label: {formatter: '{a}{b}:{c}'},
        data: []
    };
    var markLineTemp = {//Temp图平均值标注线
        label: {formatter: '{a}{b}:{c}'},
        data: []
    };
    var markPointWet = {//Wet图最大值、最小值标注点
        label: {formatter: '{a}{b}:{c}'},
        data: []
    };
    var markLineWet = {//Wet图平均值标注线
        label: {formatter: '{a}{b}:{c}'},
        data: []
    };

    var line1 = [];
    line1.push([ '1' , '200']);
    line1.push([ '2' , '185']);
    line1.push([ '3' , '170']);
    line1.push([ '4' , '155']);
    line1.push([ '5' , '140']);

    for(var i = 5; i <= 500; i++){
        line1.push([ i , '140']);
    }

    for(var i = 500; i <= 2000; i++){
        line1.push([ i , '120']);
    }

    var line2 = [];
    line2.push([ '30' , '0']);

    for(var i = 30; i <= 2000; i++){
        line2.push([ i , '70']);
    }

    var option1 = {
        tooltip: {
            trigger: 'axis'
        },
        legend: {
            show: false,
            data: chart1Legend
        },
        xAxis: {
            type: 'time',
            splitLine: {
                show: false
            }
        },
        yAxis: {
            name: '单位:（V/A）',
            type: 'value',
            scale: true,
            boundaryGap: ['10%', '10%'],
            splitLine: {
                show: false
            }
        },
        series: [
            //电压U
            {
                connectNulls: false,
                name: "u1", type: "line", smooth: true, showSymbol: false,
                markPoint: markPointUI, markLine: markLineUI,
                encode: {x: "time", y: "u1"},
                itemStyle:{
                    normal:{
                        color:'#ffff00'
                    }
                }
            },
            {
                connectNulls: false,
                name: "u2", type: "line", smooth: true, showSymbol: false,
                markPoint: markPointUI, markLine: markLineUI,
                encode: {x: "time", y: "u2"},
                itemStyle:{
                    normal:{
                        color:'#00ff00'
                    }
                }
            },
            {
                connectNulls: false,
                name: "u3", type: "line", smooth: true, showSymbol: false,
                markPoint: markPointUI, markLine: markLineUI,
                encode: {x: "time", y: "u3"},
                itemStyle:{
                    normal:{
                        color:'#ff0000'
                    }
                }
            },
            {
                connectNulls: false,
                name: "u4", type: "line", smooth: true, showSymbol: false,
                markPoint: markPointUI, markLine: markLineUI,
                encode: {x: "time", y: "u4"}
            },
            //电流I
            {
                connectNulls: true,
                name: "i1", type: "line", smooth: true, showSymbol: false,
                markPoint: markPointUI, markLine: markLineUI,
                encode: {x: "time", y: "i1"},
                itemStyle:{
                    normal:{
                        color:'#ffff00'
                    }
                }
            },
            {
                connectNulls: true,
                name: "i2", type: "line", smooth: true, showSymbol: false,
                markPoint: markPointUI, markLine: markLineUI,
                encode: {x: "time", y: "i2"},
                itemStyle:{
                    normal:{
                        color:'#00ff00'
                    }
                }
            },
            {
                connectNulls: true,
                name: "i3", type: "line", smooth: true, showSymbol: false,
                markPoint: markPointUI, markLine: markLineUI,
                encode: {x: "time", y: "i3"},
                itemStyle:{
                    normal:{
                        color:'#ff0000'
                    }
                }
            },
            {
                connectNulls: true,
                name: "i4", type: "line", smooth: true, showSymbol: false,
                markPoint: markPointUI, markLine: markLineUI,
                encode: {x: "time", y: "i4"}
            }
        ]
    };
    var option2 = {
        tooltip: {
            trigger: 'axis'
        },
        legend: {
            show: false
        },
        xAxis: {
            type: 'time',
            splitLine: {
                show: false
            }
        },
        yAxis: {
            type: 'value',
            scale: true,
            name: '(单位：Hz)',
            boundaryGap: ['10%', '10%'],
            splitLine: {
                show: false
            }
        },
        series: [
            //频率hz
            {
                connectNulls: true,
                name: 'hz', type: 'line', smooth: true, showSymbol: false,
                markPoint: markPointHZ, markLine: markLineHZ,
                encode: {x: 'time', y: 'hz'}
            }
        ]
    };
    var option3 = {
        tooltip: {
            trigger: 'axis'
        },
        legend: {
            show: false,
            data: chart3Legend
        },
        xAxis: {
            type: 'time',
            splitLine: {
                show: false
            }
        },
        yAxis: {
            type: 'value',
            scale: true,
            boundaryGap: ['10%', '10%'],
            splitLine: {
                show: false
            }
        },
        series: [
            //功率P
            {
                connectNulls: true,
                name: "p1", type: "line", smooth: true, showSymbol: false,
                markPoint: markPointP, markLine: markLineP,
                encode: {x: "time", y: "p1"},
                itemStyle:{
                    normal:{
                        color:'#ffff00'
                    }
                }
            },
            {
                connectNulls: true,
                name: "p2", type: "line", smooth: true, showSymbol: false,
                markPoint: markPointP, markLine: markLineP,
                encode: {x: "time", y: "p2"},
                itemStyle:{
                    normal:{
                        color:'#00ff00'
                    }
                }
            },
            {
                connectNulls: true,
                name: "p3", type: "line", smooth: true, showSymbol: false,
                markPoint: markPointP, markLine: markLineP,
                encode: {x: "time", y: "p3"},
                itemStyle:{
                    normal:{
                        color:'#ff0000'
                    }
                }
            },
            {
                connectNulls: true,
                name: "p", type: "line", smooth: true, showSymbol: false,
                markPoint: markPointP, markLine: markLineP,
                encode: {x: "time", y: "p"}
            },
            //功率S
            {
                connectNulls: true,
                name: "s1", type: "line", smooth: true, showSymbol: false,
                markPoint: markPointP, markLine: markLineP,
                encode: {x: "time", y: "s1"},
                itemStyle:{
                    normal:{
                        color:'#ffff00'
                    }
                }
            },
            {
                connectNulls: true,
                name: "s2", type: "line", smooth: true, showSymbol: false,
                markPoint: markPointP, markLine: markLineP,
                encode: {x: "time", y: "s2"},
                itemStyle:{
                    normal:{
                        color:'#00ff00'
                    }
                }
            },
            {
                connectNulls: true,
                name: "s3", type: "line", smooth: true, showSymbol: false,
                markPoint: markPointP, markLine: markLineP,
                encode: {x: "time", y: "s3"},
                itemStyle:{
                    normal:{
                        color:'#ff0000'
                    }
                }
            },
            {
                connectNulls: true,
                name: "s", type: "line", smooth: true, showSymbol: false,
                markPoint: markPointP, markLine: markLineP,
                encode: {x: "time", y: "s"}
            },
            //功率Q
            {
                connectNulls: true,
                name: "q1", type: "line", smooth: true, showSymbol: false,
                markPoint: markPointP, markLine: markLineP,
                encode: {x: "time", y: "q1"},
                itemStyle:{
                    normal:{
                        color:'#ffff00'
                    }
                }
            },
            {
                connectNulls: true,
                name: "q2", type: "line", smooth: true, showSymbol: false,
                markPoint: markPointP, markLine: markLineP,
                encode: {x: "time", y: "q2"},
                itemStyle:{
                    normal:{
                        color:'#00ff00'
                    }
                }
            },
            {
                connectNulls: true,
                name: "q3", type: "line", smooth: true, showSymbol: false,
                markPoint: markPointP, markLine: markLineP,
                encode: {x: "time", y: "q3"},
                itemStyle:{
                    normal:{
                        color:'#ff0000'
                    }
                }
            },
            {
                connectNulls: true,
                name: "q", type: "line", smooth: true, showSymbol: false,
                markPoint: markPointP, markLine: markLineP,
                encode: {x: "time", y: "q"}
            },
            //功率PF
            {
                connectNulls: true,
                name: "pf1", type: "line", smooth: true, showSymbol: false,
                markPoint: markPointP, markLine: markLineP,
                encode: {x: "time", y: "pf1"},
                itemStyle:{
                    normal:{
                        color:'#ffff00'
                    }
                }
            },
            {
                connectNulls: true,
                name: "pf2", type: "line", smooth: true, showSymbol: false,
                markPoint: markPointP, markLine: markLineP,
                encode: {x: "time", y: "pf2"},
                itemStyle:{
                    normal:{
                        color:'#00ff00'
                    }
                }
            },
            {
                connectNulls: true,
                name: "pf3", type: "line", smooth: true, showSymbol: false,
                markPoint: markPointP, markLine: markLineP,
                encode: {x: "time", y: "pf3"},
                itemStyle:{
                    normal:{
                        color:'#ff0000'
                    }
                }
            }/*,
            {
                connectNulls: true,
                name: "pf", type: "line", smooth: true, showSymbol: false,
                markPoint: markPointP, markLine: markLineP,
                encode: {x: "time", y: "pf"}
            }*/
        ]
    };
    var option4 = {
        tooltip: {
            trigger: 'axis'
        },
        legend: {
            show: false,
            data: chart4Legend
        },
        tooltip: {},
        xAxis: {
            type: 'value',
            max: 2000,
            min: 0,
            name: '(单位：ms)',
            splitLine: {
                show: false
            }
        },
        yAxis: {
            type: 'value',
            scale: true,
            max: 200,
            min: 0,
            name: '(单位：%)',
            boundaryGap: ['10%', '10%'],
            splitLine: {
                show: false
            }
        },
        // 数据窗口缩放
        dataZoom: [
            {
                type: 'slider',
                show: true,
                xAxisIndex: [0],
                start: 0,
                end: 50
            },
            {
                type: 'inside',
                xAxisIndex: [0],
                start: 0,
                end: 50
            }
        ],
        series: [
            // 浪涌/塌陷
            {
                connectNulls: true,
                name: 'Ua',type: 'scatter',
                encode: {x: 'time'* 1000, y: 'Ua'},
                itemStyle:{
                    normal:{
                        color:'#ffff00'
                    }
                }
            },
            {
                connectNulls: true,
                name: 'Ub',type: 'scatter',
                encode: {x: 'time'* 1000, y: 'Ub'},
                itemStyle:{
                    normal:{
                        color:'#00ff00'
                    }
                }
            },
            {
                connectNulls: true,
                name: 'Uc',type: 'scatter',
                encode: {x: 'time'* 1000, y: 'Uc'},
                itemStyle:{
                    normal:{
                        color:'#ff0000'
                    }
                }
            },
            {
                name:'',
                type:'line', smooth: true, showSymbol: false,
                itemStyle:{
                    normal:{
                        color:'#ff0000'
                    }
                },
                data: line1
            },
            {
                name:'',
                type:'line', smooth: true, showSymbol: false,
                itemStyle:{
                    normal:{
                        color:'#ff0000'
                    }
                },
                data: line2
            }
        ]
    };
    var option5 = {
        tooltip: {
            trigger: 'axis'
        },
        legend: {
            show: false,
            data: chart5Legend
        },
        xAxis: {
            type: 'time',
            splitLine: {
                show: false
            }
        },
        yAxis: {
            name: '单位:（%）',
            type: 'value',
            scale: true,
            boundaryGap: ['10%', '10%'],
            splitLine: {
                show: false
            }
        },
        series: [
            //thdU
            {
                connectNulls: true,
                name: "thdu1", type: "line", smooth: true, showSymbol: false,
                markPoint: markPointUI, markLine: markLineUI,
                encode: {x: "time", y: "thdu1"},
                itemStyle:{
                    normal:{
                        color:'#ffff00'
                    }
                }
            },
            {
                connectNulls: true,
                name: "thdu2", type: "line", smooth: true, showSymbol: false,
                markPoint: markPointUI, markLine: markLineUI,
                encode: {x: "time", y: "thdu2"},
                itemStyle:{
                    normal:{
                        color:'#00ff00'
                    }
                }
            },
            {
                connectNulls: true,
                name: "thdu3", type: "line", smooth: true, showSymbol: false,
                markPoint: markPointUI, markLine: markLineUI,
                encode: {x: "time", y: "thdu3"},
                itemStyle:{
                    normal:{
                        color:'#ff0000'
                    }
                }
            },
            {
                connectNulls: true,
                name: "thdu4", type: "line", smooth: true, showSymbol: false,
                markPoint: markPointUI, markLine: markLineUI,
                encode: {x: "time", y: "thdu4"}
            },
            //电流I
            {
                connectNulls: true,
                name: "thdi1", type: "line", smooth: true, showSymbol: false,
                markPoint: markPointUI, markLine: markLineUI,
                encode: {x: "time", y: "thdi1"},
                itemStyle:{
                    normal:{
                        color:'#ffff00'
                    }
                }
            },
            {
                connectNulls: true,
                name: "thdi2", type: "line", smooth: true, showSymbol: false,
                markPoint: markPointUI, markLine: markLineUI,
                encode: {x: "time", y: "thdi2"},
                itemStyle:{
                    normal:{
                        color:'#00ff00'
                    }
                }
            },
            {
                connectNulls: true,
                name: "thdi3", type: "line", smooth: true, showSymbol: false,
                markPoint: markPointUI, markLine: markLineUI,
                encode: {x: "time", y: "thdi3"},
                itemStyle:{
                    normal:{
                        color:'#ff0000'
                    }
                }
            },
            {
                connectNulls: true,
                name: "thdi4", type: "line", smooth: true, showSymbol: false,
                markPoint: markPointUI, markLine: markLineUI,
                encode: {x: "time", y: "thdi4"}
            }
        ]
    };
    var option6 = {
        tooltip: {
            trigger: 'axis'
        },
        legend: {
            show: false,
            data: chart6Legend
        },
        xAxis: {
            type: 'time',
            splitLine: {
                show: false
            }
        },
        yAxis: {
            name: '单位:（℃）',
            type: 'value',
            scale: true,
            splitLine: {
                show: false
            }
        },
        series: [
            //temp
            {
                connectNulls: true,
                name: "temp", type: "line", smooth: true, showSymbol: false,
                markPoint: markPointTemp, markLine: markLineTemp,
                encode: {x: "time", y: "temp"},
                itemStyle:{
                    normal:{
                        color:'#00ff00'
                    }
                }
            }
        ]
    };
    var option7 = {
        tooltip: {
            trigger: 'axis'
        },
        legend: {
            show: false,
            data: chart7Legend
        },
        xAxis: {
            type: 'time',
            splitLine: {
                show: false
            }
        },
        yAxis: {
            name: '单位:（%）',
            type: 'value',
            scale: true,
            splitLine: {
                show: false
            }
        },
        series: [
            //wet
            {
                connectNulls: true,
                name: "wet", type: "line", smooth: true, showSymbol: false,
                markPoint: markPointWet, markLine: markLineWet,
                encode: {x: "time", y: "wet"},
                itemStyle: {
                    normal: {
                        color: '#00ff00'
                    }
                }
            }
        ]
    };
    
    function showinfo(values) {
        if(values=='item2-6' || values=='item2-7'){
            $("#powermp").css("display","none");
            $("#tempmp").css("display","block");
        } else {
            $("#tempmp").css("display","none");
            $("#powermp").css("display","block");
        }
    }

    //事件绑定函数
    function eventBanding() {
        //绑定历史曲线菜单切换事件
        $('#item2-menu').change(function () {
            $('#item2>ul>li').hide();
            $('#' + $(this).val()).show();
        });
        //触发历史曲线菜单切换事件
        $('#item2-menu').trigger('change');
        //绑定UI图电压U、电流I checkbox点击事件
        $('#item2-UI-ctrl ul li.series-ctrl input:checkbox').each(function () {
            $(this).click(function () {
                if (this.checked) {
                    eventChart1.dispatchAction({
                        type: "legendSelect",
                        name: this.value
                    });
                }
                else {
                    eventChart1.dispatchAction({
                        type: "legendUnSelect",
                        name: this.value
                    });
                }
            });
        });

        //绑定THD图电压U、电流I checkbox点击事件
        $('#item2-thd-ctrl ul li.series-ctrl input:checkbox').each(function () {
            $(this).click(function () {
                if (this.checked) {
                    eventChart5.dispatchAction({
                        type: "legendSelect",
                        name: this.value
                    });
                }
                else {
                    eventChart5.dispatchAction({
                        type: "legendUnSelect",
                        name: this.value
                    });
                }
            });
        });

        //绑定UI图最大值、最小值、平均值checkbox点击事件
        $('#item2-UI-ctrl ul li.mark-ctrl input:checkbox').each(function () {
            $(this).click(function () {
                if (this.checked) {
                    switch (this.value) {
                        case 'max':
                            markPointUI.data.unshift({name: '最大值', type: 'max'});
                            break;//最大值标注配置项添加在数组头
                        case 'min':
                            markPointUI.data.push({name: '最小值', type: 'min'});
                            break;//最小值标注配置项添加在数组尾
                        case 'average':
                            markLineUI.data.push({name: '平均值', type: 'average'});
                            break;//平均值标注配置项添加
                        default:
                            break;
                    }
                }
                else {
                    switch (this.value) {
                        case 'max':
                            markPointUI.data.shift();
                            break;//移除最大值标注配置项
                        case 'min':
                            markPointUI.data.pop();
                            break;//移除最小值标注配置项
                        case 'average':
                            markLineUI.data.pop();
                            break;//移除平均值标注配置项
                        default:
                            break;
                    }
                }
                eventChart1.setOption(option1);
            });
        });
        //绑定频率图最大值、最小值、平均值checkbox点击事件
        $('#item2-HZ-ctrl input:checkbox').each(function () {
            $(this).click(function () {
                if (this.checked) {
                    switch (this.value) {
                        case 'max':
                            markPointHZ.data.unshift({name: '最大值', type: 'max'});
                            break;//最大值标注配置项添加在数组头
                        case 'min':
                            markPointHZ.data.push({name: '最小值', type: 'min'});
                            break;//最小值标注配置项添加在数组尾
                        case 'average':
                            markLineHZ.data.push({name: '平均值', type: 'average'});
                            break;//平均值标注配置项添加
                        default:
                            break;
                    }
                }
                else {
                    switch (this.value) {
                        case 'max':
                            markPointHZ.data.shift();
                            break;//移除最大值标注配置项
                        case 'min':
                            markPointHZ.data.pop();
                            break;//移除最小值标注配置项
                        case 'average':
                            markLineHZ.data.pop();
                            break;//移除平均值标注配置项
                        default:
                            break;
                    }
                }
                eventChart2.setOption(option2);
            });
        });
        //绑定功率图各种功率P的checkbox点击事件
        $('#item2-P-ctrl ul li.series-ctrl input:checkbox').each(function () {
            $(this).click(function () {
                if (this.checked) {
                    eventChart3.dispatchAction({
                        type: "legendSelect",
                        name: this.value
                    });
                }
                else {
                    eventChart3.dispatchAction({
                        type: "legendUnSelect",
                        name: this.value
                    });
                }
            });
        });
        //绑定功率图最大值、最小值、平均值checkbox点击事件
        $('#item2-P-ctrl ul li.mark-ctrl input:checkbox').each(function () {
            $(this).click(function () {
                if (this.checked) {
                    switch (this.value) {
                        case 'max':
                            markPointP.data.unshift({name: '最大值', type: 'max'});
                            break;//最大值标注配置项添加在数组头
                        case 'min':
                            markPointP.data.push({name: '最小值', type: 'min'});
                            break;//最小值标注配置项添加在数组尾
                        case 'average':
                            markLineP.data.push({name: '平均值', type: 'average'});
                            break;//平均值标注配置项添加
                        default:
                            break;
                    }
                }
                else {
                    switch (this.value) {
                        case 'max':
                            markPointP.data.shift();
                            break;//移除最大值标注配置项
                        case 'min':
                            markPointP.data.pop();
                            break;//移除最小值标注配置项
                        case 'average':
                            markLineP.data.pop();
                            break;//移除平均值标注配置项
                        default:
                            break;
                    }
                }
                eventChart3.setOption(option3);
            });
        });
        //绑定THD图最大值、最小值、平均值checkbox点击事件
        $('#item2-thd-ctrl ul li.mark-ctrl input:checkbox').each(function () {
            $(this).click(function () {
                if (this.checked) {
                    switch (this.value) {
                        case 'max':
                            markPointUI.data.unshift({name: '最大值', type: 'max'});
                            break;//最大值标注配置项添加在数组头
                        case 'min':
                            markPointUI.data.push({name: '最小值', type: 'min'});
                            break;//最小值标注配置项添加在数组尾
                        case 'average':
                            markLineUI.data.push({name: '平均值', type: 'average'});
                            break;//平均值标注配置项添加
                        default:
                            break;
                    }
                }
                else {
                    switch (this.value) {
                        case 'max':
                            markPointUI.data.shift();
                            break;//移除最大值标注配置项
                        case 'min':
                            markPointUI.data.pop();
                            break;//移除最小值标注配置项
                        case 'average':
                            markLineUI.data.pop();
                            break;//移除平均值标注配置项
                        default:
                            break;
                    }
                }
                eventChart5.setOption(option5);
            });
        });
        //绑定浪涌塌陷图中checkbox点击事件
        $('#item2-LyTx-ctrl input:checkbox').each(function () {
            $(this).click(function () {
                if (this.checked) {
                    eventChart4.dispatchAction({
                        type: "legendSelect",
                        name: this.value
                    });
                }
                else {
                    eventChart4.dispatchAction({
                        type: "legendUnSelect",
                        name: this.value
                    });
                }
            });
        });
        //绑定temp图 checkbox点击事件
        $('#item2-temp-env ul li.series-ctrl input:checkbox').each(function () {
            $(this).click(function () {
                if (this.checked) {
                    eventChart6.dispatchAction({
                        type: "legendSelect",
                        name: this.value
                    });
                }
                else {
                    eventChart6.dispatchAction({
                        type: "legendUnSelect",
                        name: this.value
                    });
                }
            });
        });
        //绑定wet图 checkbox点击事件
        $('#item2-wet-env ul li.series-ctrl input:checkbox').each(function () {
            $(this).click(function () {
                if (this.checked) {
                    eventChart7.dispatchAction({
                        type: "legendSelect",
                        name: this.value
                    });
                }
                else {
                    eventChart7.dispatchAction({
                        type: "legendUnSelect",
                        name: this.value
                    });
                }
            });
        });
        //绑定temp图最大值、最小值、平均值checkbox点击事件
        $('#item2-temp-env ul li.mark-ctrl input:checkbox').each(function () {
            $(this).click(function () {
                if (this.checked) {
                    switch (this.value) {
                        case 'max':
                            markPointTemp.data.unshift({name: '最大值', type: 'max'});
                            break;//最大值标注配置项添加在数组头
                        case 'min':
                            markPointTemp.data.push({name: '最小值', type: 'min'});
                            break;//最小值标注配置项添加在数组尾
                        case 'average':
                            markLineTemp.data.push({name: '平均值', type: 'average'});
                            break;//平均值标注配置项添加
                        default:
                            break;
                    }
                }
                else {
                    switch (this.value) {
                        case 'max':
                            markPointTemp.data.shift();
                            break;//移除最大值标注配置项
                        case 'min':
                            markPointTemp.data.pop();
                            break;//移除最小值标注配置项
                        case 'average':
                            markLineTemp.data.pop();
                            break;//移除平均值标注配置项
                        default:
                            break;
                    }
                }
                eventChart6.setOption(option6);
            });
        });
        //绑定wet图最大值、最小值、平均值checkbox点击事件
        $('#item2-wet-env ul li.mark-ctrl input:checkbox').each(function () {
            $(this).click(function () {
                if (this.checked) {
                    switch (this.value) {
                        case 'max':
                            markPointWet.data.unshift({name: '最大值', type: 'max'});
                            break;//最大值标注配置项添加在数组头
                        case 'min':
                            markPointWet.data.push({name: '最小值', type: 'min'});
                            break;//最小值标注配置项添加在数组尾
                        case 'average':
                            markLineWet.data.push({name: '平均值', type: 'average'});
                            break;//平均值标注配置项添加
                        default:
                            break;
                    }
                }
                else {
                    switch (this.value) {
                        case 'max':
                            markPointWet. data.shift();
                            break;//移除最大值标注配置项
                        case 'min':
                            markPointWet.data.pop();
                            break;//移除最小值标注配置项
                        case 'average':
                            markLineWet.data.pop();
                            break;//移除平均值标注配置项
                        default:
                            break;
                    }
                }
                eventChart7.setOption(option7);
            });
        });
    }

    //绘制图表
    function drawCharts() {
        //设置初始配置项
        eventChart1.setOption(option1);
        eventChart2.setOption(option2);
        eventChart3.setOption(option3);
        eventChart4.setOption(option4);
        eventChart5.setOption(option5);
        eventChart6.setOption(option6);
        eventChart7.setOption(option7);

        //设置曲线图初始不显示
        chart1Legend.forEach(function (item) {
            eventChart1.dispatchAction({
                type: "legendUnSelect",
                name: item
            });
        });
        chart3Legend.forEach(function (item) {
            eventChart3.dispatchAction({
                type: "legendUnSelect",
                name: item
            });
        });
        chart4Legend.forEach(function (item) {
            eventChart4.dispatchAction({
                type: "legendUnSelect",
                name: item
            });
        });
        chart5Legend.forEach(function (item) {
            eventChart5.dispatchAction({
                type: "legendUnSelect",
                name: item
            });
        });
        chart6Legend.forEach(function (item) {
            eventChart6.dispatchAction({
                type: "legendUnSelect",
                name: item
            });
        });
        chart7Legend.forEach(function (item) {
            eventChart7.dispatchAction({
                type: "legendUnSelect",
                name: item
            });
        });
    }

    //获取数据，并更新图
    function getData(starttime, endtime, did) {

        //取电压、电流、频率、功率数据
        $.ajax({
            type: "post",
            url: "getHisData",
            data: {
                starttime: starttime, // "2018-2-1 10：00：00",
                endtime: endtime, //"2018-10-5 10：00：00",
                monitorpointid: did
            },
            dataType: "json",
            success: function (result) {

                var data = JSON.parse(result);
                //UI图表部分
                eventChart1.setOption({dataset: {source: data}});
                $('#item2-UI-ctrl input.default-show').each(function () {//显示默认的曲线系列
                    $(this).trigger('click');
                });
                //频率HZ图表部分
                eventChart2.setOption({dataset: {source: data}});
                $('#item2-HZ-ctrl input.default-show').each(function () {//显示默认的曲线系列
                    $(this).trigger('click');
                });
                //功率P图表部分
                eventChart3.setOption({dataset: {source: data}});
                $('#item2-P-ctrl input.default-show').each(function () {//显示默认的曲线系列
                    $(this).trigger('click');
                });
            }
        });

        //取thd数据
        $.ajax({
            type: "post",
            url: "getHisDataTHD",
            data: {
                starttime: starttime, // "2018-2-1 10：00：00",
                endtime: endtime, //"2018-10-5 10：00：00",
                monitorpointid: did
            },
            dataType: "json",
            success: function (result) {

                var data = JSON.parse(result);
                //thd 图表部分
                eventChart5.setOption({dataset: {source: data}});
                $('#item2-thd-ctrl input.default-show').each(function () {//显示默认的曲线系列
                    $(this).trigger('click');
                });
            }
        });

        //取浪涌、塌陷数据
        $.ajax({
            type: "post",
            url: "getHisDataLyTx",
            data: {
                starttime: starttime,
                endtime: endtime,
                monitorpointid: did
            },
            dataType: "json",
            success: function(result){
               var data=JSON.parse(result);
               if(data != null) {
                   eventChart4.setOption({dataset: {source: data}});
                   $('#item2-LyTx-ctrl input.default-show').each(function () {//显示默认的系列
                       $(this).trigger('click');
                   });
               }
            }
        });

    }

    //wet temp
    function getDataTemp(starttime, endtime, did) {
        $.ajax({
            type: "post",
            url: "getHisDataEnvrionment",
            data: {
                starttime: starttime,
                endtime: endtime,
                monitorpointid: did
            },
            dataType: "json",
            success: function(result){
                var data=JSON.parse(result);
                //temp-env 图表部分
                eventChart6.setOption({dataset: {source: data}});
                $('#item2-temp-env input.default-show').each(function () {//显示默认的曲线系列
                    $(this).trigger('click');
                });

                //wet-env 图表部分
                eventChart7.setOption({dataset: {source: data}});
                $('#item2-wet-env input.default-show').each(function () {//显示默认的曲线系列
                    $(this).trigger('click');
                });
            }
        });
    }

    <!-- 时间选择器-->
    $('.form_datetime').datetimepicker({
        language: 'cn',
        weekStart: 1,
        todayBtn: 1,
        autoclose: 1,
        todayHighlight: 1,
        startView: 2,
        forceParse: 0,
        showMeridian: 1
    });

    //页面初始化工作...
    //为item2下所有的ul赋予样式list-style:none
    $('#item2 ul').css('list-style', 'none');
    eventBanding();
    drawCharts();

    //当时间选择器变化时
    $("#firstDate").change(function () {
        $('.firstDate').datetimepicker('setStartDate', $(this).val());
    });
    $("#lastDate").change(function () {
        $('.lastDate').datetimepicker('setEndDate', $(this).val());
    });

    $("#firstDate").val(getFormatDate(-1));
    $("#lastDate").val(getFormatDate(0));

    //获取当前日期前adddaycount天时间
    function getFormatDate(AddDayCount) {
        var dd = new Date();
        dd.setDate(dd.getDate() + AddDayCount);//获取AddDayCount天后的日期
        var y = dd.getFullYear();
        var m = dd.getMonth() + 1;//获取当前月份的日期
        var d = dd.getDate();
        var h = dd.getHours();
        var minute = dd.getMinutes();
        var s = dd.getSeconds();

        var seperator1 = "-";
        var seperator2 = ":";

        var currentdate = y + seperator1 + m + seperator1 + d
            + " " + h + seperator2 + minute
            + seperator2 + s;
        return currentdate;
    }

    function searchHis() {
        var did = $("#his-mpid-select").val();
        var didtemp = $("#his-temp-mpid-select").val();
        var stime = $("#firstDate").val();
        var etime = $("#lastDate").val();

        if (stime > etime) {
            alert("开始日期不能早于结束日期");
        } else if(did == null) {
            alert("请选择检测点");
        } else if(did != "" && didtemp != "" && stime != "" && etime != "") {
            var options=$("#item2-menu option:selected"); //获取选中的项

            if(options.val() == "item2-6" || options.val() == "item2-7"){
                getDataTemp(stime, etime, didtemp);
            } else if(options.val() == "item2-1" || options.val() == "item2-2" || options.val() == "item2-3" || options.val() == "item2-4" || options.val() == "item2-5"){
                getData(stime, etime, did);
            }
        }
    }
</script>

</body>

</html>
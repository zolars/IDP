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
    <link rel="stylesheet" type="text/css" href="css/font-awesome.4.6.0.css">
    <link href="css/animate.min.css" rel="stylesheet">
    <link href="css/form.css" rel="stylesheet">
    <link href="css/calendar.css" rel="stylesheet">
    <link href="css/media-player.css" rel="stylesheet">
    <link href="css/style.css" rel="stylesheet">
    <link href="css/icons.css" rel="stylesheet">
    <link href="css/generics.css" rel="stylesheet">
    <!--<link rel="stylesheet" href="css/reset.css">-->
    <link rel="stylesheet" href="css/jquery.hotspot.css">
    <link rel="stylesheet" type="text/css" href="css/deviceManager.css">
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

                <!-- 注销按钮 -->
                <div class="pull-right">
                    <li><a href="index.jsp">注销</a></li>
                </div>

                <div class="pull-right">欢迎用户${username} 登录</div>

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

    <!-- Map -->
    <script src="js/maps/jvectormap.min.js"></script>
    <!-- jVectorMap main library -->
    <script src="js/maps/usa.js"></script>
    <!-- USA Map for jVectorMap -->

    <!--Media Player-->
    <script src="js/media-player.min.js"></script>
    <!-- USA Map for jVectorMap -->

    <!--  Form Related -->
    <script src="js/icheck.js"></script>
    <!-- Custom Checkbox + Radio -->

    <!-- UX -->
    <script src="js/scroll.min.js"></script>
    <!-- Custom Scrollbar -->

    <!-- Other -->
    <script src="js/calendar.min.js"></script>
    <!-- Calendar -->
    <!--<script src="js/feeds.min.js"></script> &lt;!&ndash; News Feeds &ndash;&gt;-->
    <!--HotSpot of pic-->
    <script src="js/modernizr.custom.49511.js"></script>
    <script src="js/jquery.hotspot.min.js"></script>

    <!-- All JS functions -->
    <script src="js/functions.js"></script>
    <script type="text/javascript" src="js/deviceManager.js"></script>

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




</body>

</html>
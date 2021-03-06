<%@ page language="java" contentType="text/html; charset=UTF-8"

         pageEncoding="UTF-8"%>

<!DOCTYPE html>

<html>

<head>

    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

    <title>bootstrap-table-demo</title>

    <!-- 引入bootstrap样式 -->

    <link href="https://cdn.bootcss.com/bootstrap/3.3.2/css/bootstrap.min.css" rel="stylesheet">

    <!-- 引入bootstrap-table样式 -->

    <link href="https://cdn.bootcss.com/bootstrap-table/1.8.1/bootstrap-table.min.css" rel="stylesheet">

</head>

<body>

<div style="width: 100%; padding-top: 8px;" align="left">

    <table id="tablewrap" data-toggle="table" data-locale="zh-CN"

           data-ajax="ajaxRequest" data-side-pagination="server"

           data-striped="true" data-single-select="true"

           data-click-to-select="true" data-pagination="true"

           data-pagination-first-text="首页" data-pagination-pre-text="上一页"

           data-pagination-next-text="下一页" data-pagination-last-text="末页"

           class="fline-show-when-ready">

        <thead style="text-align: center;">

        <tr>

            <th data-formatter="numberAsc" data-width="50">序列</th>

            <th data-field="userName" data-width="300" data-formatter="nameFormat">用户名称</th>

            <th data-field="userId" data-width="100">用户id</th>

        </tr>

        </thead>

    </table>

</div>

</body>



<!-- jquery -->

<!-- 	<script src="../../js/jquery-3.3.1.min.js" type="text/javascript"></script> -->

<script src="https://cdn.bootcss.com/jquery/3.3.1/jquery.min.js"></script>

<script src="https://cdn.bootcss.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>

<!-- bootstrap-table.min.js -->

<script src="https://cdn.bootcss.com/bootstrap-table/1.8.1/bootstrap-table.min.js"></script>

<!-- 引入中文语言包 -->

<script src="https://cdn.bootcss.com/bootstrap-table/1.8.1/locale/bootstrap-table-zh-CN.min.js"></script>

<script type="text/javascript">

    var pageNum = 1;			//页码

    var pageSize = 10;			//页宽

    var count;					//数据量

    var index = 1;				//序号

    //数据获取

    function ajaxRequest(params) {

        pageSize = params.data.limit;

        pageNum = params.data.offset / pageSize + 1;

        index = params.data.offset + 1;

        $.ajax({

            type : 'get',

            url : "getCtrlEventJSON.json", //	这里的请求需要提供分页查询的功能。

            //data:{} ,//这里添加分页参数与查询条件。

            dataType : 'json',

            error : function(request, textStatus, errorThrown) {
                alert(textStatus);
            },

            success : function(data) {

                console.log(data);

                data = data.users;

                if (data) {

                    applies = data ? data : [];

                }

                console.log(applies);

                count = data.length;

                params.success({

                    total : count,

                    rows : applies

                });

                params.complete();

            }

        });

    }



    //自增序号

    function numberAsc(){

        return index++;		//index在ajaxRequest函数中被再次初始化

    }

    //名称格式化

    function nameFormat(name){

        if(name.length>20)

            return name.substring(0,20)+"...";

        else

            return name;

    }



</script>

</html>

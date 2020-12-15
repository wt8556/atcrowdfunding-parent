<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">

    <%@ include file="/WEB-INF/pages/include/base_css.jsp"%>

    <style>
        .tree li {
            list-style-type: none;
            cursor:pointer;
        }
        table tbody tr:nth-child(odd){background:#F4F4F4;}
        table tbody td:nth-child(even){color:#C00;}
    </style>
</head>

<body>

<nav class="navbar navbar-inverse navbar-fixed-top" role="navigation">
    <div class="container-fluid">
        <div class="navbar-header">
            <div><a class="navbar-brand" style="font-size:32px;" href="#">众筹平台 - 用户维护</a></div>
        </div>
        <%@ include file="/WEB-INF/pages/include/manager_loginbar.jsp"%>

    </div>
</nav>

<div class="container-fluid">
    <div class="row">
        <div class="col-sm-3 col-md-2 sidebar">
            <%@ include file="/WEB-INF/pages/include/manager_menu.jsp"%>

        </div>
        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title"><i class="glyphicon glyphicon-th"></i> 数据列表</h3>
                </div>
                <div class="panel-body">
                    <form action="${PATH}/admin/index" class="form-inline" role="form" style="float:left;">
                        <div class="form-group has-feedback">
                            <div class="input-group">
                                <div class="input-group-addon">查询条件</div>
                                <input value="${param.condition}" name="condition" class="form-control has-success" type="text" placeholder="请输入查询条件">
                            </div>
                        </div>
                        <button type="submit" class="btn btn-warning"><i class="glyphicon glyphicon-search"></i> 查询</button>
                    </form>
                    <button id="batchDelAdminsBtn" type="button" class="btn btn-danger" style="float:right;margin-left:10px;"><i class=" glyphicon glyphicon-remove"></i> 删除</button>
                    <button type="button" class="btn btn-primary" style="float:right;" onclick="window.location.href='${PATH}/admin/add.html'"><i class="glyphicon glyphicon-plus"></i> 新增</button>
                    <br>
                    <hr style="clear:both;">
                    <div class="table-responsive">
                        <table class="table  table-bordered">
                            <thead>
                            <tr >
                                <th width="30">#</th>
                                <th width="30"><input type="checkbox"></th>
                                <th>账号</th>
                                <th>名称</th>
                                <th>邮箱地址</th>
                                <th width="100">操作</th>
                            </tr>
                            </thead>
                            <tbody>
                            <%--    admins 集合使用 一个表格显示，admin对象使用一行显示
                                    varStatus: 当前遍历的状态对象，遍历开始时标签创建该对象，每次迭代时会自动更新该对象的属性值
                                        index:正在遍历元素的索引，从0开始
                                        count：正在遍历的元素是第几个,从1开始
                                        current：正在遍历的元素对象
                                        isFirst：是否是第一个,isLast

                            --%>
                            <c:if test="${!empty pageInfo.list}">
                                <c:forEach items="${pageInfo.list}" var="item" varStatus="vs">
                                    <tr>
                                        <td>${vs.count}</td>
                                        <td><input type="checkbox" adminid="${item.id}"></td>
                                        <td>${item.loginacct}</td>
                                        <td>${item.username}</td>
                                        <td>${item.email}</td>
                                        <td>
                                            <button type="button" onclick="window.location='${PATH}/admin/assignRole.html?id=${item.id}'" class="btn btn-success btn-xs"><i class=" glyphicon glyphicon-check"></i></button>
                                            <button type="button" onclick="window.location='${PATH}/admin/edit.html?id=${item.id}'" class="btn btn-primary btn-xs"><i class=" glyphicon glyphicon-pencil"></i></button>
                                            <button type="button" adminid="${item.id}" class="btn btn-danger btn-xs deleteAdminBtn"><i class=" glyphicon glyphicon-remove"></i></button>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:if>
                            </tbody>
                            <tfoot>
                            <tr >
                                <td colspan="6" align="center">
                                    <ul class="pagination">

                                        <%--上一页--%>
                                        <c:choose>
                                            <c:when test="${pageInfo.isFirstPage}">
                                                <%--当前页是第一页，上一页按钮禁用--%>
                                                <li class="disabled"><a href="javascript:void(0)">上一页</a></li>
                                            </c:when>
                                            <c:otherwise>
                                                <%--当前页不是第一页，上一页按钮可以点击--%>
                                                <li><a href="${PATH}/admin/index?pageNum=${pageInfo.pageNum-1}&condition=${param.condition}">上一页</a></li>
                                            </c:otherwise>
                                        </c:choose>

                                        <%--中间页码--%>
                                        <c:forEach items="${pageInfo.navigatepageNums}" var="index">
                                            <c:choose>
                                                <c:when test="${index == pageInfo.pageNum}">
                                                    <li class="active"><a href="javascript:void(0)">${index} <span class="sr-only">(current)</span></a></li>
                                                </c:when>
                                                <c:otherwise>
                                                    <li><a href="${PATH}/admin/index?pageNum=${index}">${index}</a></li>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:forEach>

                                        <%--下一页--%>
                                        <c:choose>
                                            <c:when test="${pageInfo.isLastPage}">
                                                <%--当前页是最后一页，下一页按钮禁用--%>
                                                <li class="disabled"><a href="javascript:void(0)">下一页</a></li>
                                            </c:when>
                                            <c:otherwise>
                                                <%--当前页不是最后一页，下一页按钮可以点击--%>
                                                <li><a href="${PATH}/admin/index?pageNum=${pageInfo.pageNum+1}&condition=${param.condition}">下一页</a></li>
                                            </c:otherwise>
                                        </c:choose>

                                    </ul>
                                </td>
                            </tr>

                            </tfoot>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/pages/include/base_js.jsp"%>
<script type="text/javascript">
    //批量删除单击事件
    $("#batchDelAdminsBtn").click(function () {
        //获取选中的tbody内的管理员id列表提交给后台删除
        var $checkedIpu = $("table tbody :checkbox:checked");
        //遍历集合，将每个input的管理员id获取到
        var idsArr = new Array();//js的数组
        $checkedIpu.each(function () {
            //jquery的增强for循环，会自动对jquery对象进行遍历，使用遍历的dom对象调用传入的函数
            //this就代表正在遍历的dom对象
            idsArr.push($(this).attr("adminid"));//向数组中添加元素
        });
        //console.log(idsArr);
        // idsArr.join(","); 将数组中的元素每两个使用逗号连接成一个字符串  ，例如：[1,2,3] ==   1,2,3
        if(idsArr.length==0){
            layer.msg("请选择要删除的管理员");
            return;
        }
        //提交批量删除的请求
        layer.confirm("您真的要删除吗?" , function () {
            window.location = "${PATH}/admin/batchDelAdmins?ids="+idsArr.join();
        })
    });

    //批量删除的全选效果
    //1、thead中的全选框的单击事件：点击时设置所有的tbody内的复选框状态和自己一致
    $("table thead :checkbox").click(function () {
        //alert(this.checked);
        //checked = true /false
        $("table tbody :checkbox").prop("checked" , this.checked);
    });
    //2、tbody中的子复选框的单击事件：每个子复选框被点击时，都需要检查是否全被选中，如果有没选中的则设置全选框不选中
    $("table tbody :checkbox").click(function () {
        // this代表被点击的复选框dom对象
        //获取所有的tbody内复选框的数量
        var totalCount = $("table tbody :checkbox").length;
        //获取tbody内被选中的复选框的数量
        var checkedCount = $("table tbody :checkbox:checked").length;

        $("table thead :checkbox").prop("checked" ,totalCount==checkedCount );
    });

    //删除单个管理员的单击事件
    $(".deleteAdminBtn").click(function () {
        //获取要删除管理员的id：被点击按钮所在行的管理员id
        //this代表被点击的删除按钮dom对象
        //$(this).prop()获取标签的自带属性   //attr()获取我们设置的自定义属性的值
        var adminid = $(this).attr("adminid");
        //alert(adminid);
        var name = $(this).parents("tr").children("td:eq(2)").text();
        layer.confirm("您真的要删除《"+ name +"》吗?" , {icon:3} , function () {
            //确认的单击事件
            window.location = "${PATH}/admin/delete/"+adminid;
        })
    });


    //当前页面所在模块的菜单自动展开+模块标签高亮显示
    $(".list-group-item:contains(' 权限管理 ')").removeClass("tree-closed");
    $(".list-group-item:contains(' 权限管理 ') ul").show();
    $(".list-group-item:contains(' 权限管理 ') li :contains('用户维护')").css("color","red");
    $(function () {
        $(".list-group-item").click(function(){
            if ( $(this).find("ul") ) {
                $(this).toggleClass("tree-closed");
                if ( $(this).hasClass("tree-closed") ) {
                    $("ul", this).hide("fast");
                } else {
                    $("ul", this).show("fast");
                }
            }
        });
    });

</script>
</body>
</html>


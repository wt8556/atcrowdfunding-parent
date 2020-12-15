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
    </style>
</head>

<body>

<nav class="navbar navbar-inverse navbar-fixed-top" role="navigation">
    <div class="container-fluid">
        <div class="navbar-header">
            <div><a class="navbar-brand" style="font-size:32px;" href="user.html">众筹平台 - 用户维护</a></div>
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

            <ol class="breadcrumb">
                <li><a href="#">首页</a></li>
                <li><a href="#">数据列表</a></li>
                <li class="active">分配角色</li>
            </ol>
            <div class="panel panel-default">
                <div class="panel-body">
                    <form role="form" class="form-inline">
                        <div class="form-group">
                            <label for="exampleInputPassword1">未分配角色列表</label><br>
                            <select id="unassignedRolesSel" class="form-control" multiple size="10" style="width:400px;overflow-y:auto;">
                                <c:forEach items="${unassignedRoles}" var="unassignedRole">
                                    <option value="${unassignedRole.id}">${unassignedRole.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group">
                            <ul>
                                <li class="btn btn-default glyphicon glyphicon-chevron-right" id="assignRolesToAdmin"></li>
                                <br>
                                <li class="btn btn-default glyphicon glyphicon-chevron-left" id="unAssignRolesToAdmin" style="margin-top:20px;"></li>
                            </ul>
                        </div>
                        <div class="form-group" style="margin-left:40px;">
                            <label for="exampleInputPassword1">已分配角色列表</label><br>
                            <select id="assignedRolesSel" class="form-control" multiple size="10" style="width:400px;overflow-y:auto;">
                                <c:forEach items="${assignedRoles}" var="assignedRole">
                                    <option value="${assignedRole.id}">${assignedRole.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
                <h4 class="modal-title" id="myModalLabel">帮助</h4>
            </div>
            <div class="modal-body">
                <div class="bs-callout bs-callout-info">
                    <h4>测试标题1</h4>
                    <p>测试内容1，测试内容1，测试内容1，测试内容1，测试内容1，测试内容1</p>
                </div>
                <div class="bs-callout bs-callout-info">
                    <h4>测试标题2</h4>
                    <p>测试内容2，测试内容2，测试内容2，测试内容2，测试内容2，测试内容2</p>
                </div>
            </div>
            <!--
            <div class="modal-footer">
              <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
              <button type="button" class="btn btn-primary">Save changes</button>
            </div>
            -->
        </div>
    </div>
</div>
<%@ include file="/WEB-INF/pages/include/base_js.jsp"%>
<script type="text/javascript">

    //取消分配角色按钮的单击事件
    $("#unAssignRolesToAdmin").click(function () {
        //获取要取消角色列表的管理员id：adminid
        var adminid = "${param.id}";
        //已分配角色列表中选中的要取消的角色id集合：roleids
        var roleidsArr = new Array();
        $("#assignedRolesSel option:selected").each(function () {
            roleidsArr.push(this.value);
        });
        if(roleidsArr.length==0){
            layer.msg("请选择要取消的角色!!!");
            return ;
        }
        //提交取消分配角色的请求
        $.ajax({
            type:"post",
            data:{adminid:adminid , roleids: roleidsArr.join()},
            url:"${PATH}/admin/unassignRolesToAdmin",
            success:function(result){
                if(result=="ok"){
                    layer.msg("删除角色成功");
                    //dom操作将被选中的option移到左边列表
                    $("#assignedRolesSel option:selected").appendTo("#unassignedRolesSel");
                }
            }
        });
    });

    //分配角色按钮的单击事件
    $("#assignRolesToAdmin").click(function () {
        //发送请求分配角色： 管理员id和角色id集合参数
        var adminid = "${param.id}";
        var roleidsArr = new Array();
        $("#unassignedRolesSel option:selected").each(function () {
            // this 代表正在遍历的选中的option
            var roleid = this.value;
            roleidsArr.push(roleid);
        });
        if(roleidsArr.length==0){
            layer.msg("请选择要分配的角色！！");
            return ;
        }
        var ids = roleidsArr.join();
        $.ajax({
            type:"post",
            url:"${PATH}/admin/assignRolesToAdmin",
            data:{adminid:adminid , roleids:ids},
            success:function (result) {
                if(result=="ok"){
                    layer.msg("角色分配成功");
                    //通过dom操作将选中的option从未选中列表移到选中的列表中
                    $("#unassignedRolesSel option:selected").appendTo("#assignedRolesSel");
                }
            }
        });


    });


    //取消分配角色按钮的单击事件



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


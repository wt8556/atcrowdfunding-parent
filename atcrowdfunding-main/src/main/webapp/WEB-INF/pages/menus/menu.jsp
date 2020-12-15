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
            <div><a class="navbar-brand" style="font-size:32px;" href="#">众筹平台 - 许可维护</a></div>
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
                <div class="panel-heading"><i class="glyphicon glyphicon-th-list"></i> 权限菜单列表 <div style="float:right;cursor:pointer;" data-toggle="modal" data-target="#myModal"><i class="glyphicon glyphicon-question-sign"></i></div></div>
                <div class="panel-body">
                    <%-- ztree显示的容器 --%>
                    <ul id="menuTree" class="ztree"></ul>
                </div>
            </div>
        </div>
    </div>
</div>
<%-- 新增子菜单的模态框 --%>
<div class="modal fade" id="addChildMenuModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="exampleModalLabel">新增菜单</h4>
            </div>
            <div class="modal-body">
                <form>
                    <%--  新增菜单的父菜单id通过隐藏域携带  --%>
                    <input type="hidden" name="pid">
                    <div class="form-group">
                        <label for="recipient-name" class="control-label">菜单名称:</label>
                        <input type="text" name="name" class="form-control" id="recipient-name">
                    </div>
                    <div class="form-group">
                        <label for="recipient-name" class="control-label">菜单图标:</label>
                        <input type="text" name="icon" class="form-control" id="recipient-name">
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button type="button" id="addChildMenuModalBtn" class="btn btn-primary">提交</button>
            </div>
        </div>
    </div>
</div>

<%-- 更新菜单的模态框 --%>
<div class="modal fade" id="updateMenuModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="exampleModalLabel">更新菜单</h4>
            </div>
            <div class="modal-body">
                <form>
                    <%--  通过隐藏域携带要更新的菜单的id  --%>
                    <input type="hidden" name="id">
                    <div class="form-group">
                        <label for="recipient-name" class="control-label">菜单名称:</label>
                        <input type="text" name="name" class="form-control" id="recipient-name">
                    </div>
                    <div class="form-group">
                        <label for="recipient-name" class="control-label">菜单图标:</label>
                        <input type="text" name="icon" class="form-control" id="recipient-name">
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button type="button" id="updateMenuModalBtn" class="btn btn-primary">提交</button>
            </div>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/pages/include/base_js.jsp"%>

<script type="text/javascript">
    //===========ztree测试 start====================
    //ztree就是jquery的插件，可以根据传入的json数据，自动将数据解析为树状图的标签可以设置到一个ul中显示
    /*
    * 使用步骤：
    *       1、在页面中引入ztree的样式文件和js文件[依赖jquery]
    *       2、在页面中准备树状图显示的容器[ ul标签设置 class值为ztree ]
    *       3、准备ztree解析使用的配置：
    *       4、准备数据源：json数据(ztree树显示的数据)
    *       5、使用ztree将数据源按照配置对象解析成ztree树设置到容器中显示
    * */
    // //配置对象
    // var setting = {};
    // //数据源
    // var zNodes;
    // //解析ztree树
    // //参数1：容器，参数2：配置，参数3：数据源
    // var $ztreeObj = $.fn.zTree.init($("#menuTree"), setting, zNodes);
    // //设置ztree自动展开
    // $ztreeObj.expandAll(true);
    //===========ztree测试 end====================

    //新增模态框提交新增请求
    $("#addChildMenuModalBtn").click(function () {
        $.ajax({
            type:"post",
            url:"${PATH}/menu/addMenu",
            data:$("#addChildMenuModal form").serialize(),
            success:function (result) {
                if(result=="ok"){
                    //关闭模态框
                    $("#addChildMenuModal").modal("hide");
                    //刷新ztree树
                    initZtree();
                }
            }
        });
    });

    //更新模态框提交按钮的单击事件
    $("#updateMenuModalBtn").click(function () {
        $.ajax({
            "type":"post",
            "url":"${PATH}/menu/updateMenu",
            "data":$("#updateMenuModal form").serialize(),
            "success":function (result) {
                if(result=="ok"){
                    //关闭模态框
                    $("#updateMenuModal").modal("hide");
                    layer.msg("更新成功");
                    //刷新菜单树
                    initZtree();
                }
            }
        });
    });

    //菜单节点按钮组的单击事件：
    //1、新增子菜单
    function addChildMenu(pid){
        //alert("addChildMenu: "+ pid);
        //回显pid
        $("#addChildMenuModal form input[name='pid']").val(pid);
        //显示新增模态框
        $("#addChildMenuModal").modal("show");

    }
    //2、回显要更新的菜单
    function updateMenu(id){
        // alert("updateMenu: "+id);
        //根据id查询要更新的模态框
        $.ajax({
            type:"get",
            url:"${PATH}/menu/getMenu",
            data:{id:id},
            success:function (menu) {
                //将菜单回显到模态框中
                $("#updateMenuModal form [name='id']").val(menu.id);
                $("#updateMenuModal form [name='name']").val(menu.name);
                $("#updateMenuModal form [name='icon']").val(menu.icon);
                //显示模态框
                $("#updateMenuModal").modal("show");
            }
        });

    }
    //3、删除当前菜单
    function deleteMenu(id,name){
        //this不代表代表被点击的删除按钮，代表windows对象
//        var name = $(this).attr("menuname");
        //alert("deleteMenu: "+id);
        layer.confirm("您真的要删除["+name+"]菜单吗？",{icon:3},function () {
            //提交删除请求
            $.ajax({
                type:"get",
                url:"${PATH}/menu/deleteMenu",
                data:{"id":id},//json属性使用双引号引起，
                success:function (result) {
                    if(result=="ok"){
                        layer.closeAll();
                        layer.msg("删除成功");
                        //刷新菜单树
                        initZtree();
                    }
                }
            });
        })
    }

    //当前页面打开后，发送异步请求加载菜单列表
    initZtree();
    function initZtree(){
        $.ajax({
            type:"get",
            url:"${PATH}/menu/getMenus",
            success:function (menus) {
                //向menus中push一个根节点
                menus.push({id:0 , name:"系统权限菜单",icon:"glyphicon glyphicon glyphicon-tasks"});
                console.log(menus);
                //异步加载数据成功，解析菜单集合形成菜单树。
                //配置对象
                var setting = {
                    view: {
                        //参数1：ztree容器的id，参数2：刚创建完毕的树节点对象
                        //ztree每创建一个树节点时，都会回调一次此方法，在方法中可以自定义对节点进行修改
                        addDiyDom: function(treeId , treeNode){
                            //treeNode:包含数据源数据()+ztree生成的属性(tId:当前树节点的id)
                            //console.log(treeNode);
                            $("#"+treeNode.tId+"_ico").remove();//移除当前树节点显示图标的span标签
                            $("#"+treeNode.tId+"_span").before("<span class='"+treeNode.icon+"'></span>");
                        },
                        //鼠标在节点上悬停时的回调函数
                        addHoverDom: function(treeId, treeNode){
                            var aObj = $("#" + treeNode.tId + "_a"); // tId = permissionTree_1, ==> $("#permissionTree_1_a")
                            //aObj.attr("href", "javascript:;");
                            if (treeNode.editNameFlag || $("#btnGroup"+treeNode.tId).length>0) return;
                            var s = '<span id="btnGroup'+treeNode.tId+'">';
                            if ( treeNode.level == 0 ) {//根节点
                                //新增按钮
                                s += '<a onclick="addChildMenu('+treeNode.id+')" href="javascript:void(0)" class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;" href="#" >&nbsp;&nbsp;<i class="fa fa-fw fa-plus rbg "></i></a>';
                            } else if ( treeNode.level == 1 ) {//枝节点
                                //更新按钮
                                s += '<a onclick="updateMenu('+treeNode.id+')" href="javascript:void(0)" class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;"  href="#" title="修改权限信息">&nbsp;&nbsp;<i class="fa fa-fw fa-edit rbg "></i></a>';
                                if (treeNode.children.length == 0) {//如果TMenu类的子菜单集合的属性不是children需要修改为自己的属性
                                    //删除按钮
                                    s += '<a menuname="'+treeNode.name+'" deleteMenu('+treeNode.id+' , \'' + treeNode.name +  '\')" href="javascript:void(0)" class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;" href="#" >&nbsp;&nbsp;<i class="fa fa-fw fa-times rbg "></i></a>';
                                }
                                //新增按钮
                                s += '<a  onclick="addChildMenu('+treeNode.id+')" href="javascript:void(0)" class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;" href="#" >&nbsp;&nbsp;<i class="fa fa-fw fa-plus rbg "></i></a>';
                            } else if ( treeNode.level == 2 ) {//叶子节点
                                //修改按钮
                                s += '<a onclick="updateMenu('+treeNode.id+')" href="javascript:void(0)" class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;"  href="#" title="修改权限信息">&nbsp;&nbsp;<i class="fa fa-fw fa-edit rbg "></i></a>';
                                //删除按钮
                                s += '<a menuname="'+treeNode.name+'" onclick="deleteMenu('+treeNode.id+' , \'' + treeNode.name +  '\')" href="javascript:void(0)" class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;" href="#">&nbsp;&nbsp;<i class="fa fa-fw fa-times rbg "></i></a>';
                            }

                            s += '</span>';
                            aObj.after(s);
                        },
                        //鼠标离开树节点时的回调函数
                        removeHoverDom: function (treeId , treeNode) {
                            $("#btnGroup"+treeNode.tId).remove();
                        }
                    },
                    data: {
                        key: {
                            url: "asdasfasfsa"
                        },
                        simpleData: {
                            enable: true,
                            pIdKey: "pid" //数据源加载时，根据pid属性形成父子结构
                        }
                    }};
                //数据源
                var zNodes = menus;
                //解析ztree树
                //参数1：容器，参数2：配置，参数3：数据源
                var $ztreeObj = $.fn.zTree.init($("#menuTree"), setting, zNodes);
                //设置ztree自动展开
                $ztreeObj.expandAll(true);
            }
        });
    }




    //当前页面所在模块的菜单自动展开+模块标签高亮显示
    $(".list-group-item:contains(' 权限管理 ')").removeClass("tree-closed");
    $(".list-group-item:contains(' 权限管理 ') ul").show();
    $(".list-group-item:contains(' 权限管理 ') li :contains('菜单维护')").css("color","red");
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

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
            <div><a class="navbar-brand" style="font-size:32px;" href="#">众筹平台 - 角色维护</a></div>
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
                    <form class="form-inline" role="form" style="float:left;">
                        <div class="form-group has-feedback">
                            <div class="input-group">
                                <div class="input-group-addon">查询条件</div>
                                <input name="condition" class="form-control has-success" type="text" placeholder="请输入查询条件">
                            </div>
                        </div>
                        <button id="queryRolesBtn" type="button" class="btn btn-warning"><i class="glyphicon glyphicon-search"></i> 查询</button>
                    </form>
                    <button type="button" id="batchDelRolesBtn" class="btn btn-danger" style="float:right;margin-left:10px;"><i class=" glyphicon glyphicon-remove"></i> 删除</button>
                    <button type="button" id="showAddRoleModalBtn" class="btn btn-primary" style="float:right;"><i class="glyphicon glyphicon-plus"></i> 新增</button>
                    <br>
                    <hr style="clear:both;">
                    <div class="table-responsive">
                        <table class="table  table-bordered">
                            <thead>
                            <tr >
                                <th width="30">#</th>
                                <th width="30"><input type="checkbox"></th>
                                <th>名称</th>
                                <th width="100">操作</th>
                            </tr>
                            </thead>
                            <tbody>

                            </tbody>
                            <tfoot>
                            <tr >
                                <td colspan="6" align="center">
                                    <ul class="pagination">

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

<%--  新增角色的模态框 --%>
<div class="modal fade" id="addRoleModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="exampleModalLabel">新增角色</h4>
            </div>
            <div class="modal-body">
                <form>
                    <div class="form-group">
                        <label for="recipient-name" class="control-label">角色名称:</label>
                        <input type="text" name="name" class="form-control" id="recipient-name">
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button type="button" id="addRoleBtn" class="btn btn-primary">提交</button>
            </div>
        </div>
    </div>
</div>
<%--  新增角色的模态框-end --%>
<%--  更新角色的模态框 --%>
<div class="modal fade" id="updateRoleModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="exampleModalLabel">更新角色</h4>
            </div>
            <div class="modal-body">
                <form>
                    <input type="hidden" name="id">
                    <div class="form-group">
                        <label for="recipient-name" class="control-label">角色名称:</label>
                        <input type="text" name="name" class="form-control" id="recipient-name">
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button type="button" id="updateRoleModalBtn" class="btn btn-primary">提交</button>
            </div>
        </div>
    </div>
</div>
<%--  更新角色的模态框-end --%>

<%--  给角色分配权限的模态框  --%>
<div class="modal fade" id="assignPermissionsToRoleModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="exampleModalLabel">权限分配</h4>
            </div>
            <div class="modal-body">
                <ul id="ztreeContainer" class="ztree"></ul>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button type="button" id="assignPermissionsToRoleBtn" class="btn btn-primary">分配</button>
            </div>
        </div>
    </div>
</div>


<%@ include file="/WEB-INF/pages/include/base_js.jsp"%>
<script type="text/javascript">
    //定义全局范围的变量：接受加载分页数据的当前页码
    var currentPagenum;
    var totalPages;
    var $ztreeObj;
    var roleid;

    //分配权限模态框的分配按钮的单击事件
    $("#assignPermissionsToRoleBtn").click(function () {
        //获取模态框中所有的被选中的权限的id集合
        //通过ztree对象获取所有被选中的节点对象
        var $checkedTreeNodes = $ztreeObj.getCheckedNodes(true);
        //console.log($checkedTreeNodes);
        var permissionidsArr = new Array();
        $.each($checkedTreeNodes,function(){
            permissionidsArr.push(this.id);
        });

        var pids ;
        if(permissionidsArr.length>0){
            pids = permissionidsArr.join();
        }
        //获取角色id
        //发送异步分配权限的请求
        $.ajax({
            type:"post",
            url:"${PATH}/role/assignPermissionsToRole",
            data:{roleid:roleid , permissionids:pids},
            success:function (result) {
                if(result=="ok"){
                    //关闭权限分配的模态框
                    $("#assignPermissionsToRoleModal").modal("hide");
                    layer.msg("权限分配成功");
                }
            }
        });
    });
    //========================分配权限按钮单击事件
    $("tbody").delegate(".showAssignPermissionModalBtn","click" , function () {
        //获取被点击按钮所在行角色的id
        roleid = $(this).attr("roleid");
        //查询已分配的权限列表
        //查询所有的权限列表
        $.ajax({
            type:"get",
            url:"${PATH}/role/getPermissions",
            success:function (permissions) {
                //获取到所有的权限后 再查询当前角色已分配的权限id集合
                $.ajax({
                    type:"get",
                    url:"${PATH}/role/getAssignedPermissionids",
                    data:{roleid:roleid},
                    success:function (permissionids) {
                        //遍历所有的权限，判断它是否应该设置默认选中
                        $.each(permissions,function () {
                            //js中。数组可用通过查找数组中元素指定索引的方式判断是否包含某个元素，如果返回-1表示没有
                            if(permissionids.indexOf(this.id)>=0){
                                //已分配的权限id中包含正在遍历的权限，设置默认选中
                                this.checked = true;
                            }
                        });

                        //模态框中准备ztree容器
                        //准备ztree配置
                        var setting = {
                            check: {
                                enable: true
                            },
                            view: {
                                addDiyDom: function (treeId , treeNode) {
                                    $("#"+treeNode.tId +"_ico").remove();
                                    $("#"+treeNode.tId +"_span").before("<span class='"+treeNode.icon+"'></span>");
                                }
                            },
                            data: {
                                simpleData: {
                                    enable: true,
                                    pIdKey: "pid"
                                },
                                key: {
                                    name: "title" //指定显示的节点名称使用数据源的哪个属性
                                }
                            }
                        };
                        //准备数据源
                        var zNodes = permissions;
                        //初始化ztree树显示到容器中
                        $ztreeObj = $.fn.zTree.init($("#ztreeContainer"), setting, zNodes);
                        $ztreeObj.expandAll(true);
                        //显示模态框
                        $("#assignPermissionsToRoleModal").modal("show");

                    }
                });


            }
        });
        //将所有的权限以ztree树的方式显示到模态框中
        //设置已分配的权限默认勾选
        //显示模态框

    });
    //======================更新-start========================
    //当点击更新按钮时，查询要更新的角色并设置到更新模态框中显示模态框
    $("tbody").delegate(".updateRoleBtn" , "click",function () {
        var roleid = $(this).attr("roleid");
        $.get("${PATH}/role/getRole" , {id:roleid} , function (role) {
            //回显数据到更新的模态框中
            //console.log(role);
            $("#updateRoleModal input[name='id']").val(role.id);
            $("#updateRoleModal input[name='name']").val(role.name);
            $("#updateRoleModal").modal("show");
        })
    });

    //更新模态框的提交按钮单击事件
    $("#updateRoleModalBtn").click(function () {
        $.post("${PATH}/role/updateRole" , $("#updateRoleModal form").serialize(),function (result) {
            if(result=="ok"){
                //关闭模态框
                $("#updateRoleModal").modal("hide");
                //更新当前页面
                var condition = $("input[name='condition']").val();
                getRoles(currentPagenum , condition);
                //提示
                layer.msg("更新成功");
            }
        } );
    });
    //======================更新-end========================

    //新增按钮的单击事件
    $("#showAddRoleModalBtn").click(function () {
        //显示模态框
        $("#addRoleModal").modal("toggle");//show   hide
    });
    //新增模态框提交按钮的单击事件
    $("#addRoleBtn").click(function () {
        $.ajax({
            type:"post",
            url:"${PATH}/role/addRole",
            data:$("#addRoleModal form").serialize(),//表单的表单项必须有name属性值才会拼接为name值=value的方式提交
            success:function (result) {
                if(result=="ok"){
                    //关闭模态框
                    $("#addRoleModal").modal("toggle");
                    //跳到最后一页显示新增内容
                    getRoles(totalPages+1);
                    layer.msg("新增成功");
                }
            }
        });
    });


    /**
     * 全选效果：
     *  1、thead中的全选框绑定单击事件：
     */
    $("thead :checkbox").click(function () {//单击事件一定是在页面加载成功后用户再点击调用
        //一定能找到异步生成的标签
        $("tbody :checkbox").prop("checked",this.checked);
    });
    //2、tbody内子复选框的单击事件
    $("tbody").delegate(':checkbox',"click",function () {
        $("thead :checkbox").prop("checked" , $("tbody :checkbox").length== $("tbody :checkbox:checked").length);
    });
    //3、给批量删除按钮绑定单击事件：点击时提交删除请求
    $("#batchDelRolesBtn").click(function () {
        //获取选中的要删除的角色id集合并拼接为ids=1,2,3的格式
        var roleidsArr = new Array();
        $("tbody :checkbox:checked").each(function () {
            //this代表正在遍历的被选中的复选框
            roleidsArr.push($(this).attr("roleid"));
        })
        if(roleidsArr.length==0){
            layer.msg("请选择要删除的角色");
            return ;
        }
        var roleids = roleidsArr.join();
        //发送ajax删除请求
        $.ajax({
            type:"get",
            url:"${PATH}/role/batchDelRoles",
            data:{"ids":roleids},
            success:function (result) {
                if(result=="ok"){
                    layer.msg("批量删除成功");
                    var condition = $("input[name='condition']").val();
                    getRoles(currentPagenum , condition);
                }
            }
        });
    });

    /**
     * 提交删除请求的单击事件
     */
    $("tbody").delegate(".deleteRoleBtn","click",function () {
        //一定要在此获取被点击按钮所在行的标签
        var $tr = $(this).parents("tr");//后台响应成功需要删除tr对象
        var roleid = $(this).attr("roleid");//异步请求删除角色的id

        layer.confirm("您确认删除吗?", {title:"删除提示:" , "icon":3} , function () {
            $.ajax({
                type:"get",
                url:"${PATH}/role/delete",
                data:{"id":roleid},
                success:function (result) {
                    if(result=="ok"){
                        layer.msg("删除成功");
                        //删除当前按钮所在行的角色标签
                        $tr.remove();
                        //判断本次删除之后页面中是否还有角色数据
                        if($("tbody tr").length===0){
                            //tbody内没有角色列表数据，刷新当前页
                            var condition = $("input[name='condition']").val();
                            getRoles(currentPagenum , condition);
                        }
                    }
                }
            });
        })

    })


    /**
     * 给带条件查询的按钮绑定单击事件，点击提交异步加载带条件分页数据并解析的请求
     */
    $("#queryRolesBtn").click(function () {
        //获取查询条件
        var condition = $("input[name='condition']").val();
        getRoles(1,condition);
    });

    /**
     * 1、当前页面浏览器访问后立即发送ajax请求加载角色列表数据显示
     */
    getRoles(1);
    //抽取的异步请求角色分页数据并解析的方法
    function getRoles(pageNum , condition){
        //还原全选款的选中状态
        $("thead :checkbox").prop("checked",false);
        //删除之前异步生成的标签
        $("tbody").empty();//删除tbody内的内容
        $("tfoot ul").empty();
        $.ajax({
            url:"${PATH}/role/getRoles",//请求地址
            type:"get",//请求方式
            data:{"pageNum":pageNum , "condition":condition},//请求参数
            success:function (pageInfo) {//请求成功后的回调函数，result代表服务器响应的结果(响应体)
                //将分页数据中的当前页码使用全局变量接收保存
                currentPagenum = pageInfo.pageNum;
                //将分页数据中的总页码使用全局变量接收保存
                totalPages = pageInfo.pages;

                //1、解析pageInfo.list集合，将数据显示到tbody内：
                initRoleList(pageInfo);

                //2、解析pageInfo.navigatepageNums，生成页码导航条
                initRoleNav(pageInfo);
            }
        });
    }
    //解析分页数据的 角色集合显示到tbody的方法
    function initRoleList(pageInfo){
        //list中的一条记录使用一行显示
        $.each(pageInfo.list,function(index){//jquery会自动遍历list集合，没遍历一个元素会使用它调用一次function函数
            //this表示{"id":1,"name":"PM - 项目经理"}  json对象
            //this.id 可以获取id
            $('<tr>\n' +
                '<td>'+(index+1)+'</td>\n' +
                '<td><input roleid="'+this.id+'" type="checkbox"></td>\n' +
                '<td>'+this.name+'</td>\n' +
                ' <td>\n' +
                '   <button roleid="'+this.id+'" type="button" class="btn btn-success btn-xs showAssignPermissionModalBtn"><i class=" glyphicon glyphicon-check"></i></button>\n' +
                '   <button roleid="'+this.id+'" type="button" class="btn btn-primary btn-xs updateRoleBtn"><i class=" glyphicon glyphicon-pencil"></i></button>\n' +
                '   <button roleid="'+this.id+'" type="button" class="btn btn-danger btn-xs deleteRoleBtn"><i class=" glyphicon glyphicon-remove"></i></button>\n' +
                '</td>\n' +
                '</tr>').appendTo("tbody");

        });
    }
    //角色分页数据的分页导航条解析方法
    function initRoleNav(pageInfo){
        //分页导航条的单击事件，请求分页数据时后台只会响应分页的json，如果让浏览器发送同步请求浏览器会显示json覆盖之前的页面(同步)
        //分页导航栏超链接点击时应该由js代码发送异步请求，成功后js可以接受并解析异步响应的结果，通过dom解析显示到页面中

        //上一页的li
        if(pageInfo.isFirstPage){
            $('<li class="disabled"><a href="javascript:void(0)">上一页</a></li>').appendTo("tfoot ul")
        }else{
            $('<li><a class="navA" pagenum="'+(pageInfo.pageNum-1)+'" href="javascript:void(0)">上一页</a></li>').appendTo("tfoot ul")
        }
        //中间页码："navigatepageNums":[1,2,3],
        $.each(pageInfo.navigatepageNums , function () {
            //this 代表正在遍历的页码
            if(this==pageInfo.pageNum){
                //当前页
                $('<li class="active"><a href="javascript:void(0)">'+this+' <span class="sr-only">(current)</span></a></li>').appendTo("tfoot ul");
            }else{
                $('<li><a class="navA" pagenum="'+this+'" href="javascript:void(0)">'+this+'</a></li>').appendTo("tfoot ul");
            }
        });


        //下一页的li
        if(pageInfo.isLastPage){
            $('<li class="disabled"><a href="javascript:void(0)">下一页</a></li>').appendTo("tfoot ul")
        }else{
            $('<li><a class="navA" pagenum="'+(pageInfo.pageNum+1)+'" href="javascript:void(0)">下一页</a></li>').appendTo("tfoot ul")
        }

        //在上面的标签创建之后，给分页超链接绑定单击事件
        // $(".navA").click(function () {
        //     var pagenum = $(this).attr("pagenum");
        //     //发送异步请求
        //     getRoles(pagenum);
        // });

    }

    //由于class值为navA的标签在异步请求成功之后才会解析生成，$(".navA")在js代码的主线程中会立即执行，在异步请求还未成功时，主线程就需要使用标签
    //所以查找失败
    //动态委派：无论现有的标签还是异步加载生成的标签都可以绑定上事件
    // $(".navA").live("click" , function(){});  如果页面中有新增的标签，class值为navA,则绑定单击事件
    //  live方法性能差，已经淘汰
    // $("祖先元素").delegate("后代元素","事件类型" , 事件处理函数); 如果祖先元素内新增的标签满足后代元素选择器字符串，则给后代元素绑定事件
    $("tfoot").delegate(".navA","click",function () {
        var pagenum = $(this).attr("pagenum");
        //发送异步请求
        //获取分页查询的条件：
        var condition = $("input[name='condition']").val();
        getRoles(pagenum,condition);
    });

    //当前页面所在模块的菜单自动展开+模块标签高亮显示
    $(".list-group-item:contains(' 权限管理 ')").removeClass("tree-closed");
    $(".list-group-item:contains(' 权限管理 ') ul").show();
    $(".list-group-item:contains(' 权限管理 ') li :contains('角色维护')").css("color","red");
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

    $("tbody .btn-success").click(function(){
        window.location.href = "assignPermission.html";
    });
</script>
</body>
</html>


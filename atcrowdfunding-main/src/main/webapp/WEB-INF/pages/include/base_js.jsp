<%--
  Created by IntelliJ IDEA.
  User: xugang2
  Date: 2020/9/13
  Time: 14:54
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<script src="jquery/jquery-2.1.1.min.js"></script>
<script src="bootstrap/js/bootstrap.min.js"></script>
<script src="script/docs.min.js"></script>
<script src="layer/layer.js"></script>
<script src="script/back-to-top.js"></script>
<script src="ztree/jquery.ztree.all-3.5.min.js"></script>
<script type="text/javascript">
    /**
     * 文档加载顺序：
     *      从上到下，只要上面加载过的html，js和css内容，下面的js代码中都可以获取使用
     */
    $("#logoutBtn").click(function () {

        //弹出确认框
        layer.confirm("您确认退出吗?" , {"title":"注销提示:" , "icon":3},function () {
            //修改地址栏对象的href属性值，浏览器会自动跳转到新地址
            //如果项目启动时，可以以简单的方式获取上下文路径即可
            //如果项目启动时，在application域中存储上下文路径，那么整个运行时所有的web组件对象中都可以使用路径

            //window.location.href = "${PATH}/admin/logout";

            //获取a标签所在的form表单提交
            $("#logoutform").submit();
        })
    });

</script>
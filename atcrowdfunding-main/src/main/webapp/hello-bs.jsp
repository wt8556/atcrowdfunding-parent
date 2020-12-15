<%--
  Created by IntelliJ IDEA.
  User: xugang2
  Date: 2020/9/12
  Time: 15:42
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/bootstrap/css/bootstrap.min.css">
</head>
<body>
    <span class="glyphicon glyphicon-plane"></span>


    <%--  表格样式的设置 --%>
    <table class="table table-hover table-bordered" style="width: 80%;">

        <tbody>
        <%-- 表内容--%>
        <tr class="warning">
            <td>11</td>
            <td>12</td>
            <td>13</td>
            <td>14</td>
        </tr>
        <tr class="success">
            <td>21</td>
            <td>22</td>
            <td>23</td>
            <td>24</td>
        </tr>
        <tr class="info">
            <td>31</td>
            <td>32</td>
            <td>33</td>
            <td>34</td>
        </tr>
        </tbody>
        <tfoot>
        <tr>
            <td colspan="4">
                <nav>
                    <ul class="pagination">
                        <li>
                            <a href="#" aria-label="Previous">
                                <span aria-hidden="true">&laquo;</span>
                            </a>
                        </li>
                        <li><a href="#">1</a></li>
                        <li><a href="#">2</a></li>
                        <li><a href="#">3</a></li>
                        <li><a href="#">4</a></li>
                        <li><a href="#">5</a></li>
                        <li>
                            <a href="#" aria-label="Next">
                                <span aria-hidden="true">&raquo;</span>
                            </a>
                        </li>
                    </ul>
                </nav>
            </td>
        </tr>

        <%-- 分页导航栏 --%>
        </tfoot>
    </table>

<hr>
    <%--  bootstrap的栅格系统：div
                响应式布局

               bs可以通过标签定义的class值将页面划分为行
               每一行在bs指定的分辨率范围内默认由12个列组成
               如果希望某个标签能在bs中某个分辨率下显示时占指定位置，可以设置它占几个列就可以实现

               一个标签可以设置不同分辨率要占的一行的列数，bs会根据分辨率的变化加载不同的属性

      --%>
    <%-- 栅格系统div： 容器   container --%>
    <div class="container">
        <%--row  :容器的一个行
                一行在每个分辨率下有12个列
        --%>
        <div class="row">
            <div class="col-lg-2 col-md-4 col-sm-6">11</div>
            <div class="col-lg-2 col-md-4 col-sm-6">12</div>
            <div class="col-lg-3 col-md-4 col-sm-6">13</div>
            <div class="col-lg-3 col-md-4 col-sm-6">14</div>
            <div class="col-lg-1 col-md-2 col-sm-6">15</div>
            <div class="col-lg-1 col-md-6 col-sm-6">16</div>
        </div>
            <div class="row">
                <div class="col-lg-2">21</div>
                <div class="col-lg-2">22</div>
                <div class="col-lg-3">23</div>
                <div class="col-lg-3">24</div>
                <div class="col-lg-1">25</div>
                <div class="col-lg-1">26</div>
            </div>
            <div class="row">
                <div class="col-lg-2">31</div>
                <div class="col-lg-2">32</div>
                <div class="col-lg-3">33</div>
                <div class="col-lg-3">34</div>
                <div class="col-lg-1">35</div>
                <div class="col-lg-1">36</div>
            </div>
    </div>




    <%--  使用bootstrap给页面设置对应的样式
            1、在项目中拷贝入boostrap的样式和js文件，由于bs依赖于jquery，还需要导入jquery
            2、在要使用bs的页面中引入bs的样式和js文件
            3、在需要使用样式的标签内的class属性值中 使用bs提供的已经写好样式的class值，标签会自动拥有样式
                bs定义的css文件中，通过class选择器，给指定的类名设置了一组样式。

    --%>
    <p class="btn btn-default btn-success">hehe,天王盖地虎</p>
    <a class="btn btn-default btn-warning">dsadasd</a>
    <hr/>
    <img src="static/img/product-4.jpg" class="img-circle">
        <%--  jquery一定要在bs之前引入 --%>
    <script type="text/javascript" src="${pageContext.request.contextPath}/static/jquery/jquery-2.1.1.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/static/bootstrap/js/bootstrap.min.js"></script>
</body>
</html>

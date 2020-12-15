
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<div id="navbar" class="navbar-collapse collapse">
    <ul class="nav navbar-nav navbar-right">
        <li style="padding-top:8px;">
            <div class="btn-group">
                <button type="button" class="btn btn-default btn-success dropdown-toggle" data-toggle="dropdown">
                    <i class="glyphicon glyphicon-user"></i> <sec:authentication property="name"></sec:authentication><%--${sessionScope.admin.loginacct}--%> <span class="caret"></span>
                </button>

                <ul class="dropdown-menu" role="menu">
                    <li><a href="#"><i class="glyphicon glyphicon-cog"></i> 个人设置</a></li>
                    <li><a href="#"><i class="glyphicon glyphicon-comment"></i> 消息</a></li>
                    <li class="divider"></li>
                    <li><a id="logoutBtn"><i class="glyphicon glyphicon-off"></i> 退出系统</a></li>
                </ul>
            </div>
            <form id="logoutform" method="post" action="${PATH}/admin/logout">
            </form>
        </li>
        <li style="margin-left:10px;padding-top:8px;">
            <sec:authorize access="hasAnyRole('PM - 项目经理')">
                <button type="button" class="btn btn-default btn-danger">
                    <span class="glyphicon glyphicon-question-sign"></span> 帮助1
                </button>
            </sec:authorize>
            <sec:authorize access="hasRole('SE - 软件工程师')">
                <button type="button" class="btn btn-default btn-danger">
                    <span class="glyphicon glyphicon-question-sign"></span> 帮助2
                </button>
            </sec:authorize>
            <sec:authorize access="hasAnyRole('PG - 程序员')">
                <button type="button" class="btn btn-default btn-danger">
                    <span class="glyphicon glyphicon-question-sign"></span> 帮助3
                </button>
            </sec:authorize>
        </li>
    </ul>
    <form class="navbar-form navbar-right">
        <input type="text" class="form-control" placeholder="查询">
    </form>
</div>

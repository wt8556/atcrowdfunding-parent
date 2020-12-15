<%--
  Created by IntelliJ IDEA.
  User: xugang2
  Date: 2020/9/13
  Time: 14:53
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="tree">
    <ul style="padding-left:0px;" class="list-group">
        <%-- 遍历session域中的菜单集合 --%>
        <c:forEach items="${pmenus}" var="pmenu">
            <%-- 判断正在遍历的父菜单是否有子菜单--%>
            <c:choose>
                <c:when test="${empty pmenu.children}">
                    <%-- 没有子菜单--%>
                    <li class="list-group-item tree-closed" >
                        <a href="${PATH}/${pmenu.url}"><i class="${pmenu.icon}"></i> ${pmenu.name}</a>
                    </li>
                </c:when>
                <c:otherwise>
                    <li class="list-group-item tree-closed">
                        <span><i class="${pmenu.icon}"></i> ${pmenu.name} <span class="badge" style="float:right">${pmenu.children.size()}</span></span>
                        <ul style="margin-top:10px;display:none;">
                                <%-- 遍历父菜单的子菜单集合 --%>
                            <c:forEach items="${pmenu.children}" var="menu">
                                <li style="height:30px;">
                                    <a href="${PATH}/${menu.url}"><i class="${menu.icon}"></i> ${menu.name}</a>
                                </li>
                            </c:forEach>
                        </ul>
                    </li>
                </c:otherwise>
            </c:choose>
        </c:forEach>

    </ul>
</div>

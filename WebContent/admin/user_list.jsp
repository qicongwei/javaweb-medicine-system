<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.medicine.model.User"%>
<%@ page import="java.util.List"%>
<%
    User adminUser = (User) session.getAttribute("user");
    if (adminUser == null || !"admin".equals(adminUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp"); return;
    }
    List<User> users = (List<User>) request.getAttribute("users");
    String msg = (String) request.getAttribute("msg");
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>用户列表 - 后台管理</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
</head>
<body>
    <header class="header">
        <div class="container">
            <a href="<%=request.getContextPath()%>/index.jsp" class="logo">
                <span class="logo-icon">💊</span>药品收费系统
            </a>
            <nav class="nav">
                <a href="<%=request.getContextPath()%>/index.jsp">返回前台</a>
                <div class="user-info"><span><%=adminUser.getRealname()%></span><a href="<%=request.getContextPath()%>/LogoutServlet" class="btn-logout">退出</a></div>
            </nav>
        </div>
    </header>

    <div class="admin-wrapper">
        <%@ include file="../common/admin-sidebar.jsp" %>

        <main class="admin-content">
            <div class="page-header">
                <h2>👥 用户管理</h2>
                <a href="<%=request.getContextPath()%>/admin/AdminUserServlet?action=add" class="btn btn-primary">➕ 添加用户</a>
            </div>

            <% if (msg != null) { %><div class="alert alert-success"><%=msg%></div><% } %>

            <div class="card" style="margin-bottom:16px;padding:12px 20px;text-align:center;">
                <p style="color:var(--gray-500);font-size:14px;">共 <strong style="color:var(--primary);"><%=users != null ? users.size() : 0%></strong> 位用户</p>
            </div>

            <div class="table-wrapper">
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>用户名</th>
                            <th>真实姓名</th>
                            <th>手机号</th>
                            <th>角色</th>
                            <th>注册时间</th>
                            <th>操作</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (users != null) {
                            for (User u : users) { %>
                            <tr>
                                <td><%=u.getId()%></td>
                                <td><strong style="color:var(--gray-800);"><%=u.getUsername()%></strong></td>
                                <td><%=u.getRealname()%></td>
                                <td><%=u.getPhone() != null ? u.getPhone() : "-"%></td>
                                <td>
                                    <span class="tag <%= "admin".equals(u.getRole()) ? "tag-info" : "tag-gray" %>">
                                        <%= "admin".equals(u.getRole()) ? "管理员" : "普通用户" %>
                                    </span>
                                </td>
                                <td style="font-size:12px;color:var(--gray-400);"><%=u.getCreateTime()%></td>
                                <td>
                                    <div class="btn-group">
                                        <a href="<%=request.getContextPath()%>/admin/AdminUserServlet?action=edit&id=<%=u.getId()%>" class="btn btn-outline btn-sm">编辑</a>
                                        <% if (!"admin".equals(u.getUsername())) { %>
                                            <a href="<%=request.getContextPath()%>/admin/AdminUserServlet?action=delete&id=<%=u.getId()%>"
                                               class="btn btn-danger btn-sm" onclick="return confirm('确定删除该用户？');">删除</a>
                                        <% } else { %>
                                            <span style="color:var(--gray-400);font-size:12px;">超级管理员</span>
                                        <% } %>
                                    </div>
                                </td>
                            </tr>
                        <% }} %>
                    </tbody>
                </table>
            </div>
        </main>
    </div>
</body>
</html>

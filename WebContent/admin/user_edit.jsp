<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.medicine.model.User"%>
<%
    User adminUser = (User) session.getAttribute("user");
    if (adminUser == null || !"admin".equals(adminUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp"); return;
    }
    User editUser = (User) request.getAttribute("editUser");
    if (editUser == null) { response.sendRedirect(request.getContextPath() + "/admin/AdminUserServlet"); return; }
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>编辑用户 - 后台管理</title>
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
                <h2>✏️ 编辑用户 - <%=editUser.getUsername()%></h2>
                <a href="<%=request.getContextPath()%>/admin/AdminUserServlet" class="btn btn-outline">返回列表</a>
            </div>

            <% if (error != null) { %><div class="alert alert-error"><%=error%></div><% } %>

            <div class="admin-form">
                <h3>修改用户信息</h3>
                <form action="<%=request.getContextPath()%>/admin/AdminUserServlet" method="post">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="id" value="<%=editUser.getId()%>">

                    <div class="form-group">
                        <label>用户名</label>
                        <input type="text" value="<%=editUser.getUsername()%>" disabled style="background:var(--gray-100);">
                        <div class="form-help">用户名不可修改</div>
                    </div>

                    <div class="form-group">
                        <label>新密码 <span class="label-hint">(留空则不修改)</span></label>
                        <input type="password" name="password" placeholder="如需修改密码请输入新密码">
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label>真实姓名 <span class="label-hint">*</span></label>
                            <input type="text" name="realname" value="<%=editUser.getRealname()%>" required>
                        </div>
                        <div class="form-group">
                            <label>角色 <span class="label-hint">*</span></label>
                            <select name="role" required>
                                <option value="user" <%= "user".equals(editUser.getRole()) ? "selected" : "" %>>普通用户</option>
                                <option value="admin" <%= "admin".equals(editUser.getRole()) ? "selected" : "" %>>管理员</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label>手机号</label>
                            <input type="tel" name="phone" value="<%=editUser.getPhone() != null ? editUser.getPhone() : ""%>">
                        </div>
                        <div class="form-group">
                            <label>收货地址</label>
                            <input type="text" name="address" value="<%=editUser.getAddress() != null ? editUser.getAddress() : ""%>">
                        </div>
                    </div>

                    <div class="btn-group" style="margin-top:20px;">
                        <button type="submit" class="btn btn-primary btn-lg">保存修改</button>
                        <a href="<%=request.getContextPath()%>/admin/AdminUserServlet" class="btn btn-outline btn-lg">取消</a>
                    </div>
                </form>
            </div>
        </main>
    </div>
</body>
</html>

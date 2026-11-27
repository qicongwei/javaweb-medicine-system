<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.medicine.model.User"%>
<%
    User adminUser = (User) session.getAttribute("user");
    if (adminUser == null || !"admin".equals(adminUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp"); return;
    }
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>后台管理 - 在线药品收费系统</title>
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
        <aside class="admin-nav">
            <div class="nav-title">☰ 后台管理</div>
            <a href="<%=request.getContextPath()%>/admin/AdminDashboardServlet" class="active">📊 控制台</a>
            <a href="<%=request.getContextPath()%>/admin/AdminMedicineServlet">💊 药品管理</a>
            <a href="<%=request.getContextPath()%>/admin/AdminOrderServlet">📋 订单管理</a>
            <a href="<%=request.getContextPath()%>/admin/AdminUserServlet">👥 用户管理</a>
            <a href="<%=request.getContextPath()%>/admin/AdminSalesServlet">📈 销售统计</a>
        </aside>

        <main class="admin-content">
            <div class="page-header">
                <h2>后台管理</h2>
            </div>
            <div style="text-align:center;padding:40px;">
                <p style="font-size:16px;color:var(--gray-500);margin-bottom:24px;">请从左侧菜单选择功能模块</p>
                <a href="<%=request.getContextPath()%>/admin/AdminDashboardServlet" class="btn btn-primary btn-lg">进入控制台</a>
            </div>
        </main>
    </div>
</body>
</html>

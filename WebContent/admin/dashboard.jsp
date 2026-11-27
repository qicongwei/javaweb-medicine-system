<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.medicine.model.User"%>
<%
    User adminUser = (User) session.getAttribute("user");
    if (adminUser == null || !"admin".equals(adminUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp"); return;
    }
    int totalUsers = (Integer) request.getAttribute("totalUsers");
    int totalMedicines = (Integer) request.getAttribute("totalMedicines");
    int totalOrders = (Integer) request.getAttribute("totalOrders");
    int todayOrders = (Integer) request.getAttribute("todayOrders");
    double todaySales = (Double) request.getAttribute("todaySales");
    double totalSales = (Double) request.getAttribute("totalSales");
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>控制台 - 后台管理</title>
    <link rel="stylesheet" href="<%=ctx%>/css/style.css">
</head>
<body>
    <!-- 后台头部 -->
    <header class="header" style="background:linear-gradient(135deg,#1e293b,#334155);">
        <div class="container">
            <a href="<%=ctx%>/index.jsp" class="logo"><span style="color:#fff;">💊</span> <span style="color:#fff;">后台管理</span></a>
            <nav class="nav">
                <a href="<%=ctx%>/index.jsp" style="color:rgba(255,255,255,0.7);">返回前台</a>
                <div class="user-info" style="border-left-color:rgba(255,255,255,0.2);"><span style="color:rgba(255,255,255,0.9);"><%=adminUser.getRealname()%></span><a href="<%=ctx%>/LogoutServlet" class="btn-logout">退出</a></div>
            </nav>
        </div>
    </header>

    <div class="admin-wrapper">
        <!-- 侧边栏盒子 -->
        <aside class="admin-sidebar">
            <div class="nav-title">☰ 后台管理</div>
            <a href="<%=ctx%>/admin/AdminDashboardServlet" class="active">📊 控制台</a>
            <a href="<%=ctx%>/admin/AdminMedicineServlet">💊 药品管理</a>
            <a href="<%=ctx%>/admin/AdminOrderServlet">📋 订单管理</a>
            <a href="<%=ctx%>/admin/AdminUserServlet">👥 用户管理</a>
            <a href="<%=ctx%>/admin/AdminSalesServlet">📈 销售统计</a>
        </aside>

        <!-- 主内容 -->
        <main class="admin-content">
            <h2 style="font-size:20px;font-weight:800;color:var(--gray-900);margin-bottom:6px;">📊 系统概览</h2>
            <p style="color:var(--gray-400);font-size:13px;margin-bottom:24px;"><%=new java.text.SimpleDateFormat("yyyy年MM月dd日 EEEE").format(new java.util.Date())%></p>

            <!-- 统计卡片网格 -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon blue">👥</div>
                    <div class="stat-value"><%=totalUsers%></div>
                    <div class="stat-label">系统用户</div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon green">💊</div>
                    <div class="stat-value"><%=totalMedicines%></div>
                    <div class="stat-label">药品总数</div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon orange">📋</div>
                    <div class="stat-value"><%=todayOrders%></div>
                    <div class="stat-label">今日订单</div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon purple">💰</div>
                    <div class="stat-value">&yen;<%=String.format("%.0f", todaySales)%></div>
                    <div class="stat-label">今日销售额</div>
                </div>
            </div>

            <!-- 快捷操作盒子 -->
            <div class="section-box" style="margin-top:20px;">
                <div class="section-box-header">⚡ 快捷操作</div>
                <div style="display:flex;gap:12px;flex-wrap:wrap;">
                    <a href="<%=ctx%>/admin/AdminMedicineServlet?action=add" class="btn btn-outline">➕ 添加药品</a>
                    <a href="<%=ctx%>/admin/AdminMedicineServlet" class="btn btn-outline">📦 药品列表</a>
                    <a href="<%=ctx%>/admin/AdminOrderServlet" class="btn btn-outline">📋 订单管理</a>
                    <a href="<%=ctx%>/admin/AdminUserServlet?action=add" class="btn btn-outline">👤 添加用户</a>
                    <a href="<%=ctx%>/admin/AdminSalesServlet" class="btn btn-outline">📈 销售统计</a>
                </div>
            </div>
        </main>
    </div>
</body>
</html>

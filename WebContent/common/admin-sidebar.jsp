<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String ctx = request.getContextPath();
    String uri = request.getRequestURI();
    boolean isMedicine = uri.contains("AdminMedicine");
    boolean isOrder    = uri.contains("AdminOrder");
    boolean isUser      = uri.contains("AdminUser");
    boolean isSales     = uri.contains("AdminSales");
    boolean isDashboard = uri.contains("AdminDashboard");
%>
<aside class="admin-nav">
    <div class="nav-title">☰ 后台管理</div>
    <a href="<%=ctx%>/admin/AdminDashboardServlet" class="<%=isDashboard ? "active" : ""%>">📊 控制台</a>
    <a href="<%=ctx%>/admin/AdminMedicineServlet" class="<%=isMedicine ? "active" : ""%>">💊 药品管理</a>
    <a href="<%=ctx%>/admin/AdminOrderServlet" class="<%=isOrder ? "active" : ""%>">📋 订单管理</a>
    <a href="<%=ctx%>/admin/AdminUserServlet" class="<%=isUser ? "active" : ""%>">👥 用户管理</a>
    <a href="<%=ctx%>/admin/AdminSalesServlet" class="<%=isSales ? "active" : ""%>">📈 销售统计</a>
</aside>

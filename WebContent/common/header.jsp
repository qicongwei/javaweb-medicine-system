<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.medicine.model.User"%>
<%
    // 使用唯一变量名 headerUser 避免与包含页冲突
    User headerUser = (User) session.getAttribute("user");
    Integer cartCountObj = (Integer) request.getAttribute("cartCount");
    int headerCartCount = (cartCountObj != null) ? cartCountObj.intValue() : 0;
    String headerCtx = request.getContextPath();
%>
<header class="header animate-fadeInDown">
    <div class="container">
        <a href="<%=headerCtx%>/index.jsp" class="logo">
            <span class="logo-icon"><i class="fas fa-pills"></i></span>药品收费系统
        </a>
        <nav class="nav">
            <a href="<%=headerCtx%>/index.jsp"><i class="fas fa-home"></i> 首页</a>
            <a href="<%=headerCtx%>/MedicineListServlet"><i class="fas fa-list"></i> 药品列表</a>
            <% if (headerUser != null) { %>
                <a href="<%=headerCtx%>/CartServlet">
                    <i class="fas fa-shopping-cart"></i> 购物车
                    <% if (headerCartCount > 0) { %><span class="cart-badge badge-pulse"><%=headerCartCount%></span><% } %>
                </a>
                <a href="<%=headerCtx%>/OrderServlet"><i class="fas fa-file-invoice"></i> 我的订单</a>
                <% if ("admin".equals(headerUser.getRole())) { %>
                    <a href="<%=headerCtx%>/admin/AdminDashboardServlet"><i class="fas fa-cog"></i> 后台管理</a>
                <% } %>
                <div class="user-info">
                    <span><i class="fas fa-user-circle"></i> <%=headerUser.getRealname()%></span>
                    <a href="<%=headerCtx%>/LogoutServlet" class="btn-logout"><i class="fas fa-sign-out-alt"></i> 退出</a>
                </div>
            <% } else { %>
                <a href="<%=headerCtx%>/login.jsp"><i class="fas fa-sign-in-alt"></i> 登录</a>
                <a href="<%=headerCtx%>/register.jsp"><i class="fas fa-user-plus"></i> 注册</a>
            <% } %>
        </nav>
    </div>
</header>

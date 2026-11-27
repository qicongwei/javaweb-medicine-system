<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.medicine.model.User"%>
<%@ page import="com.medicine.model.Order"%>
<%@ page import="java.util.List"%>
<%
    User adminUser = (User) session.getAttribute("user");
    if (adminUser == null || !"admin".equals(adminUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp"); return;
    }
    List<Order> orders = (List<Order>) request.getAttribute("orders");
    String msg = (String) request.getAttribute("msg");
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>订单列表 - 后台管理</title>
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
                <h2>📋 订单管理</h2>
            </div>

            <% if (msg != null) { %><div class="alert alert-success"><%=msg%></div><% } %>

            <div class="card" style="margin-bottom:16px;padding:12px 20px;text-align:center;">
                <p style="color:var(--gray-500);font-size:14px;">共 <strong style="color:var(--primary);"><%=orders != null ? orders.size() : 0%></strong> 个订单</p>
            </div>

            <div class="table-wrapper">
                <table>
                    <thead>
                        <tr>
                            <th>订单编号</th>
                            <th>用户</th>
                            <th>金额</th>
                            <th>状态</th>
                            <th>下单时间</th>
                            <th>操作</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (orders != null) {
                            for (Order order : orders) { %>
                            <tr>
                                <td style="font-weight:600;color:var(--primary);"><%=order.getOrderNo()%></td>
                                <td><%=order.getUsername() != null ? order.getUsername() : "用户"+order.getUserId()%></td>
                                <td style="color:var(--danger);font-weight:700;">&yen;<%=String.format("%.2f", order.getTotalAmount())%></td>
                                <td><span class="status status-<%=order.getStatus()%>"><%=order.getStatusName()%></span></td>
                                <td style="font-size:12px;color:var(--gray-400);"><%=order.getCreateTime()%></td>
                                <td>
                                    <div class="btn-group">
                                        <a href="<%=request.getContextPath()%>/admin/AdminOrderServlet?action=view&id=<%=order.getId()%>" class="btn btn-outline btn-sm">详情</a>
                                        <% if ("paid".equals(order.getStatus())) { %>
                                            <a href="<%=request.getContextPath()%>/admin/AdminOrderServlet?action=complete&id=<%=order.getId()%>"
                                               class="btn btn-success btn-sm" onclick="return confirm('确认完成订单？');">完成</a>
                                        <% } %>
                                        <% if (!"completed".equals(order.getStatus()) && !"cancelled".equals(order.getStatus())) { %>
                                            <a href="<%=request.getContextPath()%>/admin/AdminOrderServlet?action=cancel&id=<%=order.getId()%>"
                                               class="btn btn-warning btn-sm" onclick="return confirm('确认取消该订单？');">取消</a>
                                        <% } %>
                                        <a href="<%=request.getContextPath()%>/admin/AdminOrderServlet?action=delete&id=<%=order.getId()%>"
                                           class="btn btn-danger btn-sm" onclick="return confirm('确定删除该订单？此操作不可恢复！');">删除</a>
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

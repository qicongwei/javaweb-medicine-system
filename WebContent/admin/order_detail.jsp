<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.medicine.model.User"%>
<%@ page import="com.medicine.model.Order"%>
<%@ page import="com.medicine.model.OrderItem"%>
<%
    User adminUser = (User) session.getAttribute("user");
    if (adminUser == null || !"admin".equals(adminUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp"); return;
    }
    Order order = (Order) request.getAttribute("order");
    if (order == null) { response.sendRedirect(request.getContextPath() + "/admin/AdminOrderServlet"); return; }
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>订单详情 - 后台管理</title>
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
                <h2>📋 订单详情 - <%=order.getOrderNo()%></h2>
                <a href="<%=request.getContextPath()%>/admin/AdminOrderServlet" class="btn btn-outline">返回列表</a>
            </div>

            <!-- 订单信息（卡片网格） -->
            <div class="order-info-grid">
                <div class="order-info-item">
                    <div class="label">订单编号</div>
                    <div class="value"><%=order.getOrderNo()%></div>
                </div>
                <div class="order-info-item">
                    <div class="label">下单用户</div>
                    <div class="value"><%=order.getUsername()%></div>
                </div>
                <div class="order-info-item">
                    <div class="label">订单状态</div>
                    <div class="value"><span class="status status-<%=order.getStatus()%>"><%=order.getStatusName()%></span></div>
                </div>
                <div class="order-info-item">
                    <div class="label">下单时间</div>
                    <div class="value"><%=order.getCreateTime()%></div>
                </div>
                <div class="order-info-item">
                    <div class="label">收货人</div>
                    <div class="value"><%=order.getReceiverName()%></div>
                </div>
                <div class="order-info-item">
                    <div class="label">联系电话</div>
                    <div class="value"><%=order.getReceiverPhone()%></div>
                </div>
                <div class="order-info-item" style="grid-column:1/4;">
                    <div class="label">收货地址</div>
                    <div class="value" style="font-size:13px;"><%=order.getReceiverAddress()%></div>
                </div>
            </div>

            <!-- 药品清单（卡片表格） -->
            <div class="table-wrapper" style="margin-bottom:20px;">
                <table>
                    <thead>
                        <tr><th>药品名称</th><th>单价</th><th>数量</th><th>小计</th></tr>
                    </thead>
                    <tbody>
                        <% for (OrderItem item : order.getItems()) { %>
                            <tr>
                                <td style="font-weight:500;"><%=item.getMedicineName()%></td>
                                <td>&yen;<%=String.format("%.2f", item.getPrice())%></td>
                                <td><%=item.getQuantity()%></td>
                                <td style="color:var(--danger);font-weight:700;">&yen;<%=String.format("%.2f", item.getSubtotal())%></td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>

            <!-- 合计（居中卡片） -->
            <div style="display:flex;justify-content:center;margin-bottom:24px;">
                <div class="card" style="padding:24px 32px;min-width:320px;text-align:center;">
                    <div style="display:flex;justify-content:space-between;font-size:20px;font-weight:700;color:var(--gray-900);padding-top:12px;">
                        <span>订单总额</span><span style="color:var(--danger);font-size:26px;">&yen;<%=String.format("%.2f", order.getTotalAmount())%></span>
                    </div>
                </div>
            </div>

            <!-- 操作按钮（居中） -->
            <div class="btn-group">
                <a href="<%=request.getContextPath()%>/admin/AdminOrderServlet" class="btn btn-outline">返回订单列表</a>
                <% if ("paid".equals(order.getStatus())) { %>
                    <a href="<%=request.getContextPath()%>/admin/AdminOrderServlet?action=complete&id=<%=order.getId()%>"
                       class="btn btn-success" onclick="return confirm('确认完成订单？');">标记完成</a>
                <% } %>
                <% if (!"completed".equals(order.getStatus()) && !"cancelled".equals(order.getStatus())) { %>
                    <a href="<%=request.getContextPath()%>/admin/AdminOrderServlet?action=cancel&id=<%=order.getId()%>"
                       class="btn btn-warning" onclick="return confirm('确认取消该订单？');">取消订单</a>
                <% } %>
            </div>
        </main>
    </div>
</body>
</html>

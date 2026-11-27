<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.medicine.model.User"%>
<%@ page import="com.medicine.model.Order"%>
<%@ page import="com.medicine.model.OrderItem"%>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) { response.sendRedirect(request.getContextPath() + "/login.jsp"); return; }
    Order order = (Order) request.getAttribute("order");
    if (order == null) { response.sendRedirect(request.getContextPath() + "/OrderServlet"); return; }
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>订单详情 - 在线药品收费系统</title>
    <link rel="stylesheet" href="<%=ctx%>/css/style.css">
</head>
<body>

<%@ include file="/common/header.jsp" %>

<div class="container" style="max-width:960px;">
    <div class="breadcrumb">
        <a href="<%=ctx%>/index.jsp">首页</a><span class="sep">›</span>
        <a href="<%=ctx%>/OrderServlet">我的订单</a><span class="sep">›</span><span>订单详情</span>
    </div>

    <h2 style="font-size:20px;font-weight:800;color:var(--gray-900);margin-bottom:18px;">📋 订单详情</h2>

    <!-- 订单信息盒子 -->
    <div class="section-box" style="margin-bottom:20px;">
        <div style="display:grid;grid-template-columns:1fr 1fr 1fr;gap:14px;">
            <div style="background:var(--gray-50);border-radius:8px;padding:12px 16px;">
                <div style="color:var(--gray-400);font-size:12px;">订单编号</div>
                <div style="font-weight:700;color:var(--primary);"><%=order.getOrderNo()%></div>
            </div>
            <div style="background:var(--gray-50);border-radius:8px;padding:12px 16px;">
                <div style="color:var(--gray-400);font-size:12px;">下单时间</div>
                <div style="font-weight:600;"><%=order.getCreateTime()%></div>
            </div>
            <div style="background:var(--gray-50);border-radius:8px;padding:12px 16px;">
                <div style="color:var(--gray-400);font-size:12px;">订单状态</div>
                <%
                    String dtStatusClass = "tag-info";
                    if ("pending".equals(order.getStatus())) dtStatusClass = "tag-warning";
                    else if ("paid".equals(order.getStatus())) dtStatusClass = "tag-info";
                    else if ("completed".equals(order.getStatus()) || "shipped".equals(order.getStatus())) dtStatusClass = "tag-success";
                    else if ("cancelled".equals(order.getStatus())) dtStatusClass = "tag-danger";
                %>
                <span class="tag <%=dtStatusClass%>"><%=order.getStatusName()%></span>
            </div>
            <div style="background:var(--gray-50);border-radius:8px;padding:12px 16px;">
                <div style="color:var(--gray-400);font-size:12px;">收货人</div>
                <div style="font-weight:600;"><%=order.getReceiverName()%></div>
            </div>
            <div style="background:var(--gray-50);border-radius:8px;padding:12px 16px;">
                <div style="color:var(--gray-400);font-size:12px;">联系电话</div>
                <div style="font-weight:600;"><%=order.getReceiverPhone()%></div>
            </div>
            <div style="background:var(--gray-50);border-radius:8px;padding:12px 16px;">
                <div style="color:var(--gray-400);font-size:12px;">收货地址</div>
                <div style="font-weight:600;font-size:13px;"><%=order.getReceiverAddress()%></div>
            </div>
        </div>
    </div>

    <!-- 药品清单盒子 -->
    <div class="cart-box" style="margin-bottom:20px;">
        <table>
            <thead><tr><th>药品名称</th><th>单价</th><th>数量</th><th>小计</th></tr></thead>
            <tbody>
                <% for (OrderItem item : order.getItems()) { %>
                <tr>
                    <td><%=item.getMedicineName()%></td>
                    <td>¥<%=String.format("%.2f", item.getPrice())%></td>
                    <td><%=item.getQuantity()%> 盒</td>
                    <td style="color:var(--danger);font-weight:700;">¥<%=String.format("%.2f", item.getSubtotal())%></td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>

    <!-- 汇总盒子 -->
    <div class="section-box checkout-summary-box" style="max-width:400px;margin:0 auto;text-align:center;">
        <div style="display:flex;justify-content:space-between;padding:10px 0;font-size:15px;">
            <span style="color:var(--gray-500);">药品总数</span>
            <strong><% int totalQty=0; for(OrderItem i:order.getItems()) totalQty+=i.getQuantity(); %><%=totalQty%> 盒</strong>
        </div>
        <div style="border-top:2px solid var(--primary-bg);margin:10px 0;padding-top:14px;display:flex;justify-content:space-between;align-items:center;">
            <span style="font-weight:700;">订单总额</span>
            <span style="font-size:28px;font-weight:900;color:var(--danger);">¥<%=String.format("%.2f", order.getTotalAmount())%></span>
        </div>
        <div style="display:flex;gap:10px;justify-content:center;margin-top:18px;">
            <a href="<%=ctx%>/OrderServlet" class="btn btn-outline">返回订单列表</a>
            <% if ("pending".equals(order.getStatus())) { %>
                <a href="<%=ctx%>/OrderServlet?action=pay&id=<%=order.getId()%>" class="btn btn-primary btn-lg" onclick="return confirm('确认付款?')">立即付款</a>
            <% } %>
        </div>
    </div>
</div>

<%@ include file="/common/footer.jsp" %>
</body>
</html>

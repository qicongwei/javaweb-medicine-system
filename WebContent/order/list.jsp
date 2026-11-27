<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.medicine.model.User"%>
<%@ page import="com.medicine.model.Order"%>
<%@ page import="java.util.List"%>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) { response.sendRedirect(request.getContextPath() + "/login.jsp"); return; }
    List<Order> orders = (List<Order>) request.getAttribute("orders");
    String msg = (String) request.getAttribute("msg");
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>我的订单 - 在线药品收费系统</title>
    <link rel="stylesheet" href="<%=ctx%>/css/style.css">
</head>
<body>

<%@ include file="/common/header.jsp" %>

<div class="container" style="max-width:960px;">
    <div class="breadcrumb">
        <a href="<%=ctx%>/index.jsp">首页</a><span class="sep">›</span><span>我的订单</span>
    </div>

    <% if (msg != null) { %><div class="alert alert-success"><%=msg%></div><% } %>

    <% if (orders == null || orders.isEmpty()) { %>
        <div class="section-box">
            <div class="empty-state"><div class="icon">📦</div><div class="text">暂无订单</div><a href="<%=ctx%>/MedicineListServlet" class="btn btn-primary btn-lg">去购物</a></div>
        </div>
    <% } else { %>
        <div class="admin-table-box">
            <table>
                <thead>
                    <tr>
                        <th>订单编号</th>
                        <th>下单时间</th>
                        <th>金额</th>
                        <th>状态</th>
                        <th>操作</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Order order : orders) { %>
                    <tr>
                        <td style="font-weight:600;color:var(--primary);"><%=order.getOrderNo()%></td>
                        <td style="font-size:13px;"><%=order.getCreateTime()%></td>
                        <td style="color:var(--danger);font-weight:700;">¥<%=String.format("%.2f", order.getTotalAmount())%></td>
                        <td>
                            <%
                                String statusTagClass = "";
                                if ("pending".equals(order.getStatus())) statusTagClass = "tag-warning";
                                else if ("paid".equals(order.getStatus())) statusTagClass = "tag-info";
                                else if ("shipped".equals(order.getStatus()) || "completed".equals(order.getStatus())) statusTagClass = "tag-success";
                                else if ("cancelled".equals(order.getStatus())) statusTagClass = "tag-danger";
                            %>
                            <span class="tag <%=statusTagClass%>"><%=order.getStatusName()%></span>
                        </td>
                        <td>
                            <div style="display:flex;gap:6px;flex-wrap:wrap;">
                                <a href="<%=ctx%>/OrderServlet?action=view&id=<%=order.getId()%>" class="btn btn-outline btn-sm">详情</a>
                                <% if ("pending".equals(order.getStatus())) { %>
                                    <a href="<%=ctx%>/OrderServlet?action=pay&id=<%=order.getId()%>" class="btn btn-primary btn-sm" onclick="return confirm('确认支付?')">付款</a>
                                <% } %>
                                <% if ("pending".equals(order.getStatus()) || "paid".equals(order.getStatus())) { %>
                                    <a href="<%=ctx%>/OrderServlet?action=cancel&id=<%=order.getId()%>" class="btn btn-danger btn-sm" onclick="return confirm('确认取消?')">取消</a>
                                <% } %>
                            </div>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    <% } %>
</div>

<%@ include file="/common/footer.jsp" %>
</body>
</html>

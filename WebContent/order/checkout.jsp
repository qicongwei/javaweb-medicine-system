<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.medicine.model.User"%>
<%@ page import="com.medicine.model.CartItem"%>
<%@ page import="java.util.List"%>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) { response.sendRedirect(request.getContextPath() + "/login.jsp"); return; }
    List<CartItem> cartItems = (List<CartItem>) request.getAttribute("cartItems");
    double totalAmount = (Double) request.getAttribute("totalAmount");
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>确认订单 - 在线药品收费系统</title>
    <link rel="stylesheet" href="<%=ctx%>/css/style.css">
</head>
<body>

<%@ include file="/common/header.jsp" %>

<div class="container" style="max-width:960px;">
    <div class="breadcrumb">
        <a href="<%=ctx%>/index.jsp">首页</a><span class="sep">›</span>
        <a href="<%=ctx%>/CartServlet">购物车</a><span class="sep">›</span><span>确认订单</span>
    </div>

    <% if (cartItems == null || cartItems.isEmpty()) { %>
        <div class="section-box">
            <div class="empty-state"><div class="icon">🛒</div><div class="text">购物车为空，无法结算</div><a href="<%=ctx%>/MedicineListServlet" class="btn btn-primary btn-lg">去购物</a></div>
        </div>
    <% } else { %>
        <!-- 收货信息盒子 -->
        <div class="section-box" style="margin-bottom:20px;">
            <div class="section-box-header">📍 收货信息</div>
            <form action="<%=ctx%>/OrderServlet" method="post" id="checkoutForm">
                <input type="hidden" name="action" value="create">
                <div style="display:grid;grid-template-columns:1fr 1fr;gap:16px;margin-bottom:16px;">
                    <div class="form-group">
                        <label>收货人姓名</label>
                        <input type="text" name="receiverName" value="<%=user.getRealname() != null ? user.getRealname() : ""%>" required>
                    </div>
                    <div class="form-group">
                        <label>联系电话</label>
                        <input type="tel" name="receiverPhone" value="<%=user.getPhone() != null ? user.getPhone() : ""%>" placeholder="请输入收货电话" required>
                    </div>
                </div>
                <div class="form-group">
                    <label>收货地址</label>
                    <textarea name="receiverAddress" rows="2" placeholder="请输入详细收货地址" required><%=user.getAddress() != null ? user.getAddress() : ""%></textarea>
                </div>
                <div class="form-group" style="margin-bottom:0;">
                    <label>订单备注 <span class="label-hint">(选填)</span></label>
                    <textarea name="remark" rows="2" placeholder="如有特殊要求请备注"></textarea>
                </div>
            </form>
        </div>

        <!-- 药品清单盒子 -->
        <div class="cart-box" style="margin-bottom:20px;">
            <div style="padding:14px 16px;border-bottom:2px solid var(--gray-200);background:var(--gray-50);font-weight:700;font-size:13px;color:var(--gray-500);text-transform:uppercase;">💊 药品清单</div>
            <table>
                <tbody>
                    <% for (CartItem item : cartItems) { %>
                    <tr>
                        <td>
                            <strong><%=item.getMedicineName()%></strong>
                            <div style="font-size:12px;color:var(--gray-400);"><%=item.getMedicineSpec() != null ? item.getMedicineSpec() : ""%></div>
                        </td>
                        <td>¥<%=String.format("%.2f", item.getMedicinePrice())%></td>
                        <td><%=item.getQuantity()%> 盒</td>
                        <td style="color:var(--danger);font-weight:700;">¥<%=String.format("%.2f", item.getSubtotal())%></td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>

        <!-- 汇总盒子 -->
        <div class="section-box checkout-summary-box" style="max-width:400px;float:right;margin-top:0;">
            <h3 style="font-size:15px;font-weight:700;color:var(--gray-800);margin-bottom:18px;">📊 订单汇总</h3>
            <div style="display:flex;justify-content:space-between;padding:10px 0;font-size:14px;color:var(--gray-600);">
                <span>药品种类</span><strong><%=cartItems.size()%> 种</strong>
            </div>
            <div style="display:flex;justify-content:space-between;padding:10px 0;font-size:14px;color:var(--gray-600);">
                <span>药品总数</span>
                <strong><% int totalQty=0; for(CartItem i:cartItems) totalQty+=i.getQuantity(); %><%=totalQty%> 盒</strong>
            </div>
            <div style="display:flex;justify-content:space-between;padding:10px 0;font-size:14px;color:var(--gray-600);">
                <span>运费</span><strong style="color:var(--success);">免运费</strong>
            </div>
            <div style="border-top:2px solid var(--primary-bg);margin:12px 0;padding-top:12px;display:flex;justify-content:space-between;align-items:center;">
                <span style="font-size:15px;font-weight:700;">应付金额</span>
                <span style="font-size:26px;font-weight:900;color:var(--danger);">¥<%=String.format("%.2f", totalAmount)%></span>
            </div>
            <button type="submit" form="checkoutForm" class="btn btn-primary btn-lg" style="width:100%;margin-top:4px;">提交订单</button>
            <a href="<%=ctx%>/CartServlet" class="btn btn-outline" style="width:100%;margin-top:8px;">返回购物车</a>
        </div>
    <% } %>
</div>

<div style="clear:both;"></div>
<%@ include file="/common/footer.jsp" %>
</body>
</html>

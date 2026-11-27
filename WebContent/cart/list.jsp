<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.medicine.model.User"%>
<%@ page import="com.medicine.model.CartItem"%>
<%@ page import="com.medicine.dao.CartDAO"%>
<%@ page import="java.util.List"%>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) { response.sendRedirect(request.getContextPath() + "/login.jsp"); return; }
    List<CartItem> cartItems = (List<CartItem>) request.getAttribute("cartItems");
    double totalAmount = (Double) request.getAttribute("totalAmount");
    String msg = (String) request.getAttribute("msg");
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>购物车 - 在线药品收费系统</title>
    <link rel="stylesheet" href="<%=ctx%>/css/style.css">
</head>
<body>

<%@ include file="/common/header.jsp" %>

<div class="container" style="max-width:960px;">
    <!-- 面包屑盒子 -->
    <div class="breadcrumb">
        <a href="<%=ctx%>/index.jsp">首页</a><span class="sep">›</span><span>购物车</span>
    </div>

    <% if (msg != null) { %><div class="alert alert-success"><%=msg%></div><% } %>

    <% if (cartItems == null || cartItems.isEmpty()) { %>
        <div class="section-box">
            <div class="empty-state"><div class="icon">🛒</div><div class="text">购物车是空的</div><a href="<%=ctx%>/MedicineListServlet" class="btn btn-primary btn-lg">去逛逛</a></div>
        </div>
    <% } else { %>
        <!-- 购物车表格盒子 -->
        <div class="cart-box">
            <table>
                <thead>
                    <tr>
                        <th style="width:45%;">药品信息</th>
                        <th>单价</th>
                        <th>数量</th>
                        <th>小计</th>
                        <th>操作</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (CartItem item : cartItems) { %>
                    <tr>
                        <td>
                            <div style="display:flex;align-items:center;gap:12px;">
                                <div style="width:44px;height:44px;border-radius:8px;display:flex;align-items:center;justify-content:center;font-size:22px;background:var(--gray-100);"><%=item.getMedicineIsPrescription()==1?"💊":"🟢"%></div>
                                <div>
                                    <div style="font-weight:600;color:var(--gray-800);"><%=item.getMedicineName()%></div>
                                    <div style="font-size:12px;color:var(--gray-400);"><%=item.getMedicineSpec() != null ? item.getMedicineSpec() : ""%></div>
                                </div>
                            </div>
                        </td>
                        <td style="font-weight:500;">¥<%=String.format("%.2f", item.getMedicinePrice())%></td>
                        <td>
                            <form action="<%=ctx%>/CartServlet" method="post" style="display:inline;">
                                <input type="hidden" name="action" value="update">
                                <input type="hidden" name="id" value="<%=item.getId()%>">
                                <div class="qty-control" style="display:flex;border:2px solid var(--gray-200);border-radius:6px;width:fit-content;">
                                    <button type="button" onclick="var i=this.nextElementSibling;if(i.value>1){i.value--;this.form.submit();}" style="border:none;background:none;padding:4px 10px;cursor:pointer;">&minus;</button>
                                    <input type="number" name="quantity" value="<%=item.getQuantity()%>" min="1" max="<%=item.getMedicineStock()%>" readonly style="border:none;text-align:center;width:40px;padding:4px;font-size:13px;">
                                    <button type="button" onclick="var i=this.previousElementSibling;if(i.value<<%=item.getMedicineStock()%>){i.value++;this.form.submit();}" style="border:none;background:none;padding:4px 10px;cursor:pointer;">+</button>
                                </div>
                            </form>
                        </td>
                        <td style="color:var(--danger);font-weight:700;">¥<%=String.format("%.2f", item.getSubtotal())%></td>
                        <td>
                            <a href="<%=ctx%>/CartServlet?action=delete&id=<%=item.getId()%>"
                               class="btn btn-danger btn-sm" onclick="return confirm('确定移除该药品？');">移除</a>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>

        <!-- 结算汇总盒子 -->
        <div class="checkout-summary-box" style="margin-top:20px;">
            <div style="display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:16px;margin-bottom:16px;">
                <span style="font-size:14px;color:var(--gray-500);">共 <strong style="color:var(--primary);font-size:18px;"><%=cartItems.size()%></strong> 种药品</span>
                <div style="font-size:20px;font-weight:800;color:var(--danger);">
                    合计：¥<%=String.format("%.2f", totalAmount)%>
                </div>
            </div>
            <div style="display:flex;gap:12px;justify-content:flex-end;">
                <a href="<%=ctx%>/MedicineListServlet" class="btn btn-outline">继续购物</a>
                <a href="<%=ctx%>/OrderServlet?action=checkout" class="btn btn-primary btn-lg">去结算</a>
            </div>
        </div>
    <% } %>
</div>

<%@ include file="/common/footer.jsp" %>
</body>
</html>

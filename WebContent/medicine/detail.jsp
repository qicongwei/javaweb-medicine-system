<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.medicine.model.User"%>
<%@ page import="com.medicine.model.Medicine"%>
<%
    User user = (User) session.getAttribute("user");
    Medicine med = (Medicine) request.getAttribute("medicine");
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%=med != null ? med.getName() : "药品详情"%> - 在线药品收费系统</title>
    <link rel="stylesheet" href="<%=ctx%>/css/style.css">
</head>
<body>

<%@ include file="/common/header.jsp" %>

<div class="container" style="max-width:1000px;">
    <div class="breadcrumb">
        <a href="<%=ctx%>/index.jsp">首页</a><span class="sep">›</span>
        <a href="<%=ctx%>/MedicineListServlet">药品列表</a><span class="sep">›</span>
        <span><%=med != null ? med.getName() : "药品详情"%></span>
    </div>

    <% if (med == null) { %>
        <div class="section-box">
            <div class="empty-state"><div class="icon">❌</div><div class="text">药品不存在或已下架</div></div>
        </div>
    <% } else { %>
        <div class="detail-layout">
            <!-- 图片盒子 -->
            <div class="detail-img-box <%= med.getIsPrescription() == 1 ? "rx-bg" : "otc-bg"%>" style="<%= med.getIsPrescription() == 1 ? "background:linear-gradient(135deg,#fee2e2,#fecaca);" : "background:linear-gradient(135deg,#d1fae5,#a7f3d0);"%>">
                <span style="font-size:80px;"><%= med.getIsPrescription() == 1 ? "💊" : "🌿" %></span>
            </div>

            <!-- 信息盒子 -->
            <div class="detail-info-box">
                <h1 style="font-size:24px;font-weight:800;color:var(--gray-900);margin-bottom:14px;"><%=med.getName()%></h1>
                <div style="display:flex;gap:8px;margin-bottom:18px;flex-wrap:wrap;">
                    <span class="tag <%= med.getIsPrescription() == 1 ? "tag-danger" : "tag-success" %>"><%=med.getPrescriptionLabel()%></span>
                    <% if (med.getCategoryName() != null) { %><span class="tag tag-info"><%=med.getCategoryName()%></span><% } %>
                    <span class="tag tag-warning">库存 <%=med.getStock()%> 盒</span>
                </div>
                <div style="font-size:32px;font-weight:900;color:var(--danger);margin-bottom:22px;">
                    ¥<%=String.format("%.2f", med.getPrice())%>
                    <span style="font-size:14px;color:var(--gray-400);font-weight:400;">/盒</span>
                </div>

                <div style="background:var(--gray-50);border-radius:var(--radius-sm);padding:16px;margin-bottom:22px;">
                    <div style="display:flex;justify-content:space-between;padding:8px 0;border-bottom:1px dashed var(--gray-200);">
                        <span style="color:var(--gray-500);font-size:13px;">规格</span>
                        <span style="font-weight:500;"><%=med.getSpecification() != null ? med.getSpecification() : "-"%></span>
                    </div>
                    <div style="display:flex;justify-content:space-between;padding:8px 0;border-bottom:1px dashed var(--gray-200);">
                        <span style="color:var(--gray-500);font-size:13px;">生产厂家</span>
                        <span style="font-weight:500;"><%=med.getManufacturer() != null ? med.getManufacturer() : "-"%></span>
                    </div>
                    <div style="display:flex;justify-content:space-between;padding:8px 0;">
                        <span style="color:var(--gray-500);font-size:13px;">上架时间</span>
                        <span style="font-weight:500;"><%=med.getCreateTime()%></span>
                    </div>
                </div>

                <% if (med.getDescription() != null && !med.getDescription().isEmpty()) { %>
                    <div style="background:var(--primary-bg);border-radius:var(--radius-sm);padding:14px;margin-bottom:22px;font-size:13px;line-height:1.7;color:var(--gray-700);">
                        <strong>药品描述：</strong><br><%=med.getDescription()%>
                    </div>
                <% } %>

                <div style="display:flex;gap:10px;align-items:center;flex-wrap:wrap;">
                    <% if (user != null && med.getStock() > 0) { %>
                        <form action="<%=ctx%>/CartServlet" method="post" style="display:flex;gap:10px;align-items:center;flex-wrap:wrap;">
                            <input type="hidden" name="action" value="add">
                            <input type="hidden" name="medicineId" value="<%=med.getId()%>">
                            <div style="display:flex;border:2px solid var(--gray-200);border-radius:6px;">
                                <button type="button" onclick="var inp=this.nextElementSibling;var v=parseInt(inp.value);if(v>1){inp.value=v-1;}" style="border:none;background:none;padding:6px 12px;cursor:pointer;font-weight:700;">&minus;</button>
                                <input type="number" name="quantity" value="1" min="1" max="<%=med.getStock()%>" readonly style="border:none;text-align:center;width:48px;padding:6px;font-size:14px;">
                                <button type="button" onclick="var inp=this.previousElementSibling;var v=parseInt(inp.value);var max=parseInt(inp.getAttribute('max'));if(v<max){inp.value=v+1;}" style="border:none;background:none;padding:6px 12px;cursor:pointer;font-weight:700;">+</button>
                            </div>
                            <button type="submit" class="btn btn-primary btn-lg">加入购物车</button>
                            <a href="<%=ctx%>/MedicineListServlet" class="btn btn-outline">返回列表</a>
                        </form>
                    <% } else if (user == null) { %>
                        <a href="<%=ctx%>/login.jsp" class="btn btn-primary btn-lg">登录后购买</a>
                        <a href="<%=ctx%>/MedicineListServlet" class="btn btn-outline">返回列表</a>
                    <% } else { %>
                        <button disabled class="btn btn-danger btn-lg" style="opacity:0.6;">已售罄</button>
                        <a href="<%=ctx%>/MedicineListServlet" class="btn btn-outline">返回列表</a>
                    <% } %>
                </div>
            </div>
        </div>
    <% } %>
</div>

<%@ include file="/common/footer.jsp" %>
</body>
</html>

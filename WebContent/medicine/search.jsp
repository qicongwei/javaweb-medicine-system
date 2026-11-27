<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.medicine.model.User"%>
<%@ page import="com.medicine.model.Medicine"%>
<%@ page import="java.util.List"%>
<%
    User user = (User) session.getAttribute("user");
    List<Medicine> medicines = (List<Medicine>) request.getAttribute("medicines");
    String keyword = (String) request.getAttribute("keyword");
    int currentPage = (Integer) request.getAttribute("currentPage");
    int totalPages = (Integer) request.getAttribute("totalPages");
    int totalCount = (Integer) request.getAttribute("totalCount");
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>搜索结果 - 在线药品收费系统</title>
    <link rel="stylesheet" href="<%=ctx%>/css/style.css">
</head>
<body>

<%@ include file="/common/header.jsp" %>

<!-- 搜索栏盒子 -->
<div class="search-box">
    <div class="container">
        <form class="search-form" action="<%=ctx%>/MedicineListServlet" method="get">
            <input type="hidden" name="action" value="search">
            <input type="text" name="keyword" value="<%=keyword != null ? keyword : ""%>" placeholder="搜索药品名称、成分、功效...">
            <button type="submit">搜索</button>
        </form>
    </div>
</div>

<div class="container">
    <div class="breadcrumb">
        <a href="<%=ctx%>/index.jsp">首页</a><span class="sep">›</span><span>搜索结果</span>
    </div>

    <!-- 搜索结果提示盒子 -->
    <div class="section-box" style="padding:14px 24px;text-align:center;background:var(--primary-bg);">
        <span style="color:var(--gray-500);font-size:14px;">搜索 "</span>
        <strong style="color:var(--primary);"><%=keyword != null ? keyword : ""%></strong>
        <span style="color:var(--gray-500);">" 找到 </span>
        <strong style="color:var(--primary);font-size:18px;"><%=totalCount%></strong>
        <span style="color:var(--gray-500);"> 种药品</span>
    </div>

    <% if (medicines == null || medicines.isEmpty()) { %>
        <div class="section-box">
            <div class="empty-state"><div class="icon">🔍</div><div class="text">未找到相关药品</div><a href="<%=ctx%>/MedicineListServlet" class="btn btn-outline btn-lg">浏览全部药品</a></div>
        </div>
    <% } else { %>
        <!-- 药品卡片网格 -->
        <div class="section-box" style="padding:20px;">
            <div class="card-grid cols-4">
                <% for (Medicine med : medicines) { %>
                <div class="med-card">
                    <div class="card-img <%=med.getIsPrescription() == 1 ? "rx" : "otc"%>">
                        <span class="type-badge <%=med.getIsPrescription() == 1 ? "rx" : "otc"%>"><%=med.getPrescriptionLabel()%></span>
                        <%=med.getIsPrescription() == 1 ? "💊" : "🌿"%>
                    </div>
                    <div class="card-body">
                        <div class="card-name"><%=med.getName()%></div>
                        <div class="card-spec"><%=med.getSpecification() != null ? med.getSpecification() : ""%></div>
                        <div class="card-tags">
                            <% if (med.getCategoryName() != null) { %><span class="tag tag-info"><%=med.getCategoryName()%></span><% } %>
                        </div>
                        <div class="card-bottom">
                            <div>
                                <div class="card-price">¥<%=String.format("%.2f", med.getPrice())%> <span class="unit">/盒</span></div>
                                <div class="card-stock"><%=med.getStock()==0?"缺货":"库存 "+med.getStock()+" 盒"%></div>
                            </div>
                            <div style="display:flex;gap:6px;">
                                <a href="<%=ctx%>/MedicineDetailServlet?id=<%=med.getId()%>" class="btn btn-outline btn-sm">详情</a>
                                <% if (user != null && med.getStock() > 0) { %>
                                    <form action="<%=ctx%>/CartServlet" method="post" style="display:inline;">
                                        <input type="hidden" name="action" value="add"><input type="hidden" name="medicineId" value="<%=med.getId()%>">
                                        <button type="submit" class="btn btn-primary btn-sm">加购</button>
                                    </form>
                                <% } else if (user == null) { %>
                                    <a href="<%=ctx%>/login.jsp" class="btn btn-primary btn-sm">加购</a>
                                <% } %>
                            </div>
                        </div>
                    </div>
                </div>
                <% } %>
            </div>
        </div>

        <% if (totalPages > 1) {
            String pageBase = "?action=search&keyword=" + (keyword != null ? java.net.URLEncoder.encode(keyword, "UTF-8") : "") + "&page=";
        %>
            <div class="pagination-box">
                <% if (currentPage > 1) { %><a href="<%=pageBase%><%=currentPage-1%>">‹ 上一页</a><% } %>
                <% for (int i = 1; i <= totalPages; i++) { %>
                    <% if (i == currentPage) { %><span class="current"><%=i%></span>
                    <% } else { %><a href="<%=pageBase%><%=i%>"><%=i%></a><% } %>
                <% } %>
                <% if (currentPage < totalPages) { %><a href="<%=pageBase%><%=currentPage+1%>">下一页 ›</a><% } %>
            </div>
        <% } %>
    <% } %>
</div>

<%@ include file="/common/footer.jsp" %>
</body>
</html>

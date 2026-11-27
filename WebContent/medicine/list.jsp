<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.medicine.model.User"%>
<%@ page import="com.medicine.model.Medicine"%>
<%@ page import="com.medicine.model.Category"%>
<%@ page import="java.util.List"%>
<%
    User user = (User) session.getAttribute("user");
    List<Medicine> medicines = (List<Medicine>) request.getAttribute("medicines");
    List<Category> categories = (List<Category>) request.getAttribute("categories");
    int currentPage = (Integer) request.getAttribute("currentPage");
    int totalPages = (Integer) request.getAttribute("totalPages");
    int totalCount = (Integer) request.getAttribute("totalCount");
    Integer currentCategoryId = (Integer) request.getAttribute("currentCategoryId");
    if (currentCategoryId == null) currentCategoryId = -1;
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>药品列表 - 在线药品收费系统</title>
    <link rel="stylesheet" href="<%=ctx%>/css/style.css">
    <style>
        /* 药品表格样式 */
        .med-table-wrap {
            background: var(--white);
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-section);
            padding: 24px;
            margin-bottom: 24px;
            border: 1px solid rgba(255,255,255,0.8);
        }
        .med-table-title {
            font-size: 20px;
            font-weight: 700;
            color: var(--gray-800);
            margin-bottom: 20px;
            padding-bottom: 14px;
            border-bottom: 2px solid var(--primary-bg);
        }
        .med-table { width: 100%; border-collapse: collapse; }
        .med-table th, .med-table td {
            padding: 12px 16px;
            text-align: center;
            border-bottom: 1px solid var(--gray-200);
            font-size: 15px;
        }
        .med-table thead th {
            background: linear-gradient(135deg, #4f6ef7, #764ba2);
            color: #fff;
            font-weight: 700;
            font-size: 15px;
            letter-spacing: 1px;
        }
        .med-table tbody tr:hover { background: var(--primary-bg); transition: background 0.2s; }
        .med-table .td-name { text-align: left; font-weight: 600; color: var(--primary-dark); }
        .med-table .price { color: var(--danger); font-weight: 700; font-size: 16px; }
        .med-table .stock-low { color: var(--warning); font-weight: 600; }
        .med-table input[type="number"] {
            width: 60px; height: 34px; text-align: center;
            border: 1px solid var(--gray-300); border-radius: var(--radius-sm);
            font-size: 14px; outline: none; margin-right: 6px;
        }
        .med-table input[type="number"]:focus { border-color: var(--primary); box-shadow: 0 0 0 3px rgba(79,110,247,0.12); }
        .btn-cart { display: inline-block; padding: 7px 18px; background: var(--white); color: var(--primary);
            border: 1.5px solid var(--primary); border-radius: var(--radius-sm); cursor: pointer;
            font-weight: 600; font-size: 13px; transition: all 0.25s; vertical-align: middle; line-height: normal; }
        .btn-cart:hover { background: var(--primary); color: #fff; transform: translateY(-1px); }
        .table-actions { margin-top: 16px; padding-top: 16px; border-top: 1px solid var(--gray-200); }
        .table-actions a, .table-actions button {
            display: inline-block; padding: 8px 20px; margin-right: 10px;
            background: var(--gray-100); color: var(--gray-600);
            border: 1px solid var(--gray-300); border-radius: var(--radius-sm);
            font-weight: 600; font-size: 13px; text-decoration: none;
            cursor: pointer; transition: all 0.25s;
        }
        .table-actions a:hover, .table-actions button:hover {
            background: var(--primary); color: #fff; border-color: var(--primary);
        }
        @media (max-width: 720px) {
            .med-table th:nth-child(1), .med-table td:nth-child(1) { display: none; }
            .med-table { font-size: 13px; }
            .med-table th, .med-table td { padding: 8px 10px; }
        }
    </style>
</head>
<body>

<%@ include file="/common/header.jsp" %>

<!-- 搜索栏盒子 -->
<div class="search-box">
    <div class="container">
        <form class="search-form" action="<%=ctx%>/MedicineListServlet" method="get">
            <input type="hidden" name="action" value="search">
            <input type="text" name="keyword" placeholder="搜索药品名称、成分、功效...">
            <button type="submit">搜索</button>
        </form>
    </div>
</div>

<div class="container">
    <!-- 面包屑 -->
    <div class="breadcrumb">
        <a href="<%=ctx%>/index.jsp">首页</a><span class="sep">›</span>
        <span><%=currentCategoryId == -1 ? "全部药品" : ""%></span>
        <% if (currentCategoryId != -1) {
            for (Category c : categories) {
                if (c.getId() == currentCategoryId) { %>
                    <span><%=c.getName()%></span>
        <% } } } %>
    </div>

    <div class="main-layout">
        <!-- 侧边栏分类盒子 -->
        <aside class="sidebar-box">
            <h3>📂 药品分类</h3>
            <a href="<%=ctx%>/MedicineListServlet"
               style="<%=currentCategoryId == -1 ? "background:var(--primary-bg);color:var(--primary);font-weight:600;border-left-color:var(--primary);" : ""%>">
               全部药品
            </a>
            <% for (Category cat : categories) { %>
                <a href="<%=ctx%>/MedicineListServlet?categoryId=<%=cat.getId()%>"
                   style="<%=currentCategoryId == cat.getId() ? "background:var(--primary-bg);color:var(--primary);font-weight:600;border-left-color:var(--primary);" : ""%>">
                    <%=cat.getName()%>
                </a>
            <% } %>
        </aside>

        <!-- 主内容区 -->
        <main class="content-area">

            <!-- 统计条盒子 -->
            <div class="stats-bar">
                <div class="stat-text">
                    共 <strong><%=totalCount%></strong> 种药品
                </div>
            </div>

            <% if (medicines == null || medicines.isEmpty()) { %>
                <div class="section-box">
                    <div class="empty-state">
                        <div class="icon">📭</div>
                        <div class="text">暂无药品数据</div>
                    </div>
                </div>
            <% } else { %>

            <!-- 药品表格 -->
            <div class="med-table-wrap">
                <div class="med-table-title">医院药品列表</div>
                <table class="med-table">
                    <thead>
                        <tr>
                            <th style="width:60px;">ID</th>
                            <th>药品名称</th>
                            <th style="width:120px;">单价(元)</th>
                            <th style="width:100px;">当前库存</th>
                            <th style="width:200px;">购买数量</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Medicine med : medicines) { %>
                        <tr>
                            <td><%=med.getId()%></td>
                            <td class="td-name">
                                <%=med.getName()%>
                                <%=med.getIsPrescription() == 1 ?
                                    "<span style='font-size:11px;color:#ef4444;font-weight:500;margin-left:4px;'>[处方]</span>" :
                                    "<span style='font-size:11px;color:#22c55e;font-weight:500;margin-left:4px;'>[OTC]</span>"%>
                            </td>
                            <td class="price">¥<%=String.format("%.2f", med.getPrice())%></td>
                            <td class="<%=med.getStock() <= 30 && med.getStock() > 0 ? "stock-low" : "" %>"><%=med.getStock()%></td>
                            <td>
                                <% if (user != null && med.getStock() > 0) { %>
                                    <form action="<%=ctx%>/CartServlet" method="post" style="display:inline;">
                                        <input type="hidden" name="action" value="add">
                                        <input type="hidden" name="medicineId" value="<%=med.getId()%>">
                                        <input type="number" name="quantity" value="1" min="1" max="<%=med.getStock()%>">
                                        <button type="submit" class="btn-cart">加入购物车</button>
                                    </form>
                                <% } else if (user != null && med.getStock() == 0) { %>
                                    <span style="color:var(--danger);font-weight:600;">缺货</span>
                                <% } else { %>
                                    <a href="<%=ctx%>/login.jsp" class="btn-cart" onclick="alert('请先登录后再购买');return false;" style="border-color:var(--gray-400);color:var(--gray-400);">登录后加购</a>
                                <% } %>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
                <div class="table-actions">
                    <% if (user != null) { %>
                        <a href="<%=ctx%>/CartServlet"><i class="fas fa-shopping-cart"></i> 查看购物车</a>
                    <% } else { %>
                        <a href="<%=ctx%>/login.jsp"><i class="fas fa-shopping-cart"></i> 查看购物车</a>
                    <% } %>
                    <% if (user != null) { %>
                        <button onclick="if(confirm('确定要清空购物车吗？')){location.href='<%=ctx%>/CartServlet?action=clear';}">
                            <i class="fas fa-trash-alt"></i> 清空购物车
                        </button>
                    <% } %>
                    <button onclick="location.reload();">
                        <i class="fas fa-sync-alt"></i> 重置库存
                    </button>
                </div>
            </div>

            <!-- 分页盒子 -->
            <% if (totalPages > 1) {
                String pageExt = currentCategoryId != -1 ? "&categoryId=" + currentCategoryId : "";
            %>
                <div class="pagination-box">
                    <% if (currentPage > 1) { %><a href="?page=<%=currentPage-1%><%=pageExt%>">‹ 上一页</a><% } %>
                    <% for (int i = 1; i <= totalPages; i++) { %>
                        <% if (i == currentPage) { %><span class="current"><%=i%></span>
                        <% } else { %><a href="?<%=i == 1 ? "" : "page=" + i%><%=i == 1 ? "" : pageExt%>"><%=i%></a><% } %>
                    <% } %>
                    <% if (currentPage < totalPages) { %><a href="?page=<%=currentPage+1%><%=pageExt%>">下一页 ›</a><% } %>
                </div>
            <% } %>

            <% } %>
        </main>
    </div>
</div>

<%@ include file="/common/footer.jsp" %>

</body>
</html>

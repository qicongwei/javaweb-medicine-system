<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.medicine.model.User"%>
<%@ page import="java.util.List"%>
<%
    User adminUser = (User) session.getAttribute("user");
    if (adminUser == null || !"admin".equals(adminUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp"); return;
    }
    double totalSales = (Double) request.getAttribute("totalSales");
    double todaySales = (Double) request.getAttribute("todaySales");
    int totalOrders = (Integer) request.getAttribute("totalOrders");
    int todayOrders = (Integer) request.getAttribute("todayOrders");
    List<Object[]> salesByMedicine = (List<Object[]>) request.getAttribute("salesByMedicine");
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>销售统计 - 后台管理</title>
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
                <h2>📈 销售统计</h2>
            </div>

            <!-- 统计卡片（居中网格） -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon purple">💰</div>
                    <div class="stat-value">&yen;<%=String.format("%.2f", totalSales)%></div>
                    <div class="stat-label">总销售额</div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon green">💵</div>
                    <div class="stat-value">&yen;<%=String.format("%.2f", todaySales)%></div>
                    <div class="stat-label">今日销售额</div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon orange">📋</div>
                    <div class="stat-value"><%=totalOrders%></div>
                    <div class="stat-label">总订单数</div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon blue">📦</div>
                    <div class="stat-value"><%=todayOrders%></div>
                    <div class="stat-label">今日订单</div>
                </div>
            </div>

            <!-- 药品销售排行（卡片表格） -->
            <div class="card" style="margin-top:8px;">
                <div class="card-body">
                    <h3 style="font-size:16px;font-weight:700;color:var(--gray-800);margin-bottom:16px;">🏆 药品销售排行 TOP10</h3>

                    <% if (salesByMedicine == null || salesByMedicine.isEmpty()) { %>
                        <div class="empty-state">
                            <div class="icon">📊</div>
                            <div class="text">暂无销售数据</div>
                        </div>
                    <% } else { %>
                        <div class="table-wrapper" style="box-shadow:none;border:none;">
                            <table>
                                <thead>
                                    <tr>
                                        <th style="width:60px;">排名</th>
                                        <th>药品名称</th>
                                        <th style="width:120px;">销售数量</th>
                                        <th style="width:150px;">销售额</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% int rank = 1;
                                       for (Object[] row : salesByMedicine) {
                                        String medal = "";
                                        if (rank == 1) medal = "🥇";
                                        else if (rank == 2) medal = "🥈";
                                        else if (rank == 3) medal = "🥉";
                                    %>
                                        <tr>
                                            <td style="font-size:16px;"><%=medal.isEmpty() ? String.valueOf(rank) : medal%></td>
                                            <td><strong style="color:var(--gray-800);"><%=row[0]%></strong></td>
                                            <td><%=row[1]%> 盒</td>
                                            <td style="color:var(--danger);font-weight:700;">&yen;<%=String.format("%.2f", (Double)row[2])%></td>
                                        </tr>
                                    <% rank++; } %>
                                </tbody>
                            </table>
                        </div>
                    <% } %>
                </div>
            </div>
        </main>
    </div>
</body>
</html>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.medicine.model.User"%>
<%@ page import="com.medicine.model.Medicine"%>
<%@ page import="java.util.List"%>
<%
    User adminUser = (User) session.getAttribute("user");
    if (adminUser == null || !"admin".equals(adminUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp"); return;
    }
    List<Medicine> medicines = (List<Medicine>) request.getAttribute("medicines");
    int currentPage = (Integer) request.getAttribute("currentPage");
    int totalPages = (Integer) request.getAttribute("totalPages");
    int totalCount = (Integer) request.getAttribute("totalCount");
    String msg = (String) request.getAttribute("msg");
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>药品列表 - 后台管理</title>
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
                <h2>💊 药品管理</h2>
                <a href="<%=request.getContextPath()%>/admin/AdminMedicineServlet?action=add" class="btn btn-primary">➕ 添加药品</a>
            </div>

            <% if (msg != null) { %><div class="alert alert-success"><%=msg%></div><% } %>

            <div class="card" style="margin-bottom:16px;padding:12px 20px;text-align:center;">
                <p style="color:var(--gray-500);font-size:14px;">共 <strong style="color:var(--primary);"><%=totalCount%></strong> 种药品</p>
            </div>

            <div class="table-wrapper">
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>药品名称</th>
                            <th>分类</th>
                            <th>单价</th>
                            <th>库存</th>
                            <th>类型</th>
                            <th>上架时间</th>
                            <th>操作</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (medicines != null) {
                            for (Medicine med : medicines) { %>
                            <tr>
                                <td><%=med.getId()%></td>
                                <td><strong style="color:var(--gray-800);"><%=med.getName()%></strong></td>
                                <td><%=med.getCategoryName() != null ? med.getCategoryName() : "-"%></td>
                                <td style="color:var(--danger);font-weight:600;">&yen;<%=String.format("%.2f", med.getPrice())%></td>
                                <td>
                                    <% if (med.getStock() == 0) { %><span class="tag tag-danger">缺货</span>
                                    <% } else if (med.getStock() < 50) { %><span class="tag tag-warning"><%=med.getStock()%></span>
                                    <% } else { %><%=med.getStock()%><% } %>
                                </td>
                                <td><span class="tag <%= med.getIsPrescription() == 1 ? "tag-danger" : "tag-success" %>"><%=med.getPrescriptionLabel()%></span></td>
                                <td style="font-size:12px;color:var(--gray-400);"><%=med.getCreateTime()%></td>
                                <td>
                                    <div class="btn-group">
                                        <a href="<%=request.getContextPath()%>/admin/AdminMedicineServlet?action=edit&id=<%=med.getId()%>" class="btn btn-outline btn-sm">编辑</a>
                                        <a href="<%=request.getContextPath()%>/admin/AdminMedicineServlet?action=delete&id=<%=med.getId()%>"
                                           class="btn btn-danger btn-sm" onclick="return confirm('确定删除该药品？');">删除</a>
                                    </div>
                                </td>
                            </tr>
                        <% }} %>
                    </tbody>
                </table>
            </div>

            <% if (totalPages > 1) { %>
                <div class="pagination">
                    <% if (currentPage > 1) { %><a href="?page=<%=currentPage-1%>">上一页</a><% } %>
                    <% for (int i = 1; i <= totalPages; i++) { %>
                        <% if (i == currentPage) { %><span class="current"><%=i%></span>
                        <% } else { %><a href="?page=<%=i%>"><%=i%></a><% } %>
                    <% } %>
                    <% if (currentPage < totalPages) { %><a href="?page=<%=currentPage+1%>">下一页</a><% } %>
                </div>
            <% } %>
        </main>
    </div>
</body>
</html>

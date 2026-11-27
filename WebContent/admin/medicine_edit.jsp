<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.medicine.model.User"%>
<%@ page import="com.medicine.model.Medicine"%>
<%@ page import="com.medicine.model.Category"%>
<%@ page import="java.util.List"%>
<%
    User adminUser = (User) session.getAttribute("user");
    if (adminUser == null || !"admin".equals(adminUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp"); return;
    }
    Medicine medicine = (Medicine) request.getAttribute("medicine");
    List<Category> categories = (List<Category>) request.getAttribute("categories");
    if (medicine == null) { response.sendRedirect(request.getContextPath() + "/admin/AdminMedicineServlet"); return; }
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>编辑药品 - 后台管理</title>
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
                <h2>✏️ 编辑药品 - <%=medicine.getName()%></h2>
                <a href="<%=request.getContextPath()%>/admin/AdminMedicineServlet" class="btn btn-outline">返回列表</a>
            </div>

            <% if (error != null) { %><div class="alert alert-error"><%=error%></div><% } %>

            <div class="admin-form">
                <h3>修改药品信息</h3>
                <form action="<%=request.getContextPath()%>/admin/AdminMedicineServlet" method="post">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="id" value="<%=medicine.getId()%>">

                    <div class="form-group">
                        <label>药品名称 <span class="label-hint">*</span></label>
                        <input type="text" name="name" value="<%=medicine.getName()%>" required>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label>药品分类 <span class="label-hint">*</span></label>
                            <select name="categoryId" required>
                                <option value="">请选择分类</option>
                                <% for (Category cat : categories) { %>
                                    <option value="<%=cat.getId()%>" <%=medicine.getCategoryId()==cat.getId()?"selected":""%>><%=cat.getName()%></option>
                                <% } %>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>药品类型 <span class="label-hint">*</span></label>
                            <select name="is_prescription" required>
                                <option value="0" <%=medicine.getIsPrescription()==0?"selected":""%>>非处方药 (OTC)</option>
                                <option value="1" <%=medicine.getIsPrescription()==1?"selected":""%>>处方药</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label>单价(元) <span class="label-hint">*</span></label>
                            <input type="number" step="0.01" name="price" value="<%=medicine.getPrice()%>" required>
                        </div>
                        <div class="form-group">
                            <label>库存数量 <span class="label-hint">*</span></label>
                            <input type="number" name="stock" value="<%=medicine.getStock()%>" required>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label>规格</label>
                            <input type="text" name="specification" value="<%=medicine.getSpecification() != null ? medicine.getSpecification() : ""%>" placeholder="如: 10mg×12片">
                        </div>
                        <div class="form-group">
                            <label>生产厂家</label>
                            <input type="text" name="manufacturer" value="<%=medicine.getManufacturer() != null ? medicine.getManufacturer() : ""%>">
                        </div>
                    </div>

                    <div class="form-group">
                        <label>药品描述</label>
                        <textarea name="description" rows="4" placeholder="请输入药品功效、用法用量等描述..."><%=medicine.getDescription() != null ? medicine.getDescription() : ""%></textarea>
                    </div>

                    <div class="btn-group" style="margin-top:20px;">
                        <button type="submit" class="btn btn-primary btn-lg">保存修改</button>
                        <a href="<%=request.getContextPath()%>/admin/AdminMedicineServlet" class="btn btn-outline btn-lg">取消</a>
                    </div>
                </form>
            </div>
        </main>
    </div>
</body>
</html>

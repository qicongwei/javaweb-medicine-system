<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>404 - 页面未找到</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
</head>
<body class="auth-page">
    <div class="auth-card" style="text-align:center;">
        <div style="font-size:72px;margin-bottom:16px;">🔍</div>
        <h2 style="font-size:28px;margin-bottom:8px;">404</h2>
        <p class="subtitle" style="margin-bottom:24px;">抱歉，您访问的页面不存在</p>
        <a href="<%=request.getContextPath()%>/index.jsp" class="btn btn-primary btn-lg btn-block">返回首页</a>
    </div>
</body>
</html>

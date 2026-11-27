<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String error = (String) request.getAttribute("error");
    String msg = (String) request.getAttribute("msg");
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <%@ include file="common/head.jsp" %>
    <title>登录 - 在线药品收费系统</title>
    <style>
        .auth-page {
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 20px;
        }
        .auth-card {
            background: var(--white);
            border-radius: var(--radius-lg);
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            width: 420px;
            max-width: 100%;
            padding: 40px 32px;
            animation: scaleIn 0.5s ease-out;
        }
        .auth-card .auth-header {
            text-align: center;
            margin-bottom: 32px;
        }
        .auth-card .auth-icon {
            width: 64px;
            height: 64px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 16px;
            font-size: 28px;
            color: var(--white);
            box-shadow: 0 8px 24px rgba(79,110,247,0.4);
        }
        .auth-card h2 {
            font-size: 24px;
            font-weight: 800;
            color: var(--gray-900);
            margin-bottom: 8px;
        }
        .auth-card .subtitle {
            color: var(--gray-500);
            font-size: 14px;
        }
        .form-group {
            margin-bottom: 20px;
            position: relative;
        }
        .form-group label {
            display: block;
            font-size: 13px;
            font-weight: 600;
            color: var(--gray-700);
            margin-bottom: 8px;
        }
        .form-group .input-wrapper {
            position: relative;
        }
        .form-group .input-wrapper i {
            position: absolute;
            left: 14px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--gray-400);
            font-size: 16px;
            pointer-events: none;
            transition: color 0.3s ease;
        }
        .form-group input {
            width: 100%;
            padding: 12px 16px 12px 44px;
            border: 2px solid var(--gray-200);
            border-radius: var(--radius-sm);
            font-size: 14px;
            transition: var(--transition);
            background: var(--gray-50);
        }
        .form-group input:focus {
            outline: none;
            border-color: var(--primary);
            background: var(--white);
            box-shadow: 0 0 0 4px rgba(79,110,247,0.1);
        }
        .form-group input:focus + i,
        .form-group input:focus ~ i {
            color: var(--primary);
        }
        .btn-login {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: var(--white);
            border: none;
            border-radius: var(--radius-sm);
            font-size: 15px;
            font-weight: 700;
            cursor: pointer;
            transition: var(--transition);
            box-shadow: 0 4px 14px rgba(79,110,247,0.4);
            margin-top: 8px;
        }
        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 24px rgba(79,110,247,0.5);
        }
        .btn-login:active {
            transform: translateY(0);
        }
        .footer-link {
            text-align: center;
            padding: 16px 0 0;
            border-top: 1px solid var(--gray-200);
            margin-top: 24px;
            font-size: 13px;
            color: var(--gray-500);
        }
        .footer-link a {
            color: var(--primary);
            font-weight: 600;
        }
        .footer-link a:hover {
            text-decoration: underline;
        }
        .alert {
            padding: 12px 16px;
            border-radius: var(--radius-sm);
            font-size: 13px;
            font-weight: 600;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .alert-error {
            background: #fee2e2;
            color: #dc2626;
            border-left: 4px solid var(--danger);
        }
        .alert-success {
            background: #dcfce7;
            color: #16a34a;
            border-left: 4px solid var(--success);
        }
    </style>
</head>
<body class="auth-page">
    <div class="auth-card">
        <div class="auth-header">
            <div class="auth-icon">
                <i class="fas fa-sign-in-alt"></i>
            </div>
            <h2>用户登录</h2>
            <p class="subtitle">欢迎使用在线药品收费管理系统</p>
        </div>

        <% if (error != null) { %>
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle"></i> <%=error%>
            </div>
        <% } %>
        <% if (msg != null) { %>
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i> <%=msg%>
            </div>
        <% } %>

        <form action="<%=ctx%>/LoginServlet" method="post">
            <div class="form-group">
                <label>用户名</label>
                <div class="input-wrapper">
                    <input type="text" name="username" placeholder="请输入用户名" required autocomplete="username">
                    <i class="fas fa-user"></i>
                </div>
            </div>
            <div class="form-group">
                <label>密码</label>
                <div class="input-wrapper">
                    <input type="password" name="password" placeholder="请输入密码" required autocomplete="current-password">
                    <i class="fas fa-lock"></i>
                </div>
            </div>
            <button type="submit" class="btn-login btn-animate">
                <i class="fas fa-arrow-right-to-bracket"></i> 登 录
            </button>
        </form>

        <div class="footer-link">
            还没有账号？<a href="<%=ctx%>/register.jsp">立即注册</a>
        </div>
        <div class="footer-link" style="border-top:none;padding-top:12px;">
            <a href="<%=ctx%>/index.jsp"><i class="fas fa-arrow-left"></i> 返回首页</a>
        </div>
    </div>
</body>
</html>

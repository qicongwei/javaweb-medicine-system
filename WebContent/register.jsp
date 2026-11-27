<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String error = (String) request.getAttribute("error");
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <%@ include file="common/head.jsp" %>
    <title>注册 - 在线药品收费系统</title>
    <style>
        .auth-page {
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 40px 20px;
        }
        .auth-card {
            background: var(--white);
            border-radius: var(--radius-lg);
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            width: 460px;
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
            background: linear-gradient(135deg, var(--success), #16a34a);
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 16px;
            font-size: 28px;
            color: var(--white);
            box-shadow: 0 8px 24px rgba(34,197,94,0.4);
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
            margin-bottom: 18px;
            position: relative;
        }
        .form-group label {
            display: block;
            font-size: 13px;
            font-weight: 600;
            color: var(--gray-700);
            margin-bottom: 6px;
        }
        .form-group .label-hint {
            color: var(--gray-400);
            font-weight: 400;
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
            padding: 11px 16px 11px 44px;
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
        .form-group input:focus ~ i {
            color: var(--primary);
        }
        .btn-register {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, var(--success), #16a34a);
            color: var(--white);
            border: none;
            border-radius: var(--radius-sm);
            font-size: 15px;
            font-weight: 700;
            cursor: pointer;
            transition: var(--transition);
            box-shadow: 0 4px 14px rgba(34,197,94,0.4);
            margin-top: 8px;
        }
        .btn-register:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 24px rgba(34,197,94,0.5);
        }
        .btn-register:active {
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
        .password-strength {
            height: 4px;
            border-radius: 2px;
            margin-top: 8px;
            background: var(--gray-200);
            overflow: hidden;
        }
        .password-strength-bar {
            height: 100%;
            width: 0;
            border-radius: 2px;
            transition: all 0.3s ease;
        }
        .password-strength-bar.weak { width: 33%; background: var(--danger); }
        .password-strength-bar.medium { width: 66%; background: var(--warning); }
        .password-strength-bar.strong { width: 100%; background: var(--success); }
        .password-strength-text {
            font-size: 12px;
            margin-top: 4px;
            transition: color 0.3s ease;
        }
    </style>
</head>
<body class="auth-page">
    <div class="auth-card">
        <div class="auth-header">
            <div class="auth-icon">
                <i class="fas fa-user-plus"></i>
            </div>
            <h2>用户注册</h2>
            <p class="subtitle">创建您的账号</p>
        </div>

        <% if (error != null) { %>
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle"></i> <%=error%>
            </div>
        <% } %>

        <form action="<%=ctx%>/RegisterServlet" method="post" id="registerForm">
            <div class="form-group">
                <label>用户名 <span class="label-hint">(登录使用)</span></label>
                <div class="input-wrapper">
                    <input type="text" name="username" placeholder="请输入用户名" required>
                    <i class="fas fa-user"></i>
                </div>
            </div>
            <div class="form-group">
                <label>密码</label>
                <div class="input-wrapper">
                    <input type="password" name="password" id="regPassword" placeholder="请设置密码（不少于6位）" required minlength="6" oninput="checkPasswordStrength(this.value)">
                    <i class="fas fa-lock"></i>
                </div>
                <div class="password-strength">
                    <div class="password-strength-bar" id="strengthBar"></div>
                </div>
                <div class="password-strength-text" id="strengthText"></div>
            </div>
            <div class="form-group">
                <label>确认密码</label>
                <div class="input-wrapper">
                    <input type="password" name="repassword" id="regRepassword" placeholder="请再次输入密码" required>
                    <i class="fas fa-lock"></i>
                </div>
            </div>
            <div class="form-group">
                <label>真实姓名</label>
                <div class="input-wrapper">
                    <input type="text" name="realname" placeholder="请输入真实姓名" required>
                    <i class="fas fa-id-card"></i>
                </div>
            </div>
            <div class="form-group">
                <label>手机号</label>
                <div class="input-wrapper">
                    <input type="tel" name="phone" placeholder="请输入手机号">
                    <i class="fas fa-phone"></i>
                </div>
            </div>
            <div class="form-group">
                <label>收货地址</label>
                <div class="input-wrapper">
                    <input type="text" name="address" placeholder="请输入收货地址">
                    <i class="fas fa-map-marker-alt"></i>
                </div>
            </div>
            <button type="submit" class="btn-register btn-animate">
                <i class="fas fa-user-check"></i> 注 册
            </button>
        </form>

        <div class="footer-link">
            已有账号？<a href="<%=ctx%>/login.jsp">立即登录</a>
        </div>
        <div class="footer-link" style="border-top:none;padding-top:12px;">
            <a href="<%=ctx%>/index.jsp"><i class="fas fa-arrow-left"></i> 返回首页</a>
        </div>
    </div>

    <script>
        function checkPasswordStrength(password) {
            var bar = document.getElementById('strengthBar');
            var text = document.getElementById('strengthText');
            if (!password) {
                bar.className = 'password-strength-bar';
                text.textContent = '';
                return;
            }
            var strength = 0;
            if (password.length >= 6) strength++;
            if (password.length >= 10) strength++;
            if (/[A-Z]/.test(password)) strength++;
            if (/[0-9]/.test(password)) strength++;
            if (/[^A-Za-z0-9]/.test(password)) strength++;

            if (strength <= 2) {
                bar.className = 'password-strength-bar weak';
                text.textContent = '密码强度：弱';
                text.style.color = '#ef4444';
            } else if (strength <= 3) {
                bar.className = 'password-strength-bar medium';
                text.textContent = '密码强度：中';
                text.style.color = '#f59e0b';
            } else {
                bar.className = 'password-strength-bar strong';
                text.textContent = '密码强度：强';
                text.style.color = '#22c55e';
            }
        }
    </script>
</body>
</html>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.medicine.model.User"%>
<%
    String ctx = request.getContextPath();
    User user = (User) session.getAttribute("user");
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <%@ include file="common/head.jsp" %>
    <title>在线药品收费管理系统</title>
    <style>
        /* ========== 首页专用样式 ========== */
        .home-hero {
            background: linear-gradient(135deg, #4f6ef7 0%, #764ba2 100%);
            color: var(--white);
            padding: 90px 24px 110px;
            text-align: center;
            position: relative;
            overflow: hidden;
            width: 100%;
        }
        .home-hero::before {
            content: '';
            position: absolute;
            top: -50%; right: -20%;
            width: 600px; height: 600px;
            border-radius: 50%;
            background: rgba(255,255,255,0.08);
            animation: heroFloat 6s ease-in-out infinite;
        }
        .home-hero::after {
            content: '';
            position: absolute;
            bottom: -30%; left: -10%;
            width: 400px; height: 400px;
            border-radius: 50%;
            background: rgba(255,255,255,0.05);
            animation: heroFloat 8s ease-in-out infinite reverse;
        }
        @keyframes heroFloat {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-30px); }
        }
        .home-hero h1 {
            font-size: 42px; font-weight: 900; margin-bottom: 16px;
            letter-spacing: 2px; position: relative; z-index: 10;
            animation: fadeInUp 0.8s ease-out;
        }
        .home-hero p {
            font-size: 18px; opacity: 0.9; margin-bottom: 32px;
            position: relative; z-index: 10;
            animation: fadeInUp 0.8s ease-out 0.2s both;
        }
        .home-hero .btn-hero {
            display: inline-flex; align-items: center; gap: 10px;
            padding: 14px 40px;
            background: var(--white); color: var(--primary);
            font-weight: 700; font-size: 16px;
            border-radius: var(--radius);
            text-decoration: none; transition: var(--transition);
            box-shadow: 0 8px 24px rgba(0,0,0,0.15);
            position: relative; z-index: 10;
            animation: fadeInUp 0.8s ease-out 0.4s both;
        }
        .home-hero .btn-hero:hover {
            transform: translateY(-3px);
            box-shadow: 0 12px 32px rgba(0,0,0,0.25);
        }

        /* 特色卡片区 - 浮在hero上方 */
        .home-features {
            display: flex; gap: 24px;
            margin-top: -60px; position: relative; z-index: 10;
            padding-bottom: 60px; max-width: 1200px; margin-left: auto; margin-right: auto;
            padding-left: 24px; padding-right: 24px;
        }
        .feature-card {
            flex: 1; background: var(--white);
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-section);
            padding: 36px 28px; text-align: center;
            transition: var(--transition);
            border: 1px solid rgba(255,255,255,0.8);
            animation: fadeInUp 0.6s ease-out both;
        }
        .feature-card:nth-child(1) { animation-delay: 0.2s; }
        .feature-card:nth-child(2) { animation-delay: 0.4s; }
        .feature-card:nth-child(3) { animation-delay: 0.6s; }
        .feature-card:hover {
            transform: translateY(-10px); box-shadow: var(--shadow-box-hover);
        }
        .feature-card .icon {
            width: 72px; height: 72px; border-radius: 18px;
            display: flex; align-items: center; justify-content: center;
            font-size: 32px; margin: 0 auto 20px;
        }
        .feature-card .icon.blue { background: linear-gradient(135deg,#eef2ff,#c7d2fe); color: var(--primary); }
        .feature-card .icon.green { background: linear-gradient(135deg,#dcfce7,#bbf7d0); color: var(--success); }
        .feature-card .icon.purple { background: linear-gradient(135deg,#ede9fe,#ddd6fe); color: #7c3aed; }
        .feature-card h3 { font-size: 18px; font-weight: 700; color: var(--gray-800); margin-bottom: 12px; }
        .feature-card p { font-size: 14px; color: var(--gray-500); line-height: 1.7; }

        /* 响应式：小屏卡片竖排 */
        @media (max-width: 900px) {
            .home-features { flex-direction: column; margin-top: -30px; padding-bottom: 40px; }
            .home-hero h1 { font-size: 28px; }
            .home-hero p { font-size: 15px; }
        }
    </style>
</head>
<body class="page-wrapper">

<%@ include file="/common/header.jsp" %>

<!-- 主视觉区（全宽） -->
<section class="home-hero">
    <h1><i class="fas fa-pills"></i> 在线药品收费管理系统</h1>
    <p>安全 · 便捷 · 高效的药品管理与交易平台</p>
    <a href="<%=ctx%>/MedicineListServlet" class="btn-hero">
        <i class="fas fa-search"></i> 浏览药品
    </a>
</section>

<!-- 特色功能区（浮动卡片） -->
<div class="home-features">
    <div class="feature-card">
        <div class="icon blue"><i class="fas fa-capsules"></i></div>
        <h3>药品浏览</h3>
        <p>按分类浏览药品，支持模糊搜索，快速找到所需药品</p>
    </div>
    <div class="feature-card">
        <div class="icon green"><i class="fas fa-cart-shopping"></i></div>
        <h3>在线交易</h3>
        <p>加入购物车，一键下单，订单状态实时追踪</p>
    </div>
    <div class="feature-card">
        <div class="icon purple"><i class="fas fa-shield-halved"></i></div>
        <h3>权限管理</h3>
        <p>管理员后台全面管控，药品维护、订单处理、用户管理</p>
    </div>
</div>

<%@ include file="/common/footer.jsp" %>

</body>
</html>

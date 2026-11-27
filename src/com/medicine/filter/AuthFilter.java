package com.medicine.filter;

import com.medicine.model.User;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * 登录验证过滤器
 * 拦截需要登录才能访问的路径: /cart/*, /order/*, /admin/*
 */
@WebFilter("/*")
public class AuthFilter implements Filter {

    // 不需要登录就能访问的路径
    private static final String[] PUBLIC_PATHS = {
        "/", "/index.jsp",
        "/login.jsp", "/register.jsp",
        "/bg-dark.jpg", "/bg-light.jpg",  // 如果有背景图
        "/css/",
        "/error/",
        "/medicine/",   // 药品浏览不需要登录
        "/LoginServlet",
        "/RegisterServlet",
        "/MedicineListServlet",
        "/MedicineDetailServlet",
        "/CategoryServlet"
    };

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        String path = req.getRequestURI().substring(req.getContextPath().length());

        // 检查是否为公开路径
        if (isPublicPath(path)) {
            chain.doFilter(request, response);
            return;
        }

        // 检查静态资源
        if (path.startsWith("/css/") || path.startsWith("/js/") || path.startsWith("/images/")) {
            chain.doFilter(request, response);
            return;
        }

        // 未登录则跳转登录页
        if (session == null || session.getAttribute("user") == null) {
            req.getSession().setAttribute("error", "请先登录后再进行操作");
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        chain.doFilter(request, response);
    }

    private boolean isPublicPath(String path) {
        for (String publicPath : PUBLIC_PATHS) {
            if (path.startsWith(publicPath) || path.equals(publicPath)) {
                return true;
            }
        }
        return false;
    }

    @Override
    public void destroy() {
    }
}

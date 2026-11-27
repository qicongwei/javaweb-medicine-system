package com.medicine.filter;

import com.medicine.dao.CartDAO;
import com.medicine.model.User;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * 购物车数量过滤器 - 统一设置 cartCount 供 header.jsp 使用
 */
@WebFilter("/*")
public class CartFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        // 设置购物车数量
        User user = (User) req.getSession().getAttribute("user");
        if (user != null) {
            int cartCount = new CartDAO().getCountByUser(user.getId());
            req.setAttribute("cartCount", cartCount);
        } else {
            req.setAttribute("cartCount", 0);
        }

        chain.doFilter(request, response);
    }
}

package com.medicine.controller;

import com.medicine.dao.UserDAO;
import com.medicine.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * 用户登录控制器
 */
@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");

        UserDAO userDAO = new UserDAO();
        User user = userDAO.login(username, password);

        if (user != null) {
            HttpSession session = req.getSession();
            session.setAttribute("user", user);

            // 根据角色跳转
            if ("admin".equals(user.getRole())) {
                resp.sendRedirect(req.getContextPath() + "/admin/index.jsp");
            } else {
                resp.sendRedirect(req.getContextPath() + "/index.jsp");
            }
        } else {
            req.setAttribute("error", "用户名或密码错误！");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
        }
    }
}

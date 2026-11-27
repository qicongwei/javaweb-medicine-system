package com.medicine.controller;

import com.medicine.dao.UserDAO;
import com.medicine.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * 用户注册控制器
 */
@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String confirmPassword = req.getParameter("repassword");
        String realname = req.getParameter("realname");
        String phone = req.getParameter("phone");
        String address = req.getParameter("address");

        // 表单验证
        if (username == null || username.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            req.setAttribute("error", "用户名和密码不能为空！");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }

        if (!password.equals(confirmPassword)) {
            req.setAttribute("error", "两次输入的密码不一致！");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }

        UserDAO userDAO = new UserDAO();
        if (userDAO.isUsernameExist(username)) {
            req.setAttribute("error", "用户名已存在，请更换！");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }

        User user = new User(username, password, realname, phone, address, "user");
        if (userDAO.register(user)) {
            req.setAttribute("success", "注册成功，请登录！");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
        } else {
            req.setAttribute("error", "注册失败，请重试！");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
        }
    }
}

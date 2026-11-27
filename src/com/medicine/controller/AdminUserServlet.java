package com.medicine.controller;

import com.medicine.dao.UserDAO;
import com.medicine.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * 管理员用户管理控制器
 */
@WebServlet("/admin/AdminUserServlet")
public class AdminUserServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        UserDAO userDAO = new UserDAO();

        if ("delete".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            User user = userDAO.findById(id);
            if (user != null && !"admin".equals(user.getUsername())) {
                userDAO.delete(id);
            }
            resp.sendRedirect(req.getContextPath() + "/admin/AdminUserServlet");
        } else if ("add".equals(action)) {
            // 添加用户页面
            req.getRequestDispatcher("/admin/user_add.jsp").forward(req, resp);
        } else if ("edit".equals(action)) {
            // 编辑用户页面
            int id = Integer.parseInt(req.getParameter("id"));
            User editUser = userDAO.findById(id);
            req.setAttribute("editUser", editUser);
            req.getRequestDispatcher("/admin/user_edit.jsp").forward(req, resp);
        } else {
            // 用户列表
            List<User> users = userDAO.findAll();
            req.setAttribute("users", users);
            req.getRequestDispatcher("/admin/user_list.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        UserDAO userDAO = new UserDAO();

        if ("add".equals(action)) {
            // 管理员添加用户
            String username = req.getParameter("username");
            if (userDAO.isUsernameExist(username)) {
                req.setAttribute("error", "用户名已存在！");
                req.getRequestDispatcher("/admin/user_add.jsp").forward(req, resp);
                return;
            }
            User user = new User();
            user.setUsername(username);
            user.setPassword(req.getParameter("password"));
            user.setRealname(req.getParameter("realname"));
            user.setPhone(req.getParameter("phone"));
            user.setAddress(req.getParameter("address"));
            user.setRole(req.getParameter("role"));
            if (userDAO.addByAdmin(user)) {
                resp.sendRedirect(req.getContextPath() + "/admin/AdminUserServlet");
            } else {
                req.setAttribute("error", "添加用户失败！");
                req.getRequestDispatcher("/admin/user_add.jsp").forward(req, resp);
            }
        } else if ("update".equals(action)) {
            // 管理员修改用户信息
            int id = Integer.parseInt(req.getParameter("id"));
            User user = userDAO.findById(id);
            if (user != null) {
                user.setRealname(req.getParameter("realname"));
                user.setPhone(req.getParameter("phone"));
                user.setAddress(req.getParameter("address"));
                user.setRole(req.getParameter("role"));
                userDAO.updateByAdmin(user);
                // 如果修改了密码
                String newPassword = req.getParameter("password");
                if (newPassword != null && !newPassword.trim().isEmpty()) {
                    userDAO.resetPassword(id, newPassword.trim());
                }
            }
            resp.sendRedirect(req.getContextPath() + "/admin/AdminUserServlet");
        }
    }
}

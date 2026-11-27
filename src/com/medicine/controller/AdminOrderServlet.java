package com.medicine.controller;

import com.medicine.dao.OrderDAO;
import com.medicine.model.Order;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * 管理员订单管理控制器
 */
@WebServlet("/admin/AdminOrderServlet")
public class AdminOrderServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        OrderDAO orderDAO = new OrderDAO();

        if ("view".equals(action)) {
            int orderId = Integer.parseInt(req.getParameter("id"));
            Order order = orderDAO.findById(orderId);
            req.setAttribute("order", order);
            req.getRequestDispatcher("/admin/order_detail.jsp").forward(req, resp);
        } else if ("complete".equals(action)) {
            int orderId = Integer.parseInt(req.getParameter("id"));
            orderDAO.updateStatus(orderId, "completed");
            resp.sendRedirect(req.getContextPath() + "/admin/AdminOrderServlet");
        } else if ("cancel".equals(action)) {
            int orderId = Integer.parseInt(req.getParameter("id"));
            orderDAO.updateStatus(orderId, "cancelled");
            resp.sendRedirect(req.getContextPath() + "/admin/AdminOrderServlet");
        } else if ("delete".equals(action)) {
            int orderId = Integer.parseInt(req.getParameter("id"));
            orderDAO.delete(orderId);
            resp.sendRedirect(req.getContextPath() + "/admin/AdminOrderServlet");
        } else {
            List<Order> orders = orderDAO.findAll();
            req.setAttribute("orders", orders);
            req.getRequestDispatcher("/admin/order_list.jsp").forward(req, resp);
        }
    }
}

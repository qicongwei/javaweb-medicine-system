package com.medicine.controller;

import com.medicine.dao.CartDAO;
import com.medicine.model.CartItem;
import com.medicine.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * 购物车控制器
 */
@WebServlet("/CartServlet")
public class CartServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");

        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        CartDAO cartDAO = new CartDAO();

        if ("delete".equals(action)) {
            // 删除购物车项
            int cartId = Integer.parseInt(req.getParameter("id"));
            cartDAO.delete(cartId);
            resp.sendRedirect(req.getContextPath() + "/CartServlet");
            return;
        }

        // 显示购物车列表
        List<CartItem> cartItems = cartDAO.findByUser(user.getId());
        double totalAmount = 0;
        for (CartItem item : cartItems) {
            totalAmount += item.getSubtotal();
        }

        req.setAttribute("cartItems", cartItems);
        req.setAttribute("totalAmount", totalAmount);
        req.getRequestDispatcher("/cart/list.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String action = req.getParameter("action");
        CartDAO cartDAO = new CartDAO();

        if ("add".equals(action)) {
            // 添加到购物车
            int medicineId = Integer.parseInt(req.getParameter("medicineId"));
            int quantity = 1;
            try { quantity = Integer.parseInt(req.getParameter("quantity")); } catch (Exception e) {}
            if (quantity < 1) quantity = 1;

            cartDAO.add(user.getId(), medicineId, quantity);

            // 返回药品列表页
            String referer = req.getParameter("referer");
            if (referer != null && !referer.isEmpty()) {
                resp.sendRedirect(referer);
            } else {
                resp.sendRedirect(req.getContextPath() + "/MedicineListServlet");
            }
        } else if ("update".equals(action)) {
            // 更新购物车数量
            int cartId = Integer.parseInt(req.getParameter("id"));
            int quantity = Integer.parseInt(req.getParameter("quantity"));
            cartDAO.updateQuantity(cartId, quantity);
            resp.sendRedirect(req.getContextPath() + "/CartServlet");
        }
    }
}

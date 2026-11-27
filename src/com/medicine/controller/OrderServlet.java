package com.medicine.controller;

import com.medicine.dao.CartDAO;
import com.medicine.dao.MedicineDAO;
import com.medicine.dao.OrderDAO;
import com.medicine.model.CartItem;
import com.medicine.model.Medicine;
import com.medicine.model.Order;
import com.medicine.model.OrderItem;
import com.medicine.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * 订单控制器
 */
@WebServlet("/OrderServlet")
public class OrderServlet extends HttpServlet {

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

        OrderDAO orderDAO = new OrderDAO();

        if ("view".equals(action)) {
            // 查看订单详情
            int orderId = Integer.parseInt(req.getParameter("id"));
            Order order = orderDAO.findById(orderId);
            if (order != null && order.getUserId() == user.getId()) {
                req.setAttribute("order", order);
                req.getRequestDispatcher("/order/detail.jsp").forward(req, resp);
            } else {
                resp.sendRedirect(req.getContextPath() + "/OrderServlet");
            }
        } else if ("checkout".equals(action)) {
            // 结算页 - 加载购物车数据
            CartDAO cartDAO = new CartDAO();
            List<CartItem> cartItems = cartDAO.findByUser(user.getId());
            double totalAmount = 0;
            for (CartItem item : cartItems) {
                totalAmount += item.getSubtotal();
            }
            req.setAttribute("cartItems", cartItems);
            req.setAttribute("totalAmount", totalAmount);
            req.getRequestDispatcher("/order/checkout.jsp").forward(req, resp);
        } else if ("pay".equals(action)) {
            // 模拟付款
            int orderId = Integer.parseInt(req.getParameter("id"));
            Order order = orderDAO.findById(orderId);
            if (order != null && order.getUserId() == user.getId() && "pending".equals(order.getStatus())) {
                orderDAO.updateStatus(orderId, "paid");
            }
            resp.sendRedirect(req.getContextPath() + "/OrderServlet");
        } else if ("cancel".equals(action)) {
            // 取消订单（pending 或 paid 状态均可取消，paid 需退库存）
            int orderId = Integer.parseInt(req.getParameter("id"));
            Order order = orderDAO.findById(orderId);
            if (order != null && order.getUserId() == user.getId()
                    && ("pending".equals(order.getStatus()) || "paid".equals(order.getStatus()))) {
                orderDAO.updateStatus(orderId, "cancelled");
            }
            resp.sendRedirect(req.getContextPath() + "/OrderServlet");
        } else {
            // 显示用户订单列表
            List<Order> orders = orderDAO.findByUser(user.getId());
            req.setAttribute("orders", orders);
            req.getRequestDispatcher("/order/list.jsp").forward(req, resp);
        }
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

        if ("create".equals(action)) {
            // 从购物车创建订单
            CartDAO cartDAO = new CartDAO();
            List<CartItem> cartItems = cartDAO.findByUser(user.getId());

            if (cartItems.isEmpty()) {
                resp.getWriter().write("<script>alert('购物车为空，无法下单！');location.href='"
                    + req.getContextPath() + "/CartServlet';</script>");
                return;
            }

            // 生成订单
            Order order = new Order();
            order.setOrderNo(OrderDAO.generateOrderNo());
            order.setUserId(user.getId());

            double totalAmount = 0;
            for (CartItem cartItem : cartItems) {
                OrderItem oi = new OrderItem();
                oi.setMedicineId(cartItem.getMedicineId());
                oi.setMedicineName(cartItem.getMedicineName());
                oi.setQuantity(cartItem.getQuantity());
                oi.setPrice(cartItem.getMedicinePrice());
                order.getItems().add(oi);
                totalAmount += oi.getSubtotal();
            }
            order.setTotalAmount(totalAmount);

            // 收货信息
            order.setReceiverName(req.getParameter("receiverName") != null ? req.getParameter("receiverName") : user.getRealname());
            order.setReceiverPhone(req.getParameter("receiverPhone") != null ? req.getParameter("receiverPhone") : user.getPhone());
            order.setReceiverAddress(req.getParameter("receiverAddress") != null ? req.getParameter("receiverAddress") : user.getAddress());

            OrderDAO orderDAO = new OrderDAO();
            if (orderDAO.createOrder(order)) {
                resp.getWriter().write("<script>alert('下单成功！请及时付款。');location.href='"
                    + req.getContextPath() + "/OrderServlet';</script>");
            } else {
                resp.getWriter().write("<script>alert('下单失败，可能库存不足！');location.href='"
                    + req.getContextPath() + "/CartServlet';</script>");
            }
        } else if ("directOrder".equals(action)) {
            // 直接下单（不经过购物车）
            int medicineId = Integer.parseInt(req.getParameter("medicineId"));
            int quantity = 1;
            try { quantity = Integer.parseInt(req.getParameter("quantity")); } catch (Exception e) {}
            if (quantity < 1) quantity = 1;

            MedicineDAO medicineDAO = new MedicineDAO();
            Medicine medicine = medicineDAO.findById(medicineId);

            if (medicine == null) {
                resp.getWriter().write("<script>alert('药品不存在！');history.back();</script>");
                return;
            }
            if (medicine.getStock() < quantity) {
                resp.getWriter().write("<script>alert('库存不足！当前库存：" + medicine.getStock() + "');history.back();</script>");
                return;
            }

            // 构建订单
            Order order = new Order();
            order.setOrderNo(OrderDAO.generateOrderNo());
            order.setUserId(user.getId());

            OrderItem oi = new OrderItem();
            oi.setMedicineId(medicine.getId());
            oi.setMedicineName(medicine.getName());
            oi.setQuantity(quantity);
            oi.setPrice(medicine.getPrice());
            order.getItems().add(oi);
            order.setTotalAmount(medicine.getPrice() * quantity);

            // 收货信息
            order.setReceiverName(req.getParameter("receiverName") != null && !req.getParameter("receiverName").isEmpty() ? req.getParameter("receiverName") : user.getRealname());
            order.setReceiverPhone(req.getParameter("receiverPhone") != null && !req.getParameter("receiverPhone").isEmpty() ? req.getParameter("receiverPhone") : user.getPhone());
            order.setReceiverAddress(req.getParameter("receiverAddress") != null && !req.getParameter("receiverAddress").isEmpty() ? req.getParameter("receiverAddress") : user.getAddress());

            OrderDAO orderDAO = new OrderDAO();
            if (orderDAO.createDirectOrder(order)) {
                resp.getWriter().write("<script>alert('直接下单成功！订单号：" + order.getOrderNo() + "');location.href='"
                    + req.getContextPath() + "/OrderServlet';</script>");
            } else {
                resp.getWriter().write("<script>alert('下单失败，可能库存不足！');history.back();</script>");
            }
        }
    }
}

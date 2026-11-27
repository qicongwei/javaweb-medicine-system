package com.medicine.controller;

import com.medicine.dao.OrderDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * 管理员销售统计控制器
 */
@WebServlet("/admin/AdminSalesServlet")
public class AdminSalesServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        OrderDAO orderDAO = new OrderDAO();

        req.setAttribute("totalSales", orderDAO.getTotalSales());
        req.setAttribute("todaySales", orderDAO.getTodaySales());
        req.setAttribute("totalOrders", orderDAO.getTotalCount());
        req.setAttribute("todayOrders", orderDAO.getTodayCount());

        List<Object[]> salesByMedicine = orderDAO.getSalesByMedicine();
        req.setAttribute("salesByMedicine", salesByMedicine);

        req.getRequestDispatcher("/admin/sales.jsp").forward(req, resp);
    }
}

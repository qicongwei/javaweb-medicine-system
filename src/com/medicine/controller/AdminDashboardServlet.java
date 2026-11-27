package com.medicine.controller;

import com.medicine.dao.MedicineDAO;
import com.medicine.dao.CategoryDAO;
import com.medicine.dao.OrderDAO;
import com.medicine.dao.UserDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * 管理员后台首页控制器 - 显示统计数据
 */
@WebServlet("/admin/AdminDashboardServlet")
public class AdminDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        UserDAO userDAO = new UserDAO();
        MedicineDAO medicineDAO = new MedicineDAO();
        OrderDAO orderDAO = new OrderDAO();

        req.setAttribute("totalUsers", userDAO.getTotalCount());
        req.setAttribute("totalMedicines", medicineDAO.getTotalCount());
        req.setAttribute("totalOrders", orderDAO.getTotalCount());
        req.setAttribute("todayOrders", orderDAO.getTodayCount());
        req.setAttribute("todaySales", orderDAO.getTodaySales());
        req.setAttribute("totalSales", orderDAO.getTotalSales());

        req.getRequestDispatcher("/admin/dashboard.jsp").forward(req, resp);
    }
}

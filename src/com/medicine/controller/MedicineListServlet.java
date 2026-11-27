package com.medicine.controller;

import com.medicine.dao.CartDAO;
import com.medicine.dao.CategoryDAO;
import com.medicine.dao.MedicineDAO;
import com.medicine.model.Category;
import com.medicine.model.Medicine;
import com.medicine.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * 药品列表控制器（支持分类筛选和搜索）
 */
@WebServlet("/MedicineListServlet")
public class MedicineListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        int page = 1;
        int pageSize = 12;
        try { page = Integer.parseInt(req.getParameter("page")); } catch (Exception e) {}

        String keyword = req.getParameter("keyword");
        String categoryIdStr = req.getParameter("categoryId");

        MedicineDAO medicineDAO = new MedicineDAO();
        CategoryDAO categoryDAO = new CategoryDAO();

        List<Medicine> medicines;
        int totalCount;

        String action = req.getParameter("action");

        if (keyword != null && !keyword.trim().isEmpty()) {
            // 搜索模式 - 跳转到搜索结果页
            medicines = medicineDAO.search(keyword.trim(), page, pageSize);
            totalCount = medicineDAO.getSearchCount(keyword.trim());
            req.setAttribute("keyword", keyword.trim());
        } else if ("search".equals(action) && (keyword == null || keyword.trim().isEmpty())) {
            // 搜索入口但无关键词 - 显示搜索页
            req.getRequestDispatcher("/medicine/search.jsp").forward(req, resp);
            return;
        } else if (categoryIdStr != null && !categoryIdStr.isEmpty()) {
            // 分类筛选模式
            int categoryId = Integer.parseInt(categoryIdStr);
            medicines = medicineDAO.findByCategory(categoryId, page, pageSize);
            totalCount = medicineDAO.getCountByCategory(categoryId);
            req.setAttribute("currentCategoryId", categoryId);
        } else {
            // 全部药品
            medicines = medicineDAO.findAll(page, pageSize);
            totalCount = medicineDAO.getTotalCount();
        }

        // 获取全部分类（侧边栏用）
        List<Category> categories = categoryDAO.findAll();

        int totalPages = (int) Math.ceil((double) totalCount / pageSize);

        req.setAttribute("medicines", medicines);
        req.setAttribute("categories", categories);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("totalCount", totalCount);

        // 设置购物车数量（供 header.jsp 使用）
        User user = (User) req.getSession().getAttribute("user");
        if (user != null) {
            int cartCount = new CartDAO().getCountByUser(user.getId());
            req.setAttribute("cartCount", cartCount);
        }

        // 搜索结果跳转到搜索页，其他跳转到列表页
        if (keyword != null && !keyword.trim().isEmpty()) {
            req.getRequestDispatcher("/medicine/search.jsp").forward(req, resp);
        } else {
            req.getRequestDispatcher("/medicine/list.jsp").forward(req, resp);
        }
    }
}

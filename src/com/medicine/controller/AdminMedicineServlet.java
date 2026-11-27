package com.medicine.controller;

import com.medicine.dao.MedicineDAO;
import com.medicine.dao.CategoryDAO;
import com.medicine.model.Medicine;
import com.medicine.model.Category;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * 管理员药品管理控制器（增删改查）
 */
@WebServlet("/admin/AdminMedicineServlet")
public class AdminMedicineServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        MedicineDAO medicineDAO = new MedicineDAO();
        CategoryDAO categoryDAO = new CategoryDAO();

        if ("edit".equals(action)) {
            // 编辑药品页面
            int id = Integer.parseInt(req.getParameter("id"));
            Medicine medicine = medicineDAO.findById(id);
            List<Category> categories = categoryDAO.findAll();
            req.setAttribute("medicine", medicine);
            req.setAttribute("categories", categories);
            req.getRequestDispatcher("/admin/medicine_edit.jsp").forward(req, resp);
        } else if ("add".equals(action)) {
            // 添加药品页面
            List<Category> categories = categoryDAO.findAll();
            req.setAttribute("categories", categories);
            req.getRequestDispatcher("/admin/medicine_add.jsp").forward(req, resp);
        } else if ("delete".equals(action)) {
            // 删除药品
            int id = Integer.parseInt(req.getParameter("id"));
            medicineDAO.delete(id);
            resp.sendRedirect(req.getContextPath() + "/admin/AdminMedicineServlet");
        } else {
            // 药品列表
            int page = 1;
            try { page = Integer.parseInt(req.getParameter("page")); } catch (Exception e) {}
            int pageSize = 10;

            List<Medicine> medicines = medicineDAO.findAll(page, pageSize);
            int totalCount = medicineDAO.getTotalCount();
            int totalPages = (int) Math.ceil((double) totalCount / pageSize);

            req.setAttribute("medicines", medicines);
            req.setAttribute("currentPage", page);
            req.setAttribute("totalPages", totalPages);
            req.setAttribute("totalCount", totalCount);
            req.getRequestDispatcher("/admin/medicine_list.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        MedicineDAO medicineDAO = new MedicineDAO();

        Medicine medicine = new Medicine();
        // 如果是编辑模式，需要设置ID
        String idStr = req.getParameter("id");
        if (idStr != null && !idStr.isEmpty()) {
            medicine.setId(Integer.parseInt(idStr));
        }
        medicine.setName(req.getParameter("name"));
        medicine.setCategoryId(Integer.parseInt(req.getParameter("categoryId")));
        medicine.setPrice(Double.parseDouble(req.getParameter("price")));
        medicine.setStock(Integer.parseInt(req.getParameter("stock")));
        medicine.setSpecification(req.getParameter("specification"));
        medicine.setManufacturer(req.getParameter("manufacturer"));
        medicine.setDescription(req.getParameter("description"));
        medicine.setIsPrescription(Integer.parseInt(req.getParameter("is_prescription")));

        if ("update".equals(action)) {
            medicineDAO.update(medicine);
        } else if ("add".equals(action)) {
            medicineDAO.add(medicine);
        }

        resp.sendRedirect(req.getContextPath() + "/admin/AdminMedicineServlet");
    }
}

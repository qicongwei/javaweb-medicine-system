package com.medicine.controller;

import com.medicine.dao.MedicineDAO;
import com.medicine.model.Medicine;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * 药品详情控制器
 */
@WebServlet("/MedicineDetailServlet")
public class MedicineDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            MedicineDAO medicineDAO = new MedicineDAO();
            Medicine medicine = medicineDAO.findById(id);

            if (medicine != null) {
                req.setAttribute("medicine", medicine);
                req.getRequestDispatcher("/medicine/detail.jsp").forward(req, resp);
            } else {
                resp.sendRedirect(req.getContextPath() + "/medicine/list.jsp");
            }
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/medicine/list.jsp");
        }
    }
}

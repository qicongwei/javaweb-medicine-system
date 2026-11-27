package com.medicine.dao;

import com.medicine.model.CartItem;
import com.medicine.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * 购物车数据访问层
 */
public class CartDAO {

    /**
     * 添加到购物车（如果已存在则增加数量）
     */
    public boolean add(int userId, int medicineId, int quantity) {
        // 先检查是否已存在
        CartItem exist = findByUserAndMedicine(userId, medicineId);
        if (exist != null) {
            return updateQuantity(exist.getId(), exist.getQuantity() + quantity);
        }
        String sql = "INSERT INTO cart_items(user_id, medicine_id, quantity) VALUES(?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            pstmt.setInt(2, medicineId);
            pstmt.setInt(3, quantity);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 获取用户购物车列表（关联药品信息）
     */
    public List<CartItem> findByUser(int userId) {
        List<CartItem> list = new ArrayList<>();
        String sql = "SELECT ci.*, m.name AS medicine_name, m.price AS medicine_price, " +
                     "m.specification AS medicine_spec, m.stock AS medicine_stock, " +
                     "m.is_prescription AS medicine_is_prescription " +
                     "FROM cart_items ci JOIN medicines m ON ci.medicine_id = m.id " +
                     "WHERE ci.user_id = ? ORDER BY ci.id DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                CartItem item = new CartItem();
                item.setId(rs.getInt("id"));
                item.setUserId(rs.getInt("user_id"));
                item.setMedicineId(rs.getInt("medicine_id"));
                item.setMedicineName(rs.getString("medicine_name"));
                item.setMedicinePrice(rs.getDouble("medicine_price"));
                item.setMedicineSpec(rs.getString("medicine_spec"));
                item.setQuantity(rs.getInt("quantity"));
                item.setMedicineStock(rs.getInt("medicine_stock"));
                item.setMedicineIsPrescription(rs.getInt("medicine_is_prescription"));
                list.add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * 获取用户购物车商品数量
     */
    public int getCountByUser(int userId) {
        String sql = "SELECT SUM(quantity) FROM cart_items WHERE user_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                int count = rs.getInt(1);
                return rs.wasNull() ? 0 : count;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * 更新购物车项数量
     */
    public boolean updateQuantity(int cartId, int quantity) {
        if (quantity <= 0) {
            return delete(cartId);
        }
        String sql = "UPDATE cart_items SET quantity = ? WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, quantity);
            pstmt.setInt(2, cartId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 删除购物车项
     */
    public boolean delete(int cartId) {
        String sql = "DELETE FROM cart_items WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, cartId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 清空用户购物车
     */
    public boolean clearByUser(int userId) {
        String sql = "DELETE FROM cart_items WHERE user_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            pstmt.executeUpdate();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private CartItem findByUserAndMedicine(int userId, int medicineId) {
        String sql = "SELECT * FROM cart_items WHERE user_id = ? AND medicine_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            pstmt.setInt(2, medicineId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                CartItem item = new CartItem();
                item.setId(rs.getInt("id"));
                item.setUserId(rs.getInt("user_id"));
                item.setMedicineId(rs.getInt("medicine_id"));
                item.setQuantity(rs.getInt("quantity"));
                return item;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}

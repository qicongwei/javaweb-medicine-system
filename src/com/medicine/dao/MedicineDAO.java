package com.medicine.dao;

import com.medicine.model.Medicine;
import com.medicine.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * 药品数据访问层
 */
public class MedicineDAO {

    /**
     * 获取所有药品（分页，关联分类名）
     */
    public List<Medicine> findAll(int page, int pageSize) {
        List<Medicine> list = new ArrayList<>();
        String sql = "SELECT m.*, c.name AS category_name FROM medicines m " +
                     "LEFT JOIN categories c ON m.category_id = c.id " +
                     "ORDER BY m.id DESC LIMIT ?, ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, (page - 1) * pageSize);
            pstmt.setInt(2, pageSize);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                list.add(extractMedicine(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * 获取药品总数
     */
    public int getTotalCount() {
        String sql = "SELECT COUNT(*) FROM medicines";
        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * 根据分类筛选药品
     */
    public List<Medicine> findByCategory(int categoryId, int page, int pageSize) {
        List<Medicine> list = new ArrayList<>();
        String sql = "SELECT m.*, c.name AS category_name FROM medicines m " +
                     "LEFT JOIN categories c ON m.category_id = c.id " +
                     "WHERE m.category_id = ? ORDER BY m.id DESC LIMIT ?, ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, categoryId);
            pstmt.setInt(2, (page - 1) * pageSize);
            pstmt.setInt(3, pageSize);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                list.add(extractMedicine(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * 按分类统计药品数量
     */
    public int getCountByCategory(int categoryId) {
        String sql = "SELECT COUNT(*) FROM medicines WHERE category_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, categoryId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * 关键词搜索药品
     */
    public List<Medicine> search(String keyword, int page, int pageSize) {
        List<Medicine> list = new ArrayList<>();
        String sql = "SELECT m.*, c.name AS category_name FROM medicines m " +
                     "LEFT JOIN categories c ON m.category_id = c.id " +
                     "WHERE m.name LIKE ? OR m.manufacturer LIKE ? OR m.description LIKE ? " +
                     "ORDER BY m.id DESC LIMIT ?, ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            String like = "%" + keyword + "%";
            pstmt.setString(1, like);
            pstmt.setString(2, like);
            pstmt.setString(3, like);
            pstmt.setInt(4, (page - 1) * pageSize);
            pstmt.setInt(5, pageSize);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                list.add(extractMedicine(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * 搜索结果总数
     */
    public int getSearchCount(String keyword) {
        String sql = "SELECT COUNT(*) FROM medicines WHERE name LIKE ? OR manufacturer LIKE ? OR description LIKE ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            String like = "%" + keyword + "%";
            pstmt.setString(1, like);
            pstmt.setString(2, like);
            pstmt.setString(3, like);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * 根据ID查找药品
     */
    public Medicine findById(int id) {
        String sql = "SELECT m.*, c.name AS category_name FROM medicines m " +
                     "LEFT JOIN categories c ON m.category_id = c.id WHERE m.id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return extractMedicine(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * 添加药品
     */
    public boolean add(Medicine medicine) {
        String sql = "INSERT INTO medicines(name, category_id, price, stock, specification, manufacturer, description, is_prescription) " +
                     "VALUES(?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, medicine.getName());
            pstmt.setInt(2, medicine.getCategoryId());
            pstmt.setDouble(3, medicine.getPrice());
            pstmt.setInt(4, medicine.getStock());
            pstmt.setString(5, medicine.getSpecification());
            pstmt.setString(6, medicine.getManufacturer());
            pstmt.setString(7, medicine.getDescription());
            pstmt.setInt(8, medicine.getIsPrescription());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 更新药品
     */
    public boolean update(Medicine medicine) {
        String sql = "UPDATE medicines SET name=?, category_id=?, price=?, stock=?, specification=?, " +
                     "manufacturer=?, description=?, is_prescription=? WHERE id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, medicine.getName());
            pstmt.setInt(2, medicine.getCategoryId());
            pstmt.setDouble(3, medicine.getPrice());
            pstmt.setInt(4, medicine.getStock());
            pstmt.setString(5, medicine.getSpecification());
            pstmt.setString(6, medicine.getManufacturer());
            pstmt.setString(7, medicine.getDescription());
            pstmt.setInt(8, medicine.getIsPrescription());
            pstmt.setInt(9, medicine.getId());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 删除药品
     */
    public boolean delete(int id) {
        String sql = "DELETE FROM medicines WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 更新库存（下单减库存）
     */
    public boolean updateStock(int id, int quantity) {
        String sql = "UPDATE medicines SET stock = stock - ? WHERE id = ? AND stock >= ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, quantity);
            pstmt.setInt(2, id);
            pstmt.setInt(3, quantity);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 恢复库存（取消订单时）
     */
    public boolean restoreStock(int id, int quantity) {
        String sql = "UPDATE medicines SET stock = stock + ? WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, quantity);
            pstmt.setInt(2, id);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private Medicine extractMedicine(ResultSet rs) throws SQLException {
        Medicine m = new Medicine();
        m.setId(rs.getInt("id"));
        m.setName(rs.getString("name"));
        m.setCategoryId(rs.getInt("category_id"));
        try { m.setCategoryName(rs.getString("category_name")); } catch (SQLException e) { m.setCategoryName("未分类"); }
        m.setPrice(rs.getDouble("price"));
        m.setStock(rs.getInt("stock"));
        m.setSpecification(rs.getString("specification"));
        m.setManufacturer(rs.getString("manufacturer"));
        m.setDescription(rs.getString("description"));
        m.setIsPrescription(rs.getInt("is_prescription"));
        m.setCreateTime(rs.getString("create_time"));
        return m;
    }
}

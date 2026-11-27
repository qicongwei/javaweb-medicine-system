package com.medicine.dao;

import com.medicine.model.Order;
import com.medicine.model.OrderItem;
import com.medicine.util.DBUtil;

import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * 订单数据访问层
 */
public class OrderDAO {

    /**
     * 创建订单（事务处理：插入订单 + 订单明细 + 减库存 + 清空购物车）
     */
    public boolean createOrder(Order order) {
        Connection conn = null;
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false); // 开启事务

            // 1. 插入订单
            String orderSql = "INSERT INTO orders(order_no, user_id, total_amount, status, receiver_name, receiver_phone, receiver_address) " +
                              "VALUES(?, ?, ?, 'pending', ?, ?, ?)";
            PreparedStatement orderPstmt = conn.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS);
            orderPstmt.setString(1, order.getOrderNo());
            orderPstmt.setInt(2, order.getUserId());
            orderPstmt.setDouble(3, order.getTotalAmount());
            orderPstmt.setString(4, order.getReceiverName());
            orderPstmt.setString(5, order.getReceiverPhone());
            orderPstmt.setString(6, order.getReceiverAddress());
            orderPstmt.executeUpdate();

            ResultSet rs = orderPstmt.getGeneratedKeys();
            if (!rs.next()) {
                conn.rollback();
                return false;
            }
            int orderId = rs.getInt(1);

            // 2. 插入订单明细 + 减库存
            String itemSql = "INSERT INTO order_items(order_id, medicine_id, medicine_name, quantity, price) VALUES(?, ?, ?, ?, ?)";
            String stockSql = "UPDATE medicines SET stock = stock - ? WHERE id = ? AND stock >= ?";
            PreparedStatement itemPstmt = conn.prepareStatement(itemSql);
            PreparedStatement stockPstmt = conn.prepareStatement(stockSql);

            for (OrderItem item : order.getItems()) {
                itemPstmt.setInt(1, orderId);
                itemPstmt.setInt(2, item.getMedicineId());
                itemPstmt.setString(3, item.getMedicineName());
                itemPstmt.setInt(4, item.getQuantity());
                itemPstmt.setDouble(5, item.getPrice());
                itemPstmt.addBatch();

                stockPstmt.setInt(1, item.getQuantity());
                stockPstmt.setInt(2, item.getMedicineId());
                stockPstmt.setInt(3, item.getQuantity());
                int affected = stockPstmt.executeUpdate();
                if (affected == 0) {
                    conn.rollback();
                    return false; // 库存不足
                }
            }
            itemPstmt.executeBatch();

            // 3. 清空购物车
            String clearCartSql = "DELETE FROM cart_items WHERE user_id = ?";
            PreparedStatement clearPstmt = conn.prepareStatement(clearCartSql);
            clearPstmt.setInt(1, order.getUserId());
            clearPstmt.executeUpdate();

            conn.commit();
            return true;
        } catch (SQLException e) {
            try { if (conn != null) conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            e.printStackTrace();
            return false;
        } finally {
            try { if (conn != null) { conn.setAutoCommit(true); conn.close(); } } catch (SQLException e) { e.printStackTrace(); }
        }
    }

    /**
     * 直接下单（事务处理：插入订单 + 订单明细 + 减库存，不清空购物车）
     */
    public boolean createDirectOrder(Order order) {
        Connection conn = null;
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);

            // 1. 插入订单
            String orderSql = "INSERT INTO orders(order_no, user_id, total_amount, status, receiver_name, receiver_phone, receiver_address) " +
                              "VALUES(?, ?, ?, 'pending', ?, ?, ?)";
            PreparedStatement orderPstmt = conn.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS);
            orderPstmt.setString(1, order.getOrderNo());
            orderPstmt.setInt(2, order.getUserId());
            orderPstmt.setDouble(3, order.getTotalAmount());
            orderPstmt.setString(4, order.getReceiverName());
            orderPstmt.setString(5, order.getReceiverPhone());
            orderPstmt.setString(6, order.getReceiverAddress());
            orderPstmt.executeUpdate();

            ResultSet rs = orderPstmt.getGeneratedKeys();
            if (!rs.next()) {
                conn.rollback();
                return false;
            }
            int orderId = rs.getInt(1);

            // 2. 插入订单明细 + 减库存
            String itemSql = "INSERT INTO order_items(order_id, medicine_id, medicine_name, quantity, price) VALUES(?, ?, ?, ?, ?)";
            String stockSql = "UPDATE medicines SET stock = stock - ? WHERE id = ? AND stock >= ?";
            PreparedStatement itemPstmt = conn.prepareStatement(itemSql);
            PreparedStatement stockPstmt = conn.prepareStatement(stockSql);

            for (OrderItem item : order.getItems()) {
                itemPstmt.setInt(1, orderId);
                itemPstmt.setInt(2, item.getMedicineId());
                itemPstmt.setString(3, item.getMedicineName());
                itemPstmt.setInt(4, item.getQuantity());
                itemPstmt.setDouble(5, item.getPrice());
                itemPstmt.addBatch();

                stockPstmt.setInt(1, item.getQuantity());
                stockPstmt.setInt(2, item.getMedicineId());
                stockPstmt.setInt(3, item.getQuantity());
                int affected = stockPstmt.executeUpdate();
                if (affected == 0) {
                    conn.rollback();
                    return false;
                }
            }
            itemPstmt.executeBatch();

            conn.commit();
            return true;
        } catch (SQLException e) {
            try { if (conn != null) conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            e.printStackTrace();
            return false;
        } finally {
            try { if (conn != null) { conn.setAutoCommit(true); conn.close(); } } catch (SQLException e) { e.printStackTrace(); }
        }
    }

    /**
     * 获取用户订单列表
     */
    public List<Order> findByUser(int userId) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT o.*, u.username FROM orders o JOIN users u ON o.user_id = u.id " +
                     "WHERE o.user_id = ? ORDER BY o.create_time DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Order order = extractOrder(rs);
                order.setItems(findItemsByOrder(order.getId()));
                list.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * 获取所有订单（管理员用）
     */
    public List<Order> findAll() {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT o.*, u.username FROM orders o JOIN users u ON o.user_id = u.id " +
                     "ORDER BY o.create_time DESC";
        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Order order = extractOrder(rs);
                order.setItems(findItemsByOrder(order.getId()));
                list.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * 根据ID查找订单
     */
    public Order findById(int id) {
        String sql = "SELECT o.*, u.username FROM orders o JOIN users u ON o.user_id = u.id WHERE o.id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                Order order = extractOrder(rs);
                order.setItems(findItemsByOrder(order.getId()));
                return order;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * 更新订单状态
     */
    public boolean updateStatus(int id, String status) {
        String sql;
        if ("paid".equals(status)) {
            sql = "UPDATE orders SET status = ?, pay_time = NOW() WHERE id = ?";
        } else if ("cancelled".equals(status)) {
            // 取消订单时恢复库存
            Order order = findById(id);
            if (order != null) {
                for (OrderItem item : order.getItems()) {
                    restoreStock(item.getMedicineId(), item.getQuantity());
                }
            }
            sql = "UPDATE orders SET status = ? WHERE id = ?";
        } else {
            sql = "UPDATE orders SET status = ? WHERE id = ?";
        }
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, status);
            pstmt.setInt(2, id);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 删除订单
     */
    public boolean delete(int id) {
        String sql = "DELETE FROM orders WHERE id = ?";
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
     * 获取订单总数
     */
    public int getTotalCount() {
        String sql = "SELECT COUNT(*) FROM orders";
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
     * 获取今日订单总数
     */
    public int getTodayCount() {
        String sql = "SELECT COUNT(*) FROM orders WHERE DATE(create_time) = CURDATE()";
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
     * 获取今日销售总额
     */
    public double getTodaySales() {
        String sql = "SELECT COALESCE(SUM(total_amount), 0) FROM orders WHERE DATE(create_time) = CURDATE() AND status != 'cancelled'";
        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) return rs.getDouble(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * 获取总销售额
     */
    public double getTotalSales() {
        String sql = "SELECT COALESCE(SUM(total_amount), 0) FROM orders WHERE status != 'cancelled'";
        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) return rs.getDouble(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * 获取销售统计（按药品）
     */
    public List<Object[]> getSalesByMedicine() {
        List<Object[]> list = new ArrayList<>();
        String sql = "SELECT oi.medicine_name, SUM(oi.quantity) AS total_qty, SUM(oi.price * oi.quantity) AS total_amount " +
                     "FROM order_items oi JOIN orders o ON oi.order_id = o.id " +
                     "WHERE o.status != 'cancelled' GROUP BY oi.medicine_id, oi.medicine_name " +
                     "ORDER BY total_qty DESC LIMIT 10";
        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                list.add(new Object[]{
                    rs.getString("medicine_name"),
                    rs.getInt("total_qty"),
                    rs.getDouble("total_amount")
                });
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ==================== 私有辅助方法 ====================

    private List<OrderItem> findItemsByOrder(int orderId) {
        List<OrderItem> list = new ArrayList<>();
        String sql = "SELECT * FROM order_items WHERE order_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, orderId);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                OrderItem item = new OrderItem();
                item.setId(rs.getInt("id"));
                item.setOrderId(rs.getInt("order_id"));
                item.setMedicineId(rs.getInt("medicine_id"));
                item.setMedicineName(rs.getString("medicine_name"));
                item.setQuantity(rs.getInt("quantity"));
                item.setPrice(rs.getDouble("price"));
                list.add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    private Order extractOrder(ResultSet rs) throws SQLException {
        Order order = new Order();
        order.setId(rs.getInt("id"));
        order.setOrderNo(rs.getString("order_no"));
        order.setUserId(rs.getInt("user_id"));
        try { order.setUsername(rs.getString("username")); } catch (SQLException e) {}
        order.setTotalAmount(rs.getDouble("total_amount"));
        order.setStatus(rs.getString("status"));
        order.setReceiverName(rs.getString("receiver_name"));
        order.setReceiverPhone(rs.getString("receiver_phone"));
        order.setReceiverAddress(rs.getString("receiver_address"));
        order.setCreateTime(rs.getString("create_time"));
        order.setPayTime(rs.getString("pay_time"));
        return order;
    }

    private void restoreStock(int medicineId, int quantity) {
        String sql = "UPDATE medicines SET stock = stock + ? WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, quantity);
            pstmt.setInt(2, medicineId);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /**
     * 生成订单编号
     */
    public static String generateOrderNo() {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
        String dateStr = sdf.format(new Date());
        int random = (int)(Math.random() * 9000) + 1000;
        return "MS" + dateStr + random;
    }
}

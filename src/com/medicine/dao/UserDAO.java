package com.medicine.dao;

import com.medicine.model.User;
import com.medicine.util.DBUtil;
import com.medicine.util.MD5Util;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * 用户数据访问层
 */
public class UserDAO {

    /**
     * 用户注册
     */
    public boolean register(User user) {
        String sql = "INSERT INTO users(username, password, realname, phone, address, role) VALUES(?, ?, ?, ?, ?, 'user')";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, user.getUsername());
            pstmt.setString(2, MD5Util.md5(user.getPassword()));
            pstmt.setString(3, user.getRealname());
            pstmt.setString(4, user.getPhone());
            pstmt.setString(5, user.getAddress());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 用户登录验证
     */
    public User login(String username, String password) {
        String sql = "SELECT * FROM users WHERE username = ? AND password = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, username);
            pstmt.setString(2, MD5Util.md5(password));
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return extractUser(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * 根据ID查找用户
     */
    public User findById(int id) {
        String sql = "SELECT * FROM users WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return extractUser(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * 检查用户名是否存在
     */
    public boolean isUsernameExist(String username) {
        String sql = "SELECT COUNT(*) FROM users WHERE username = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, username);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * 获取所有用户列表（管理员用）
     */
    public List<User> findAll() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM users ORDER BY create_time DESC";
        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                list.add(extractUser(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * 获取用户总数
     */
    public int getTotalCount() {
        String sql = "SELECT COUNT(*) FROM users";
        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * 删除用户
     */
    public boolean delete(int id) {
        String sql = "DELETE FROM users WHERE id = ?";
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
     * 修改用户信息
     */
    public boolean update(User user) {
        String sql = "UPDATE users SET realname=?, phone=?, address=? WHERE id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, user.getRealname());
            pstmt.setString(2, user.getPhone());
            pstmt.setString(3, user.getAddress());
            pstmt.setInt(4, user.getId());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 管理员修改用户信息（含角色）
     */
    public boolean updateByAdmin(User user) {
        String sql = "UPDATE users SET realname=?, phone=?, address=?, role=? WHERE id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, user.getRealname());
            pstmt.setString(2, user.getPhone());
            pstmt.setString(3, user.getAddress());
            pstmt.setString(4, user.getRole());
            pstmt.setInt(5, user.getId());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 管理员重置用户密码
     */
    public boolean resetPassword(int id, String newPassword) {
        String sql = "UPDATE users SET password=? WHERE id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, MD5Util.md5(newPassword));
            pstmt.setInt(2, id);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 管理员添加用户（可指定角色）
     */
    public boolean addByAdmin(User user) {
        String sql = "INSERT INTO users(username, password, realname, phone, address, role) VALUES(?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, user.getUsername());
            pstmt.setString(2, MD5Util.md5(user.getPassword()));
            pstmt.setString(3, user.getRealname());
            pstmt.setString(4, user.getPhone());
            pstmt.setString(5, user.getAddress());
            pstmt.setString(6, user.getRole());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 修改密码
     */
    public boolean updatePassword(int id, String oldPassword, String newPassword) {
        User user = findById(id);
        if (user == null || !MD5Util.verify(oldPassword, user.getPassword())) {
            return false;
        }
        String sql = "UPDATE users SET password=? WHERE id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, MD5Util.md5(newPassword));
            pstmt.setInt(2, id);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private User extractUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setId(rs.getInt("id"));
        user.setUsername(rs.getString("username"));
        user.setPassword(rs.getString("password"));
        user.setRealname(rs.getString("realname"));
        user.setPhone(rs.getString("phone"));
        user.setAddress(rs.getString("address"));
        user.setRole(rs.getString("role"));
        user.setCreateTime(rs.getString("create_time"));
        return user;
    }
}

package com.medicine.util;

import java.sql.*;

/**
 * 数据库连接工具类
 *
 * 连接参数不写死在源码里，按以下优先级读取：
 *   1. JVM 参数  -Dmedicine.db.url / -Dmedicine.db.user / -Dmedicine.db.password
 *   2. 环境变量  MEDICINE_DB_URL / MEDICINE_DB_USER / MEDICINE_DB_PASSWORD
 *   3. 下面的默认值（仅地址与用户名有默认，密码必须外部提供）
 */
public class DBUtil {
    private static final String DRIVER = "com.mysql.jdbc.Driver";
    private static final String URL = cfg(
            "medicine.db.url", "MEDICINE_DB_URL",
            "jdbc:mysql://localhost:3306/medicine_db?useUnicode=true&characterEncoding=utf-8"
                    + "&useSSL=false&serverTimezone=Asia/Shanghai&allowPublicKeyRetrieval=true");
    private static final String USER = cfg("medicine.db.user", "MEDICINE_DB_USER", "root");
    private static final String PASSWORD = cfg("medicine.db.password", "MEDICINE_DB_PASSWORD", "");

    private static String cfg(String prop, String env, String def) {
        String v = System.getProperty(prop);
        if (v == null || v.isEmpty()) {
            v = System.getenv(env);
        }
        return (v == null || v.isEmpty()) ? def : v;
    }

    static {
        try {
            Class.forName(DRIVER);
        } catch (ClassNotFoundException e) {
            System.err.println("MySQL JDBC驱动加载失败: " + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * 获取数据库连接
     */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }

    /**
     * 关闭资源
     */
    public static void close(Connection conn, Statement stmt, ResultSet rs) {
        try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (stmt != null) stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }

    /**
     * 关闭资源(无ResultSet)
     */
    public static void close(Connection conn, Statement stmt) {
        close(conn, stmt, null);
    }

    /**
     * 关闭资源(无Statement)
     */
    public static void close(Connection conn) {
        close(conn, null, null);
    }
}

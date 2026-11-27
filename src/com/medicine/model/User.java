package com.medicine.model;

/**
 * 用户实体类
 */
public class User {
    private int id;
    private String username;
    private String password;
    private String realname;
    private String phone;
    private String address;
    private String role;
    private String createTime;

    public User() {}

    public User(String username, String password, String realname, String phone, String address, String role) {
        this.username = username;
        this.password = password;
        this.realname = realname;
        this.phone = phone;
        this.address = address;
        this.role = role;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getRealname() { return realname; }
    public void setRealname(String realname) { this.realname = realname; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public String getCreateTime() { return createTime; }
    public void setCreateTime(String createTime) { this.createTime = createTime; }

    @Override
    public String toString() {
        return "User{id=" + id + ", username='" + username + "', realname='" + realname + "', role='" + role + "'}";
    }
}

package com.medicine.model;

import java.util.ArrayList;
import java.util.List;

/**
 * 订单实体类
 */
public class Order {
    private int id;
    private String orderNo;
    private int userId;
    private String username; // 关联查询字段
    private double totalAmount;
    private String status;
    private String receiverName;
    private String receiverPhone;
    private String receiverAddress;
    private String createTime;
    private String payTime;
    private List<OrderItem> items = new ArrayList<>();

    public Order() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getOrderNo() { return orderNo; }
    public void setOrderNo(String orderNo) { this.orderNo = orderNo; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getReceiverName() { return receiverName; }
    public void setReceiverName(String receiverName) { this.receiverName = receiverName; }

    public String getReceiverPhone() { return receiverPhone; }
    public void setReceiverPhone(String receiverPhone) { this.receiverPhone = receiverPhone; }

    public String getReceiverAddress() { return receiverAddress; }
    public void setReceiverAddress(String receiverAddress) { this.receiverAddress = receiverAddress; }

    public String getCreateTime() { return createTime; }
    public void setCreateTime(String createTime) { this.createTime = createTime; }

    public String getPayTime() { return payTime; }
    public void setPayTime(String payTime) { this.payTime = payTime; }

    public List<OrderItem> getItems() { return items; }
    public void setItems(List<OrderItem> items) { this.items = items; }

    /**
     * 获取状态中文名
     */
    public String getStatusName() {
        switch (status) {
            case "pending": return "待付款";
            case "paid": return "已付款";
            case "completed": return "已完成";
            case "cancelled": return "已取消";
            default: return status;
        }
    }

    @Override
    public String toString() {
        return "Order{id=" + id + ", orderNo='" + orderNo + "', amount=" + totalAmount + ", status='" + status + "'}";
    }
}

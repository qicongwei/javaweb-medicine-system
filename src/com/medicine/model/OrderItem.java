package com.medicine.model;

/**
 * 订单明细实体类
 */
public class OrderItem {
    private int id;
    private int orderId;
    private int medicineId;
    private String medicineName;
    private int quantity;
    private double price;

    public OrderItem() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }

    public int getMedicineId() { return medicineId; }
    public void setMedicineId(int medicineId) { this.medicineId = medicineId; }

    public String getMedicineName() { return medicineName; }
    public void setMedicineName(String medicineName) { this.medicineName = medicineName; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    /**
     * 小计
     */
    public double getSubtotal() {
        return price * quantity;
    }

    @Override
    public String toString() {
        return "OrderItem{id=" + id + ", medicine='" + medicineName + "', qty=" + quantity + ", price=" + price + "}";
    }
}

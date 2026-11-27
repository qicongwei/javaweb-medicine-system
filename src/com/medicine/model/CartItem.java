package com.medicine.model;

/**
 * 购物车项实体类
 */
public class CartItem {
    private int id;
    private int userId;
    private int medicineId;
    private String medicineName;
    private double medicinePrice;
    private String medicineSpec;
    private int quantity;
    private int medicineStock; // 药品库存，用于判断是否可购买
    private int medicineIsPrescription; // 是否处方药

    public CartItem() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getMedicineId() { return medicineId; }
    public void setMedicineId(int medicineId) { this.medicineId = medicineId; }

    public String getMedicineName() { return medicineName; }
    public void setMedicineName(String medicineName) { this.medicineName = medicineName; }

    public double getMedicinePrice() { return medicinePrice; }
    public void setMedicinePrice(double medicinePrice) { this.medicinePrice = medicinePrice; }

    public String getMedicineSpec() { return medicineSpec; }
    public void setMedicineSpec(String medicineSpec) { this.medicineSpec = medicineSpec; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public int getMedicineStock() { return medicineStock; }
    public void setMedicineStock(int medicineStock) { this.medicineStock = medicineStock; }

    /**
     * 计算小计金额
     */
    public double getSubtotal() {
        return medicinePrice * quantity;
    }

    public int getMedicineIsPrescription() { return medicineIsPrescription; }
    public void setMedicineIsPrescription(int medicineIsPrescription) { this.medicineIsPrescription = medicineIsPrescription; }

    @Override
    public String toString() {
        return "CartItem{id=" + id + ", medicine='" + medicineName + "', qty=" + quantity + "}";
    }
}

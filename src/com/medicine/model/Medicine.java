package com.medicine.model;

/**
 * 药品实体类
 */
public class Medicine {
    private int id;
    private String name;
    private int categoryId;
    private String categoryName; // 关联查询时的分类名称
    private double price;
    private int stock;
    private String specification;
    private String manufacturer;
    private String description;
    private int isPrescription;
    private String createTime;

    public Medicine() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }

    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public int getStock() { return stock; }
    public void setStock(int stock) { this.stock = stock; }

    public String getSpecification() { return specification; }
    public void setSpecification(String specification) { this.specification = specification; }

    public String getManufacturer() { return manufacturer; }
    public void setManufacturer(String manufacturer) { this.manufacturer = manufacturer; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public int getIsPrescription() { return isPrescription; }
    public void setIsPrescription(int isPrescription) { this.isPrescription = isPrescription; }

    public String getCreateTime() { return createTime; }
    public void setCreateTime(String createTime) { this.createTime = createTime; }

    /**
     * 获取处方药标签文本
     */
    public String getPrescriptionLabel() {
        return isPrescription == 1 ? "处方药" : "非处方药(OTC)";
    }

    @Override
    public String toString() {
        return "Medicine{id=" + id + ", name='" + name + "', price=" + price + ", stock=" + stock + "}";
    }
}

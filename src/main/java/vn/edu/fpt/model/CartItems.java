package vn.edu.fpt.model;

public class CartItems {
    private int cartItemID;
    private Integer tourScheduleID;
    private Integer serviceID;
    private int quantity;
    private double unitPrice;
    private double subTotal;

    // Optional display fields
    private String itemName;
    private String type;

    public CartItems() {}

    public int getCartItemID() { return cartItemID; }
    public void setCartItemID(int cartItemID) { this.cartItemID = cartItemID; }

    public Integer getTourScheduleID() { return tourScheduleID; }
    public void setTourScheduleID(Integer tourScheduleID) { this.tourScheduleID = tourScheduleID; }

    public Integer getServiceID() { return serviceID; }
    public void setServiceID(Integer serviceID) { this.serviceID = serviceID; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public double getUnitPrice() { return unitPrice; }
    public void setUnitPrice(double unitPrice) { this.unitPrice = unitPrice; }

    public double getSubTotal() { return subTotal; }
    public void setSubTotal(double subTotal) { this.subTotal = subTotal; }

    public String getItemName() { return itemName; }
    public void setItemName(String itemName) { this.itemName = itemName; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }
}
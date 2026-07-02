package vn.edu.fpt.model;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class Carts {
    private int cartID;
    private int userID;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    private List<CartItems> items = new ArrayList<>();

    public int getCartID() {
        return cartID;
    }

    public void setCartID(int cartID) {
        this.cartID = cartID;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    public List<CartItems> getItems() {
        return items;
    }

    public void setItems(List<CartItems> items) {
        this.items = items == null ? new ArrayList<>() : items;
    }
}
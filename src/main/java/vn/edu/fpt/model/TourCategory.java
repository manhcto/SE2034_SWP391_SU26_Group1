package vn.edu.fpt.model;

public class TourCategory {
    private int tourCategoryID;
    private String categoryName;
    private String description;
    private String status;

    public int getTourCategoryID() {
        return tourCategoryID;
    }

    public int getCategoryID() {
        return tourCategoryID;
    }

    public void setTourCategoryID(int tourCategoryID) {
        this.tourCategoryID = tourCategoryID;
    }

    public void setCategoryID(int categoryID) {
        this.tourCategoryID = categoryID;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = safeTrim(categoryName);
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = safeTrim(description);
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = safeTrim(status);
    }

    private String safeTrim(String value) {
        return value == null ? "" : value.trim();
    }
}

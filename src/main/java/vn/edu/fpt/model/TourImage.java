package vn.edu.fpt.model;

public class TourImage {
    private int imageID;
    private int tourID;
    private String imageUrl;
    private String caption;
    private int displayOrder;
    private String status;

    public int getImageID() { return imageID; }
    public void setImageID(int imageID) { this.imageID = imageID; }

    public int getTourID() { return tourID; }
    public void setTourID(int tourID) { this.tourID = tourID; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = safeTrim(imageUrl); }

    public String getCaption() { return caption; }
    public void setCaption(String caption) { this.caption = safeTrim(caption); }

    public int getDisplayOrder() { return displayOrder; }
    public void setDisplayOrder(int displayOrder) { this.displayOrder = displayOrder; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = safeTrim(status); }

    private String safeTrim(String value) {
        return value == null ? "" : value.trim();
    }
}

package vn.edu.fpt.model;

public class TourOptionalServiceRequest {
    private String externalServiceCode;
    private String serviceName;
    private String description;
    private String imageUrl;
    private int price;
    private boolean defaultSelected;

    public String getExternalServiceCode() {
        return externalServiceCode;
    }

    public void setExternalServiceCode(String externalServiceCode) {
        this.externalServiceCode = externalServiceCode;
    }

    public String getServiceName() {
        return serviceName;
    }

    public void setServiceName(String serviceName) {
        this.serviceName = serviceName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public int getPrice() {
        return price;
    }

    public void setPrice(int price) {
        this.price = price;
    }

    public boolean isDefaultSelected() {
        return defaultSelected;
    }

    public void setDefaultSelected(boolean defaultSelected) {
        this.defaultSelected = defaultSelected;
    }
}

package vn.edu.fpt.model;

public class ResourceOptionDTO {
    private int value;
    private String label;
    private String type;
    private Integer regionID;
    private Integer price;
    private String extra;

    public ResourceOptionDTO() {}

    public ResourceOptionDTO(int value, String label, String type, Integer regionID, Integer price, String extra) {
        this.value = value;
        this.label = label;
        this.type = type;
        this.regionID = regionID;
        this.price = price;
        this.extra = extra;
    }

    public int getValue() { return value; }
    public void setValue(int value) { this.value = value; }

    public String getLabel() { return label; }
    public void setLabel(String label) { this.label = label; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public Integer getRegionID() { return regionID; }
    public void setRegionID(Integer regionID) { this.regionID = regionID; }

    public Integer getPrice() { return price; }
    public void setPrice(Integer price) { this.price = price; }

    public String getExtra() { return extra; }
    public void setExtra(String extra) { this.extra = extra; }
}

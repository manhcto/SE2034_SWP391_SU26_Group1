package vn.edu.fpt.model;

public class SelectOption {
    private int value;
    private String label;
    private Integer parentID;

    public SelectOption() {
    }

    public SelectOption(int value, String label) {
        this.value = value;
        this.label = label;
    }

    public SelectOption(int value, String label, Integer parentID) {
        this.value = value;
        this.label = label;
        this.parentID = parentID;
    }

    public int getValue() {
        return value;
    }

    public void setValue(int value) {
        this.value = value;
    }

    public String getLabel() {
        return label;
    }

    public void setLabel(String label) {
        this.label = label;
    }

    public Integer getParentID() {
        return parentID;
    }

    public void setParentID(Integer parentID) {
        this.parentID = parentID;
    }
}

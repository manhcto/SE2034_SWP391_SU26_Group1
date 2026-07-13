package vn.edu.fpt.model;

public class AdministrativeUnit {

    private int administrativeUnitID;
    private String provinceCode;
    private String provinceName;
    private String wardType;
    private String wardName;
    private String regionGroup;

    public int getAdministrativeUnitID() {
        return administrativeUnitID;
    }

    public void setAdministrativeUnitID(int administrativeUnitID) {
        this.administrativeUnitID = administrativeUnitID;
    }

    public String getProvinceCode() {
        return provinceCode;
    }

    public void setProvinceCode(String provinceCode) {
        this.provinceCode = safeTrim(provinceCode);
    }

    public String getProvinceName() {
        return provinceName;
    }

    public void setProvinceName(String provinceName) {
        this.provinceName = safeTrim(provinceName);
    }

    public String getWardType() {
        return wardType;
    }

    public void setWardType(String wardType) {
        this.wardType = safeTrim(wardType);
    }

    public String getWardName() {
        return wardName;
    }

    public void setWardName(String wardName) {
        this.wardName = safeTrim(wardName);
    }

    public String getRegionGroup() {
        return regionGroup;
    }

    public void setRegionGroup(String regionGroup) {
        this.regionGroup = safeTrim(regionGroup);
    }

    public String getDisplayName() {
        String wardPart = (wardType + " " + wardName).trim();
        if (wardPart.isEmpty()) {
            return provinceName;
        }
        if (wardPart.equals(wardName)) {
            wardPart = wardName;
        }
        return wardPart + ", " + provinceName;
    }

    private String safeTrim(String value) {
        return value == null ? "" : value.trim();
    }
}

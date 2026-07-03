package vn.edu.fpt.model;

public class AdministrativeUnit {

    private int administrativeUnitID;
    private String provinceCode;
    private String provinceName;
    private String wardType;
    private String wardName;

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

    private String safeTrim(String value) {
        return value == null ? "" : value.trim();
    }
}

package vn.edu.fpt.model;

import java.sql.Date;
import java.sql.Timestamp;

public class StaffProfileDTO {
    private int staffID;
    private int userID;
    private String staffCode;
    private String staffType;
    private String position;
    private String workRegion;
    private Date hireDate;
    private String licenseNumber;
    private String licenseClass;
    private String guideLicenseNo;
    private String languages;
    private String workStatus;

    private String firstName;
    private String lastName;
    private String email;
    private String phone;
    private String gender;
    private String userStatus;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public int getStaffID() { return staffID; }
    public void setStaffID(int staffID) { this.staffID = staffID; }

    public int getUserID() { return userID; }
    public void setUserID(int userID) { this.userID = userID; }

    public String getStaffCode() { return staffCode; }
    public void setStaffCode(String staffCode) { this.staffCode = staffCode; }

    public String getStaffType() { return staffType; }
    public void setStaffType(String staffType) { this.staffType = staffType; }

    public String getPosition() { return position; }
    public void setPosition(String position) { this.position = position; }

    public String getWorkRegion() { return workRegion; }
    public void setWorkRegion(String workRegion) { this.workRegion = workRegion; }

    public Date getHireDate() { return hireDate; }
    public void setHireDate(Date hireDate) { this.hireDate = hireDate; }

    public String getLicenseNumber() { return licenseNumber; }
    public void setLicenseNumber(String licenseNumber) { this.licenseNumber = licenseNumber; }

    public String getLicenseClass() { return licenseClass; }
    public void setLicenseClass(String licenseClass) { this.licenseClass = licenseClass; }

    public String getGuideLicenseNo() { return guideLicenseNo; }
    public void setGuideLicenseNo(String guideLicenseNo) { this.guideLicenseNo = guideLicenseNo; }

    public String getLanguages() { return languages; }
    public void setLanguages(String languages) { this.languages = languages; }

    public String getWorkStatus() { return workStatus; }
    public void setWorkStatus(String workStatus) { this.workStatus = workStatus; }

    public String getFirstName() { return firstName; }
    public void setFirstName(String firstName) { this.firstName = firstName; }

    public String getLastName() { return lastName; }
    public void setLastName(String lastName) { this.lastName = lastName; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }

    public String getUserStatus() { return userStatus; }
    public void setUserStatus(String userStatus) { this.userStatus = userStatus; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }

    public String getFullName() {
        String first = firstName == null ? "" : firstName.trim();
        String last = lastName == null ? "" : lastName.trim();
        String full = (last + " " + first).trim();
        return full.isEmpty() ? staffCode : full;
    }

    public String getAvatarText() {
        String full = getFullName();
        if (full == null || full.isBlank()) return "S";
        return full.substring(0, 1).toUpperCase();
    }

    public String getStaffTypeText() {
        if ("Guide".equals(staffType)) return "Hướng dẫn viên";
        if ("Driver".equals(staffType)) return "Tài xế";
        if ("Coordinator".equals(staffType)) return "Điều phối viên";
        if ("Admin".equals(staffType)) return "Quản trị viên";
        if ("OperationStaff".equals(staffType)) return "Nhân viên điều hành";
        if ("Staff".equals(staffType)) return "Nhân viên";
        return staffType;
    }

    public String getWorkRegionText() {
        if ("North".equals(workRegion)) return "Miền Bắc";
        if ("Central".equals(workRegion)) return "Miền Trung";
        if ("South".equals(workRegion)) return "Miền Nam";
        if ("All".equals(workRegion)) return "Toàn quốc";
        return "Chưa cập nhật";
    }

    public String getWorkStatusText() {
        if ("Working".equals(workStatus)) return "Đang làm việc";
        if ("OnLeave".equals(workStatus)) return "Đang nghỉ phép";
        if ("Inactive".equals(workStatus)) return "Ngừng hoạt động";
        return workStatus;
    }
}

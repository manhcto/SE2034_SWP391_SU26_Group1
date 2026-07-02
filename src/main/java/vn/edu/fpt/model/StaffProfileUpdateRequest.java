package vn.edu.fpt.model;

public class StaffProfileUpdateRequest {
    private int userID;
    private int staffID;
    private String firstName;
    private String lastName;
    private String phone;
    private String gender;
    private String position;
    private String workRegion;
    private String licenseNumber;
    private String licenseClass;
    private String guideLicenseNo;
    private String languages;

    public int getUserID() { return userID; }
    public void setUserID(int userID) { this.userID = userID; }

    public int getStaffID() { return staffID; }
    public void setStaffID(int staffID) { this.staffID = staffID; }

    public String getFirstName() { return firstName; }
    public void setFirstName(String firstName) { this.firstName = firstName; }

    public String getLastName() { return lastName; }
    public void setLastName(String lastName) { this.lastName = lastName; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }

    public String getPosition() { return position; }
    public void setPosition(String position) { this.position = position; }

    public String getWorkRegion() { return workRegion; }
    public void setWorkRegion(String workRegion) { this.workRegion = workRegion; }

    public String getLicenseNumber() { return licenseNumber; }
    public void setLicenseNumber(String licenseNumber) { this.licenseNumber = licenseNumber; }

    public String getLicenseClass() { return licenseClass; }
    public void setLicenseClass(String licenseClass) { this.licenseClass = licenseClass; }

    public String getGuideLicenseNo() { return guideLicenseNo; }
    public void setGuideLicenseNo(String guideLicenseNo) { this.guideLicenseNo = guideLicenseNo; }

    public String getLanguages() { return languages; }
    public void setLanguages(String languages) { this.languages = languages; }
}

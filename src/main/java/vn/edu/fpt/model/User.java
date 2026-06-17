package vn.edu.fpt.model;

public class User {

    private int userID;
    private String firstName;
    private String lastName;
    private String email;
    private String password;
    private String gender;   // thêm
    private int roleID;
    private String phone;


    public User() {
    }

    public User(int userID, String firstName, String lastName,
                String email, String password,
                String gender, int roleID) {
        this.userID = userID;
        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email;
        this.password = password;
        this.gender = gender;
        this.roleID = roleID;
    }

    // getter setter

    public User(int userID, String firstName, String lastName, String email, String password, int roleID) {
        this.userID = userID;
        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email;
        this.password = password;
        this.roleID = roleID;
    }

    public User(int userID, String firstName, String lastName, String email, int roleID) {
        this.userID = userID;
        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email;
        this.roleID = roleID;
    }


    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }
    public String getGender() {return gender;
    }

    public void setGender(String gender) {this.gender = gender;
    }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    public int getRoleID() {
        return roleID;
    }

    public void setRoleID(int roleID) {
        this.roleID = roleID;
    }
}

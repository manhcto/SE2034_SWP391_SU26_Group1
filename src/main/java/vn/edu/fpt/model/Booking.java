package vn.edu.fpt.model;

import java.util.Date;

public class Booking {
    public static final String STATUS_PROCESSING = "Đang xử lý";
    public static final String STATUS_APPROVED = "Đã duyệt";
    public static final String STATUS_CANCELLED = "Đã hủy";
    public static final String STATUS_COMPLETED = "Hoàn thành";

    private int bookingID;
    private String bookingCode;
    private String bookingType;
    private String email;
    private String phone;
    private int numberAdult;
    private int numberChildren;
    private String note;
    private String identityNumber;
    private String identityImageUrl;
    private String address;
    private String firstName;
    private String lastName;
    private Integer userID; // Dùng Integer thay vì int để có thể lưu giá trị null (trường hợp khách vãng lai không đăng nhập)
    private String status;
    private Date bookDate;
    private boolean isBookedForOther;
    private double totalPrice;
    private Integer voucherID;
    private Integer detailAccommodationID;
    private Integer detailTourScheduleID;
    private int detailQuantity;
    private double detailUnitPrice;
    private double detailSubTotal;
    private Date serviceStartDate;
    private Date serviceEndDate;
    private String serviceName;

    // 1. Constructor rỗng
    public Booking() {
    }

    // 2. Constructor đầy đủ tham số
    public Booking(int bookingID, String bookingCode, String bookingType, String email, String phone,
                   int numberAdult, int numberChildren, String note, String address, String firstName,
                   String lastName, Integer userID, String status, Date bookDate, boolean isBookedForOther,
                   double totalPrice, Integer voucherID) {
        this.bookingID = bookingID;
        this.bookingCode = bookingCode;
        this.bookingType = bookingType;
        this.email = email;
        this.phone = phone;
        this.numberAdult = numberAdult;
        this.numberChildren = numberChildren;
        this.note = note;
        this.address = address;
        this.firstName = firstName;
        this.lastName = lastName;
        this.userID = userID;
        this.status = status;
        this.bookDate = bookDate;
        this.isBookedForOther = isBookedForOther;
        this.totalPrice = totalPrice;
        this.voucherID = voucherID;
    }

    // 3. Các hàm Getters và Setters
    public int getBookingID() { return bookingID; }
    public void setBookingID(int bookingID) { this.bookingID = bookingID; }

    public String getBookingCode() { return bookingCode; }
    public void setBookingCode(String bookingCode) { this.bookingCode = bookingCode; }

    public String getBookingType() { return bookingType; }
    public void setBookingType(String bookingType) { this.bookingType = bookingType; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public int getNumberAdult() { return numberAdult; }
    public void setNumberAdult(int numberAdult) { this.numberAdult = numberAdult; }

    public int getNumberChildren() { return numberChildren; }
    public void setNumberChildren(int numberChildren) { this.numberChildren = numberChildren; }

    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }

    public String getIdentityNumber() { return identityNumber; }
    public void setIdentityNumber(String identityNumber) { this.identityNumber = identityNumber; }

    public String getIdentityImageUrl() { return identityImageUrl; }
    public void setIdentityImageUrl(String identityImageUrl) { this.identityImageUrl = identityImageUrl; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getFirstName() { return firstName; }
    public void setFirstName(String firstName) { this.firstName = firstName; }

    public String getLastName() { return lastName; }
    public void setLastName(String lastName) { this.lastName = lastName; }

    public Integer getUserID() { return userID; }
    public void setUserID(Integer userID) { this.userID = userID; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Date getBookDate() { return bookDate; }
    public void setBookDate(Date bookDate) { this.bookDate = bookDate; }

    public boolean isBookedForOther() { return isBookedForOther; }
    public void setBookedForOther(boolean isBookedForOther) { this.isBookedForOther = isBookedForOther; }

    public double getTotalPrice() { return totalPrice; }
    public void setTotalPrice(double totalPrice) { this.totalPrice = totalPrice; }

    public Integer getVoucherID() { return voucherID; }
    public void setVoucherID(Integer voucherID) { this.voucherID = voucherID; }

    public Integer getDetailAccommodationID() { return detailAccommodationID; }
    public void setDetailAccommodationID(Integer detailAccommodationID) { this.detailAccommodationID = detailAccommodationID; }

    public Integer getDetailTourScheduleID() { return detailTourScheduleID; }
    public void setDetailTourScheduleID(Integer detailTourScheduleID) { this.detailTourScheduleID = detailTourScheduleID; }

    public int getDetailQuantity() { return detailQuantity; }
    public void setDetailQuantity(int detailQuantity) { this.detailQuantity = detailQuantity; }

    public double getDetailUnitPrice() { return detailUnitPrice; }
    public void setDetailUnitPrice(double detailUnitPrice) { this.detailUnitPrice = detailUnitPrice; }

    public double getDetailSubTotal() { return detailSubTotal; }
    public void setDetailSubTotal(double detailSubTotal) { this.detailSubTotal = detailSubTotal; }

    public Date getServiceStartDate() { return serviceStartDate; }
    public void setServiceStartDate(Date serviceStartDate) { this.serviceStartDate = serviceStartDate; }

    public Date getServiceEndDate() { return serviceEndDate; }
    public void setServiceEndDate(Date serviceEndDate) { this.serviceEndDate = serviceEndDate; }

    public String getServiceName() { return serviceName; }
    public void setServiceName(String serviceName) { this.serviceName = serviceName; }

    public int getTotalGuests() {
        return numberAdult + numberChildren;
    }

    public String getDisplayType() {
        if ("Tour".equalsIgnoreCase(bookingType)) {
            return "Tour";
        }

        if ("Accommodation".equalsIgnoreCase(bookingType)) {
            return "Lưu trú";
        }

        return bookingType;
    }

    public String getDisplayStatus() {
        if (isProcessingStatus(status)) {
            return STATUS_PROCESSING;
        }

        // Trạng thái "Đã duyệt" đã bị loại bỏ khỏi luồng nghiệp vụ.
        // Các đơn cũ trong DB còn 'Đã duyệt'/'Confirmed' sẽ hiển thị là "Hoàn thành".
        if (isApprovedStatus(status)) {
            return STATUS_COMPLETED;
        }

        if (isCancelledStatus(status)) {
            return STATUS_CANCELLED;
        }

        if (isCompletedStatus(status)) {
            return STATUS_COMPLETED;
        }

        return status;
    }

    public static boolean isProcessingStatus(String value) {
        return STATUS_PROCESSING.equalsIgnoreCase(value) || "Pending".equalsIgnoreCase(value);
    }

    public static boolean isApprovedStatus(String value) {
        return STATUS_APPROVED.equalsIgnoreCase(value) || "Confirmed".equalsIgnoreCase(value);
    }

    public static boolean isCancelledStatus(String value) {
        return STATUS_CANCELLED.equalsIgnoreCase(value) || "Cancelled".equalsIgnoreCase(value);
    }

    public static boolean isCompletedStatus(String value) {
        return STATUS_COMPLETED.equalsIgnoreCase(value) || "Completed".equalsIgnoreCase(value);
    }

    @Override
    public String toString() {
        return "Booking{" + "bookingCode=" + bookingCode + ", email=" + email + ", totalPrice=" + totalPrice + '}';
    }
}

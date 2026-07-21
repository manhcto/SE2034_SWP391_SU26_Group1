package vn.edu.fpt.model;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class Tour {
    private int tourID;
    private int tourCategoryID;
    private String tourName;
    private String tourCode;
    private String tourType;
    private int numberOfDay;
    private Integer numberOfNights;
    private String startPlace;
    private String endPlace;
    private String image;
    private String introImage;
    private BigDecimal adultPrice;
    private BigDecimal childrenPrice;
    private BigDecimal infantPrice;
    private BigDecimal singleRoomSurcharge;
    private int depositPercent;
    private int vatPercent;
    private String tourIntroduce;
    private String tourInclude;
    private String tourNonInclude;
    private String pickupPointName;
    private String pickupAddress;
    private Integer arriveBeforeMinutes;
    private String pickupNote;
    private String mainTransportType;
    private String childPolicyNote;
    private BigDecimal rate;
    private String status;
    private boolean featured;
    private Integer regionID;
    private Integer createdByUserID;
    private Integer approvedByUserID;
    private Timestamp approvedAt;
    private String rejectionReason;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    private String categoryName;
    private String regionName;
    private String createdByName;
    private String approvedByName;
    private int scheduleCount;
    private int bookingCount;

    private List<TourItinerary> itineraryList;
    private List<TourSchedule> scheduleList;

    public Tour() {
        this.itineraryList = new ArrayList<>();
        this.scheduleList = new ArrayList<>();
        this.adultPrice = BigDecimal.ZERO;
        this.childrenPrice = BigDecimal.ZERO;
        this.infantPrice = BigDecimal.ZERO;
        this.singleRoomSurcharge = BigDecimal.ZERO;
    }

    public int getTourID() { return tourID; }
    public void setTourID(int tourID) { this.tourID = tourID; }

    public int getTourCategoryID() { return tourCategoryID; }
    public void setTourCategoryID(int tourCategoryID) { this.tourCategoryID = tourCategoryID; }

    public String getTourName() { return tourName; }
    public void setTourName(String tourName) { this.tourName = safeTrim(tourName); }

    public String getTourCode() { return tourCode; }
    public void setTourCode(String tourCode) { this.tourCode = safeTrim(tourCode); }

    public String getTourType() { return tourType; }
    public void setTourType(String tourType) { this.tourType = safeTrim(tourType); }

    public int getNumberOfDay() { return numberOfDay; }
    public void setNumberOfDay(int numberOfDay) { this.numberOfDay = numberOfDay; }

    public Integer getNumberOfNights() { return numberOfNights; }
    public void setNumberOfNights(Integer numberOfNights) { this.numberOfNights = numberOfNights; }

    public String getStartPlace() { return startPlace; }
    public void setStartPlace(String startPlace) { this.startPlace = safeTrim(startPlace); }

    public String getEndPlace() { return endPlace; }
    public void setEndPlace(String endPlace) { this.endPlace = safeTrim(endPlace); }

    public String getImage() { return image; }
    public void setImage(String image) { this.image = safeTrim(image); }

    public String getIntroImage() { return introImage; }
    public void setIntroImage(String introImage) { this.introImage = safeTrim(introImage); }

    public BigDecimal getAdultPrice() { return adultPrice; }
    public void setAdultPrice(BigDecimal adultPrice) { this.adultPrice = adultPrice == null ? BigDecimal.ZERO : adultPrice; }

    public BigDecimal getChildrenPrice() { return childrenPrice; }
    public void setChildrenPrice(BigDecimal childrenPrice) { this.childrenPrice = childrenPrice == null ? BigDecimal.ZERO : childrenPrice; }

    public BigDecimal getInfantPrice() { return infantPrice; }
    public void setInfantPrice(BigDecimal infantPrice) { this.infantPrice = infantPrice == null ? BigDecimal.ZERO : infantPrice; }

    public BigDecimal getSingleRoomSurcharge() { return singleRoomSurcharge; }
    public void setSingleRoomSurcharge(BigDecimal singleRoomSurcharge) { this.singleRoomSurcharge = singleRoomSurcharge == null ? BigDecimal.ZERO : singleRoomSurcharge; }

    public int getDepositPercent() { return depositPercent; }
    public void setDepositPercent(int depositPercent) { this.depositPercent = depositPercent; }

    public int getVatPercent() { return vatPercent; }
    public void setVatPercent(int vatPercent) { this.vatPercent = vatPercent; }

    public String getTourIntroduce() { return tourIntroduce; }
    public void setTourIntroduce(String tourIntroduce) { this.tourIntroduce = safeTrim(tourIntroduce); }

    public String getTourInclude() { return tourInclude; }
    public void setTourInclude(String tourInclude) { this.tourInclude = safeTrim(tourInclude); }

    public String getTourNonInclude() { return tourNonInclude; }
    public void setTourNonInclude(String tourNonInclude) { this.tourNonInclude = safeTrim(tourNonInclude); }

    public String getPickupPointName() { return pickupPointName; }
    public void setPickupPointName(String pickupPointName) { this.pickupPointName = safeTrim(pickupPointName); }

    public String getPickupAddress() { return pickupAddress; }
    public void setPickupAddress(String pickupAddress) { this.pickupAddress = safeTrim(pickupAddress); }

    public Integer getArriveBeforeMinutes() { return arriveBeforeMinutes; }
    public void setArriveBeforeMinutes(Integer arriveBeforeMinutes) { this.arriveBeforeMinutes = arriveBeforeMinutes; }

    public String getPickupNote() { return pickupNote; }
    public void setPickupNote(String pickupNote) { this.pickupNote = safeTrim(pickupNote); }

    public String getMainTransportType() { return mainTransportType; }
    public void setMainTransportType(String mainTransportType) { this.mainTransportType = safeTrim(mainTransportType); }

    public String getChildPolicyNote() { return childPolicyNote; }
    public void setChildPolicyNote(String childPolicyNote) { this.childPolicyNote = safeTrim(childPolicyNote); }

    public BigDecimal getRate() { return rate; }
    public void setRate(BigDecimal rate) { this.rate = rate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = safeTrim(status); }

    public boolean isFeatured() { return featured; }
    public boolean getFeatured() { return featured; }
    public void setFeatured(boolean featured) { this.featured = featured; }

    public Integer getRegionID() { return regionID; }
    public void setRegionID(Integer regionID) { this.regionID = regionID; }

    public Integer getCreatedByUserID() { return createdByUserID; }
    public void setCreatedByUserID(Integer createdByUserID) { this.createdByUserID = createdByUserID; }

    public Integer getApprovedByUserID() { return approvedByUserID; }
    public void setApprovedByUserID(Integer approvedByUserID) { this.approvedByUserID = approvedByUserID; }

    public Timestamp getApprovedAt() { return approvedAt; }
    public void setApprovedAt(Timestamp approvedAt) { this.approvedAt = approvedAt; }

    public String getRejectionReason() { return rejectionReason; }
    public void setRejectionReason(String rejectionReason) { this.rejectionReason = safeTrim(rejectionReason); }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }

    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = safeTrim(categoryName); }

    public String getRegionName() { return regionName; }
    public void setRegionName(String regionName) { this.regionName = safeTrim(regionName); }

    public String getCreatedByName() { return createdByName; }
    public void setCreatedByName(String createdByName) { this.createdByName = safeTrim(createdByName); }

    public String getApprovedByName() { return approvedByName; }
    public void setApprovedByName(String approvedByName) { this.approvedByName = safeTrim(approvedByName); }

    public int getScheduleCount() { return scheduleCount; }
    public void setScheduleCount(int scheduleCount) { this.scheduleCount = scheduleCount; }

    public int getBookingCount() { return bookingCount; }
    public void setBookingCount(int bookingCount) { this.bookingCount = bookingCount; }

    public List<TourItinerary> getItineraryList() { return itineraryList; }
    public void setItineraryList(List<TourItinerary> itineraryList) { this.itineraryList = itineraryList == null ? new ArrayList<>() : itineraryList; }

    public List<TourSchedule> getScheduleList() { return scheduleList; }
    public void setScheduleList(List<TourSchedule> scheduleList) { this.scheduleList = scheduleList == null ? new ArrayList<>() : scheduleList; }

    public String getDisplayStatus() {
        if ("Draft".equalsIgnoreCase(status)) return "Bản nháp";
        if ("Pending".equalsIgnoreCase(status)) return "Chờ duyệt";
        if ("Active".equalsIgnoreCase(status)) return "Đang bán";
        if ("Inactive".equalsIgnoreCase(status)) return "Ngừng bán";
        if ("Rejected".equalsIgnoreCase(status)) return "Bị từ chối";
        return status;
    }

    public String getDisplayTourType() {
        return "Tour trọn gói";
    }

    private String safeTrim(String value) {
        return value == null ? "" : value.trim();
    }
}

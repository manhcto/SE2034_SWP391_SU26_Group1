package vn.edu.fpt.model;

import vn.edu.fpt.utils.TourBusinessRule;

import java.sql.Time;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class TourDetailDTO {
    private int tourID;
    private String tourCode;
    private String tourName;
    private int tourCategoryID;
    private Integer regionID;
    private String tourCategoryName;
    private String regionName;
    private String departurePlace;
    private String destination;
    private String pickupPointName;
    private Time pickupTime;
    private int numberOfDays;
    private int numberOfNights;
    private String mainTransportType;
    private Integer vehicleSeatCount;
    private String shortDescription;
    private String description;
    private String coverImageUrl;
    private String tourStatus;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    private List<TourScheduleDTO> schedules = new ArrayList<>();
    private List<TourItineraryRequest> itineraries = new ArrayList<>();
    private List<TourOptionalServiceRequest> optionalServices = new ArrayList<>();
    private List<String> imageUrls = new ArrayList<>();

    public int getTourID() {
        return tourID;
    }

    public void setTourID(int tourID) {
        this.tourID = tourID;
    }

    public String getTourCode() {
        return tourCode;
    }

    public void setTourCode(String tourCode) {
        this.tourCode = tourCode;
    }

    public String getTourName() {
        return tourName;
    }

    public void setTourName(String tourName) {
        this.tourName = tourName;
    }

    public int getTourCategoryID() { return tourCategoryID; }
    public void setTourCategoryID(int tourCategoryID) { this.tourCategoryID = tourCategoryID; }
    public Integer getRegionID() { return regionID; }
    public void setRegionID(Integer regionID) { this.regionID = regionID; }
    public String getTourCategoryName() {
        return tourCategoryName;
    }

    public void setTourCategoryName(String tourCategoryName) {
        this.tourCategoryName = tourCategoryName;
    }

    public String getRegionName() {
        return regionName;
    }

    public void setRegionName(String regionName) {
        this.regionName = regionName;
    }

    public String getDeparturePlace() {
        return departurePlace;
    }

    public void setDeparturePlace(String departurePlace) {
        this.departurePlace = departurePlace;
    }

    public String getDestination() {
        return destination;
    }

    public void setDestination(String destination) {
        this.destination = destination;
    }

    public String getPickupPointName() {
        return pickupPointName;
    }

    public void setPickupPointName(String pickupPointName) {
        this.pickupPointName = pickupPointName;
    }

    public Time getPickupTime() {
        return pickupTime;
    }

    public void setPickupTime(Time pickupTime) {
        this.pickupTime = pickupTime;
    }

    public int getNumberOfDays() {
        return numberOfDays;
    }

    public void setNumberOfDays(int numberOfDays) {
        this.numberOfDays = numberOfDays;
    }

    public int getNumberOfNights() {
        return numberOfNights;
    }

    public void setNumberOfNights(int numberOfNights) {
        this.numberOfNights = numberOfNights;
    }

    public String getMainTransportType() {
        return mainTransportType;
    }

    public void setMainTransportType(String mainTransportType) {
        this.mainTransportType = mainTransportType;
    }

    public Integer getVehicleSeatCount() {
        return vehicleSeatCount;
    }

    public void setVehicleSeatCount(Integer vehicleSeatCount) {
        this.vehicleSeatCount = vehicleSeatCount;
    }

    public String getShortDescription() {
        return shortDescription;
    }

    public void setShortDescription(String shortDescription) {
        this.shortDescription = shortDescription;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getCoverImageUrl() {
        return coverImageUrl;
    }

    public void setCoverImageUrl(String coverImageUrl) {
        this.coverImageUrl = coverImageUrl;
    }

    public String getTourStatus() {
        return tourStatus;
    }

    public void setTourStatus(String tourStatus) {
        this.tourStatus = tourStatus;
    }

    public String getStatusCssClass() {
        if (TourBusinessRule.STATUS_PENDING_APPROVAL.equals(tourStatus)) return "status-pending";
        if (TourBusinessRule.STATUS_SELLING.equals(tourStatus) || TourBusinessRule.STATUS_APPROVED_LEGACY.equals(tourStatus)) return "status-approved";
        if (TourBusinessRule.STATUS_REJECTED.equals(tourStatus)) return "status-rejected";
        if (TourBusinessRule.STATUS_CANCELLED.equals(tourStatus)) return "status-cancelled";
        if (TourBusinessRule.STATUS_COMPLETED.equals(tourStatus) || TourBusinessRule.STATUS_SOLD_OUT.equals(tourStatus)) return "status-completed";
        return "status-draft";
    }

    public String getTourStatusText() {
        if (TourBusinessRule.STATUS_DRAFT.equals(tourStatus)) return "Nháp";
        if (TourBusinessRule.STATUS_REJECTED.equals(tourStatus)) return "Bị từ chối";
        if (TourBusinessRule.STATUS_PENDING_APPROVAL.equals(tourStatus)) return "Chờ duyệt";
        if (TourBusinessRule.STATUS_SELLING.equals(tourStatus) || TourBusinessRule.STATUS_APPROVED_LEGACY.equals(tourStatus)) return "Đang bán";
        if (TourBusinessRule.STATUS_SOLD_OUT.equals(tourStatus)) return "Đã bán";
        if (TourBusinessRule.STATUS_CANCELLED.equals(tourStatus)) return "Đã hủy";
        if (TourBusinessRule.STATUS_COMPLETED.equals(tourStatus)) return "Hoàn thành";
        return tourStatus;
    }

    public boolean isCanEditBasic() {
        return TourBusinessRule.canEditTourBasic(tourStatus);
    }

    public boolean isCanEditItinerary() {
        return TourBusinessRule.canEditItinerary(tourStatus);
    }

    public boolean isCanAddOrEditSchedule() {
        return TourBusinessRule.canAddOrEditSchedule(tourStatus);
    }

    public boolean isCanSubmitForApproval() {
        return TourBusinessRule.canSubmitForApproval(tourStatus);
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    public List<TourScheduleDTO> getSchedules() {
        return schedules;
    }

    public void setSchedules(List<TourScheduleDTO> schedules) {
        this.schedules = schedules;
    }

    public List<TourItineraryRequest> getItineraries() {
        return itineraries;
    }

    public void setItineraries(List<TourItineraryRequest> itineraries) {
        this.itineraries = itineraries;
    }

    public List<TourOptionalServiceRequest> getOptionalServices() {
        return optionalServices;
    }

    public void setOptionalServices(List<TourOptionalServiceRequest> optionalServices) {
        this.optionalServices = optionalServices;
    }

    public List<String> getImageUrls() {
        return imageUrls;
    }

    public void setImageUrls(List<String> imageUrls) {
        this.imageUrls = imageUrls;
    }
}

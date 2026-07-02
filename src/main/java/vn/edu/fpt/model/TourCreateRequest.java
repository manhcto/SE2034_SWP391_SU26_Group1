package vn.edu.fpt.model;

import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

public class TourCreateRequest {
    private String tourCode;
    private String tourName;
    private int tourCategoryID;
    private Integer regionID;
    private Integer departureDestinationID;
    private Integer destinationID;

    private String pickupPointName;
    private LocalTime pickupTime;

    private int numberOfDays;
    private int numberOfNights;

    private String mainTransportType;
    private Integer vehicleSeatCount;

    private String shortDescription;
    private String description;
    private String coverImageUrl;

    private List<String> imageUrls = new ArrayList<>();
    private List<TourScheduleRequest> schedules = new ArrayList<>();
    private List<TourItineraryRequest> itineraries = new ArrayList<>();
    private List<TourOptionalServiceRequest> optionalServices = new ArrayList<>();

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

    public int getTourCategoryID() {
        return tourCategoryID;
    }

    public void setTourCategoryID(int tourCategoryID) {
        this.tourCategoryID = tourCategoryID;
    }

    public Integer getRegionID() {
        return regionID;
    }

    public void setRegionID(Integer regionID) {
        this.regionID = regionID;
    }

    public Integer getDepartureDestinationID() {
        return departureDestinationID;
    }

    public void setDepartureDestinationID(Integer departureDestinationID) {
        this.departureDestinationID = departureDestinationID;
    }

    public Integer getDestinationID() {
        return destinationID;
    }

    public void setDestinationID(Integer destinationID) {
        this.destinationID = destinationID;
    }

    public String getPickupPointName() {
        return pickupPointName;
    }

    public void setPickupPointName(String pickupPointName) {
        this.pickupPointName = pickupPointName;
    }

    public LocalTime getPickupTime() {
        return pickupTime;
    }

    public void setPickupTime(LocalTime pickupTime) {
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

    public List<String> getImageUrls() {
        return imageUrls;
    }

    public void setImageUrls(List<String> imageUrls) {
        this.imageUrls = imageUrls;
    }

    public List<TourScheduleRequest> getSchedules() {
        return schedules;
    }

    public void setSchedules(List<TourScheduleRequest> schedules) {
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
}

package vn.edu.fpt.model;

import java.time.LocalDate;

public class TourItineraryRequest {
    private int dayNumber;
    private LocalDate itineraryDate;
    private String transportDescription;
    private String experienceActivities;
    private String accommodationDescription;
    private String note;

    public int getDayNumber() {
        return dayNumber;
    }

    public void setDayNumber(int dayNumber) {
        this.dayNumber = dayNumber;
    }

    public LocalDate getItineraryDate() {
        return itineraryDate;
    }

    public void setItineraryDate(LocalDate itineraryDate) {
        this.itineraryDate = itineraryDate;
    }

    public String getTransportDescription() {
        return transportDescription;
    }

    public void setTransportDescription(String transportDescription) {
        this.transportDescription = transportDescription;
    }

    public String getExperienceActivities() {
        return experienceActivities;
    }

    public void setExperienceActivities(String experienceActivities) {
        this.experienceActivities = experienceActivities;
    }

    public String getAccommodationDescription() {
        return accommodationDescription;
    }

    public void setAccommodationDescription(String accommodationDescription) {
        this.accommodationDescription = accommodationDescription;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }
}

package vn.edu.fpt.model;

public class TourItinerary {
    private int itineraryID;
    private int tourID;
    private int dayNumber;
    private String title;
    private String description;
    private String mealPlan;
    private String transportNote;
    private String status;
    private String imageUrl;

    public int getItineraryID() {
        return itineraryID;
    }

    public void setItineraryID(int itineraryID) {
        this.itineraryID = itineraryID;
    }

    public int getTourID() {
        return tourID;
    }

    public void setTourID(int tourID) {
        this.tourID = tourID;
    }

    public int getDayNumber() {
        return dayNumber;
    }

    public void setDayNumber(int dayNumber) {
        this.dayNumber = dayNumber;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = safeTrim(title);
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = safeTrim(description);
    }

    public String getMealPlan() {
        return mealPlan;
    }

    public void setMealPlan(String mealPlan) {
        this.mealPlan = safeTrim(mealPlan);
    }

    public String getTransportNote() {
        return transportNote;
    }

    public void setTransportNote(String transportNote) {
        this.transportNote = safeTrim(transportNote);
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = safeTrim(status);
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = safeTrim(imageUrl);
    }

    private String safeTrim(String value) {
        return value == null ? "" : value.trim();
    }
}

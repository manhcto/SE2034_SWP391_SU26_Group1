package vn.edu.fpt.model;

import java.util.Date;

public class Feedback {
    private int feedbackID;
    private double rate;
    private String content;
    private Date createDate;
    private String status;
    private String image;
    private int userID;
    private int bookingID;

    public Feedback() {
    }

    public Feedback(int feedbackID, double rate, String content, Date createDate,
                    String status, String image, int userID, int bookingID) {
        this.feedbackID = feedbackID;
        this.rate = rate;
        this.content = content;
        this.createDate = createDate;
        this.status = status;
        this.image = image;
        this.userID = userID;
        this.bookingID = bookingID;
    }

    public int getFeedbackID() {
        return feedbackID;
    }

    public void setFeedbackID(int feedbackID) {
        this.feedbackID = feedbackID;
    }

    public double getRate() {
        return rate;
    }

    public void setRate(double rate) {
        this.rate = rate;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Date getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Date createDate) {
        this.createDate = createDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public int getBookingID() {
        return bookingID;
    }

    public void setBookingID(int bookingID) {
        this.bookingID = bookingID;
    }

    @Override
    public String toString() {
        return "Feedback{"
                + "feedbackID=" + feedbackID
                + ", rate=" + rate
                + ", status='" + status + '\''
                + ", userID=" + userID
                + ", bookingID=" + bookingID
                + '}';
    }
}
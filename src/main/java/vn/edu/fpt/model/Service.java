package vn.edu.fpt.model;

import java.sql.Timestamp;

public class Service {

    private int serviceID;
    private int serviceCategoryID;
    private String serviceName;
    private String status;
    private String serviceType;
    private String fulfillmentType;
    private Timestamp createdAt;

    // Trong DB là updateAt
    private Timestamp updateAt;

    public Service() {
    }

    public Service(int serviceID, int serviceCategoryID, String serviceName,
                   String status, String serviceType, String fulfillmentType,
                   Timestamp createdAt, Timestamp updateAt) {
        this.serviceID = serviceID;
        this.serviceCategoryID = serviceCategoryID;
        this.serviceName = serviceName;
        this.status = status;
        this.serviceType = serviceType;
        this.fulfillmentType = fulfillmentType;
        this.createdAt = createdAt;
        this.updateAt = updateAt;
    }

    public int getServiceID() {
        return serviceID;
    }

    public void setServiceID(int serviceID) {
        this.serviceID = serviceID;
    }

    public int getServiceCategoryID() {
        return serviceCategoryID;
    }

    public void setServiceCategoryID(int serviceCategoryID) {
        this.serviceCategoryID = serviceCategoryID;
    }

    public String getServiceName() {
        return serviceName;
    }

    public void setServiceName(String serviceName) {
        this.serviceName = serviceName;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getServiceType() {
        return serviceType;
    }

    public void setServiceType(String serviceType) {
        this.serviceType = serviceType;
    }

    public String getFulfillmentType() {
        return fulfillmentType;
    }

    public void setFulfillmentType(String fulfillmentType) {
        this.fulfillmentType = fulfillmentType;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdateAt() {
        return updateAt;
    }

    public void setUpdateAt(Timestamp updateAt) {
        this.updateAt = updateAt;
    }
}
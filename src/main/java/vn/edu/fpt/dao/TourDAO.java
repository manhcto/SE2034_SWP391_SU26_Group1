package vn.edu.fpt.dao;

import vn.edu.fpt.model.TourCreateRequest;
import vn.edu.fpt.model.TourDetailDTO;
import vn.edu.fpt.model.TourListItem;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

public interface TourDAO {
    String generateNextTourCode(Connection conn) throws SQLException;

    int createTourWithSchedules(Connection conn, TourCreateRequest request, Integer createdByUserID)
            throws SQLException;

    void updateTourFull(Connection conn, int tourID, TourCreateRequest request, Integer updatedByUserID)
            throws SQLException;

    void updateSchedulesOnly(Connection conn, int tourID, TourCreateRequest request, Integer updatedByUserID)
            throws SQLException;

    String getTourStatus(int tourID) throws SQLException;

    List<TourListItem> searchTours(String keyword, String status, Integer regionID, Integer categoryID)
            throws SQLException;

    TourDetailDTO getTourDetailByID(int tourID) throws SQLException;

    void submitForApproval(int tourID, Integer userID) throws SQLException;

    void approveTour(int tourID, Integer userID) throws SQLException;

    void markTourSoldOut(int tourID, Integer userID) throws SQLException;
}

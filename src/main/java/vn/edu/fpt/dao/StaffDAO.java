package vn.edu.fpt.dao;

import vn.edu.fpt.model.StaffOption;

import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;

public interface StaffDAO {
    List<StaffOption> getActiveGuides() throws SQLException;

    List<StaffOption> getActiveDrivers() throws SQLException;

    boolean isGuideAvailable(int staffID, LocalDate departureDate, LocalDate returnDate, Integer excludeScheduleID)
            throws SQLException;

    boolean isDriverAvailable(int staffID, LocalDate departureDate, LocalDate returnDate, Integer excludeScheduleID)
            throws SQLException;
}

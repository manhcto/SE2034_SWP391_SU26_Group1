package vn.edu.fpt.dao;

import vn.edu.fpt.model.StaffAssignmentDTO;
import vn.edu.fpt.model.StaffAssignmentRequest;
import vn.edu.fpt.model.StaffAssignmentScheduleDTO;
import vn.edu.fpt.model.StaffOption;

import java.time.LocalDate;
import java.util.List;

public interface StaffAssignmentDAO {
    List<StaffAssignmentScheduleDTO> searchSchedules(String keyword, String scheduleStatus) throws Exception;
    StaffAssignmentScheduleDTO findScheduleByID(int tourScheduleID) throws Exception;
    List<StaffAssignmentDTO> getAssignmentsByScheduleID(int tourScheduleID) throws Exception;
    List<StaffOption> getAssignableStaff() throws Exception;
    StaffOption findStaffByID(int staffID) throws Exception;
    boolean existsActiveAssignment(int tourScheduleID, int staffID, String roleInTour) throws Exception;
    boolean hasScheduleConflict(int staffID, LocalDate departureDate, LocalDate returnDate, Integer excludeAssignmentID) throws Exception;
    int insertAssignment(StaffAssignmentRequest request) throws Exception;
    StaffAssignmentDTO findAssignmentByID(int assignmentID) throws Exception;
    void updateAssignmentStatus(int assignmentID, String assignmentStatus, String note) throws Exception;
}

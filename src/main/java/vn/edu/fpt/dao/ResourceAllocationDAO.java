package vn.edu.fpt.dao;

import vn.edu.fpt.model.ResourceAssignmentDTO;
import vn.edu.fpt.model.ResourceAssignmentRequest;
import vn.edu.fpt.model.ResourceOptionDTO;
import vn.edu.fpt.model.TourScheduleResourceDTO;

import java.util.List;

public interface ResourceAllocationDAO {
    List<TourScheduleResourceDTO> searchSchedules(String keyword, String scheduleStatus) throws Exception;

    TourScheduleResourceDTO findScheduleByID(int tourScheduleID) throws Exception;

    List<ResourceAssignmentDTO> getAssignmentsByScheduleID(int tourScheduleID) throws Exception;

    List<ResourceOptionDTO> getActiveServices() throws Exception;

    List<ResourceOptionDTO> getAvailableVehicles() throws Exception;

    List<ResourceOptionDTO> getAvailableRooms() throws Exception;

    List<ResourceOptionDTO> getActiveMealPackages() throws Exception;

    List<ResourceOptionDTO> getWorkingDrivers() throws Exception;

    void insertAssignment(ResourceAssignmentRequest request, Integer createdByUserID) throws Exception;

    void updateAssignmentStatus(int assignmentID, String assignmentStatus) throws Exception;
}

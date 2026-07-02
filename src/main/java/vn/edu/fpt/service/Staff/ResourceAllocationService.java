package vn.edu.fpt.service.Staff;

import vn.edu.fpt.dao.ResourceAllocationDAO;
import vn.edu.fpt.dao.impl.ResourceAllocationDAOImpl;
import vn.edu.fpt.exception.BusinessException;
import vn.edu.fpt.exception.FieldValidationException;
import vn.edu.fpt.model.ResourceAssignmentDTO;
import vn.edu.fpt.model.ResourceAssignmentRequest;
import vn.edu.fpt.model.ResourceOptionDTO;
import vn.edu.fpt.model.TourScheduleResourceDTO;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class ResourceAllocationService {
    private final ResourceAllocationDAO resourceDAO = new ResourceAllocationDAOImpl();

    public List<TourScheduleResourceDTO> searchSchedules(String keyword, String status) throws Exception {
        return resourceDAO.searchSchedules(keyword, status);
    }

    public TourScheduleResourceDTO getSchedule(int tourScheduleID) throws Exception {
        TourScheduleResourceDTO schedule = resourceDAO.findScheduleByID(tourScheduleID);
        if (schedule == null) {
            throw new BusinessException("Không tìm thấy lịch khởi hành cần phân bổ tài nguyên.");
        }
        return schedule;
    }

    public List<ResourceAssignmentDTO> getAssignments(int tourScheduleID) throws Exception {
        return resourceDAO.getAssignmentsByScheduleID(tourScheduleID);
    }

    public List<ResourceOptionDTO> getActiveServices() throws Exception {
        return resourceDAO.getActiveServices();
    }

    public List<ResourceOptionDTO> getAvailableVehicles() throws Exception {
        return resourceDAO.getAvailableVehicles();
    }

    public List<ResourceOptionDTO> getAvailableRooms() throws Exception {
        return resourceDAO.getAvailableRooms();
    }

    public List<ResourceOptionDTO> getActiveMealPackages() throws Exception {
        return resourceDAO.getActiveMealPackages();
    }

    public List<ResourceOptionDTO> getWorkingDrivers() throws Exception {
        return resourceDAO.getWorkingDrivers();
    }

    public void addAssignment(ResourceAssignmentRequest request, Integer createdByUserID) throws Exception {
        Map<String, String> errors = validate(request);
        if (!errors.isEmpty()) {
            throw new FieldValidationException(errors);
        }
        resourceDAO.insertAssignment(request, createdByUserID);
    }

    public void changeAssignmentStatus(int assignmentID, String status) throws Exception {
        if (assignmentID <= 0) {
            throw new BusinessException("Không xác định được tài nguyên cần cập nhật.");
        }
        if (!"Planned".equals(status)
                && !"Confirmed".equals(status)
                && !"InUse".equals(status)
                && !"Completed".equals(status)
                && !"Cancelled".equals(status)) {
            throw new BusinessException("Trạng thái phân bổ tài nguyên không hợp lệ.");
        }
        resourceDAO.updateAssignmentStatus(assignmentID, status);
    }

    private Map<String, String> validate(ResourceAssignmentRequest request) {
        Map<String, String> errors = new LinkedHashMap<>();
        if (request.getTourScheduleID() <= 0) {
            errors.put("tourScheduleID", "Không xác định được lịch khởi hành.");
        }
        if (request.getServiceID() <= 0) {
            errors.put("serviceID", "Vui lòng chọn dịch vụ/tài nguyên.");
        }
        if (isBlank(request.getAssignmentCategory())) {
            errors.put("assignmentCategory", "Vui lòng chọn loại phân bổ.");
        }
        if (request.getQuantity() <= 0) {
            errors.put("quantity", "Số lượng phải lớn hơn 0.");
        }
        if (request.getStartDate() != null && request.getEndDate() != null
                && request.getEndDate().isBefore(request.getStartDate())) {
            errors.put("endDate", "Ngày kết thúc không được trước ngày bắt đầu.");
        }
        if ("Vehicle".equals(request.getAssignmentCategory()) && request.getVehicleID() == null) {
            errors.put("vehicleID", "Phân bổ xe cần chọn xe cụ thể.");
        }
        if ("Room".equals(request.getAssignmentCategory()) && request.getRoomID() == null) {
            errors.put("roomID", "Phân bổ phòng cần chọn phòng cụ thể.");
        }
        if ("Meal".equals(request.getAssignmentCategory()) && request.getMealPackageID() == null) {
            errors.put("mealPackageID", "Phân bổ bữa ăn cần chọn gói ăn.");
        }
        if (request.getEstimatedCost() != null && request.getEstimatedCost() < 0) {
            errors.put("estimatedCost", "Chi phí dự kiến không được âm.");
        }
        if (request.getActualCost() != null && request.getActualCost() < 0) {
            errors.put("actualCost", "Chi phí thực tế không được âm.");
        }
        if (isBlank(request.getAssignmentStatus())) {
            request.setAssignmentStatus("Planned");
        }
        return errors;
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}

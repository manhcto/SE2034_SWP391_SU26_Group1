package vn.edu.fpt.service.Staff;

import vn.edu.fpt.dao.StaffAssignmentDAO;
import vn.edu.fpt.dao.impl.StaffAssignmentDAOImpl;
import vn.edu.fpt.exception.BusinessException;
import vn.edu.fpt.exception.FieldValidationException;
import vn.edu.fpt.model.StaffAssignmentDTO;
import vn.edu.fpt.model.StaffAssignmentRequest;
import vn.edu.fpt.model.StaffAssignmentScheduleDTO;
import vn.edu.fpt.model.StaffOption;

import java.time.LocalDate;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class StaffAssignmentService {
    private final StaffAssignmentDAO staffAssignmentDAO = new StaffAssignmentDAOImpl();

    public List<StaffAssignmentScheduleDTO> searchSchedules(String keyword, String scheduleStatus) throws Exception {
        return staffAssignmentDAO.searchSchedules(keyword, scheduleStatus);
    }

    public StaffAssignmentScheduleDTO getSchedule(int tourScheduleID) throws Exception {
        StaffAssignmentScheduleDTO schedule = staffAssignmentDAO.findScheduleByID(tourScheduleID);
        if (schedule == null) {
            throw new BusinessException("Không tìm thấy lịch khởi hành cần phân công nhân sự.");
        }
        return schedule;
    }

    public List<StaffAssignmentDTO> getAssignments(int tourScheduleID) throws Exception {
        return staffAssignmentDAO.getAssignmentsByScheduleID(tourScheduleID);
    }

    public List<StaffOption> getAssignableStaff() throws Exception {
        return staffAssignmentDAO.getAssignableStaff();
    }

    public void assignStaff(StaffAssignmentRequest request) throws Exception {
        Map<String, String> errors = validateAssignRequest(request);
        if (!errors.isEmpty()) {
            throw new FieldValidationException(errors);
        }

        StaffAssignmentScheduleDTO schedule = getSchedule(request.getTourScheduleID());
        StaffOption staff = staffAssignmentDAO.findStaffByID(request.getStaffID());
        if (staff == null) {
            errors.put("staffID", "Nhân viên không tồn tại hoặc không ở trạng thái đang làm việc.");
            throw new FieldValidationException(errors);
        }

        validateBusinessRules(request, schedule, staff, errors);
        if (!errors.isEmpty()) {
            throw new FieldValidationException(errors);
        }

        staffAssignmentDAO.insertAssignment(request);
    }

    public void changeAssignmentStatus(int assignmentID, String newStatus, String note) throws Exception {
        if (assignmentID <= 0) {
            throw new BusinessException("Không xác định được nhiệm vụ cần cập nhật.");
        }
        if (!isValidStatus(newStatus)) {
            throw new BusinessException("Trạng thái nhiệm vụ không hợp lệ.");
        }

        StaffAssignmentDTO current = staffAssignmentDAO.findAssignmentByID(assignmentID);
        if (current == null) {
            throw new BusinessException("Không tìm thấy nhiệm vụ nhân sự.");
        }
        if (!canChangeStatus(current.getAssignmentStatus(), newStatus)) {
            throw new BusinessException("Không thể chuyển trạng thái từ '" + current.getStatusText() + "' sang trạng thái đã chọn.");
        }
        if (note != null && note.length() > 500) {
            throw new BusinessException("Ghi chú không được vượt quá 500 ký tự.");
        }
        staffAssignmentDAO.updateAssignmentStatus(assignmentID, newStatus, note == null ? null : note.trim());
    }

    private Map<String, String> validateAssignRequest(StaffAssignmentRequest request) {
        Map<String, String> errors = new LinkedHashMap<>();
        if (request.getTourScheduleID() <= 0) {
            errors.put("tourScheduleID", "Không xác định được lịch khởi hành.");
        }
        if (request.getStaffID() <= 0) {
            errors.put("staffID", "Vui lòng chọn nhân viên nhận nhiệm vụ.");
        }
        if (isBlank(request.getRoleInTour())) {
            errors.put("roleInTour", "Vui lòng chọn nhiệm vụ trong tour.");
        } else if (!isValidRole(request.getRoleInTour())) {
            errors.put("roleInTour", "Nhiệm vụ trong tour không hợp lệ.");
        }
        if (isBlank(request.getAssignmentStatus())) {
            request.setAssignmentStatus("Pending");
        } else if (!isValidStatus(request.getAssignmentStatus())) {
            errors.put("assignmentStatus", "Trạng thái phân công không hợp lệ.");
        }
        if (request.getNote() != null && request.getNote().length() > 500) {
            errors.put("note", "Ghi chú không được vượt quá 500 ký tự.");
        }
        return errors;
    }

    private void validateBusinessRules(StaffAssignmentRequest request,
                                       StaffAssignmentScheduleDTO schedule,
                                       StaffOption staff,
                                       Map<String, String> errors) throws Exception {
        String scheduleStatus = schedule.getScheduleStatus();
        if ("Cancelled".equals(scheduleStatus) || "Completed".equals(scheduleStatus) || "Departed".equals(scheduleStatus)) {
            errors.put("schedule", "Lịch đã hủy/hoàn thành/khởi hành nên không thể phân công thêm nhân sự.");
        }

        if (!isStaffTypeCompatible(request.getRoleInTour(), staff.getStaffType())) {
            errors.put("staffID", "Nhân viên được chọn không phù hợp với nhiệm vụ " + getRoleText(request.getRoleInTour()) + ".");
        }

        if (staffAssignmentDAO.existsActiveAssignment(request.getTourScheduleID(), request.getStaffID(), request.getRoleInTour())) {
            errors.put("staffID", "Nhân viên này đã có nhiệm vụ tương tự trong lịch khởi hành này.");
        }

        LocalDate departure = schedule.getDepartureDate().toLocalDate();
        LocalDate returning = schedule.getReturnDate().toLocalDate();
        if (staffAssignmentDAO.hasScheduleConflict(request.getStaffID(), departure, returning, null)) {
            errors.put("staffID", "Nhân viên này đã có nhiệm vụ khác bị trùng thời gian với lịch khởi hành này.");
        }
    }

    private boolean isStaffTypeCompatible(String roleInTour, String staffType) {
        if ("Guide".equals(roleInTour)) {
            return "Guide".equals(staffType);
        }
        if ("Driver".equals(roleInTour)) {
            return "Driver".equals(staffType);
        }
        if ("Coordinator".equals(roleInTour)) {
            return "Coordinator".equals(staffType) || "OperationStaff".equals(staffType) || "Staff".equals(staffType);
        }
        if ("OperationStaff".equals(roleInTour)) {
            return "OperationStaff".equals(staffType) || "Coordinator".equals(staffType) || "Staff".equals(staffType);
        }
        return true;
    }

    private boolean isValidRole(String role) {
        return "Guide".equals(role)
                || "Driver".equals(role)
                || "Coordinator".equals(role)
                || "OperationStaff".equals(role)
                || "Other".equals(role);
    }

    private boolean isValidStatus(String status) {
        return "Pending".equals(status)
                || "Accepted".equals(status)
                || "Rejected".equals(status)
                || "Cancelled".equals(status)
                || "Completed".equals(status);
    }

    private boolean canChangeStatus(String currentStatus, String newStatus) {
        if (currentStatus == null || newStatus == null) return false;
        if (currentStatus.equals(newStatus)) return true;
        if ("Pending".equals(currentStatus)) {
            return "Accepted".equals(newStatus) || "Rejected".equals(newStatus) || "Cancelled".equals(newStatus);
        }
        if ("Accepted".equals(currentStatus)) {
            return "Completed".equals(newStatus) || "Cancelled".equals(newStatus);
        }
        return false;
    }

    private String getRoleText(String role) {
        if ("Guide".equals(role)) return "Hướng dẫn viên";
        if ("Driver".equals(role)) return "Tài xế";
        if ("Coordinator".equals(role)) return "Điều phối viên";
        if ("OperationStaff".equals(role)) return "Nhân sự vận hành";
        return "Nhiệm vụ khác";
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}

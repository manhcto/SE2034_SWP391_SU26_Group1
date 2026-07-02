package vn.edu.fpt.service.Staff;

import vn.edu.fpt.dao.StaffProfileDAO;
import vn.edu.fpt.dao.impl.StaffProfileDAOImpl;
import vn.edu.fpt.exception.FieldValidationException;
import vn.edu.fpt.model.StaffProfileDTO;
import vn.edu.fpt.model.StaffProfileUpdateRequest;

import java.util.LinkedHashMap;
import java.util.Map;

public class StaffProfileService {
    private final StaffProfileDAO staffProfileDAO = new StaffProfileDAOImpl();

    public StaffProfileDTO getProfile(Integer userID) throws Exception {
        StaffProfileDTO profile = staffProfileDAO.findByUserID(userID);
        if (profile == null) {
            profile = staffProfileDAO.findDefaultWorkingStaff();
        }
        return profile;
    }

    public void updateProfile(StaffProfileUpdateRequest request) throws Exception {
        Map<String, String> errors = validate(request);
        if (!errors.isEmpty()) {
            throw new FieldValidationException(errors);
        }
        staffProfileDAO.updateProfile(request);
    }

    private Map<String, String> validate(StaffProfileUpdateRequest request) {
        Map<String, String> errors = new LinkedHashMap<>();
        if (request == null || request.getUserID() <= 0 || request.getStaffID() <= 0) {
            errors.put("profile", "Không xác định được hồ sơ cá nhân cần cập nhật.");
            return errors;
        }
        if (isBlank(request.getFirstName())) {
            errors.put("firstName", "Vui lòng nhập tên.");
        } else if (request.getFirstName().length() > 100) {
            errors.put("firstName", "Tên không được vượt quá 100 ký tự.");
        }
        if (isBlank(request.getLastName())) {
            errors.put("lastName", "Vui lòng nhập họ.");
        } else if (request.getLastName().length() > 100) {
            errors.put("lastName", "Họ không được vượt quá 100 ký tự.");
        }
        if (!isBlank(request.getPhone())) {
            if (request.getPhone().length() > 20) {
                errors.put("phone", "Số điện thoại không được vượt quá 20 ký tự.");
            } else if (!request.getPhone().matches("^[0-9+() .-]{8,20}$")) {
                errors.put("phone", "Số điện thoại chỉ nên gồm số, dấu +, khoảng trắng hoặc dấu gạch.");
            }
        }
        if (!isBlank(request.getGender())
                && !"Male".equals(request.getGender())
                && !"Female".equals(request.getGender())
                && !"Other".equals(request.getGender())) {
            errors.put("gender", "Giới tính không hợp lệ.");
        }
        if (!isBlank(request.getWorkRegion())
                && !"North".equals(request.getWorkRegion())
                && !"Central".equals(request.getWorkRegion())
                && !"South".equals(request.getWorkRegion())
                && !"All".equals(request.getWorkRegion())) {
            errors.put("workRegion", "Khu vực làm việc không hợp lệ.");
        }
        if (!isBlank(request.getPosition()) && request.getPosition().length() > 100) {
            errors.put("position", "Chức vụ không được vượt quá 100 ký tự.");
        }
        if (!isBlank(request.getLicenseNumber()) && request.getLicenseNumber().length() > 100) {
            errors.put("licenseNumber", "Số GPLX không được vượt quá 100 ký tự.");
        }
        if (!isBlank(request.getLicenseClass()) && request.getLicenseClass().length() > 50) {
            errors.put("licenseClass", "Hạng bằng lái không được vượt quá 50 ký tự.");
        }
        if (!isBlank(request.getGuideLicenseNo()) && request.getGuideLicenseNo().length() > 100) {
            errors.put("guideLicenseNo", "Số thẻ HDV không được vượt quá 100 ký tự.");
        }
        if (!isBlank(request.getLanguages()) && request.getLanguages().length() > 255) {
            errors.put("languages", "Ngôn ngữ không được vượt quá 255 ký tự.");
        }
        return errors;
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}

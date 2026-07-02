package vn.edu.fpt.controller.staff;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.fpt.exception.FieldValidationException;
import vn.edu.fpt.model.StaffProfileDTO;
import vn.edu.fpt.model.StaffProfileUpdateRequest;
import vn.edu.fpt.service.Staff.StaffProfileService;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Map;

@WebServlet(urlPatterns = {"/staff/profile"})
public class StaffProfileServlet extends HttpServlet {
    private static final String PROFILE_JSP = "/WEB-INF/views/staff/staff-profile.jsp";
    private final StaffProfileService staffProfileService = new StaffProfileService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        setUtf8(request, response);
        try {
            StaffProfileDTO profile = staffProfileService.getProfile(resolveCurrentUserID(request));
            if (profile == null) {
                request.setAttribute("systemError", "Chưa có hồ sơ nhân viên để hiển thị.");
            }
            request.setAttribute("activeMenu", "profile");
            request.setAttribute("profile", profile);
            request.getRequestDispatcher(PROFILE_JSP).forward(request, response);
        } catch (Exception ex) {
            ex.printStackTrace();
            request.setAttribute("activeMenu", "profile");
            request.setAttribute("systemError", "Không thể tải hồ sơ nhân viên. Vui lòng kiểm tra dữ liệu Staff/User.");
            request.getRequestDispatcher(PROFILE_JSP).forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        setUtf8(request, response);
        StaffProfileUpdateRequest updateRequest = buildUpdateRequest(request);
        try {
            staffProfileService.updateProfile(updateRequest);
            response.sendRedirect(request.getContextPath() + "/staff/profile?success="
                    + URLEncoder.encode("Cập nhật hồ sơ thành công.", StandardCharsets.UTF_8));
        } catch (FieldValidationException ex) {
            request.setAttribute("activeMenu", "profile");
            request.setAttribute("fieldErrors", ex.getFieldErrors());
            try {
                request.setAttribute("profile", staffProfileService.getProfile(updateRequest.getUserID()));
            } catch (Exception ignored) {
                request.setAttribute("profile", null);
            }
            request.getRequestDispatcher(PROFILE_JSP).forward(request, response);
        } catch (Exception ex) {
            ex.printStackTrace();
            request.setAttribute("activeMenu", "profile");
            request.setAttribute("systemError", "Không thể cập nhật hồ sơ nhân viên. Vui lòng thử lại.");
            try {
                request.setAttribute("profile", staffProfileService.getProfile(updateRequest.getUserID()));
            } catch (Exception ignored) {
                request.setAttribute("profile", null);
            }
            request.getRequestDispatcher(PROFILE_JSP).forward(request, response);
        }
    }

    private StaffProfileUpdateRequest buildUpdateRequest(HttpServletRequest request) {
        StaffProfileUpdateRequest dto = new StaffProfileUpdateRequest();
        dto.setUserID(parseInt(request.getParameter("userID"), 0));
        dto.setStaffID(parseInt(request.getParameter("staffID"), 0));
        dto.setFirstName(trim(request.getParameter("firstName")));
        dto.setLastName(trim(request.getParameter("lastName")));
        dto.setPhone(trim(request.getParameter("phone")));
        dto.setGender(trim(request.getParameter("gender")));
        dto.setPosition(trim(request.getParameter("position")));
        dto.setWorkRegion(trim(request.getParameter("workRegion")));
        dto.setLicenseNumber(trim(request.getParameter("licenseNumber")));
        dto.setLicenseClass(trim(request.getParameter("licenseClass")));
        dto.setGuideLicenseNo(trim(request.getParameter("guideLicenseNo")));
        dto.setLanguages(trim(request.getParameter("languages")));
        return dto;
    }

    private Integer resolveCurrentUserID(HttpServletRequest request) {
        String userIDParam = request.getParameter("userID");
        Integer fromParam = parseNullableInt(userIDParam);
        if (fromParam != null && fromParam > 0) {
            return fromParam;
        }

        HttpSession session = request.getSession(false);
        if (session == null) {
            return null;
        }

        Object value = session.getAttribute("userID");
        if (value == null) value = session.getAttribute("currentUserID");
        if (value == null) value = session.getAttribute("accountID");

        if (value instanceof Integer) return (Integer) value;
        if (value instanceof Number) return ((Number) value).intValue();
        if (value instanceof String) return parseNullableInt((String) value);
        return null;
    }

    private void setUtf8(HttpServletRequest request, HttpServletResponse response) throws IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
    }

    private int parseInt(String value, int defaultValue) {
        try {
            if (value == null || value.trim().isEmpty()) return defaultValue;
            return Integer.parseInt(value.trim());
        } catch (NumberFormatException ex) {
            return defaultValue;
        }
    }

    private Integer parseNullableInt(String value) {
        try {
            if (value == null || value.trim().isEmpty()) return null;
            return Integer.parseInt(value.trim());
        } catch (NumberFormatException ex) {
            return null;
        }
    }

    private String trim(String value) {
        return value == null ? null : value.trim();
    }
}

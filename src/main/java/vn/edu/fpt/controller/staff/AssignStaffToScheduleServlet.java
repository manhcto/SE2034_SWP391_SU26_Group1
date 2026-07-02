package vn.edu.fpt.controller.staff;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.fpt.exception.FieldValidationException;
import vn.edu.fpt.model.StaffAssignmentRequest;
import vn.edu.fpt.service.Staff.StaffAssignmentService;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;

@WebServlet(urlPatterns = {"/staff/assignments/detail"})
public class AssignStaffToScheduleServlet extends HttpServlet {
    private static final String DETAIL_JSP = "/WEB-INF/views/staff/staff-assignment-detail.jsp";
    private final StaffAssignmentService staffAssignmentService = new StaffAssignmentService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        setUtf8(request, response);
        int tourScheduleID = parseInt(request.getParameter("tourScheduleID"), 0);
        forwardDetail(request, response, tourScheduleID);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        setUtf8(request, response);
        StaffAssignmentRequest assignmentRequest = buildRequest(request);
        try {
            staffAssignmentService.assignStaff(assignmentRequest);
            redirectToDetail(request, response, assignmentRequest.getTourScheduleID(), "success", "Đã phân công nhân sự cho lịch khởi hành.");
        } catch (FieldValidationException ex) {
            request.setAttribute("fieldErrors", ex.getFieldErrors());
            request.setAttribute("old", assignmentRequest);
            forwardDetail(request, response, assignmentRequest.getTourScheduleID());
        } catch (Exception ex) {
            ex.printStackTrace();
            request.setAttribute("systemError", ex.getMessage() == null ? "Không thể phân công nhân sự." : ex.getMessage());
            request.setAttribute("old", assignmentRequest);
            forwardDetail(request, response, assignmentRequest.getTourScheduleID());
        }
    }

    private void forwardDetail(HttpServletRequest request, HttpServletResponse response, int tourScheduleID)
            throws ServletException, IOException {
        try {
            request.setAttribute("activeMenu", "staffAssignments");
            request.setAttribute("schedule", staffAssignmentService.getSchedule(tourScheduleID));
            request.setAttribute("assignments", staffAssignmentService.getAssignments(tourScheduleID));
            request.setAttribute("staffOptions", staffAssignmentService.getAssignableStaff());
        } catch (Exception ex) {
            ex.printStackTrace();
            request.setAttribute("activeMenu", "staffAssignments");
            request.setAttribute("assignments", new ArrayList<>());
            request.setAttribute("staffOptions", new ArrayList<>());
            request.setAttribute("systemError", ex.getMessage() == null ? "Không thể tải dữ liệu phân công nhân sự." : ex.getMessage());
        }
        request.getRequestDispatcher(DETAIL_JSP).forward(request, response);
    }

    private StaffAssignmentRequest buildRequest(HttpServletRequest request) {
        StaffAssignmentRequest dto = new StaffAssignmentRequest();
        dto.setTourScheduleID(parseInt(request.getParameter("tourScheduleID"), 0));
        dto.setStaffID(parseInt(request.getParameter("staffID"), 0));
        dto.setRoleInTour(trim(request.getParameter("roleInTour")));
        dto.setAssignmentStatus(trimOrDefault(request.getParameter("assignmentStatus"), "Pending"));
        dto.setNote(trim(request.getParameter("note")));
        return dto;
    }

    private void redirectToDetail(HttpServletRequest request, HttpServletResponse response,
                                  int tourScheduleID, String paramName, String message) throws IOException {
        response.sendRedirect(request.getContextPath()
                + "/staff/assignments/detail?tourScheduleID=" + tourScheduleID
                + "&" + paramName + "=" + URLEncoder.encode(message, StandardCharsets.UTF_8));
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

    private String trim(String value) {
        return value == null ? null : value.trim();
    }

    private String trimOrDefault(String value, String defaultValue) {
        String trimmed = trim(value);
        return trimmed == null || trimmed.isEmpty() ? defaultValue : trimmed;
    }
}

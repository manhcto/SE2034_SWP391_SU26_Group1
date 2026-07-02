package vn.edu.fpt.controller.staff;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.fpt.service.Staff.StaffAssignmentService;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebServlet(urlPatterns = {"/staff/assignments/status"})
public class ChangeStaffAssignmentStatusServlet extends HttpServlet {
    private final StaffAssignmentService staffAssignmentService = new StaffAssignmentService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        setUtf8(request, response);
        int assignmentID = parseInt(request.getParameter("assignmentID"), 0);
        int tourScheduleID = parseInt(request.getParameter("tourScheduleID"), 0);
        String status = trim(request.getParameter("assignmentStatus"));
        String note = trim(request.getParameter("note"));
        try {
            staffAssignmentService.changeAssignmentStatus(assignmentID, status, note);
            redirect(request, response, tourScheduleID, "success", "Đã cập nhật trạng thái nhiệm vụ.");
        } catch (Exception ex) {
            ex.printStackTrace();
            redirect(request, response, tourScheduleID, "error", ex.getMessage() == null ? "Không thể cập nhật trạng thái nhiệm vụ." : ex.getMessage());
        }
    }

    private void redirect(HttpServletRequest request, HttpServletResponse response,
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
}

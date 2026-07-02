package vn.edu.fpt.controller.resource;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.fpt.service.Staff.ResourceAllocationService;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebServlet(urlPatterns = {"/staff/resources/status"})
public class ChangeResourceAssignmentStatusServlet extends HttpServlet {
    private final ResourceAllocationService resourceService = new ResourceAllocationService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        int tourScheduleID = parseInt(request.getParameter("tourScheduleID"), 0);
        int assignmentID = parseInt(request.getParameter("assignmentID"), 0);
        String status = trimOrDefault(request.getParameter("assignmentStatus"), "Cancelled");

        try {
            resourceService.changeAssignmentStatus(assignmentID, status);
            redirect(request, response, tourScheduleID, "success", "Đã cập nhật trạng thái tài nguyên.");
        } catch (Exception ex) {
            ex.printStackTrace();
            redirect(request, response, tourScheduleID, "error", "Không thể cập nhật trạng thái tài nguyên.");
        }
    }

    private void redirect(HttpServletRequest request, HttpServletResponse response,
                          int tourScheduleID, String key, String message) throws IOException {
        response.sendRedirect(request.getContextPath()
                + "/staff/resources/assign?tourScheduleID=" + tourScheduleID
                + "&" + key + "=" + URLEncoder.encode(message, StandardCharsets.UTF_8));
    }

    private int parseInt(String value, int defaultValue) {
        try {
            if (value == null || value.trim().isEmpty()) return defaultValue;
            return Integer.parseInt(value.trim());
        } catch (NumberFormatException ex) {
            return defaultValue;
        }
    }

    private String trimOrDefault(String value, String defaultValue) {
        String trimmed = value == null ? null : value.trim();
        return trimmed == null || trimmed.isEmpty() ? defaultValue : trimmed;
    }
}

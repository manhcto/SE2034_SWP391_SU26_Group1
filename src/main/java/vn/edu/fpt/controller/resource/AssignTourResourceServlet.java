package vn.edu.fpt.controller.resource;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.fpt.exception.FieldValidationException;
import vn.edu.fpt.model.ResourceAssignmentRequest;
import vn.edu.fpt.service.Staff.ResourceAllocationService;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.util.ArrayList;

@WebServlet(urlPatterns = {"/staff/resources/assign"})
public class AssignTourResourceServlet extends HttpServlet {
    private static final String DETAIL_JSP = "/WEB-INF/views/staff/resource-allocation-detail.jsp";
    private final ResourceAllocationService resourceService = new ResourceAllocationService();

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
        ResourceAssignmentRequest assignmentRequest = buildRequest(request);
        try {
            resourceService.addAssignment(assignmentRequest, null);
            redirectToDetail(request, response, assignmentRequest.getTourScheduleID(), "success", "Đã thêm phân bổ tài nguyên.");
        } catch (FieldValidationException ex) {
            request.setAttribute("fieldErrors", ex.getFieldErrors());
            request.setAttribute("old", assignmentRequest);
            forwardDetail(request, response, assignmentRequest.getTourScheduleID());
        } catch (Exception ex) {
            ex.printStackTrace();
            request.setAttribute("systemError", "Không thể thêm phân bổ tài nguyên. Vui lòng kiểm tra dữ liệu và thử lại.");
            request.setAttribute("old", assignmentRequest);
            forwardDetail(request, response, assignmentRequest.getTourScheduleID());
        }
    }

    private void forwardDetail(HttpServletRequest request, HttpServletResponse response, int tourScheduleID)
            throws ServletException, IOException {
        try {
            request.setAttribute("activeMenu", "resources");
            request.setAttribute("schedule", resourceService.getSchedule(tourScheduleID));
            request.setAttribute("assignments", resourceService.getAssignments(tourScheduleID));
            request.setAttribute("services", resourceService.getActiveServices());
            request.setAttribute("vehicles", resourceService.getAvailableVehicles());
            request.setAttribute("rooms", resourceService.getAvailableRooms());
            request.setAttribute("mealPackages", resourceService.getActiveMealPackages());
            request.setAttribute("drivers", resourceService.getWorkingDrivers());
        } catch (Exception ex) {
            ex.printStackTrace();
            request.setAttribute("activeMenu", "resources");
            request.setAttribute("assignments", new ArrayList<>());
            request.setAttribute("services", new ArrayList<>());
            request.setAttribute("vehicles", new ArrayList<>());
            request.setAttribute("rooms", new ArrayList<>());
            request.setAttribute("mealPackages", new ArrayList<>());
            request.setAttribute("drivers", new ArrayList<>());
            request.setAttribute("systemError", "Không thể tải dữ liệu phân bổ tài nguyên.");
        }
        request.getRequestDispatcher(DETAIL_JSP).forward(request, response);
    }

    private ResourceAssignmentRequest buildRequest(HttpServletRequest request) {
        ResourceAssignmentRequest dto = new ResourceAssignmentRequest();
        dto.setTourScheduleID(parseInt(request.getParameter("tourScheduleID"), 0));
        dto.setServiceID(parseInt(request.getParameter("serviceID"), 0));
        dto.setAssignmentCategory(trim(request.getParameter("assignmentCategory")));
        dto.setServiceDate(parseDate(request.getParameter("serviceDate")));
        dto.setStartDate(parseDate(request.getParameter("startDate")));
        dto.setEndDate(parseDate(request.getParameter("endDate")));
        dto.setVehicleID(parseNullableInt(request.getParameter("vehicleID")));
        dto.setDriverStaffID(parseNullableInt(request.getParameter("driverStaffID")));
        dto.setRoomID(parseNullableInt(request.getParameter("roomID")));
        dto.setMealPackageID(parseNullableInt(request.getParameter("mealPackageID")));
        dto.setQuantity(parseInt(request.getParameter("quantity"), 1));
        dto.setParticipantEstimate(parseNullableInt(request.getParameter("participantEstimate")));
        dto.setEstimatedCost(parseMoneyNullable(request.getParameter("estimatedCost")));
        dto.setActualCost(parseMoneyNullable(request.getParameter("actualCost")));
        dto.setAssignmentStatus(trimOrDefault(request.getParameter("assignmentStatus"), "Planned"));
        dto.setNote(trim(request.getParameter("note")));
        return dto;
    }

    private void redirectToDetail(HttpServletRequest request, HttpServletResponse response,
                                  int tourScheduleID, String paramName, String message) throws IOException {
        response.sendRedirect(request.getContextPath()
                + "/staff/resources/assign?tourScheduleID=" + tourScheduleID
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

    private Integer parseNullableInt(String value) {
        try {
            if (value == null || value.trim().isEmpty()) return null;
            return Integer.parseInt(value.trim());
        } catch (NumberFormatException ex) {
            return null;
        }
    }

    private Integer parseMoneyNullable(String value) {
        if (value == null || value.trim().isEmpty()) return null;
        return parseInt(value.replace(".", "").replace(",", "").replace("VND", "").replace("₫", "").trim(), 0);
    }

    private LocalDate parseDate(String value) {
        try {
            if (value == null || value.trim().isEmpty()) return null;
            return LocalDate.parse(value.trim());
        } catch (Exception ex) {
            return null;
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

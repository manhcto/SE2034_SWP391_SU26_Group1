package vn.edu.fpt.controller.staff;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.fpt.DAO.AssignmentDAOImpl;
import vn.edu.fpt.DAO.BookingTravelerDAO;
import vn.edu.fpt.DAO.ItineraryLogDAO;
import vn.edu.fpt.model.AssignmentView;
import vn.edu.fpt.model.TourAssignments;
import vn.edu.fpt.model.User;

import java.io.IOException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeParseException;

@WebServlet(name = "ManageAssignmentTourController", urlPatterns = {"/staff/assignment", "/staff/tour-assignment"})
public class ManageAssignmentTourController extends HttpServlet {

    private AssignmentDAOImpl assignmentDAO;
    private BookingTravelerDAO travelerDAO;
    private ItineraryLogDAO itineraryLogDAO;

    @Override
    public void init() {
        assignmentDAO = new AssignmentDAOImpl();
        travelerDAO = new BookingTravelerDAO();
        itineraryLogDAO = new ItineraryLogDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        String action = trimToDefault(request.getParameter("action"), "list");

        switch (action) {
            case "create" -> showAddTourAssignment(request, response);
            case "edit" -> showEditTourAssignment(request, response);
            case "view" -> showViewTourAssignment(request, response);
            case "list" -> showListTourAssignment(request, response);
            case "insert", "delete", "update" -> response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
            default -> showListTourAssignment(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws IOException {

        request.setCharacterEncoding("UTF-8");
        String action = trimToDefault(request.getParameter("action"), "list");

        switch (action) {
            case "insert" -> addTourAssignment(request, response);
            case "update" -> editTourAssignment(request, response);
            case "delete" -> deleteTourAssignment(request, response);
            default -> response.sendRedirect(request.getContextPath() + "/staff/assignment");
        }
    }

    private void showListTourAssignment(HttpServletRequest request,
                                        HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("keyword");
        String status = request.getParameter("status");

        request.setAttribute("assignmentList", assignmentDAO.getAllAssignments(keyword, status));
        request.setAttribute("scheduleList", assignmentDAO.getConfirmedSchedulesForAssignment(keyword));
        request.setAttribute("keyword", keyword);
        request.setAttribute("status", status);

        request.getRequestDispatcher("/views/staff/tour-assignment-list.jsp")
                .forward(request, response);
    }

    private void showAddTourAssignment(HttpServletRequest request,
                                       HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute("scheduleList", assignmentDAO.getConfirmedSchedulesForAssignment(request.getParameter("keyword")));
        request.setAttribute("guideList", assignmentDAO.getAllGuides());

        request.getRequestDispatcher("/views/staff/tour-assignment-create.jsp")
                .forward(request, response);
    }

    private void addTourAssignment(HttpServletRequest request,
                                   HttpServletResponse response)
            throws IOException {

        int tourScheduleID = parseRequiredInt(request.getParameter("tourScheduleID"));
        int guideID = parseRequiredInt(request.getParameter("userID"));

        if (tourScheduleID <= 0 || guideID <= 0) {
            response.sendRedirect(request.getContextPath() + "/staff/assignment?action=create&error=missing");
            return;
        }

        if (!assignmentDAO.isGuideAvailable(guideID, tourScheduleID, 0)) {
            response.sendRedirect(request.getContextPath() + "/staff/assignment?action=create&error=guideBusy");
            return;
        }

        TourAssignments assignment = buildAssignmentFromRequest(request);
        assignment.setTourScheduleID(tourScheduleID);
        assignment.setUserID(guideID);
        assignment.setBookingID(parseOptionalInt(request.getParameter("bookingID")));

        boolean inserted = assignmentDAO.addAssignment(assignment);
        response.sendRedirect(request.getContextPath()
                + "/staff/assignment"
                + (inserted ? "?success=insert" : "?error=insert"));
    }

    private void showEditTourAssignment(HttpServletRequest request,
                                        HttpServletResponse response)
            throws ServletException, IOException {

        int id = parseRequiredInt(request.getParameter("id"));
        TourAssignments assignment = assignmentDAO.getAssignmentById(id);

        if (assignment == null) {
            response.sendRedirect(request.getContextPath() + "/staff/assignment?error=notFound");
            return;
        }

        request.setAttribute("assignment", assignment);
        request.setAttribute("assignmentDetail", assignmentDAO.getAssignmentDetail(id));
        request.setAttribute("scheduleDetail", assignmentDAO.getScheduleById(assignment.getTourScheduleID()));
        request.setAttribute("guideList", assignmentDAO.getAllGuides());

        request.getRequestDispatcher("/views/staff/tour-assignment-edit.jsp")
                .forward(request, response);
    }

    private void editTourAssignment(HttpServletRequest request,
                                    HttpServletResponse response)
            throws IOException {

        int assignmentID = parseRequiredInt(request.getParameter("assignmentID"));
        int tourScheduleID = parseRequiredInt(request.getParameter("tourScheduleID"));
        int guideID = parseRequiredInt(request.getParameter("userID"));

        if (assignmentID <= 0 || tourScheduleID <= 0 || guideID <= 0) {
            response.sendRedirect(request.getContextPath() + "/staff/assignment?error=missing");
            return;
        }

        if (!assignmentDAO.isGuideAvailable(guideID, tourScheduleID, assignmentID)) {
            response.sendRedirect(request.getContextPath()
                    + "/staff/assignment?action=edit&id=" + assignmentID + "&error=guideBusy");
            return;
        }

        TourAssignments assignment = buildAssignmentFromRequest(request);
        assignment.setAssignmentID(assignmentID);
        assignment.setTourScheduleID(tourScheduleID);
        assignment.setUserID(guideID);
        assignment.setBookingID(parseOptionalInt(request.getParameter("bookingID")));
        assignment.setActualStartAt(parseDateTime(request.getParameter("actualStartAt")));
        assignment.setActualEndAt(parseDateTime(request.getParameter("actualEndAt")));
        assignment.setRejectionReason(trimToNull(request.getParameter("rejectionReason")));

        boolean updated = assignmentDAO.updateAssignment(assignment);
        response.sendRedirect(request.getContextPath()
                + "/staff/assignment"
                + (updated ? "?success=update" : "?error=update"));
    }

    private void showViewTourAssignment(HttpServletRequest request,
                                        HttpServletResponse response)
            throws ServletException, IOException {

        int id = parseRequiredInt(request.getParameter("id"));
        AssignmentView assignment = assignmentDAO.getAssignmentDetail(id);

        if (assignment == null) {
            response.sendRedirect(request.getContextPath() + "/staff/assignment?error=notFound");
            return;
        }

        request.setAttribute("assignment", assignment);
        request.setAttribute("travelerList", travelerDAO.getTravelersByAssignment(id));
        request.setAttribute("progressLogs", itineraryLogDAO.getLogsByAssignment(id));

        request.getRequestDispatcher("/views/staff/tour-assignment-view.jsp")
                .forward(request, response);
    }

    private void deleteTourAssignment(HttpServletRequest request,
                                      HttpServletResponse response)
            throws IOException {

        int id = parseRequiredInt(request.getParameter("id"));
        boolean deleted = id > 0 && assignmentDAO.deleteAssignment(id);

        response.sendRedirect(request.getContextPath()
                + "/staff/assignment"
                + (deleted ? "?success=delete" : "?error=delete"));
    }

    private TourAssignments buildAssignmentFromRequest(HttpServletRequest request) {
        TourAssignments assignment = new TourAssignments();

        assignment.setRoleInTour(trimToDefault(request.getParameter("roleInTour"), "Tour Guide"));
        assignment.setAssignedBy(getCurrentUserID(request));
        assignment.setAssignmentStatus(normalizeAssignmentStatus(request.getParameter("assignmentStatus")));
        assignment.setPriorityLevel(normalizePriorityLevel(request.getParameter("priorityLevel")));
        assignment.setMeetingPoint(trimToNull(request.getParameter("meetingPoint")));
        assignment.setPickupTime(parseDateTime(request.getParameter("pickupTime")));
        assignment.setCheckInDeadline(parseDateTime(request.getParameter("checkInDeadline")));
        assignment.setStaffNote(trimToNull(request.getParameter("staffNote")));
        assignment.setGuideNote(trimToNull(request.getParameter("guideNote")));
        assignment.setCustomerNote(trimToNull(request.getParameter("customerNote")));

        return assignment;
    }

    private String normalizeAssignmentStatus(String status) {
        if (status == null) {
            return "Pending";
        }

        return switch (status.trim()) {
            case "Pending", "Accepted", "Confirmed", "In Progress", "Completed", "Cancelled", "Rejected" -> status.trim();
            default -> "Pending";
        };
    }

    private String normalizePriorityLevel(String priorityLevel) {
        if (priorityLevel == null) {
            return "Normal";
        }

        return switch (priorityLevel.trim()) {
            case "Low", "Normal", "High", "Urgent" -> priorityLevel.trim();
            default -> "Normal";
        };
    }

    private Timestamp parseDateTime(String raw) {
        String value = trimToNull(raw);

        if (value == null) {
            return null;
        }

        try {
            return Timestamp.valueOf(LocalDateTime.parse(value));
        } catch (DateTimeParseException ex) {
            return null;
        }
    }

    private int parseRequiredInt(String raw) {
        try {
            return Integer.parseInt(trimToDefault(raw, "0"));
        } catch (NumberFormatException ex) {
            return 0;
        }
    }

    private int parseOptionalInt(String raw) {
        return parseRequiredInt(raw);
    }

    private String trimToDefault(String value, String fallback) {
        String trimmed = trimToNull(value);
        return trimmed == null ? fallback : trimmed;
    }

    private String trimToNull(String value) {
        if (value == null || value.trim().isEmpty()) {
            return null;
        }

        return value.trim();
    }

    private int getCurrentUserID(HttpServletRequest request) {
        HttpSession session = request.getSession(false);

        if (session == null) {
            return 0;
        }

        Object user = session.getAttribute("user");

        if (user instanceof User currentUser) {
            return currentUser.getUserID();
        }

        return 0;
    }
}

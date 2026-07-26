package vn.edu.fpt.controller.staff;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.fpt.DAO.AssignmentDAOImpl;
import vn.edu.fpt.model.AssignmentView;
import vn.edu.fpt.model.TourAssignments;
import vn.edu.fpt.model.User;

import java.io.IOException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeParseException;
import java.util.List;

@WebServlet(name = "ManageAssignmentTourController", urlPatterns = {"/staff/assignment"})
public class ManageAssignmentTourController extends HttpServlet {

    private AssignmentDAOImpl assignmentDAO;

    @Override
    public void init() {
        assignmentDAO = new AssignmentDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "list" -> listAssignment(request, response);
            case "view" -> viewAssignment(request, response);
            case "create" -> showCreateForm(request, response);
            case "edit" -> showEditForm(request, response);
            case "insert", "delete", "update" -> response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
            default -> listAssignment(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws IOException {

        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        if ("insert".equals(action)) {
            insertAssignment(request, response);
            return;
        }

        if ("update".equals(action)) {
            updateAssignment(request, response);
            return;
        }

        if ("delete".equals(action)) {
            deleteAssignment(request, response);
            return;
        }

        response.sendRedirect(request.getContextPath() + "/staff/assignment");
    }

    private void listAssignment(HttpServletRequest request,
                                HttpServletResponse response)
            throws ServletException, IOException {

        List<AssignmentView> list = assignmentDAO.getAllAssignments();

        request.setAttribute("assignmentList", list);
        request.getRequestDispatcher("/views/staff/assignment-management.jsp")
                .forward(request, response);
    }

    private void viewAssignment(HttpServletRequest request,
                                HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        AssignmentView assignment = assignmentDAO.getAssignmentDetail(id);

        if (assignment == null) {
            response.sendRedirect(request.getContextPath() + "/staff/assignment?error=notFound");
            return;
        }

        request.setAttribute("staffAssignmentLocked", isStaffLockedAssignmentStatus(assignment.getAssignmentStatus()));
        request.setAttribute("assignment", assignment);
        request.getRequestDispatcher("/views/staff/assignment-view.jsp")
                .forward(request, response);
    }

    private void showCreateForm(HttpServletRequest request,
                                HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute("bookingList", assignmentDAO.getAllBookingsForAssignment());
        request.setAttribute("guideList", assignmentDAO.getAllGuides());

        request.getRequestDispatcher("/views/staff/assignment-create.jsp")
                .forward(request, response);
    }

    private void insertAssignment(HttpServletRequest request,
                                  HttpServletResponse response)
            throws IOException {

        int bookingID = Integer.parseInt(request.getParameter("bookingID"));
        int guideID = Integer.parseInt(request.getParameter("userID"));
        int tourScheduleID = assignmentDAO.getTourScheduleIDByBookingID(bookingID);

        if (tourScheduleID == -1) {
            response.sendRedirect(
                    request.getContextPath()
                            + "/staff/assignment?action=create&error=notFoundSchedule"
            );
            return;
        }

        if (!assignmentDAO.isCompletedTourBookingForAssignment(bookingID)) {
            response.sendRedirect(
                    request.getContextPath()
                            + "/staff/assignment?action=create&error=notCompletedBooking"
            );
            return;
        }

        if (assignmentDAO.hasAssignmentForSameTourCustomer(tourScheduleID, bookingID, 0)) {
            response.sendRedirect(
                    request.getContextPath()
                            + "/staff/assignment?action=create&error=duplicateCustomer"
            );
            return;
        }

        if (assignmentDAO.hasAssignmentForSameTourGuide(tourScheduleID, guideID, 0)) {
            response.sendRedirect(
                    request.getContextPath()
                            + "/staff/assignment?action=create&error=duplicateGuide"
            );
            return;
        }

        if (assignmentDAO.hasOverlappingAssignmentForGuide(tourScheduleID, guideID, 0)) {
            response.sendRedirect(
                    request.getContextPath()
                            + "/staff/assignment?action=create&error=guideScheduleOverlap"
            );
            return;
        }

        TourAssignments assignment = buildAssignmentFromRequest(request);

        assignment.setTourScheduleID(tourScheduleID);
        assignment.setBookingID(bookingID);
        assignment.setUserID(guideID);
        applyScheduledCheckpoints(assignment, tourScheduleID);

        boolean inserted = assignmentDAO.addAssignment(assignment);

        if (!inserted) {
            response.sendRedirect(
                    request.getContextPath()
                            + "/staff/assignment?action=create&error=insertFailed"
            );
            return;
        }

        response.sendRedirect(request.getContextPath() + "/staff/assignment?success=insert");
    }

    private void deleteAssignment(HttpServletRequest request,
                                  HttpServletResponse response)
            throws IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        TourAssignments assignment = assignmentDAO.getAssignmentById(id);

        if (assignment == null) {
            response.sendRedirect(request.getContextPath() + "/staff/assignment?error=notFound");
            return;
        }

        if (isStaffLockedAssignmentStatus(assignment.getAssignmentStatus())) {
            response.sendRedirect(request.getContextPath() + "/staff/assignment?error=assignmentLocked");
            return;
        }

        boolean deleted = assignmentDAO.deleteAssignment(id);

        response.sendRedirect(
                request.getContextPath()
                        + "/staff/assignment"
                        + (deleted ? "?success=delete" : "?error=deleteFailed")
        );
    }

    private void showEditForm(HttpServletRequest request,
                              HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        TourAssignments assignment = assignmentDAO.getAssignmentById(id);

        if (assignment == null) {
            response.sendRedirect(request.getContextPath() + "/staff/assignment?error=notFound");
            return;
        }

        if (isStaffLockedAssignmentStatus(assignment.getAssignmentStatus())) {
            response.sendRedirect(request.getContextPath() + "/staff/assignment?error=assignmentLocked");
            return;
        }

        AssignmentView assignmentDetail = assignmentDAO.getAssignmentDetail(id);
        applyScheduledCheckpoints(assignment, assignment.getTourScheduleID());
        if (assignmentDetail != null) {
            assignmentDetail.setPickupTime(assignment.getPickupTime());
            assignmentDetail.setCheckInDeadline(assignment.getCheckInDeadline());
        }

        request.setAttribute("assignment", assignment);
        request.setAttribute("assignmentDetail", assignmentDetail);
        request.setAttribute("guideList", assignmentDAO.getAllGuides());

        request.getRequestDispatcher("/views/staff/assignment-edit.jsp")
                .forward(request, response);
    }

    private void updateAssignment(HttpServletRequest request,
                                  HttpServletResponse response)
            throws IOException {

        int assignmentID = Integer.parseInt(request.getParameter("assignmentID"));
        int tourScheduleID = Integer.parseInt(request.getParameter("tourScheduleID"));
        int userID = Integer.parseInt(request.getParameter("userID"));

        TourAssignments existing = assignmentDAO.getAssignmentById(assignmentID);

        if (existing == null) {
            response.sendRedirect(request.getContextPath() + "/staff/assignment?error=notFound");
            return;
        }

        if (isStaffLockedAssignmentStatus(existing.getAssignmentStatus())) {
            response.sendRedirect(request.getContextPath() + "/staff/assignment?error=assignmentLocked");
            return;
        }

        int bookingID = parseOptionalInt(request.getParameter("bookingID"));

        if (assignmentDAO.hasAssignmentForSameTourCustomer(tourScheduleID, bookingID, assignmentID)) {
            response.sendRedirect(
                    request.getContextPath()
                            + "/staff/assignment?action=edit&id=" + assignmentID + "&error=duplicateCustomer"
            );
            return;
        }

        if (assignmentDAO.hasAssignmentForSameTourGuide(tourScheduleID, userID, assignmentID)) {
            response.sendRedirect(
                    request.getContextPath()
                            + "/staff/assignment?action=edit&id=" + assignmentID + "&error=duplicateGuide"
            );
            return;
        }

        if (assignmentDAO.hasOverlappingAssignmentForGuide(tourScheduleID, userID, assignmentID)) {
            response.sendRedirect(
                    request.getContextPath()
                            + "/staff/assignment?action=edit&id=" + assignmentID + "&error=guideScheduleOverlap"
            );
            return;
        }

        TourAssignments assignment = buildAssignmentFromRequest(request, existing);

        assignment.setAssignmentID(assignmentID);
        assignment.setTourScheduleID(tourScheduleID);
        assignment.setUserID(userID);
        assignment.setBookingID(bookingID);
        assignment.setActualStartAt(existing.getActualStartAt());
        assignment.setActualEndAt(existing.getActualEndAt());
        assignment.setRejectionReason(existing.getRejectionReason());
        applyScheduledCheckpoints(assignment, tourScheduleID);

        boolean updated = assignmentDAO.updateAssignment(assignment);

        if (!updated) {
            response.sendRedirect(
                    request.getContextPath()
                            + "/staff/assignment?action=edit&id=" + assignmentID + "&error=updateFailed"
            );
            return;
        }

        response.sendRedirect(request.getContextPath() + "/staff/assignment?success=update");
    }

    private TourAssignments buildAssignmentFromRequest(HttpServletRequest request) {
        return buildAssignmentFromRequest(request, null);
    }

    private TourAssignments buildAssignmentFromRequest(HttpServletRequest request, TourAssignments existing) {
        TourAssignments assignment = new TourAssignments();

        assignment.setRoleInTour(resolveRoleInTour(request, existing));
        assignment.setAssignedBy(getCurrentUserID(request));
        assignment.setAssignmentStatus(resolveAssignmentStatus(request, existing));
        assignment.setPriorityLevel(resolvePriorityLevel(request, existing));
        assignment.setMeetingPoint(trimToNull(request.getParameter("meetingPoint")));
        assignment.setPickupTime(parseDateTime(request.getParameter("pickupTime")));
        assignment.setCheckInDeadline(parseDateTime(request.getParameter("checkInDeadline")));
        assignment.setStaffNote(resolveTextField(request, "staffNote", existing == null ? null : existing.getStaffNote()));
        assignment.setGuideNote(resolveTextField(request, "guideNote", existing == null ? null : existing.getGuideNote()));
        assignment.setCustomerNote(resolveTextField(request, "customerNote", existing == null ? null : existing.getCustomerNote()));

        return assignment;
    }

    private void applyScheduledCheckpoints(TourAssignments assignment, int tourScheduleID) {
        Timestamp departureAt = assignmentDAO.getScheduleDepartureAt(tourScheduleID);

        if (departureAt == null) {
            assignment.setPickupTime(null);
            assignment.setCheckInDeadline(null);
            return;
        }

        LocalDateTime departureTime = departureAt.toLocalDateTime();
        assignment.setPickupTime(Timestamp.valueOf(departureTime.minusMinutes(30)));
        assignment.setCheckInDeadline(Timestamp.valueOf(departureTime.minusMinutes(10)));
    }

    private String resolveRoleInTour(HttpServletRequest request, TourAssignments existing) {
        if (!hasParameter(request, "roleInTour") && existing != null) {
            return normalizeRoleInTour(existing.getRoleInTour());
        }

        return normalizeRoleInTour(request.getParameter("roleInTour"));
    }

    private String resolveAssignmentStatus(HttpServletRequest request, TourAssignments existing) {
        if (!hasParameter(request, "assignmentStatus") && existing != null) {
            return normalizeAssignmentStatus(existing.getAssignmentStatus());
        }

        return normalizeAssignmentStatus(request.getParameter("assignmentStatus"));
    }

    private String resolvePriorityLevel(HttpServletRequest request, TourAssignments existing) {
        if (!hasParameter(request, "priorityLevel") && existing != null) {
            return normalizePriorityLevel(existing.getPriorityLevel());
        }

        return normalizePriorityLevel(request.getParameter("priorityLevel"));
    }

    private String resolveTextField(HttpServletRequest request, String parameterName, String existingValue) {
        if (!hasParameter(request, parameterName)) {
            return existingValue;
        }

        return trimToNull(request.getParameter(parameterName));
    }

    private boolean hasParameter(HttpServletRequest request, String parameterName) {
        return request.getParameterMap().containsKey(parameterName);
    }

    private boolean isStaffLockedAssignmentStatus(String status) {
        if (status == null) {
            return false;
        }

        return switch (status.trim()) {
            case "Accepted", "Confirmed", "In Progress", "Completed" -> true;
            default -> false;
        };
    }

    private String normalizeRoleInTour(String roleInTour) {
        if (roleInTour == null || roleInTour.trim().isEmpty()) {
            return "Hướng dẫn viên";
        }

        return roleInTour.trim();
    }

    private String normalizeAssignmentStatus(String status) {
        if (status == null) {
            return "Pending";
        }

        return switch (status.trim()) {
            case "Accepted", "Confirmed", "In Progress", "Completed", "Cancelled", "Rejected" -> status.trim();
            default -> "Pending";
        };
    }

    private String normalizePriorityLevel(String priorityLevel) {
        if (priorityLevel == null) {
            return "Normal";
        }

        return switch (priorityLevel.trim()) {
            case "Low", "High", "Urgent" -> priorityLevel.trim();
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

    private int parseOptionalInt(String raw) {
        String value = trimToNull(raw);

        if (value == null) {
            return 0;
        }

        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException ex) {
            return 0;
        }
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

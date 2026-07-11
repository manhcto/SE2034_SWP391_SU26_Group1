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

        TourAssignments assignment = buildAssignmentFromRequest(request);

        assignment.setTourScheduleID(tourScheduleID);
        assignment.setBookingID(bookingID);
        assignment.setUserID(guideID);

        assignmentDAO.addAssignment(assignment);

        response.sendRedirect(request.getContextPath() + "/staff/assignment?success=insert");
    }

    private void deleteAssignment(HttpServletRequest request,
                                  HttpServletResponse response)
            throws IOException {

        int id = Integer.parseInt(request.getParameter("id"));

        assignmentDAO.deleteAssignment(id);
        response.sendRedirect(request.getContextPath() + "/staff/assignment?success=delete");
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

        AssignmentView assignmentDetail = assignmentDAO.getAssignmentDetail(id);

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

        TourAssignments assignment = buildAssignmentFromRequest(request);

        assignment.setAssignmentID(assignmentID);
        assignment.setTourScheduleID(tourScheduleID);
        assignment.setUserID(userID);
        assignment.setBookingID(parseOptionalInt(request.getParameter("bookingID")));
        assignment.setActualStartAt(parseDateTime(request.getParameter("actualStartAt")));
        assignment.setActualEndAt(parseDateTime(request.getParameter("actualEndAt")));
        assignment.setRejectionReason(trimToNull(request.getParameter("rejectionReason")));

        assignmentDAO.updateAssignment(assignment);

        response.sendRedirect(request.getContextPath() + "/staff/assignment?success=update");
    }

    private TourAssignments buildAssignmentFromRequest(HttpServletRequest request) {
        TourAssignments assignment = new TourAssignments();

        assignment.setRoleInTour(normalizeRoleInTour(request.getParameter("roleInTour")));
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

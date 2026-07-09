package vn.edu.fpt.controller.tourguide;

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
import vn.edu.fpt.model.User;

import java.io.IOException;

@WebServlet(name = "TourGuideScheduleController", urlPatterns = {"/guide/assignment", "/guide/assigned-tour"})
public class TourGuideScheduleController extends HttpServlet {

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

        User guide = getCurrentGuide(request);
        if (guide == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = trimToDefault(request.getParameter("action"), "list");

        switch (action) {
            case "detail" -> viewAssignedTour(request, response, guide);
            case "passengers", "editPassengerStatus" -> showEditPassengerStatus(request, response, guide);
            case "progressLog", "addProgressLog" -> showAddTourProgressLog(request, response, guide);
            default -> listAssignedTours(request, response, guide);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws IOException {

        request.setCharacterEncoding("UTF-8");

        User guide = getCurrentGuide(request);
        if (guide == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = trimToDefault(request.getParameter("action"), "list");

        switch (action) {
            case "updatePassengerStatus" -> updatePassengerStatus(request, response, guide);
            case "addProgressLog" -> addTourProgressLog(request, response, guide);
            case "updateAssignmentStatus" -> updateAssignmentStatus(request, response, guide);
            default -> response.sendRedirect(request.getContextPath() + "/guide/assignment");
        }
    }

    private void listAssignedTours(HttpServletRequest request,
                                   HttpServletResponse response,
                                   User guide)
            throws ServletException, IOException {

        String status = request.getParameter("status");
        String dateFrom = request.getParameter("dateFrom");
        String dateTo = request.getParameter("dateTo");

        request.setAttribute(
                "assignmentList",
                assignmentDAO.getAssignmentsByGuide(guide.getUserID(), status, dateFrom, dateTo)
        );
        request.setAttribute("status", status);
        request.setAttribute("dateFrom", dateFrom);
        request.setAttribute("dateTo", dateTo);

        request.getRequestDispatcher("/views/guide/assigned-tour-list.jsp")
                .forward(request, response);
    }

    private void viewAssignedTour(HttpServletRequest request,
                                  HttpServletResponse response,
                                  User guide)
            throws ServletException, IOException {

        int assignmentID = parseInt(request.getParameter("id"));
        AssignmentView assignment = assignmentDAO.getAssignmentDetailForGuide(assignmentID, guide.getUserID());

        if (assignment == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        request.setAttribute("assignment", assignment);
        request.setAttribute("travelerList", travelerDAO.getTravelersByAssignment(assignmentID));
        request.setAttribute("progressLogs", itineraryLogDAO.getLogsByAssignment(assignmentID));

        request.getRequestDispatcher("/views/guide/assigned-tour-view.jsp")
                .forward(request, response);
    }

    private void showEditPassengerStatus(HttpServletRequest request,
                                         HttpServletResponse response,
                                         User guide)
            throws ServletException, IOException {

        int assignmentID = parseInt(request.getParameter("id"));
        AssignmentView assignment = assignmentDAO.getAssignmentDetailForGuide(assignmentID, guide.getUserID());

        if (assignment == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        request.setAttribute("assignment", assignment);
        request.setAttribute("travelerList", travelerDAO.getTravelersByAssignment(assignmentID));

        request.getRequestDispatcher("/views/guide/passenger-status-edit.jsp")
                .forward(request, response);
    }

    private void updatePassengerStatus(HttpServletRequest request,
                                       HttpServletResponse response,
                                       User guide)
            throws IOException {

        int assignmentID = parseInt(request.getParameter("assignmentID"));
        int travelerID = parseInt(request.getParameter("travelerID"));
        String status = request.getParameter("travelerStatus");
        String note = request.getParameter("note");

        if (!isValidTravelerStatus(status)) {
            response.sendRedirect(request.getContextPath()
                    + "/guide/assignment?action=passengers&id=" + assignmentID + "&error=invalidStatus");
            return;
        }

        boolean updated = travelerDAO.updateTravelerStatusForGuide(
                assignmentID,
                guide.getUserID(),
                travelerID,
                status,
                note
        );

        response.sendRedirect(request.getContextPath()
                + "/guide/assignment?action=passengers&id=" + assignmentID
                + (updated ? "&success=passenger" : "&error=notAllowed"));
    }

    private void showAddTourProgressLog(HttpServletRequest request,
                                        HttpServletResponse response,
                                        User guide)
            throws ServletException, IOException {

        int assignmentID = parseInt(request.getParameter("id"));
        AssignmentView assignment = assignmentDAO.getAssignmentDetailForGuide(assignmentID, guide.getUserID());

        if (assignment == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        request.setAttribute("assignment", assignment);
        request.setAttribute("progressLogs", itineraryLogDAO.getLogsByAssignment(assignmentID));

        request.getRequestDispatcher("/views/guide/tour-progress-log-create.jsp")
                .forward(request, response);
    }

    private void addTourProgressLog(HttpServletRequest request,
                                    HttpServletResponse response,
                                    User guide)
            throws IOException {

        int assignmentID = parseInt(request.getParameter("assignmentID"));
        String progressStatus = request.getParameter("progressStatus");
        String title = request.getParameter("title");
        String content = request.getParameter("content");

        boolean inserted = itineraryLogDAO.addLogForGuide(
                assignmentID,
                guide.getUserID(),
                progressStatus,
                title,
                content
        );

        response.sendRedirect(request.getContextPath()
                + "/guide/assignment?action=detail&id=" + assignmentID
                + (inserted ? "&success=progressLog" : "&error=progressLog"));
    }

    private void updateAssignmentStatus(HttpServletRequest request,
                                        HttpServletResponse response,
                                        User guide)
            throws IOException {

        int assignmentID = parseInt(request.getParameter("assignmentID"));
        String status = request.getParameter("assignmentStatus");
        String guideNote = request.getParameter("guideNote");

        if (!isValidAssignmentStatus(status)) {
            response.sendRedirect(request.getContextPath()
                    + "/guide/assignment?action=detail&id=" + assignmentID + "&error=invalidStatus");
            return;
        }

        boolean updated = assignmentDAO.updateAssignmentStatusForGuide(
                assignmentID,
                guide.getUserID(),
                status,
                guideNote
        );

        response.sendRedirect(request.getContextPath()
                + "/guide/assignment?action=detail&id=" + assignmentID
                + (updated ? "&success=status" : "&error=notAllowed"));
    }

    private User getCurrentGuide(HttpServletRequest request) {
        HttpSession session = request.getSession(false);

        if (session == null) {
            return null;
        }

        Object user = session.getAttribute("user");

        if (user instanceof User currentUser && isTourGuide(currentUser)) {
            return currentUser;
        }

        return null;
    }

    private boolean isTourGuide(User user) {
        String roleName = user.getRoleName();

        if (roleName != null) {
            String normalizedRoleName = roleName.trim().toLowerCase()
                    .replace(" ", "")
                    .replace("-", "");

            if ("tourguide".equals(normalizedRoleName)
                    || "guide".equals(normalizedRoleName)) {
                return true;
            }

            if (!normalizedRoleName.isEmpty()) {
                return false;
            }
        }

        return user.getRoleID() == 3;
    }

    private boolean isValidAssignmentStatus(String status) {
        return "Assigned".equals(status)
                || "Pending".equals(status)
                || "Accepted".equals(status)
                || "Confirmed".equals(status)
                || "In Progress".equals(status)
                || "Completed".equals(status)
                || "Cancelled".equals(status)
                || "Rejected".equals(status);
    }

    private boolean isValidTravelerStatus(String status) {
        return "Pending".equals(status)
                || "Checked-in".equals(status)
                || "Absent".equals(status)
                || "Completed".equals(status);
    }

    private int parseInt(String raw) {
        try {
            return Integer.parseInt(trimToDefault(raw, "0"));
        } catch (NumberFormatException ex) {
            return 0;
        }
    }

    private String trimToDefault(String value, String fallback) {
        if (value == null || value.trim().isEmpty()) {
            return fallback;
        }

        return value.trim();
    }
}

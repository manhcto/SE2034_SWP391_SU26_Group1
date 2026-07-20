package vn.edu.fpt.controller.tourguide;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import vn.edu.fpt.DAO.AssignmentDAOImpl;
import vn.edu.fpt.DAO.BookingTravelerDAO;
import vn.edu.fpt.DAO.ItineraryLogDAO;
import vn.edu.fpt.model.AssignmentView;
import vn.edu.fpt.model.ItineraryLog;
import vn.edu.fpt.model.User;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "TourGuideScheduleController", urlPatterns = {"/guide/assignment"})
public class TourGuideScheduleController extends HttpServlet {

    private AssignmentDAOImpl assignmentDAO;
    private BookingTravelerDAO bookingTravelerDAO;
    private ItineraryLogDAO itineraryLogDAO;

    @Override
    public void init() {
        assignmentDAO = new AssignmentDAOImpl();
        bookingTravelerDAO = new BookingTravelerDAO();
        itineraryLogDAO = new ItineraryLogDAO();
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
            case "detail":
                viewAssignmentDetail(request, response);
                break;

            case "editStatus":
            case "editPassengerStatus":
                showEditPassengerStatus(request, response);
                break;

            case "progressLog":
                showProgressLogForm(request, response);
                break;

            default:
                listAssignments(request, response);
                break;
        }
    }

    private void listAssignments(HttpServletRequest request,
                                 HttpServletResponse response)
            throws ServletException, IOException {

        User guide = getCurrentGuide(request);

        if (guide == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        List<AssignmentView> list =
                assignmentDAO.getAssignmentsByGuide(guide.getUserID());

        request.setAttribute("assignmentList", list);

        request.getRequestDispatcher(
                "/views/guide/assignment-list.jsp"
        ).forward(request, response);
    }

    private void viewAssignmentDetail(HttpServletRequest request,
                                      HttpServletResponse response)
            throws ServletException, IOException {

        User guide = getCurrentGuide(request);

        if (guide == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int id = Integer.parseInt(request.getParameter("id"));

        AssignmentView assignment =
                assignmentDAO.getAssignmentDetailForGuide(id, guide.getUserID());

        if (assignment == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        request.setAttribute("assignment", assignment);
        request.setAttribute(
                "progressLogs",
                itineraryLogDAO.getLogsByAssignmentForGuide(id, guide.getUserID())
        );

        request.getRequestDispatcher(
                "/views/guide/assignment-detail.jsp"
        ).forward(request, response);
    }

    private void showEditPassengerStatus(HttpServletRequest request,
                                         HttpServletResponse response)
            throws ServletException, IOException {

        User guide = getCurrentGuide(request);

        if (guide == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int id = Integer.parseInt(request.getParameter("id"));

        AssignmentView assignment =
                assignmentDAO.getAssignmentDetailForGuide(id, guide.getUserID());

        if (assignment == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        request.setAttribute("assignment", assignment);
        request.setAttribute(
                "travelerList",
                bookingTravelerDAO.getTravelersByAssignment(id)
        );

        request.getRequestDispatcher(
                "/views/guide/passenger-status-edit.jsp"
        ).forward(request, response);
    }

    private void showProgressLogForm(HttpServletRequest request,
                                     HttpServletResponse response)
            throws ServletException, IOException {

        User guide = getCurrentGuide(request);

        if (guide == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int id = Integer.parseInt(request.getParameter("id"));

        AssignmentView assignment =
                assignmentDAO.getAssignmentDetailForGuide(id, guide.getUserID());

        if (assignment == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        request.setAttribute("assignment", assignment);
        request.setAttribute(
                "progressLogs",
                itineraryLogDAO.getLogsByAssignmentForGuide(id, guide.getUserID())
        );

        request.getRequestDispatcher(
                "/views/guide/tour-progress-log-create.jsp"
        ).forward(request, response);
    }

    private void updatePassengerStatus(HttpServletRequest request,
                                       HttpServletResponse response)
            throws IOException {

        User guide = getCurrentGuide(request);

        if (guide == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int assignmentID = Integer.parseInt(request.getParameter("assignmentID"));
        int travelerID = Integer.parseInt(request.getParameter("travelerID"));
        String travelerStatus = request.getParameter("travelerStatus");
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String note = request.getParameter("note");

        if (!isValidTravelerStatus(travelerStatus)) {
            response.sendRedirect(
                    request.getContextPath()
                            + "/guide/assignment?action=editPassengerStatus&id="
                            + assignmentID
                            + "&error=invalidStatus"
            );
            return;
        }

        boolean updated = bookingTravelerDAO.updateTravelerStatusForGuide(
                assignmentID,
                guide.getUserID(),
                travelerID,
                travelerStatus,
                fullName,
                phone,
                note
        );

        response.sendRedirect(
                request.getContextPath()
                        + "/guide/assignment?action=editPassengerStatus&id="
                        + assignmentID
                        + (updated ? "&success=passenger" : "&error=notAllowed")
        );
    }

    private void addProgressLog(HttpServletRequest request,
                                HttpServletResponse response)
            throws IOException {

        User guide = getCurrentGuide(request);

        if (guide == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int assignmentID = Integer.parseInt(request.getParameter("assignmentID"));

        AssignmentView assignment =
                assignmentDAO.getAssignmentDetailForGuide(assignmentID, guide.getUserID());

        if (assignment == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        ItineraryLog log = new ItineraryLog();
        log.setTourScheduleID(assignment.getTourScheduleID());
        log.setAssignmentID(assignmentID);
        log.setLoggedByUserID(guide.getUserID());
        log.setProgressStatus(request.getParameter("progressStatus"));
        log.setTitle(request.getParameter("title"));
        log.setContent(request.getParameter("content"));

        boolean added = itineraryLogDAO.addProgressLog(log);

        response.sendRedirect(
                request.getContextPath()
                        + "/guide/assignment?action=detail&id="
                        + assignmentID
                        + (added ? "&success=progressLog" : "&error=progressLog")
        );
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        if ("updatePassengerStatus".equals(action)) {
            updatePassengerStatus(request, response);
            return;
        }

        if ("addProgressLog".equals(action)) {
            addProgressLog(request, response);
            return;
        }

        response.sendRedirect(
                request.getContextPath() + "/guide/assignment");
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
        String roleName = normalizeRoleName(user.getRoleName());

        if (!roleName.isEmpty()) {
            return "tourguide".equals(roleName)
                    || "guide".equals(roleName);
        }

        return user.getRoleID() == 3;
    }

    private String normalizeRoleName(String roleName) {
        if (roleName == null) {
            return "";
        }

        return roleName
                .trim()
                .toLowerCase()
                .replace(" ", "")
                .replace("-", "")
                .replace("_", "");
    }

    private boolean isValidTravelerStatus(String status) {
        return "Pending".equals(status)
                || "Checked-in".equals(status)
                || "Absent".equals(status)
                || "Completed".equals(status);
    }
}

package vn.edu.fpt.controller.tourguide;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import vn.edu.fpt.DAO.AssignmentDAOImpl;
import vn.edu.fpt.model.AssignmentView;
import vn.edu.fpt.model.User;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "TourGuideScheduleController", urlPatterns = {"/guide/assignment"})
public class TourGuideScheduleController extends HttpServlet {

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
            case "detail":
                viewAssignmentDetail(request, response);
                break;

            case "editStatus":
                showEditPassengerStatus(request, response);
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

        request.getRequestDispatcher(
                "/views/guide/passenger-status.jsp"
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
        String status = request.getParameter("status");
        String guideNote = request.getParameter("guideNote");

        if (!isValidAssignmentStatus(status)) {
            response.sendRedirect(
                    request.getContextPath()
                            + "/guide/assignment?action=detail&id="
                            + assignmentID
                            + "&error=invalidStatus"
            );
            return;
        }

        boolean updated = assignmentDAO.updateAssignmentStatusForGuide(
                assignmentID,
                guide.getUserID(),
                status,
                guideNote
        );

        response.sendRedirect(
                request.getContextPath()
                        + "/guide/assignment?action=detail&id="
                        + assignmentID
                        + (updated ? "&success=status" : "&error=notAllowed")
        );
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        if ("updateStatus".equals(action)) {
            updatePassengerStatus(request, response);
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
        String roleName = user.getRoleName();

        if (roleName != null) {
            String normalizedRoleName = roleName.trim().toLowerCase();
            return "tour guide".equals(normalizedRoleName)
                    || "guide".equals(normalizedRoleName);
        }

        return user.getRoleID() == 3;
    }

    private boolean isValidAssignmentStatus(String status) {
        return "Pending".equals(status)
                || "Accepted".equals(status)
                || "Confirmed".equals(status)
                || "In Progress".equals(status)
                || "Completed".equals(status)
                || "Cancelled".equals(status)
                || "Rejected".equals(status);
    }
}

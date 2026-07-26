package vn.edu.fpt.controller.tourguide;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.fpt.DAO.AssignmentDAOImpl;
import vn.edu.fpt.DAO.ItineraryLogDAO;
import vn.edu.fpt.model.AssignmentView;
import vn.edu.fpt.model.User;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "TourGuideHomeController", urlPatterns = {
        "/guide",
        "/guide/home"
})
public class TourGuideHomeController extends HttpServlet {

    private AssignmentDAOImpl assignmentDAO;
    private ItineraryLogDAO itineraryLogDAO;

    @Override
    public void init() {
        assignmentDAO = new AssignmentDAOImpl();
        itineraryLogDAO = new ItineraryLogDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User guide = getCurrentUser(request);

        if (guide == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        List<AssignmentView> assignedTours = assignmentDAO.getAssignmentsByGuide(guide.getUserID());

        request.setAttribute("assignedTours", assignedTours);
        request.setAttribute("assignedTourCount", assignedTours.size());
        request.setAttribute("confirmedTourCount", countByStatus(assignedTours, "Accepted", "Confirmed"));
        request.setAttribute("inProgressTourCount", countByStatus(assignedTours, "In Progress"));
        request.setAttribute("completedTourCount", countByStatus(assignedTours, "Completed"));
        request.setAttribute("recentProgressLogs", itineraryLogDAO.getRecentLogsByGuide(guide.getUserID(), 5));

        request.getRequestDispatcher("/views/guide/tour-guide-home.jsp")
                .forward(request, response);
    }

    private User getCurrentUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        Object user = session == null ? null : session.getAttribute("user");
        return user instanceof User currentUser ? currentUser : null;
    }

    private int countByStatus(List<AssignmentView> assignedTours, String... statuses) {
        int count = 0;

        for (AssignmentView assignment : assignedTours) {
            for (String status : statuses) {
                if (status.equals(assignment.getAssignmentStatus())) {
                    count++;
                    break;
                }
            }
        }

        return count;
    }
}

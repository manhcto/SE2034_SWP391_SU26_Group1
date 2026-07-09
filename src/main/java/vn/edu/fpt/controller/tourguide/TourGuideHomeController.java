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
        User guide = getCurrentGuide(request);

        if (guide != null) {
            List<AssignmentView> assignments = assignmentDAO.getAssignmentsByGuide(guide.getUserID());

            request.setAttribute("assignmentList", assignments);
            request.setAttribute("pendingCount", countByStatus(assignments, "Pending"));
            request.setAttribute("confirmedCount", countByStatus(assignments, "Confirmed"));
            request.setAttribute("inProgressCount", countByStatus(assignments, "In Progress"));
            request.setAttribute("completedCount", countByStatus(assignments, "Completed"));
            request.setAttribute("recentLogs", itineraryLogDAO.getRecentLogsByGuide(guide.getUserID(), 5));
        }

        request.getRequestDispatcher("/views/guide/tour-guide-home.jsp")
                .forward(request, response);
    }

    private User getCurrentGuide(HttpServletRequest request) {
        HttpSession session = request.getSession(false);

        if (session == null) {
            return null;
        }

        Object user = session.getAttribute("user");

        if (user instanceof User currentUser) {
            return currentUser;
        }

        return null;
    }

    private long countByStatus(List<AssignmentView> assignments, String status) {
        return assignments.stream()
                .filter(a -> status.equals(a.getAssignmentStatus()))
                .count();
    }
}

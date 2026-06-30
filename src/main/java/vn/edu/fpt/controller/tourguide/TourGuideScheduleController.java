package vn.edu.fpt.controller.tourguide;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import vn.edu.fpt.DAO.AssignmentDAOImpl;
import vn.edu.fpt.model.AssignmentView;

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

            case "updateStatus":
                updatePassengerStatus(request, response);
                break;

            default:
                listAssignments(request, response);
                break;
        }
    }

    private void listAssignments(HttpServletRequest request,
                                 HttpServletResponse response)
            throws ServletException, IOException {

        // Tạm thời hard-code để test.
        // Sau này lấy từ session user đăng nhập.
        int guideID = 1;

        List<AssignmentView> list =
                assignmentDAO.getAssignmentsByGuide(guideID);

        request.setAttribute("assignmentList", list);

        request.getRequestDispatcher(
                "/views/guide/assignment-list.jsp"
        ).forward(request, response);
    }

    private void viewAssignmentDetail(HttpServletRequest request,
                                      HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));

        AssignmentView assignment =
                assignmentDAO.getAssignmentDetail(id);

        request.setAttribute("assignment", assignment);

        request.getRequestDispatcher(
                "/views/guide/assignment-detail.jsp"
        ).forward(request, response);
    }

    private void showEditPassengerStatus(HttpServletRequest request,
                                         HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));

        AssignmentView assignment =
                assignmentDAO.getAssignmentDetail(id);

        request.setAttribute("assignment", assignment);

        request.getRequestDispatcher(
                "/views/guide/passenger-status.jsp"
        ).forward(request, response);
    }

    private void updatePassengerStatus(HttpServletRequest request,
                                       HttpServletResponse response)
            throws IOException {

        int assignmentID = Integer.parseInt(request.getParameter("assignmentID"));
        int bookingID = Integer.parseInt(request.getParameter("bookingID"));
        String status = request.getParameter("status");

        assignmentDAO.updateBookingStatus(bookingID, status);

        response.sendRedirect(
                request.getContextPath()
                        + "/guide/assignment?action=detail&id="
                        + assignmentID
                        + "&success=status"
        );
    }
}
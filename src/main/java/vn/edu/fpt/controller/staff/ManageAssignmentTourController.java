package vn.edu.fpt.controller.staff;

import vn.edu.fpt.DAO.AssignmentDAOImpl;
import vn.edu.fpt.model.AssignmentView;
import vn.edu.fpt.model.TourAssignments;
import vn.edu.fpt.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
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

            case "list":
                listAssignment(request, response);
                break;

            case "view":
                viewAssignment(request, response);
                break;

            case "create":
                showCreateForm(request, response);
                break;

            case "insert":
                insertAssignment(request, response);
                break;

            case "delete":
                deleteAssignment(request, response);
                break;

            case "edit":
                showEditForm(request, response);
                break;

            case "update":
                updateAssignment(request, response);
                break;

            default:
                listAssignment(request, response);
                break;
        }
    }

    private void listAssignment(HttpServletRequest request,
                                HttpServletResponse response)
            throws ServletException, IOException {

        List<AssignmentView> list =
                assignmentDAO.getAllAssignments();

        request.setAttribute(
                "assignmentList",
                list
        );

        request.getRequestDispatcher("/views/admin/assignment-management.jsp"
        ).forward(request, response);
    }

    private void viewAssignment(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(
                request.getParameter("id"));

        AssignmentView assignment =
                assignmentDAO.getAssignmentDetail(id);

        request.setAttribute(
                "assignment",
                assignment);

        request.getRequestDispatcher(
                        "/views/admin/assignment-view.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        if ("insert".equals(action)) {
            insertAssignment(request, response);
        } else if ("update".equals(action)) {
            updateAssignment(request, response);
        } else {
            response.sendRedirect(
                    request.getContextPath() + "/staff/assignment"
            );
        }
    }

    private void showCreateForm(HttpServletRequest request,
                                HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute(
                "bookingList",
                assignmentDAO.getAllBookingsForAssignment()
        );

        request.setAttribute(
                "guideList",
                assignmentDAO.getAllGuides()
        );

        request.getRequestDispatcher(
                "/views/admin/assignment-create.jsp"
        ).forward(request, response);
    }

    private void insertAssignment(HttpServletRequest request,
                                  HttpServletResponse response)
            throws IOException {

        int bookingID = Integer.parseInt(
                request.getParameter("bookingID"));

        int guideID = Integer.parseInt(
                request.getParameter("userID"));

        int tourScheduleID =
                assignmentDAO.getTourScheduleIDByBookingID(bookingID);

        if (tourScheduleID == -1) {
            response.sendRedirect(
                    request.getContextPath()
                            + "/staff/assignment?action=create&error=notFoundSchedule"
            );
            return;
        }

        TourAssignments assignment = new TourAssignments();

        assignment.setTourScheduleID(tourScheduleID);
        assignment.setUserID(guideID);
        assignment.setRoleInTour("Hướng dẫn viên");

        assignmentDAO.addAssignment(assignment);

        response.sendRedirect(
                request.getContextPath()
                        + "/staff/assignment"
        );
    }

    private void deleteAssignment(HttpServletRequest request,
                                  HttpServletResponse response)
            throws IOException {

        int id = Integer.parseInt(request.getParameter("id"));

        assignmentDAO.deleteAssignment(id);

        response.sendRedirect(
                request.getContextPath()
                        + "/staff/assignment?success=delete"
        );
    }

    private void showEditForm(HttpServletRequest request,
                              HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));

        TourAssignments assignment =
                assignmentDAO.getAssignmentById(id);

        request.setAttribute("assignment", assignment);
        request.setAttribute("guideList", assignmentDAO.getAllGuides());

        request.getRequestDispatcher(
                "/views/admin/assignment-edit.jsp"
        ).forward(request, response);
    }

    private void updateAssignment(HttpServletRequest request,
                                  HttpServletResponse response)
            throws IOException {

        int assignmentID = Integer.parseInt(request.getParameter("assignmentID"));
        int tourScheduleID = Integer.parseInt(request.getParameter("tourScheduleID"));
        int userID = Integer.parseInt(request.getParameter("userID"));

        TourAssignments assignment = new TourAssignments();

        assignment.setAssignmentID(assignmentID);
        assignment.setTourScheduleID(tourScheduleID);
        assignment.setUserID(userID);
        assignment.setRoleInTour("Hướng dẫn viên");

        assignmentDAO.updateAssignment(assignment);

        response.sendRedirect(
                request.getContextPath()
                        + "/staff/assignment?success=update"
        );
    }


}
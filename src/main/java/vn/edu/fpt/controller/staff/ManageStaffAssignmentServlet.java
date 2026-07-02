package vn.edu.fpt.controller.staff;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.fpt.service.Staff.StaffAssignmentService;

import java.io.IOException;
import java.util.ArrayList;

@WebServlet(urlPatterns = {"/staff/assignments"})
public class ManageStaffAssignmentServlet extends HttpServlet {
    private static final String LIST_JSP = "/WEB-INF/views/staff/staff-assignment-list.jsp";
    private final StaffAssignmentService staffAssignmentService = new StaffAssignmentService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        setUtf8(request, response);
        String keyword = trim(request.getParameter("keyword"));
        String status = trim(request.getParameter("status"));
        try {
            request.setAttribute("activeMenu", "staffAssignments");
            request.setAttribute("keyword", keyword);
            request.setAttribute("status", status);
            request.setAttribute("schedules", staffAssignmentService.searchSchedules(keyword, status));
        } catch (Exception ex) {
            ex.printStackTrace();
            request.setAttribute("activeMenu", "staffAssignments");
            request.setAttribute("schedules", new ArrayList<>());
            request.setAttribute("systemError", "Không thể tải danh sách lịch cần phân công nhân sự.");
        }
        request.getRequestDispatcher(LIST_JSP).forward(request, response);
    }

    private void setUtf8(HttpServletRequest request, HttpServletResponse response) throws IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }
}

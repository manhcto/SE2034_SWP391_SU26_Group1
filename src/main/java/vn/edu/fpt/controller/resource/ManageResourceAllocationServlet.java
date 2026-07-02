package vn.edu.fpt.controller.resource;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.fpt.service.Staff.ResourceAllocationService;

import java.io.IOException;
import java.util.ArrayList;

@WebServlet(urlPatterns = {"/staff/resources"})
public class ManageResourceAllocationServlet extends HttpServlet {
    private static final String LIST_JSP = "/WEB-INF/views/staff/resource-allocation-list.jsp";
    private final ResourceAllocationService resourceService = new ResourceAllocationService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        setUtf8(request, response);
        String keyword = trim(request.getParameter("keyword"));
        String status = trim(request.getParameter("status"));
        try {
            request.setAttribute("activeMenu", "resources");
            request.setAttribute("keyword", keyword);
            request.setAttribute("status", status);
            request.setAttribute("schedules", resourceService.searchSchedules(keyword, status));
        } catch (Exception ex) {
            ex.printStackTrace();
            request.setAttribute("activeMenu", "resources");
            request.setAttribute("schedules", new ArrayList<>());
            request.setAttribute("systemError", "Không thể tải danh sách lịch khởi hành để phân bổ tài nguyên.");
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

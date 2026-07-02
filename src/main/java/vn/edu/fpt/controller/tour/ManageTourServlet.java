package vn.edu.fpt.controller.tour;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * Staff - màn danh sách/quản lý tour.
 * Chỉ xử lý GET /staff/tours.
 */
@WebServlet(urlPatterns = "/staff/tours")
public class ManageTourServlet extends BaseTourServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        setUtf8(request, response);

        String keyword = request.getParameter("keyword");
        String status = request.getParameter("status");
        Integer regionID = parseNullableInt(request.getParameter("regionID"));
        Integer categoryID = parseNullableInt(request.getParameter("categoryID"));

        try {
            request.setAttribute("tours", tourService.searchTours(keyword, status, regionID, categoryID));
            loadListFiltersSafe(request);
            request.setAttribute("keyword", keyword);
            request.setAttribute("status", status);
            request.setAttribute("regionID", regionID);
            request.setAttribute("categoryID", categoryID);
            request.getRequestDispatcher(TOUR_LIST_JSP).forward(request, response);
        } catch (Exception ex) {
            ex.printStackTrace();
            request.setAttribute("systemError", "Không thể tải danh sách tour. Vui lòng kiểm tra database hoặc thử lại sau.");
            loadListFiltersSafe(request);
            request.getRequestDispatcher(TOUR_LIST_JSP).forward(request, response);
        }
    }
}

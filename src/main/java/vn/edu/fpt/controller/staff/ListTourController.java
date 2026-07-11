package vn.edu.fpt.controller.staff;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.fpt.DAO.TourDAO;
import vn.edu.fpt.model.Tour;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ListTourController", urlPatterns = {"/staff/tour"})
public class ListTourController extends HttpServlet {

    private final TourDAO tourDAO = new TourDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String keyword = safeTrim(request.getParameter("keyword"));
        String status = safeTrim(request.getParameter("status"));
        Integer categoryID = parsePositiveInt(request.getParameter("categoryID"));
        Integer regionID = parsePositiveInt(request.getParameter("regionID"));

        List<Tour> tourList = tourDAO.getToursForStaff(keyword, status, categoryID, regionID);

        request.setAttribute("tourList", tourList);
        request.setAttribute("categoryList", tourDAO.getActiveCategories());
        request.setAttribute("regionList", tourDAO.getActiveRegions());
        request.setAttribute("keyword", keyword);
        request.setAttribute("selectedStatus", status);
        request.setAttribute("selectedCategoryID", categoryID);
        request.setAttribute("selectedRegionID", regionID);
        request.setAttribute("status", safeTrim(request.getParameter("statusMessage")));
        request.setAttribute("messageCode", safeTrim(request.getParameter("message")));

        request.getRequestDispatcher("/views/staff/tour-management.jsp")
                .forward(request, response);
    }

    private Integer parsePositiveInt(String value) {
        try {
            if (value == null || value.trim().isEmpty()) {
                return null;
            }

            int number = Integer.parseInt(value.trim());
            return number > 0 ? number : null;
        } catch (Exception e) {
            return null;
        }
    }

    private String safeTrim(String value) {
        return value == null ? "" : value.trim();
    }
}

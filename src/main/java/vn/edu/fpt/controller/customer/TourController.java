package vn.edu.fpt.controller.customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.fpt.DAO.TourDAO;
import vn.edu.fpt.model.Tour;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "CustomerTourController", urlPatterns = {"/tour", "/tours", "/tour-detail"})
public class TourController extends HttpServlet {

    private final TourDAO tourDAO = new TourDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String path = request.getServletPath();
        if ("/tour-detail".equals(path)) {
            showTourDetail(request, response);
            return;
        }

        showTourList(request, response);
    }

    private void showTourList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = normalize(request.getParameter("keyword"));
        String from = normalize(request.getParameter("from"));
        String destination = normalize(request.getParameter("destination"));
        String startDate = normalize(request.getParameter("startDate"));
        Integer regionID = parsePositiveInteger(request.getParameter("regionID"));
        Integer categoryID = parsePositiveInteger(request.getParameter("categoryID"));

        List<Tour> tourList = tourDAO.getPublishedToursForCustomer(keyword, from, destination, regionID, categoryID, startDate, 100);

        request.setAttribute("tourList", tourList);
        request.setAttribute("categoryList", tourDAO.getActiveCategories());
        request.setAttribute("regionList", tourDAO.getActiveRegions());
        request.setAttribute("startPlaces", tourDAO.getPublishedStartPlaces());
        request.setAttribute("destinations", tourDAO.getPublishedDestinations());

        request.setAttribute("keyword", keyword);
        request.setAttribute("selectedFrom", from);
        request.setAttribute("selectedDestination", destination);
        request.setAttribute("selectedStartDate", startDate);
        request.setAttribute("selectedRegionID", regionID == null ? 0 : regionID);
        request.setAttribute("selectedCategoryID", categoryID == null ? 0 : categoryID);

        request.getRequestDispatcher("/views/customer/tour-list.jsp").forward(request, response);
    }

    private void showTourDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Integer tourID = parsePositiveInteger(request.getParameter("id"));
        if (tourID == null) {
            response.sendRedirect(request.getContextPath() + "/tour?message=notFound");
            return;
        }

        Tour tour = tourDAO.getPublishedTourById(tourID);
        if (tour == null) {
            response.sendRedirect(request.getContextPath() + "/tour?message=notFound");
            return;
        }

        request.setAttribute("tour", tour);
        request.setAttribute("relatedTours", tourDAO.getPublishedToursForCustomer(null, null, null, tour.getRegionID(), null, null, 4));
        request.getRequestDispatcher("/views/customer/tour-detail.jsp").forward(request, response);
    }

    private Integer parsePositiveInteger(String rawValue) {
        String value = normalize(rawValue);
        if (value.isEmpty() || !value.matches("\\d+")) {
            return null;
        }
        try {
            int parsed = Integer.parseInt(value);
            return parsed > 0 ? parsed : null;
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private String normalize(String value) {
        return value == null ? "" : value.trim();
    }
}

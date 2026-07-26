package vn.edu.fpt.controller.customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.fpt.DAO.AdministrativeUnitDAO;
import vn.edu.fpt.DAO.TourDAO;
import vn.edu.fpt.model.Tour;

import java.io.IOException;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.StringJoiner;

@WebServlet(name = "CustomerTourController", urlPatterns = {"/tour", "/tours", "/tour-detail"})
public class TourController extends HttpServlet {

    private final TourDAO tourDAO = new TourDAO();
    private final AdministrativeUnitDAO administrativeUnitDAO = new AdministrativeUnitDAO();

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
        final int pageSize = 10;
        String keyword = normalize(request.getParameter("keyword"));
        String from = normalize(request.getParameter("from"));
        String destination = normalize(request.getParameter("destination"));
        String startDate = normalize(request.getParameter("startDate"));
        Integer regionID = parsePositiveInteger(request.getParameter("regionID"));
        Integer categoryID = parsePositiveInteger(request.getParameter("categoryID"));
        Integer requestedPage = parsePositiveInteger(request.getParameter("page"));
        int currentPage = requestedPage == null ? 1 : requestedPage;
        BigDecimal minPrice = parseNonNegativeMoney(request.getParameter("minPrice"));
        BigDecimal maxPrice = parseNonNegativeMoney(request.getParameter("maxPrice"));
        if (minPrice != null && maxPrice != null && minPrice.compareTo(maxPrice) > 0) {
            BigDecimal swap = minPrice;
            minPrice = maxPrice;
            maxPrice = swap;
        }

        List<Tour> allTours = tourDAO.getPublishedToursForCustomer(keyword, from, destination, regionID, categoryID, startDate, minPrice, maxPrice, 1000);
        int totalTourCount = allTours.size();
        int totalPages = Math.max(1, (int) Math.ceil(totalTourCount / (double) pageSize));
        currentPage = Math.min(Math.max(1, currentPage), totalPages);
        int fromIndex = Math.min((currentPage - 1) * pageSize, totalTourCount);
        int toIndex = Math.min(fromIndex + pageSize, totalTourCount);
        List<Tour> tourList = new ArrayList<>(allTours.subList(fromIndex, toIndex));

        request.setAttribute("tourList", tourList);
        request.setAttribute("totalTourCount", totalTourCount);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("previousPage", Math.max(1, currentPage - 1));
        request.setAttribute("nextPage", Math.min(totalPages, currentPage + 1));
        request.setAttribute("hasPreviousPage", currentPage > 1);
        request.setAttribute("hasNextPage", currentPage < totalPages);
        request.setAttribute("paginationQuery", buildPaginationQuery(request));
        request.setAttribute("categoryList", tourDAO.getActiveCategories());
        request.setAttribute("regionList", tourDAO.getActiveRegions());
        request.setAttribute("startPlaces", administrativeUnitDAO.getActiveProvinceNames());
        request.setAttribute("destinations", tourDAO.getPublishedDestinations());

        request.setAttribute("keyword", keyword);
        request.setAttribute("selectedFrom", from);
        request.setAttribute("selectedDestination", destination);
        request.setAttribute("selectedStartDate", startDate);
        request.setAttribute("selectedRegionID", regionID == null ? 0 : regionID);
        request.setAttribute("selectedCategoryID", categoryID == null ? 0 : categoryID);
        request.setAttribute("selectedMinPrice", minPrice == null ? "" : minPrice.toPlainString());
        request.setAttribute("selectedMaxPrice", maxPrice == null ? "" : maxPrice.toPlainString());

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

    private BigDecimal parseNonNegativeMoney(String rawValue) {
        String value = normalize(rawValue).replace(",", "");
        if (value.isEmpty() || !value.matches("\\d+(\\.\\d+)?")) {
            return null;
        }
        try {
            BigDecimal parsed = new BigDecimal(value);
            return parsed.signum() >= 0 ? parsed : null;
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private String buildPaginationQuery(HttpServletRequest request) {
        StringJoiner joiner = new StringJoiner("&");
        for (Map.Entry<String, String[]> entry : request.getParameterMap().entrySet()) {
            String key = entry.getKey();
            if ("page".equals(key)) {
                continue;
            }
            String[] values = entry.getValue();
            if (values == null) {
                continue;
            }
            for (String value : values) {
                String safeValue = normalize(value);
                if (safeValue.isEmpty()) {
                    continue;
                }
                joiner.add(URLEncoder.encode(key, StandardCharsets.UTF_8)
                        + "="
                        + URLEncoder.encode(safeValue, StandardCharsets.UTF_8));
            }
        }
        String query = joiner.toString();
        return query.isEmpty() ? "" : "&" + query;
    }
}

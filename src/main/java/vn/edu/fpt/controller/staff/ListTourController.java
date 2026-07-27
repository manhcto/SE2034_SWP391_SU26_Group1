package vn.edu.fpt.controller.staff;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.fpt.DAO.TourDAO;
import vn.edu.fpt.model.Tour;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.StringJoiner;

@WebServlet(name = "ListTourController", urlPatterns = {"/staff/tour"})
public class ListTourController extends HttpServlet {

    private static final int PAGE_SIZE = 10;
    private final TourDAO tourDAO = new TourDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String keyword = safeTrim(request.getParameter("keyword"));
        String status = safeTrim(request.getParameter("status"));
        Integer categoryID = parsePositiveInt(request.getParameter("categoryID"));
        Integer regionID = parsePositiveInt(request.getParameter("regionID"));
        String readiness = safeTrim(request.getParameter("readiness"));
        Integer requestedPage = parsePositiveInt(request.getParameter("page"));
        int currentPage = requestedPage == null ? 1 : requestedPage;

        List<Tour> tourList = tourDAO.getToursForStaff(keyword, status, categoryID, regionID);
        if ("notReady".equals(readiness)) {
            List<Tour> notReadyTours = new ArrayList<>();
            for (Tour tour : tourList) {
                if (tour != null && !tourDAO.getTourReadinessErrors(tour.getTourID()).isEmpty()) {
                    notReadyTours.add(tour);
                }
            }
            tourList = notReadyTours;
        }

        tourDAO.applyLowestScheduleAdultPrices(tourList);
        int totalTourCount = tourList.size();
        int totalPages = Math.max(1, (int) Math.ceil(totalTourCount / (double) PAGE_SIZE));
        currentPage = Math.min(Math.max(1, currentPage), totalPages);
        int fromIndex = Math.min((currentPage - 1) * PAGE_SIZE, totalTourCount);
        int toIndex = Math.min(fromIndex + PAGE_SIZE, totalTourCount);
        tourList = new ArrayList<>(tourList.subList(fromIndex, toIndex));

        request.setAttribute("tourList", tourList);
        request.setAttribute("totalTourCount", totalTourCount);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("previousPage", Math.max(1, currentPage - 1));
        request.setAttribute("nextPage", Math.min(totalPages, currentPage + 1));
        request.setAttribute("hasPreviousPage", currentPage > 1);
        request.setAttribute("hasNextPage", currentPage < totalPages);
        request.setAttribute("rowNumberStart", fromIndex + 1);
        request.setAttribute("paginationQuery", buildPaginationQuery(request));
        request.setAttribute("categoryList", tourDAO.getActiveCategories());
        request.setAttribute("regionList", tourDAO.getActiveRegions());
        request.setAttribute("keyword", keyword);
        request.setAttribute("selectedStatus", status);
        request.setAttribute("selectedCategoryID", categoryID);
        request.setAttribute("selectedRegionID", regionID);
        request.setAttribute("selectedReadiness", readiness);
        request.setAttribute("status", safeTrim(request.getParameter("statusMessage")));
        request.setAttribute("messageCode", safeTrim(request.getParameter("message")));
        attachExcelImportFlash(request);

        request.getRequestDispatcher("/views/staff/tour-management.jsp")
                .forward(request, response);
    }

    private void attachExcelImportFlash(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return;
        }

        Object insertedCount = session.getAttribute("tourExcelImportInsertedCount");
        Object updatedCount = session.getAttribute("tourExcelImportUpdatedCount");
        Object errorList = session.getAttribute("tourExcelImportErrors");

        if (insertedCount != null || updatedCount != null || errorList != null) {
            request.setAttribute("tourExcelImportInsertedCount", insertedCount == null ? 0 : insertedCount);
            request.setAttribute("tourExcelImportUpdatedCount", updatedCount == null ? 0 : updatedCount);
            request.setAttribute("tourExcelImportErrors", errorList);
        }

        session.removeAttribute("tourExcelImportInsertedCount");
        session.removeAttribute("tourExcelImportUpdatedCount");
        session.removeAttribute("tourExcelImportErrors");
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
                String safeValue = safeTrim(value);
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

package vn.edu.fpt.controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.fpt.DAO.TourDAO;
import vn.edu.fpt.model.Tour;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.StringJoiner;

@WebServlet(name = "AdminTourListController", urlPatterns = {
        "/admin/tour",
        "/admin/tour/approval"
})
public class AdminTourListController extends HttpServlet {

    private TourDAO tourDAO;
    private static final int PAGE_SIZE = 10;

    @Override
    public void init() {
        tourDAO = new TourDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        if (request.getServletPath().endsWith("/approval")) {
            response.sendRedirect(request.getContextPath() + "/admin/tour?status=Pending");
            return;
        }

        boolean approvalPage = false;
        String keyword = normalize(request.getParameter("keyword"));
        String status = normalize(request.getParameter("status"));
        Integer categoryID = parsePositiveInt(request.getParameter("categoryID"));
        Integer regionID = parsePositiveInt(request.getParameter("regionID"));
        Integer requestedPage = parsePositiveInt(request.getParameter("page"));
        int currentPage = requestedPage == null ? 1 : requestedPage;

        if (!isValidTourStatus(status)) {
            status = "";
        }

        List<Tour> allTours = tourDAO.getToursForStaff(keyword, status, categoryID, regionID);
        tourDAO.applyLowestScheduleAdultPrices(allTours);
        int totalTourCount = allTours.size();
        int totalPages = Math.max(1, (int) Math.ceil(totalTourCount / (double) PAGE_SIZE));
        currentPage = Math.min(Math.max(1, currentPage), totalPages);
        int fromIndex = Math.min((currentPage - 1) * PAGE_SIZE, totalTourCount);
        int toIndex = Math.min(fromIndex + PAGE_SIZE, totalTourCount);
        List<Tour> tours = new ArrayList<>(allTours.subList(fromIndex, toIndex));
        Map<String, Integer> statusCounts = tourDAO.getTourStatusCounts();

        request.setAttribute("tours", tours);
        request.setAttribute("totalTourCount", totalTourCount);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("previousPage", Math.max(1, currentPage - 1));
        request.setAttribute("nextPage", Math.min(totalPages, currentPage + 1));
        request.setAttribute("hasPreviousPage", currentPage > 1);
        request.setAttribute("hasNextPage", currentPage < totalPages);
        request.setAttribute("rowNumberStart", fromIndex + 1);
        request.setAttribute("paginationQuery", buildPaginationQuery(request));
        request.setAttribute("statusCounts", statusCounts);
        request.setAttribute("categoryList", tourDAO.getActiveCategories());
        request.setAttribute("regionList", tourDAO.getActiveRegions());
        request.setAttribute("keyword", keyword);
        request.setAttribute("selectedStatus", status);
        request.setAttribute("selectedCategoryID", categoryID == null ? 0 : categoryID);
        request.setAttribute("selectedRegionID", regionID == null ? 0 : regionID);
        request.setAttribute("approvalPage", approvalPage);
        request.setAttribute("message", normalize(request.getParameter("message")));
        request.getRequestDispatcher("/views/admin/admin-tour-list.jsp").forward(request, response);
    }

    private String normalize(String value) {
        return value == null ? "" : value.trim();
    }

    private Integer parsePositiveInt(String raw) {
        try {
            int value = Integer.parseInt(raw);
            return value > 0 ? value : null;
        } catch (Exception e) {
            return null;
        }
    }

    private boolean isValidTourStatus(String status) {
        if (status == null || status.isBlank()) {
            return true;
        }
        return status.equals("Draft") || status.equals("Pending") || status.equals("Active")
                || status.equals("Rejected") || status.equals("Inactive");
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

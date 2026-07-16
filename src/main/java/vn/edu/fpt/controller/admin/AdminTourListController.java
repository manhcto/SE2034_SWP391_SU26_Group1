package vn.edu.fpt.controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.fpt.DAO.TourDAO;
import vn.edu.fpt.model.Tour;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet(name = "AdminTourListController", urlPatterns = {
        "/admin/tour",
        "/admin/tour/approval"
})
public class AdminTourListController extends HttpServlet {

    private TourDAO tourDAO;

    @Override
    public void init() {
        tourDAO = new TourDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        boolean approvalPage = request.getServletPath().endsWith("/approval");
        String keyword = normalize(request.getParameter("keyword"));
        String status = normalize(request.getParameter("status"));
        Integer categoryID = parsePositiveInt(request.getParameter("categoryID"));
        Integer regionID = parsePositiveInt(request.getParameter("regionID"));

        if (approvalPage && status.isBlank()) {
            status = "Pending";
        }

        if (!isValidTourStatus(status)) {
            status = "";
        }

        List<Tour> tours = tourDAO.getToursForStaff(keyword, status, categoryID, regionID);
        Map<String, Integer> statusCounts = tourDAO.getTourStatusCounts();

        request.setAttribute("tours", tours);
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
}

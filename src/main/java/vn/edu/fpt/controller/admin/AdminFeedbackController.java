package vn.edu.fpt.controller.admin;

import vn.edu.fpt.DAO.FeedbackDAO;
import vn.edu.fpt.model.Feedback;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet(name = "AdminFeedbackController", urlPatterns = {
        "/admin/feedback",
        "/admin/feedback-detail"
})
public class AdminFeedbackController extends HttpServlet {

    private static final String ADMIN_FEEDBACK_LIST_PAGE = "/views/admin/admin-feedback-list.jsp";
    private static final String ADMIN_FEEDBACK_DETAIL_PAGE = "/views/admin/admin-feedback-detail.jsp";

    private final FeedbackDAO feedbackDAO = new FeedbackDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String path = request.getServletPath();

        switch (path) {
            case "/admin/feedback":
                showFeedbackList(request, response);
                break;

            case "/admin/feedback-detail":
                showFeedbackDetail(request, response);
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/admin/feedback");
                break;
        }
    }

    private void showFeedbackList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String type = normalizeServiceType(request.getParameter("type"));
        List<Feedback> feedbackList = feedbackDAO.getFeedbacksByType(type);

        request.setAttribute("feedbackList", feedbackList);
        request.setAttribute("type", type);
        request.setAttribute("typeText", convertServiceTypeToVietnamese(type));

        request.getRequestDispatcher(ADMIN_FEEDBACK_LIST_PAGE).forward(request, response);
    }

    private void showFeedbackDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String type = normalizeServiceType(request.getParameter("type"));
        int feedbackID = parsePositiveIntValue(request.getParameter("feedbackID"));

        if (feedbackID <= 0) {
            response.sendRedirect(request.getContextPath()
                    + buildAdminFeedbackListUrl(type)
                    + "&error=invalid");
            return;
        }

        Map<String, Object> feedbackDetail = feedbackDAO.getFeedbackDetailByID(feedbackID);

        if (feedbackDetail == null) {
            response.sendRedirect(request.getContextPath()
                    + buildAdminFeedbackListUrl(type)
                    + "&error=notfound");
            return;
        }

        String detailType = normalizeServiceType(String.valueOf(feedbackDetail.get("serviceType")));

        if ("All".equals(type) && !"All".equals(detailType)) {
            type = detailType;
        }

        request.setAttribute("feedbackDetail", feedbackDetail);
        request.setAttribute("type", type);
        request.setAttribute("typeText", convertServiceTypeToVietnamese(type));

        request.getRequestDispatcher(ADMIN_FEEDBACK_DETAIL_PAGE).forward(request, response);
    }

    private String buildAdminFeedbackListUrl(String type) {
        return "/admin/feedback?type=" + normalizeServiceType(type);
    }

    private int parsePositiveIntValue(String value) {
        try {
            int number = Integer.parseInt(value);
            return number > 0 ? number : 0;
        } catch (Exception e) {
            return 0;
        }
    }

    private String normalizeServiceType(String type) {
        if (type == null || type.trim().isEmpty()) {
            return "All";
        }

        String value = type.trim().toLowerCase();

        if ("all".equals(value)
                || "tatca".equals(value)
                || "tất cả".equals(value)) {
            return "All";
        }

        if ("accommodation".equals(value)
                || "hotel".equals(value)
                || "khachsan".equals(value)
                || "khách sạn".equals(value)
                || "luutru".equals(value)
                || "lưu trú".equals(value)) {
            return "Accommodation";
        }

        if ("tour".equals(value)) {
            return "Tour";
        }

        return "All";
    }

    private String convertServiceTypeToVietnamese(String type) {
        String serviceType = normalizeServiceType(type);

        if ("Accommodation".equals(serviceType)) {
            return "Khách sạn";
        }

        if ("Tour".equals(serviceType)) {
            return "Tour";
        }

        return "Tất cả";
    }
}

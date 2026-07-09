package vn.edu.fpt.controller.staff;

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

@WebServlet(name = "ManageFeedbackController", urlPatterns = {
        "/staff/feedback",
        "/staff/feedback-detail",
        "/staff/feedback-delete",
        "/staff/feedback-status"
})
public class ManageFeedbackController extends HttpServlet {

    private static final String STAFF_FEEDBACK_LIST_PAGE = "/views/staff/staff-feedback-list.jsp";
    private static final String STAFF_FEEDBACK_DETAIL_PAGE = "/views/staff/staff-feedback-detail.jsp";

    private final FeedbackDAO feedbackDAO = new FeedbackDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String path = request.getServletPath();

        switch (path) {
            case "/staff/feedback":
                showFeedbackList(request, response);
                break;

            case "/staff/feedback-detail":
                showFeedbackDetail(request, response);
                break;

            case "/staff/feedback-delete":
                deleteFeedback(request, response);
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/staff/feedback");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String path = request.getServletPath();

        switch (path) {
            case "/staff/feedback-delete":
                deleteFeedback(request, response);
                break;

            case "/staff/feedback-status":
                updateFeedbackStatus(request, response);
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/staff/feedback");
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

        request.getRequestDispatcher(STAFF_FEEDBACK_LIST_PAGE).forward(request, response);
    }

    private void showFeedbackDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String type = normalizeServiceType(request.getParameter("type"));
        int feedbackID = parsePositiveIntValue(request.getParameter("feedbackID"));

        if (feedbackID <= 0) {
            response.sendRedirect(request.getContextPath()
                    + buildStaffFeedbackListUrl(type)
                    + "&error=invalid");
            return;
        }

        Map<String, Object> feedbackDetail = feedbackDAO.getFeedbackDetailByID(feedbackID);

        if (feedbackDetail == null) {
            response.sendRedirect(request.getContextPath()
                    + buildStaffFeedbackListUrl(type)
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

        request.getRequestDispatcher(STAFF_FEEDBACK_DETAIL_PAGE).forward(request, response);
    }

    private void deleteFeedback(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String type = normalizeServiceType(request.getParameter("type"));
        int feedbackID = parsePositiveIntValue(request.getParameter("feedbackID"));

        if (feedbackID <= 0) {
            response.sendRedirect(request.getContextPath()
                    + buildStaffFeedbackListUrl(type)
                    + "&error=invalid");
            return;
        }

        boolean deleted = feedbackDAO.deleteFeedback(feedbackID);

        if (deleted) {
            response.sendRedirect(request.getContextPath()
                    + buildStaffFeedbackListUrl(type)
                    + "&success=delete");
        } else {
            response.sendRedirect(request.getContextPath()
                    + buildStaffFeedbackListUrl(type)
                    + "&error=delete");
        }
    }

    private void updateFeedbackStatus(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String type = normalizeServiceType(request.getParameter("type"));
        int feedbackID = parsePositiveIntValue(request.getParameter("feedbackID"));
        String status = normalizeStatus(request.getParameter("status"));
        String redirectTo = getTrimValue(request, "redirectTo");

        if (feedbackID <= 0) {
            response.sendRedirect(request.getContextPath()
                    + buildStaffFeedbackListUrl(type)
                    + "&error=invalid");
            return;
        }

        boolean updated = feedbackDAO.updateFeedbackStatus(feedbackID, status);

        if ("detail".equalsIgnoreCase(redirectTo)) {
            if (updated) {
                response.sendRedirect(request.getContextPath()
                        + buildStaffFeedbackDetailUrl(feedbackID, type)
                        + "&success=status");
            } else {
                response.sendRedirect(request.getContextPath()
                        + buildStaffFeedbackDetailUrl(feedbackID, type)
                        + "&error=status");
            }

            return;
        }

        if (updated) {
            response.sendRedirect(request.getContextPath()
                    + buildStaffFeedbackListUrl(type)
                    + "&success=status");
        } else {
            response.sendRedirect(request.getContextPath()
                    + buildStaffFeedbackListUrl(type)
                    + "&error=status");
        }
    }

    private String buildStaffFeedbackListUrl(String type) {
        return "/staff/feedback?type=" + normalizeServiceType(type);
    }

    private String buildStaffFeedbackDetailUrl(int feedbackID, String type) {
        return "/staff/feedback-detail?feedbackID=" + feedbackID
                + "&type=" + normalizeServiceType(type);
    }

    private String getTrimValue(HttpServletRequest request, String paramName) {
        String value = request.getParameter(paramName);
        return value == null ? "" : value.trim();
    }

    private int parsePositiveIntValue(String value) {
        try {
            int number = Integer.parseInt(value);
            return number > 0 ? number : 0;
        } catch (Exception e) {
            return 0;
        }
    }

    private String normalizeStatus(String status) {
        if (status == null || status.trim().isEmpty()) {
            return "Hidden";
        }

        if ("Visible".equalsIgnoreCase(status.trim())) {
            return "Visible";
        }

        return "Hidden";
    }

    private String normalizeServiceType(String type) {
        if (type == null || type.trim().isEmpty()) {
            return "All";
        }

        String value = type.trim().toLowerCase();

        if ("all".equals(value) || "tatca".equals(value) || "tất cả".equals(value)) {
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

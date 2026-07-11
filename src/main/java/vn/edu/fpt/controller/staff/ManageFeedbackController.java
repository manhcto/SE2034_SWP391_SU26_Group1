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
        "/staff/feedback-status"
})
public class ManageFeedbackController extends HttpServlet {

    private static final String STAFF_FEEDBACK_LIST_PAGE = "/views/staff/staff-feedback-list.jsp";
    private static final String STAFF_FEEDBACK_DETAIL_PAGE = "/views/staff/staff-feedback-detail.jsp";

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

        FeedbackDAO feedbackDAO = new FeedbackDAO();
        List<Feedback> feedbackList = feedbackDAO.getAllFeedbacks();

        request.setAttribute("feedbackList", feedbackList);
        request.getRequestDispatcher(STAFF_FEEDBACK_LIST_PAGE).forward(request, response);
    }

    private void showFeedbackDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String feedbackIDRaw = request.getParameter("feedbackID");

        if (feedbackIDRaw == null || feedbackIDRaw.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/staff/feedback");
            return;
        }

        try {
            int feedbackID = Integer.parseInt(feedbackIDRaw.trim());

            FeedbackDAO feedbackDAO = new FeedbackDAO();
            Map<String, Object> feedbackDetail = feedbackDAO.getFeedbackDetailByID(feedbackID);

            if (feedbackDetail == null) {
                request.setAttribute("error", "Không tìm thấy feedback.");
                request.getRequestDispatcher(STAFF_FEEDBACK_DETAIL_PAGE).forward(request, response);
                return;
            }

            request.setAttribute("feedbackDetail", feedbackDetail);
            request.getRequestDispatcher(STAFF_FEEDBACK_DETAIL_PAGE).forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/staff/feedback");
        }
    }

    private void updateFeedbackStatus(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String feedbackIDRaw = request.getParameter("feedbackID");
        String newStatus = request.getParameter("status");
        String redirectTo = request.getParameter("redirectTo");

        if (feedbackIDRaw == null || feedbackIDRaw.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/staff/feedback?error=invalid");
            return;
        }

        if (!isValidStatus(newStatus)) {
            response.sendRedirect(request.getContextPath() + "/staff/feedback?error=status");
            return;
        }

        try {
            int feedbackID = Integer.parseInt(feedbackIDRaw.trim());

            FeedbackDAO feedbackDAO = new FeedbackDAO();
            Feedback feedback = feedbackDAO.getFeedbackByID(feedbackID);

            if (feedback == null) {
                response.sendRedirect(request.getContextPath() + "/staff/feedback?error=notfound");
                return;
            }

            feedback.setStatus(newStatus);

            boolean updated = feedbackDAO.updateFeedback(feedback);

            if (updated) {
                if ("detail".equals(redirectTo)) {
                    response.sendRedirect(request.getContextPath()
                            + "/staff/feedback-detail?feedbackID=" + feedbackID + "&success=status");
                } else {
                    response.sendRedirect(request.getContextPath() + "/staff/feedback?success=status");
                }
            } else {
                if ("detail".equals(redirectTo)) {
                    response.sendRedirect(request.getContextPath()
                            + "/staff/feedback-detail?feedbackID=" + feedbackID + "&error=update");
                } else {
                    response.sendRedirect(request.getContextPath() + "/staff/feedback?error=update");
                }
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/staff/feedback?error=invalid");
        }
    }

    private boolean isValidStatus(String status) {
        return "Visible".equals(status) || "Hidden".equals(status);
    }
}
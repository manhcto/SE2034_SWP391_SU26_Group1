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

        FeedbackDAO feedbackDAO = new FeedbackDAO();
        List<Feedback> feedbackList = feedbackDAO.getAllFeedbacks();

        request.setAttribute("feedbackList", feedbackList);
        request.getRequestDispatcher(ADMIN_FEEDBACK_LIST_PAGE).forward(request, response);
    }

    private void showFeedbackDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String feedbackIDRaw = request.getParameter("feedbackID");

        if (feedbackIDRaw == null || feedbackIDRaw.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/feedback");
            return;
        }

        try {
            int feedbackID = Integer.parseInt(feedbackIDRaw.trim());

            FeedbackDAO feedbackDAO = new FeedbackDAO();
            Map<String, Object> feedbackDetail = feedbackDAO.getFeedbackDetailByID(feedbackID);

            if (feedbackDetail == null) {
                request.setAttribute("error", "Không tìm thấy feedback.");
                request.getRequestDispatcher(ADMIN_FEEDBACK_DETAIL_PAGE).forward(request, response);
                return;
            }

            request.setAttribute("feedbackDetail", feedbackDetail);
            request.getRequestDispatcher(ADMIN_FEEDBACK_DETAIL_PAGE).forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/feedback");
        }
    }
}
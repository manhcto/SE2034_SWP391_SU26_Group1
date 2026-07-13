package vn.edu.fpt.controller.customer;

import vn.edu.fpt.DAO.FeedbackDAO;
import vn.edu.fpt.model.Feedback;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@WebServlet(name = "FeedbackController", urlPatterns = {
        "/feedback-list",
        "/feedback-detail",
        "/feedback-add",
        "/feedback-edit"
})
public class FeedbackController extends HttpServlet {

    private static final String LIST_PAGE = "/views/customer/feedback-list.jsp";
    private static final String DETAIL_PAGE = "/views/customer/feedback-detail.jsp";
    private static final String ADD_PAGE = "/views/customer/feedback-add.jsp";
    private static final String EDIT_PAGE = "/views/customer/feedback-edit.jsp";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String path = request.getServletPath();

        switch (path) {
            case "/feedback-list":
                showFeedbackList(request, response);
                break;

            case "/feedback-detail":
                showFeedbackDetail(request, response);
                break;

            case "/feedback-add":
                showAddFeedbackForm(request, response);
                break;

            case "/feedback-edit":
                showEditFeedbackForm(request, response);
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/feedback-list");
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
            case "/feedback-add":
                addFeedback(request, response);
                break;

            case "/feedback-edit":
                editFeedback(request, response);
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/feedback-list");
                break;
        }
    }

    private void showFeedbackList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        FeedbackDAO feedbackDAO = new FeedbackDAO();
        List<Feedback> feedbackList;

        String tourIDRaw = request.getParameter("tourID");
        String accommodationIDRaw = request.getParameter("accommodationID");

        if (tourIDRaw != null && !tourIDRaw.trim().isEmpty()) {
            // Lọc feedback theo tour
            try {
                int tourID = Integer.parseInt(tourIDRaw.trim());
                feedbackList = feedbackDAO.getFeedbacksByTourID(tourID);

                request.setAttribute("filterType", "tour");
                request.setAttribute("filterID", tourID);
            } catch (NumberFormatException e) {
                feedbackList = feedbackDAO.getAllFeedbacks();
            }

        } else if (accommodationIDRaw != null && !accommodationIDRaw.trim().isEmpty()) {
            // Lọc feedback theo nơi lưu trú
            try {
                int accommodationID = Integer.parseInt(accommodationIDRaw.trim());
                feedbackList = feedbackDAO.getFeedbacksByAccommodationID(accommodationID);

                request.setAttribute("filterType", "accommodation");
                request.setAttribute("filterID", accommodationID);
            } catch (NumberFormatException e) {
                feedbackList = feedbackDAO.getAllFeedbacks();
            }

        } else {
            feedbackList = feedbackDAO.getAllFeedbacks();
        }

        request.setAttribute("feedbackList", feedbackList);
        request.getRequestDispatcher(LIST_PAGE).forward(request, response);
    }

    private void showFeedbackDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String feedbackIDRaw = request.getParameter("feedbackID");

        if (feedbackIDRaw == null || feedbackIDRaw.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/feedback-list");
            return;
        }

        try {
            int feedbackID = Integer.parseInt(feedbackIDRaw);

            FeedbackDAO feedbackDAO = new FeedbackDAO();
            Map<String, Object> feedbackDetail = feedbackDAO.getFeedbackDetailByID(feedbackID);

            if (feedbackDetail == null) {
                request.setAttribute("error", "Không tìm thấy feedback.");
                request.getRequestDispatcher(DETAIL_PAGE).forward(request, response);
                return;
            }

            request.setAttribute("feedbackDetail", feedbackDetail);
            request.getRequestDispatcher(DETAIL_PAGE).forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/feedback-list");
        }
    }

    private void showAddFeedbackForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String bookingIDRaw = request.getParameter("bookingID");

        if (bookingIDRaw != null && !bookingIDRaw.trim().isEmpty()) {
            request.setAttribute("bookingID", bookingIDRaw.trim());
        }

        request.getRequestDispatcher(ADD_PAGE).forward(request, response);
    }

    private void showEditFeedbackForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String feedbackIDRaw = request.getParameter("feedbackID");

        if (feedbackIDRaw == null || feedbackIDRaw.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/feedback-list");
            return;
        }

        try {
            int feedbackID = Integer.parseInt(feedbackIDRaw);

            FeedbackDAO feedbackDAO = new FeedbackDAO();
            Feedback feedback = feedbackDAO.getFeedbackByID(feedbackID);

            if (feedback == null) {
                request.setAttribute("error", "Không tìm thấy feedback cần sửa.");
                request.getRequestDispatcher(EDIT_PAGE).forward(request, response);
                return;
            }

            request.setAttribute("feedback", feedback);
            request.getRequestDispatcher(EDIT_PAGE).forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/feedback-list");
        }
    }

    private void addFeedback(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<String> errors = new ArrayList<>();

        String rateRaw = getTrimValue(request, "rate");
        String content = getTrimValue(request, "content");
        String image = getTrimValue(request, "image");
        String userIDRaw = getTrimValue(request, "userID");
        String bookingIDRaw = getTrimValue(request, "bookingID");

        double rate = parseRate(rateRaw, errors);
        int userID = parsePositiveInt(userIDRaw, "User ID", errors);
        int bookingID = parsePositiveInt(bookingIDRaw, "Booking ID", errors);

        validateContentAndImage(content, image, errors);

        FeedbackDAO feedbackDAO = new FeedbackDAO();

        if (userID > 0 && !feedbackDAO.isUserExist(userID)) {
            errors.add("User ID không tồn tại trong hệ thống.");
        }

        if (bookingID > 0 && !feedbackDAO.isBookingExist(bookingID)) {
            errors.add("Booking ID không tồn tại trong hệ thống.");
        }

        Feedback feedback = new Feedback();
        feedback.setRate(rate);
        feedback.setContent(content);
        feedback.setImage(image);
        feedback.setUserID(userID);
        feedback.setBookingID(bookingID);
        feedback.setStatus("Hidden");

        if (!errors.isEmpty()) {
            request.setAttribute("errors", errors);
            request.setAttribute("feedback", feedback);
            request.getRequestDispatcher(ADD_PAGE).forward(request, response);
            return;
        }

        int feedbackID = feedbackDAO.insertFeedback(feedback);

        if (feedbackID > 0) {
            response.sendRedirect(request.getContextPath() + "/feedback-detail?feedbackID=" + feedbackID);
        } else {
            errors.add("Thêm feedback thất bại. Vui lòng thử lại.");

            request.setAttribute("errors", errors);
            request.setAttribute("feedback", feedback);
            request.getRequestDispatcher(ADD_PAGE).forward(request, response);
        }
    }

    private void editFeedback(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<String> errors = new ArrayList<>();

        String feedbackIDRaw = getTrimValue(request, "feedbackID");
        String rateRaw = getTrimValue(request, "rate");
        String content = getTrimValue(request, "content");
        String image = getTrimValue(request, "image");
        String status = getTrimValue(request, "status");

        int feedbackID = parsePositiveInt(feedbackIDRaw, "Feedback ID", errors);
        double rate = parseRate(rateRaw, errors);

        validateContentAndImage(content, image, errors);

        if (!isValidStatus(status)) {
            errors.add("Trạng thái feedback không hợp lệ.");
        }

        FeedbackDAO feedbackDAO = new FeedbackDAO();
        Feedback oldFeedback = null;

        if (feedbackID > 0) {
            oldFeedback = feedbackDAO.getFeedbackByID(feedbackID);

            if (oldFeedback == null) {
                errors.add("Feedback không tồn tại trong hệ thống.");
            }
        }

        Feedback feedback = new Feedback();
        feedback.setFeedbackID(feedbackID);
        feedback.setRate(rate);
        feedback.setContent(content);
        feedback.setImage(image);
        feedback.setStatus(status);

        if (oldFeedback != null) {
            feedback.setUserID(oldFeedback.getUserID());
            feedback.setBookingID(oldFeedback.getBookingID());
            feedback.setCreateDate(oldFeedback.getCreateDate());
        }

        if (!errors.isEmpty()) {
            request.setAttribute("errors", errors);
            request.setAttribute("feedback", feedback);
            request.getRequestDispatcher(EDIT_PAGE).forward(request, response);
            return;
        }

        boolean updated = feedbackDAO.updateFeedback(feedback);

        if (updated) {
            response.sendRedirect(request.getContextPath() + "/feedback-detail?feedbackID=" + feedbackID);
        } else {
            errors.add("Cập nhật feedback thất bại. Vui lòng thử lại.");

            request.setAttribute("errors", errors);
            request.setAttribute("feedback", feedback);
            request.getRequestDispatcher(EDIT_PAGE).forward(request, response);
        }
    }

    private String getTrimValue(HttpServletRequest request, String paramName) {
        String value = request.getParameter(paramName);
        return value == null ? "" : value.trim();
    }

    private int parsePositiveInt(String rawValue, String fieldName, List<String> errors) {
        if (rawValue == null || rawValue.trim().isEmpty()) {
            errors.add(fieldName + " không được để trống.");
            return -1;
        }

        String valueText = rawValue.trim();

        if (!valueText.matches("\\d+")) {
            errors.add(fieldName + " chỉ được nhập số, không được nhập chữ hoặc ký tự đặc biệt.");
            return -1;
        }

        try {
            int value = Integer.parseInt(valueText);

            if (value <= 0) {
                errors.add(fieldName + " phải lớn hơn 0.");
                return -1;
            }

            return value;

        } catch (NumberFormatException e) {
            errors.add(fieldName + " không hợp lệ.");
            return -1;
        }
    }

    private double parseRate(String rateRaw, List<String> errors) {
        if (rateRaw == null || rateRaw.trim().isEmpty()) {
            errors.add("Vui lòng chọn điểm đánh giá.");
            return 0;
        }

        try {
            double rate = Double.parseDouble(rateRaw.trim());

            if (rate < 1 || rate > 5) {
                errors.add("Điểm đánh giá không hợp lệ.");
                return 0;
            }

            return rate;

        } catch (NumberFormatException e) {
            errors.add("Điểm đánh giá không hợp lệ.");
            return 0;
        }
    }

    private void validateContentAndImage(String content, String image, List<String> errors) {
        if (content.length() > 1000) {
            errors.add("Nội dung feedback không được vượt quá 1000 ký tự.");
        }

        if (image.length() > 500) {
            errors.add("Đường dẫn ảnh không được vượt quá 500 ký tự.");
        }
    }

    private boolean isValidStatus(String status) {
        return "Visible".equals(status)
                || "Hidden".equals(status);
    }
}
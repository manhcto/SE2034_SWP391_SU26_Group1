package vn.edu.fpt.controller.customer;

import vn.edu.fpt.DAO.FeedbackDAO;
import vn.edu.fpt.model.Feedback;
import vn.edu.fpt.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.UUID;

@WebServlet(name = "FeedbackController", urlPatterns = {
        "/feedback-list",
        "/feedback-detail",
        "/feedback-add"
})
@MultipartConfig(
        maxFileSize = 5 * 1024 * 1024,
        maxRequestSize = 6 * 1024 * 1024
)
public class FeedbackController extends HttpServlet {

    private static final String LIST_PAGE = "/views/customer/feedback-list.jsp";
    private static final String DETAIL_PAGE = "/views/customer/feedback-detail.jsp";
    private static final String ADD_PAGE = "/views/customer/feedback-add.jsp";

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

        if ("/feedback-add".equals(path)) {
            addFeedback(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/feedback-list");
        }
    }

    // Danh sách feedback ĐÃ DUYỆT của 1 tour hoặc 1 nơi lưu trú
    private void showFeedbackList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        FeedbackDAO feedbackDAO = new FeedbackDAO();
        List<Map<String, Object>> feedbackList = new ArrayList<>();

        int tourID = parseIDParam(request, "tourID");
        int accommodationID = parseIDParam(request, "accommodationID");

        if (tourID > 0) {
            feedbackList = feedbackDAO.getVisibleFeedbacksByTourID(tourID);
            request.setAttribute("filterType", "tour");
            request.setAttribute("filterID", tourID);
            request.setAttribute("serviceName", feedbackDAO.getTourNameByID(tourID));

        } else if (accommodationID > 0) {
            feedbackList = feedbackDAO.getVisibleFeedbacksByAccommodationID(accommodationID);
            request.setAttribute("filterType", "accommodation");
            request.setAttribute("filterID", accommodationID);
            request.setAttribute("serviceName", feedbackDAO.getAccommodationNameByID(accommodationID));
        }

        User currentUser = getSessionUser(request);
        boolean hasFeedbackContext = tourID > 0 || accommodationID > 0;
        boolean canAddFeedback = currentUser != null
                && hasFeedbackContext
                && findEndedBookingID(currentUser.getUserID(), tourID, accommodationID) > 0;
        request.setAttribute("canAddFeedback", canAddFeedback);
        request.setAttribute("feedbackList", feedbackList);
        request.getRequestDispatcher(LIST_PAGE).forward(request, response);
    }

    // Chi tiết feedback (chỉ cho xem feedback đã được duyệt)
    private void showFeedbackDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int feedbackID = parseIDParam(request, "feedbackID");

        if (feedbackID <= 0) {
            response.sendRedirect(request.getContextPath() + "/feedback-list");
            return;
        }

        FeedbackDAO feedbackDAO = new FeedbackDAO();
        Map<String, Object> feedbackDetail = feedbackDAO.getFeedbackDetailByID(feedbackID);

        if (feedbackDetail == null || !"Visible".equals(feedbackDetail.get("status"))) {
            response.sendRedirect(request.getContextPath() + "/feedback-list");
            return;
        }

        request.setAttribute("feedbackDetail", feedbackDetail);
        request.getRequestDispatcher(DETAIL_PAGE).forward(request, response);
    }

    // Hiển thị form thêm feedback (yêu cầu đăng nhập + booking đã ở trạng thái Tour kết thúc)
    private void showAddFeedbackForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = getSessionUser(request);
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int tourID = parseIDParam(request, "tourID");
        int accommodationID = parseIDParam(request, "accommodationID");

        if (tourID <= 0 && accommodationID <= 0) {
            response.sendRedirect(request.getContextPath() + "/feedback-list");
            return;
        }

        int bookingID = findEndedBookingID(user.getUserID(), tourID, accommodationID);

        if (bookingID <= 0) {
            redirectNotEnded(request, response, tourID, accommodationID);
            return;
        }

        setContextAttributes(request, tourID, accommodationID);
        request.getRequestDispatcher(ADD_PAGE).forward(request, response);
    }

    // Xử lý gửi feedback
    private void addFeedback(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = getSessionUser(request);
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int tourID = parseIDParam(request, "tourID");
        int accommodationID = parseIDParam(request, "accommodationID");

        if (tourID <= 0 && accommodationID <= 0) {
            response.sendRedirect(request.getContextPath() + "/feedback-list");
            return;
        }

        int bookingID = findEndedBookingID(user.getUserID(), tourID, accommodationID);

        if (bookingID <= 0) {
            redirectNotEnded(request, response, tourID, accommodationID);
            return;
        }

        List<String> errors = new ArrayList<>();

        String rateRaw = getTrimValue(request, "rate");
        String content = getTrimValue(request, "content");

        int rate = parseRate(rateRaw, errors);
        validateContent(content, errors);

        Part imagePart = null;
        try {
            imagePart = request.getPart("image");
        } catch (Exception e) {
            imagePart = null;
        }

        boolean hasImage = imagePart != null && imagePart.getSize() > 0;

        if (hasImage && !isValidFeedbackImage(imagePart)) {
            errors.add("Ảnh minh họa chưa hợp lệ. Vui lòng chọn ảnh JPG, JPEG, PNG hoặc WEBP, dung lượng tối đa 5MB.");
        }

        if (!errors.isEmpty()) {
            forwardBackToForm(request, response, tourID, accommodationID, rateRaw, content, errors);
            return;
        }

        String imageUrl = "";
        if (hasImage) {
            imageUrl = saveFeedbackImage(imagePart, user.getUserID());

            if (imageUrl == null) {
                errors.add("Không thể lưu ảnh minh họa. Vui lòng thử lại.");
                forwardBackToForm(request, response, tourID, accommodationID, rateRaw, content, errors);
                return;
            }
        }

        Feedback feedback = new Feedback();
        feedback.setRate(rate);
        feedback.setContent(content);
        feedback.setImage(imageUrl);
        feedback.setUserID(user.getUserID());
        feedback.setBookingID(bookingID);
        feedback.setStatus("Hidden"); // Chờ staff duyệt

        FeedbackDAO feedbackDAO = new FeedbackDAO();
        int feedbackID = feedbackDAO.insertFeedback(feedback);

        if (feedbackID > 0) {
            String backUrl = request.getContextPath() + "/feedback-list?"
                    + buildContextQuery(tourID, accommodationID)
                    + "&success=1";
            response.sendRedirect(backUrl);
        } else {
            errors.add("Gửi đánh giá thất bại. Vui lòng thử lại.");
            forwardBackToForm(request, response, tourID, accommodationID, rateRaw, content, errors);
        }
    }

    // ==========================================================
    // CÁC HÀM HỖ TRỢ
    // ==========================================================

    private User getSessionUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session == null ? null : (User) session.getAttribute("user");
    }

    private int parseIDParam(HttpServletRequest request, String paramName) {
        String raw = request.getParameter(paramName);

        if (raw == null || raw.trim().isEmpty() || !raw.trim().matches("\\d+")) {
            return -1;
        }

        try {
            return Integer.parseInt(raw.trim());
        } catch (NumberFormatException e) {
            return -1;
        }
    }

    // Tìm booking đã kết thúc mới nhất của user cho tour hoặc nơi lưu trú.
    private int findEndedBookingID(int userID, int tourID, int accommodationID) {
        FeedbackDAO feedbackDAO = new FeedbackDAO();

        if (tourID > 0) {
            return feedbackDAO.getLatestEndedBookingIDByTour(userID, tourID);
        }

        return feedbackDAO.getLatestEndedBookingIDByAccommodation(userID, accommodationID);
    }

    private String buildContextQuery(int tourID, int accommodationID) {
        if (tourID > 0) {
            return "tourID=" + tourID;
        }
        return "accommodationID=" + accommodationID;
    }

    private void setContextAttributes(HttpServletRequest request, int tourID, int accommodationID) {
        FeedbackDAO feedbackDAO = new FeedbackDAO();
        if (tourID > 0) {
            request.setAttribute("tourID", tourID);
            request.setAttribute("serviceName", feedbackDAO.getTourNameByID(tourID));
        } else {
            request.setAttribute("accommodationID", accommodationID);
            request.setAttribute("serviceName", feedbackDAO.getAccommodationNameByID(accommodationID));
        }
    }

    private void redirectNotEnded(HttpServletRequest request, HttpServletResponse response,
                                  int tourID, int accommodationID) throws IOException {
        response.sendRedirect(request.getContextPath() + "/feedback-list?"
                + buildContextQuery(tourID, accommodationID)
                + "&error=notEnded");
    }

    private void forwardBackToForm(HttpServletRequest request, HttpServletResponse response,
                                   int tourID, int accommodationID,
                                   String rateRaw, String content,
                                   List<String> errors) throws ServletException, IOException {

        setContextAttributes(request, tourID, accommodationID);
        request.setAttribute("errors", errors);
        request.setAttribute("oldRate", rateRaw);
        request.setAttribute("oldContent", content);
        request.getRequestDispatcher(ADD_PAGE).forward(request, response);
    }

    private String getTrimValue(HttpServletRequest request, String paramName) {
        String value = request.getParameter(paramName);
        return value == null ? "" : value.trim();
    }

    private int parseRate(String rateRaw, List<String> errors) {
        if (rateRaw == null || rateRaw.trim().isEmpty()) {
            errors.add("Vui lòng chọn số sao đánh giá.");
            return 0;
        }

        try {
            int rate = Integer.parseInt(rateRaw.trim());

            if (rate < 1 || rate > 5) {
                errors.add("Số sao đánh giá phải từ 1 đến 5.");
                return 0;
            }

            return rate;

        } catch (NumberFormatException e) {
            errors.add("Số sao đánh giá không hợp lệ.");
            return 0;
        }
    }

    private void validateContent(String content, List<String> errors) {
        if (content == null || content.isEmpty()) {
            errors.add("Vui lòng nhập nội dung đánh giá.");
            return;
        }

        if (content.length() < 10) {
            errors.add("Nội dung đánh giá phải có ít nhất 10 ký tự.");
        }

        if (content.length() > 1000) {
            errors.add("Nội dung đánh giá không được vượt quá 1000 ký tự.");
        }
    }

    // Kiểm tra file ảnh hợp lệ (giống pattern ảnh CCCD trong BookingController)
    private boolean isValidFeedbackImage(Part part) {
        if (part == null || part.getSize() <= 0 || part.getSize() > 5 * 1024 * 1024) {
            return false;
        }

        String contentType = part.getContentType();
        String normalizedType = contentType == null ? "" : contentType.toLowerCase(Locale.ROOT);
        if ("image/jpeg".equals(normalizedType)
                || "image/jpg".equals(normalizedType)
                || "image/pjpeg".equals(normalizedType)
                || "image/png".equals(normalizedType)
                || "image/webp".equals(normalizedType)) {
            return true;
        }

        String fileName = part.getSubmittedFileName();
        String normalizedName = fileName == null ? "" : fileName.toLowerCase(Locale.ROOT);
        return normalizedName.endsWith(".jpg")
                || normalizedName.endsWith(".jpeg")
                || normalizedName.endsWith(".png")
                || normalizedName.endsWith(".webp");
    }

    // Lưu ảnh feedback vào /uploads/feedback, trả về đường dẫn tương đối
    private String saveFeedbackImage(Part part, int userID) throws IOException {
        if (!isValidFeedbackImage(part)) {
            return null;
        }

        String uploadRoot = getServletContext().getRealPath("/uploads/feedback");
        if (uploadRoot == null) {
            return null;
        }

        Path uploadDir = Paths.get(uploadRoot);
        Files.createDirectories(uploadDir);

        String extension = getFeedbackImageExtension(part);
        String fileName = "feedback_" + userID + "_" + UUID.randomUUID() + extension;
        Path target = uploadDir.resolve(fileName).normalize();

        if (!target.startsWith(uploadDir)) {
            return null;
        }

        part.write(target.toString());
        return "uploads/feedback/" + fileName;
    }

    private String getFeedbackImageExtension(Part part) {
        String contentType = part == null ? "" : part.getContentType();
        String normalizedType = contentType == null ? "" : contentType.toLowerCase(Locale.ROOT);

        if ("image/png".equals(normalizedType)) {
            return ".png";
        }

        if ("image/webp".equals(normalizedType)) {
            return ".webp";
        }

        String fileName = part == null ? "" : part.getSubmittedFileName();
        String normalizedName = fileName == null ? "" : fileName.toLowerCase(Locale.ROOT);

        if (normalizedName.endsWith(".png")) {
            return ".png";
        }

        if (normalizedName.endsWith(".webp")) {
            return ".webp";
        }

        if (normalizedName.endsWith(".jpeg")) {
            return ".jpeg";
        }

        return ".jpg";
    }
}

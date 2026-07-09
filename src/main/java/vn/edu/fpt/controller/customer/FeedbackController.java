package vn.edu.fpt.controller.customer;

import vn.edu.fpt.DAO.FeedbackDAO;
import vn.edu.fpt.model.Feedback;
import vn.edu.fpt.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

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

    private final FeedbackDAO feedbackDAO = new FeedbackDAO();

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

        String type = normalizeServiceType(getTrimValue(request, "type"));
        int serviceID = parsePositiveIntValue(request.getParameter("serviceID"));
        User currentUser = getCurrentUser(request);
        Integer currentUserID = currentUser == null ? null : currentUser.getUserID();

        List<Feedback> feedbackList;
        Map<String, Object> serviceInfo = null;
        Feedback userFeedback = null;
        boolean canAddFeedback = false;
        int userBookingID = -1;

        if (serviceID > 0) {
            serviceInfo = feedbackDAO.getServiceInfo(type, serviceID);

            if (serviceInfo == null) {
                request.setAttribute("error", "Không tìm thấy dịch vụ cần xem đánh giá.");
                request.setAttribute("feedbackList", new ArrayList<Feedback>());
                setServiceRequestAttributes(request, type, serviceID, null);
                request.getRequestDispatcher(LIST_PAGE).forward(request, response);
                return;
            }

            feedbackList = feedbackDAO.getFeedbacksByService(type, serviceID, currentUserID);

            if (currentUserID != null && currentUserID > 0) {
                userFeedback = feedbackDAO.getUserFeedbackForService(currentUserID, type, serviceID);
                userBookingID = feedbackDAO.findUserBookingIDForService(currentUserID, type, serviceID);
                canAddFeedback = userFeedback == null && userBookingID > 0;
            }
        } else {
            feedbackList = filterVisibleFeedbacksForCustomer(
                    feedbackDAO.getAllFeedbacks(),
                    currentUserID
            );
        }

        request.setAttribute("feedbackList", feedbackList);
        request.setAttribute("serviceInfo", serviceInfo);
        request.setAttribute("userFeedback", userFeedback);
        request.setAttribute("canAddFeedback", canAddFeedback);
        request.setAttribute("userBookingID", userBookingID);
        request.setAttribute("currentUser", currentUser);
        request.setAttribute("isLoggedIn", currentUser != null);

        setServiceRequestAttributes(request, type, serviceID, serviceInfo);

        request.getRequestDispatcher(LIST_PAGE).forward(request, response);
    }

    private void showFeedbackDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String feedbackIDRaw = getTrimValue(request, "feedbackID");

        if (feedbackIDRaw.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/feedback-list");
            return;
        }

        try {
            int feedbackID = Integer.parseInt(feedbackIDRaw);
            User currentUser = getCurrentUser(request);
            Integer currentUserID = currentUser == null ? null : currentUser.getUserID();

            Map<String, Object> feedbackDetail = feedbackDAO.getFeedbackDetailByID(feedbackID, currentUserID);

            if (feedbackDetail == null) {
                request.setAttribute("error", "Không tìm thấy đánh giá.");
                request.getRequestDispatcher(DETAIL_PAGE).forward(request, response);
                return;
            }

            String status = safeString(feedbackDetail.get("status"));
            boolean owner = Boolean.TRUE.equals(feedbackDetail.get("owner"));

            if (!"Visible".equalsIgnoreCase(status) && !owner) {
                request.setAttribute("error", "Bạn không có quyền xem đánh giá này.");
                request.getRequestDispatcher(DETAIL_PAGE).forward(request, response);
                return;
            }

            String type = normalizeServiceType(safeString(feedbackDetail.get("serviceType")));
            int serviceID = getIntValue(feedbackDetail.get("serviceID"));

            request.setAttribute("feedbackDetail", feedbackDetail);
            request.setAttribute("currentUser", currentUser);
            request.setAttribute("isLoggedIn", currentUser != null);
            request.setAttribute("canEditFeedback", owner);

            setServiceRequestAttributes(request, type, serviceID, null);

            request.getRequestDispatcher(DETAIL_PAGE).forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/feedback-list");
        }
    }

    private void showAddFeedbackForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User currentUser = getCurrentUser(request);

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String type = normalizeServiceType(getTrimValue(request, "type"));
        int serviceID = parsePositiveIntValue(request.getParameter("serviceID"));

        if (serviceID <= 0) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        Map<String, Object> serviceInfo = feedbackDAO.getServiceInfo(type, serviceID);

        if (serviceInfo == null) {
            request.setAttribute("error", "Không tìm thấy dịch vụ cần đánh giá.");
            request.getRequestDispatcher(ADD_PAGE).forward(request, response);
            return;
        }

        Feedback userFeedback = feedbackDAO.getUserFeedbackForService(currentUser.getUserID(), type, serviceID);

        if (userFeedback != null) {
            response.sendRedirect(request.getContextPath()
                    + buildFeedbackDetailUrl(userFeedback.getFeedbackID(), type, serviceID));
            return;
        }

        int bookingID = feedbackDAO.findUserBookingIDForService(currentUser.getUserID(), type, serviceID);

        if (bookingID <= 0) {
            List<String> errors = new ArrayList<>();
            errors.add("Bạn cần đặt dịch vụ này trước khi gửi đánh giá.");

            request.setAttribute("errors", errors);
            request.setAttribute("canSubmitFeedback", false);
        } else {
            request.setAttribute("bookingID", bookingID);
            request.setAttribute("canSubmitFeedback", true);
        }

        request.setAttribute("serviceInfo", serviceInfo);
        request.setAttribute("currentUser", currentUser);
        request.setAttribute("isLoggedIn", true);

        setServiceRequestAttributes(request, type, serviceID, serviceInfo);

        request.getRequestDispatcher(ADD_PAGE).forward(request, response);
    }

    private void showEditFeedbackForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User currentUser = getCurrentUser(request);

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String feedbackIDRaw = getTrimValue(request, "feedbackID");

        if (feedbackIDRaw.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/feedback-list");
            return;
        }

        try {
            int feedbackID = Integer.parseInt(feedbackIDRaw);

            Feedback feedback = feedbackDAO.getFeedbackByID(feedbackID);

            if (feedback == null) {
                request.setAttribute("error", "Không tìm thấy đánh giá cần sửa.");
                request.getRequestDispatcher(EDIT_PAGE).forward(request, response);
                return;
            }

            if (feedback.getUserID() != currentUser.getUserID()) {
                request.setAttribute("error", "Bạn chỉ được sửa đánh giá của chính mình.");
                request.getRequestDispatcher(EDIT_PAGE).forward(request, response);
                return;
            }

            Map<String, Object> feedbackDetail = feedbackDAO.getFeedbackDetailByID(feedbackID, currentUser.getUserID());

            String type = "All";
            int serviceID = 0;
            Map<String, Object> serviceInfo = null;

            if (feedbackDetail != null) {
                type = normalizeServiceType(safeString(feedbackDetail.get("serviceType")));
                serviceID = getIntValue(feedbackDetail.get("serviceID"));

                if (serviceID > 0) {
                    serviceInfo = feedbackDAO.getServiceInfo(type, serviceID);
                }
            }

            request.setAttribute("feedback", feedback);
            request.setAttribute("feedbackDetail", feedbackDetail);
            request.setAttribute("serviceInfo", serviceInfo);
            request.setAttribute("currentUser", currentUser);
            request.setAttribute("isLoggedIn", true);

            setServiceRequestAttributes(request, type, serviceID, serviceInfo);

            request.getRequestDispatcher(EDIT_PAGE).forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/feedback-list");
        }
    }

    private void addFeedback(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User currentUser = getCurrentUser(request);

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        List<String> errors = new ArrayList<>();

        String type = normalizeServiceType(getTrimValue(request, "type"));
        int serviceID = parsePositiveIntValue(request.getParameter("serviceID"));

        String rateRaw = getTrimValue(request, "rate");
        String content = getTrimValue(request, "content");
        String image = getTrimValue(request, "image");

        double rate = parseRate(rateRaw, errors);

        validateContentAndImage(content, image, errors);

        Map<String, Object> serviceInfo = null;
        int bookingID = -1;

        if (serviceID <= 0) {
            errors.add("Dịch vụ cần đánh giá không hợp lệ.");
        } else {
            serviceInfo = feedbackDAO.getServiceInfo(type, serviceID);

            if (serviceInfo == null) {
                errors.add("Không tìm thấy dịch vụ cần đánh giá.");
            }
        }

        if (serviceInfo != null) {
            if (feedbackDAO.hasUserFeedbackForService(currentUser.getUserID(), type, serviceID)) {
                errors.add("Bạn đã đánh giá dịch vụ này rồi. Nếu muốn thay đổi, hãy sửa đánh giá cũ.");
            }

            bookingID = feedbackDAO.findUserBookingIDForService(currentUser.getUserID(), type, serviceID);

            if (bookingID <= 0) {
                errors.add("Bạn cần đặt dịch vụ này trước khi gửi đánh giá.");
            }
        }

        Feedback feedback = new Feedback();
        feedback.setRate(rate);
        feedback.setContent(content);
        feedback.setImage(image);
        feedback.setUserID(currentUser.getUserID());
        feedback.setBookingID(bookingID);
        feedback.setStatus("Hidden");
        feedback.setServiceID(serviceID);
        feedback.setServiceType(type);

        if (!errors.isEmpty()) {
            request.setAttribute("errors", errors);
            request.setAttribute("feedback", feedback);
            request.setAttribute("serviceInfo", serviceInfo);
            request.setAttribute("currentUser", currentUser);
            request.setAttribute("isLoggedIn", true);
            request.setAttribute("canSubmitFeedback", bookingID > 0);

            setServiceRequestAttributes(request, type, serviceID, serviceInfo);

            request.getRequestDispatcher(ADD_PAGE).forward(request, response);
            return;
        }

        int feedbackID = feedbackDAO.insertFeedback(feedback);

        if (feedbackID > 0) {
            response.sendRedirect(request.getContextPath()
                    + buildFeedbackListUrl(type, serviceID)
                    + "&success=add");
        } else {
            errors.add("Gửi đánh giá thất bại. Vui lòng thử lại.");

            request.setAttribute("errors", errors);
            request.setAttribute("feedback", feedback);
            request.setAttribute("serviceInfo", serviceInfo);
            request.setAttribute("currentUser", currentUser);
            request.setAttribute("isLoggedIn", true);
            request.setAttribute("canSubmitFeedback", true);

            setServiceRequestAttributes(request, type, serviceID, serviceInfo);

            request.getRequestDispatcher(ADD_PAGE).forward(request, response);
        }
    }

    private void editFeedback(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User currentUser = getCurrentUser(request);

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        List<String> errors = new ArrayList<>();

        String feedbackIDRaw = getTrimValue(request, "feedbackID");
        String rateRaw = getTrimValue(request, "rate");
        String content = getTrimValue(request, "content");
        String image = getTrimValue(request, "image");

        int feedbackID = parsePositiveInt(feedbackIDRaw, "Mã đánh giá", errors);
        double rate = parseRate(rateRaw, errors);

        validateContentAndImage(content, image, errors);

        Feedback oldFeedback = null;
        Map<String, Object> feedbackDetail = null;

        String type = normalizeServiceType(getTrimValue(request, "type"));
        int serviceID = parsePositiveIntValue(request.getParameter("serviceID"));
        Map<String, Object> serviceInfo = null;

        if (feedbackID > 0) {
            oldFeedback = feedbackDAO.getFeedbackByID(feedbackID);

            if (oldFeedback == null) {
                errors.add("Đánh giá không tồn tại trong hệ thống.");
            } else if (oldFeedback.getUserID() != currentUser.getUserID()) {
                errors.add("Bạn chỉ được sửa đánh giá của chính mình.");
            }

            feedbackDetail = feedbackDAO.getFeedbackDetailByID(feedbackID, currentUser.getUserID());

            if (feedbackDetail != null) {
                String detailType = normalizeServiceType(safeString(feedbackDetail.get("serviceType")));
                int detailServiceID = getIntValue(feedbackDetail.get("serviceID"));

                if (!"All".equals(detailType)) {
                    type = detailType;
                }

                if (detailServiceID > 0) {
                    serviceID = detailServiceID;
                    serviceInfo = feedbackDAO.getServiceInfo(type, serviceID);
                }
            }
        }

        Feedback feedback = new Feedback();
        feedback.setFeedbackID(feedbackID);
        feedback.setRate(rate);
        feedback.setContent(content);
        feedback.setImage(image);
        feedback.setStatus("Hidden");
        feedback.setServiceID(serviceID);
        feedback.setServiceType(type);

        if (oldFeedback != null) {
            feedback.setUserID(oldFeedback.getUserID());
            feedback.setBookingID(oldFeedback.getBookingID());
            feedback.setCreateDate(oldFeedback.getCreateDate());
        }

        if (!errors.isEmpty()) {
            request.setAttribute("errors", errors);
            request.setAttribute("feedback", feedback);
            request.setAttribute("feedbackDetail", feedbackDetail);
            request.setAttribute("serviceInfo", serviceInfo);
            request.setAttribute("currentUser", currentUser);
            request.setAttribute("isLoggedIn", true);

            setServiceRequestAttributes(request, type, serviceID, serviceInfo);

            request.getRequestDispatcher(EDIT_PAGE).forward(request, response);
            return;
        }

        boolean updated = feedbackDAO.updateFeedbackByCustomer(feedback, currentUser.getUserID());

        if (updated) {
            response.sendRedirect(request.getContextPath()
                    + buildFeedbackDetailUrl(feedbackID, type, serviceID)
                    + "&success=edit");
        } else {
            errors.add("Cập nhật đánh giá thất bại. Vui lòng thử lại.");

            request.setAttribute("errors", errors);
            request.setAttribute("feedback", feedback);
            request.setAttribute("feedbackDetail", feedbackDetail);
            request.setAttribute("serviceInfo", serviceInfo);
            request.setAttribute("currentUser", currentUser);
            request.setAttribute("isLoggedIn", true);

            setServiceRequestAttributes(request, type, serviceID, serviceInfo);

            request.getRequestDispatcher(EDIT_PAGE).forward(request, response);
        }
    }

    private void setServiceRequestAttributes(HttpServletRequest request,
                                             String type,
                                             int serviceID,
                                             Map<String, Object> serviceInfo) {

        request.setAttribute("type", normalizeServiceType(type));
        request.setAttribute("serviceID", serviceID);

        if (serviceInfo != null) {
            request.setAttribute("serviceType", serviceInfo.get("serviceType"));
            request.setAttribute("serviceTypeText", serviceInfo.get("serviceTypeText"));
            request.setAttribute("serviceName", serviceInfo.get("serviceName"));
            request.setAttribute("serviceImage", serviceInfo.get("serviceImage"));
        } else {
            request.setAttribute("serviceType", normalizeServiceType(type));
            request.setAttribute("serviceTypeText", convertServiceTypeToVietnamese(type));
        }
    }

    private List<Feedback> filterVisibleFeedbacksForCustomer(List<Feedback> sourceList, Integer currentUserID) {
        List<Feedback> filteredList = new ArrayList<>();

        if (sourceList == null) {
            return filteredList;
        }

        for (Feedback feedback : sourceList) {
            boolean visible = "Visible".equalsIgnoreCase(feedback.getStatus());
            boolean owner = currentUserID != null && feedback.getUserID() == currentUserID;

            if (visible || owner) {
                feedback.setOwner(owner);
                filteredList.add(feedback);
            }
        }

        return filteredList;
    }

    private String buildFeedbackListUrl(String type, int serviceID) {
        StringBuilder url = new StringBuilder();

        url.append("/feedback-list");

        if (serviceID > 0) {
            url.append("?type=").append(normalizeServiceType(type));
            url.append("&serviceID=").append(serviceID);
        } else {
            url.append("?type=").append(normalizeServiceType(type));
        }

        return url.toString();
    }

    private String buildFeedbackDetailUrl(int feedbackID, String type, int serviceID) {
        StringBuilder url = new StringBuilder();

        url.append("/feedback-detail?feedbackID=").append(feedbackID);

        if (serviceID > 0) {
            url.append("&type=").append(normalizeServiceType(type));
            url.append("&serviceID=").append(serviceID);
        }

        return url.toString();
    }

    private User getCurrentUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);

        if (session == null) {
            return null;
        }

        Object userObject = session.getAttribute("user");

        if (userObject instanceof User) {
            return (User) userObject;
        }

        return null;
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
                errors.add("Điểm đánh giá phải nằm trong khoảng từ 1 đến 5.");
                return 0;
            }

            return rate;

        } catch (NumberFormatException e) {
            errors.add("Điểm đánh giá không hợp lệ.");
            return 0;
        }
    }

    private void validateContentAndImage(String content, String image, List<String> errors) {
        if (content == null || content.trim().isEmpty()) {
            errors.add("Nội dung đánh giá không được để trống.");
        } else if (content.length() > 1000) {
            errors.add("Nội dung đánh giá không được vượt quá 1000 ký tự.");
        }

        if (image != null && image.length() > 500) {
            errors.add("Đường dẫn ảnh không được vượt quá 500 ký tự.");
        }

        if (image != null
                && !image.trim().isEmpty()
                && !image.startsWith("http://")
                && !image.startsWith("https://")) {
            errors.add("Đường dẫn ảnh phải bắt đầu bằng http:// hoặc https://.");
        }
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

        return type.trim();
    }

    private String convertServiceTypeToVietnamese(String type) {
        String serviceType = normalizeServiceType(type);

        if ("Accommodation".equals(serviceType)) {
            return "Khách sạn";
        }

        if ("Tour".equals(serviceType)) {
            return "Tour";
        }

        return "Nội dung";
    }

    private String safeString(Object value) {
        return value == null ? "" : String.valueOf(value);
    }

    private int getIntValue(Object value) {
        if (value == null) {
            return 0;
        }

        if (value instanceof Number) {
            return ((Number) value).intValue();
        }

        try {
            return Integer.parseInt(String.valueOf(value));
        } catch (Exception e) {
            return 0;
        }
    }
}

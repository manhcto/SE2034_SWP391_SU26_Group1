package vn.edu.fpt.controller.staff;

import java.io.IOException;
import java.sql.Time;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import vn.edu.fpt.DAO.AccommodationDAO;
import vn.edu.fpt.DAO.RoomDAO;
import vn.edu.fpt.model.Accommodation;
import vn.edu.fpt.model.Room;
import vn.edu.fpt.model.Service;

@WebServlet(name = "ManageAccommodationController", urlPatterns = {"/staff/accommodation"})
public class ManageAccommodationController extends HttpServlet {

    private final AccommodationDAO accommodationDAO = new AccommodationDAO();
    private final RoomDAO roomDAO = new RoomDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        if (action == null || action.trim().isEmpty()) {
            action = "list";
        }

        switch (action) {
            case "list":
                listAccommodations(request, response);
                break;

            case "view":
                viewAccommodation(request, response);
                break;

            case "delete":
                deleteAccommodation(request, response);
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/staff/accommodation?action=list");
                break;
        }
    }

    private void listAccommodations(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Accommodation> list = accommodationDAO.getAllAccommodations();
        request.setAttribute("accommodationList", list);

        request.getRequestDispatcher("/views/admin/accommodation-management.jsp")
                .forward(request, response);
    }

    private void viewAccommodation(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idRaw = request.getParameter("id");

        if (isBlank(idRaw)) {
            response.sendRedirect(request.getContextPath()
                    + "/staff/accommodation?action=list&status=missingID");
            return;
        }

        int serviceID = Integer.parseInt(idRaw);

        Accommodation accommodation = accommodationDAO.getAccommodationById(serviceID);

        if (accommodation == null) {
            response.sendRedirect(request.getContextPath()
                    + "/staff/accommodation?action=list&status=notFound");
            return;
        }

        List<Room> roomList = roomDAO.getRoomsByAccommodation(serviceID);

        request.setAttribute("accommodation", accommodation);
        request.setAttribute("roomList", roomList);

        request.getRequestDispatcher("/views/admin/accommodation-detail.jsp")
                .forward(request, response);
    }

    private void deleteAccommodation(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String statusParam = "deleteFail";

        try {
            String idRaw = request.getParameter("id");

            if (!isBlank(idRaw)) {
                int serviceID = Integer.parseInt(idRaw);
                boolean success = accommodationDAO.deleteAccommodation(serviceID);

                if (success) {
                    statusParam = "deleteSuccess";
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath()
                + "/staff/accommodation?action=list&status=" + statusParam);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        if ("add".equals(action)) {
            addAccommodation(request, response);
            return;
        }

        if ("update".equals(action)) {
            updateAccommodation(request, response);
            return;
        }

        response.sendRedirect(request.getContextPath() + "/staff/accommodation?action=list");
    }

    private void addAccommodation(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String statusParam = "addFail";

        try {
            String accName = request.getParameter("accName");
            String accImage = request.getParameter("accImage");
            String accAddress = request.getParameter("accAddress");
            String accPhone = request.getParameter("accPhone");
            String accType = request.getParameter("accType");
            String accStatus = request.getParameter("accStatus");
            String accDesc = request.getParameter("accDesc");
            String accRate = request.getParameter("accRate");
            String accCheckIn = request.getParameter("accCheckIn");
            String accCheckOut = request.getParameter("accCheckOut");

            List<String> errors = validateAccommodationInput(
                    accName,
                    accImage,
                    accAddress,
                    accPhone,
                    accType,
                    accStatus,
                    accRate,
                    accCheckIn,
                    accCheckOut,
                    accDesc
            );

            if (!errors.isEmpty()) {
                request.getSession().setAttribute("errors", errors);
                response.sendRedirect(request.getContextPath()
                        + "/staff/accommodation?action=list&status=validationFail");
                return;
            }

            Accommodation a = new Accommodation();

            accName = safeTrim(accName);

            a.setName(accName);
            a.setImage(safeTrim(accImage));
            a.setAddress(safeTrim(accAddress));
            a.setPhone(safeTrim(accPhone));
            a.setType(safeTrim(accType));
            a.setStatus(safeTrim(accStatus));
            a.setDescription(safeTrim(accDesc));
            a.setRate(Double.parseDouble(accRate.trim()));
            a.setCheckInTime(parseTime(accCheckIn));
            a.setCheckOutTime(parseTime(accCheckOut));

            Service s = new Service();
            s.setServiceCategoryID(1);
            s.setServiceName(accName);
            s.setStatus("Active");
            s.setServiceType("Accommodation");
            s.setFulfillmentType("Booking");

            a.setServiceDetails(s);

            boolean success = accommodationDAO.addAccommodation(a);

            if (success) {
                statusParam = "addSuccess";
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath()
                + "/staff/accommodation?action=list&status=" + statusParam);
    }

    private void updateAccommodation(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String statusParam = "updateFail";

        try {
            String serviceIDRaw = request.getParameter("serviceID");

            String accName = request.getParameter("accName");
            String accImage = request.getParameter("accImage");
            String accAddress = request.getParameter("accAddress");
            String accPhone = request.getParameter("accPhone");
            String accType = request.getParameter("accType");
            String accStatus = request.getParameter("accStatus");
            String accDesc = request.getParameter("accDesc");
            String accRate = request.getParameter("accRate");
            String accCheckIn = request.getParameter("accCheckIn");
            String accCheckOut = request.getParameter("accCheckOut");

            List<String> errors = validateAccommodationInput(
                    accName,
                    accImage,
                    accAddress,
                    accPhone,
                    accType,
                    accStatus,
                    accRate,
                    accCheckIn,
                    accCheckOut,
                    accDesc
            );

            if (isBlank(serviceIDRaw)) {
                errors.add("Thiếu mã dịch vụ của cơ sở lưu trú.");
            }

            if (!errors.isEmpty()) {
                request.getSession().setAttribute("errors", errors);
                response.sendRedirect(request.getContextPath()
                        + "/staff/accommodation?action=list&status=validationFail");
                return;
            }

            int serviceID = Integer.parseInt(serviceIDRaw);

            Accommodation a = new Accommodation();

            accName = safeTrim(accName);

            a.setServiceID(serviceID);
            a.setName(accName);
            a.setImage(safeTrim(accImage));
            a.setAddress(safeTrim(accAddress));
            a.setPhone(safeTrim(accPhone));
            a.setType(safeTrim(accType));
            a.setStatus(safeTrim(accStatus));
            a.setDescription(safeTrim(accDesc));
            a.setRate(Double.parseDouble(accRate.trim()));
            a.setCheckInTime(parseTime(accCheckIn));
            a.setCheckOutTime(parseTime(accCheckOut));

            Service s = new Service();
            s.setServiceID(serviceID);
            s.setServiceCategoryID(1);
            s.setServiceName(accName);
            s.setStatus("Active");
            s.setServiceType("Accommodation");
            s.setFulfillmentType("Booking");

            a.setServiceDetails(s);

            boolean success = accommodationDAO.updateAccommodation(a);

            if (success) {
                statusParam = "updateSuccess";
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath()
                + "/staff/accommodation?action=list&status=" + statusParam);
    }

    private List<String> validateAccommodationInput(String name, String image, String address,
                                                    String phone, String type, String status,
                                                    String rateRaw, String checkInRaw,
                                                    String checkOutRaw, String description) {
        List<String> errors = new ArrayList<>();

        name = safeTrim(name);
        image = safeTrim(image);
        address = safeTrim(address);
        phone = safeTrim(phone);
        type = safeTrim(type);
        status = safeTrim(status);
        description = safeTrim(description);

        if (isBlank(name)) {
            errors.add("Tên cơ sở lưu trú không được để trống.");
        } else if (name.length() < 2 || name.length() > 255) {
            errors.add("Tên cơ sở lưu trú phải từ 2 đến 255 ký tự.");
        }

        if (isBlank(image)) {
            errors.add("Link ảnh không được để trống.");
        } else if (!image.matches("^https?://.+")) {
            errors.add("Link ảnh phải bắt đầu bằng http:// hoặc https://.");
        }

        if (isBlank(address)) {
            errors.add("Địa chỉ không được để trống.");
        } else if (address.length() < 5 || address.length() > 255) {
            errors.add("Địa chỉ phải từ 5 đến 255 ký tự.");
        }

        if (isBlank(phone)) {
            errors.add("Số điện thoại không được để trống.");
        } else if (!phone.matches("^[0-9]{8,11}$")) {
            errors.add("Số điện thoại chỉ được nhập số, từ 8 đến 11 chữ số.");
        }

        if (!isValidAccommodationType(type)) {
            errors.add("Loại hình lưu trú không hợp lệ.");
        }

        if (!isValidStatus(status)) {
            errors.add("Trạng thái lưu trú không hợp lệ.");
        }

        if (isBlank(rateRaw)) {
            errors.add("Đánh giá không được để trống.");
        } else {
            try {
                double rate = Double.parseDouble(rateRaw.trim());

                if (rate < 0 || rate > 5) {
                    errors.add("Đánh giá phải nằm trong khoảng từ 0 đến 5.");
                }

            } catch (NumberFormatException e) {
                errors.add("Đánh giá phải là số hợp lệ.");
            }
        }

        Time checkIn = parseTimeForValidation(checkInRaw);
        Time checkOut = parseTimeForValidation(checkOutRaw);

        if (checkIn == null) {
            errors.add("Giờ check-in không hợp lệ.");
        }

        if (checkOut == null) {
            errors.add("Giờ check-out không hợp lệ.");
        }

        if (checkIn != null && checkOut != null && checkIn.equals(checkOut)) {
            errors.add("Giờ check-in và check-out không được trùng nhau.");
        }

        if (description.length() > 2000) {
            errors.add("Mô tả không được vượt quá 2000 ký tự.");
        }

        return errors;
    }

    private Time parseTime(String timeRaw) {
        if (timeRaw == null || timeRaw.trim().isEmpty()) {
            return null;
        }

        timeRaw = timeRaw.trim();

        if (timeRaw.length() == 5) {
            return Time.valueOf(timeRaw + ":00");
        }

        if (timeRaw.length() == 8) {
            return Time.valueOf(timeRaw);
        }

        throw new IllegalArgumentException("Invalid time format: " + timeRaw);
    }

    private Time parseTimeForValidation(String timeRaw) {
        try {
            return parseTime(timeRaw);
        } catch (Exception e) {
            return null;
        }
    }

    private boolean isValidAccommodationType(String type) {
        return "Khách sạn".equals(type)
                || "Homestay".equals(type)
                || "Resort".equals(type)
                || "Apartment".equals(type);
    }

    private boolean isValidStatus(String status) {
        return "Available".equals(status)
                || "Unavailable".equals(status)
                || "Maintenance".equals(status);
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    private String safeTrim(String value) {
        return value == null ? "" : value.trim();
    }
}
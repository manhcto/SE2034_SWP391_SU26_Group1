package vn.edu.fpt.controller.staff;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import vn.edu.fpt.DAO.AccommodationDAO;
import vn.edu.fpt.DAO.FacilityDAO;
import vn.edu.fpt.DAO.RoomBookingDAO;
import vn.edu.fpt.DAO.RoomDAO;
import vn.edu.fpt.model.Accommodation;
import vn.edu.fpt.model.Facility;
import vn.edu.fpt.model.Room;
import vn.edu.fpt.model.Service;

import java.io.IOException;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.Time;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "ManageAccommodationController", urlPatterns = {"/staff/accommodation"})
public class ManageAccommodationController extends HttpServlet {

    private final AccommodationDAO accommodationDAO = new AccommodationDAO();
    private final RoomDAO roomDAO = new RoomDAO();
    private final FacilityDAO facilityDAO = new FacilityDAO();
    private final RoomBookingDAO roomBookingDAO = new RoomBookingDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String action = safeTrim(request.getParameter("action"));

        if (action.isEmpty()) {
            action = "list";
        }

        switch (action) {
            case "list":
                showAccommodationList(request, response);
                break;

            case "detail":
                showAccommodationDetail(request, response);
                break;

            case "delete":
                deleteAccommodation(request, response);
                break;

            case "deleteRoom":
                deleteRoom(request, response);
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/staff/accommodation?action=list");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String action = safeTrim(request.getParameter("action"));

        switch (action) {
            case "add":
                addAccommodation(request, response);
                break;

            case "update":
                updateAccommodation(request, response);
                break;

            case "addRoom":
                addRoom(request, response);
                break;

            case "updateRoom":
                updateRoom(request, response);
                break;

            case "updateAccommodationFacilities":
                updateAccommodationFacilities(request, response);
                break;

            case "updateRoomFacilities":
                updateRoomFacilities(request, response);
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/staff/accommodation?action=list");
                break;
        }
    }

    private void showAccommodationList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Accommodation> accommodationList = accommodationDAO.getAllAccommodations();
        List<Facility> accommodationFacilityOptions = facilityDAO.getAccommodationFacilityOptions();

        for (Accommodation accommodation : accommodationList) {
            int serviceID = accommodation.getServiceID();

            List<Room> roomList = roomDAO.getRoomsByAccommodation(serviceID);
            List<Facility> facilityList = facilityDAO.getFacilitiesByAccommodation(serviceID);

            accommodation.setRoomList(roomList);
            accommodation.setFacilityList(facilityList);
        }

        request.setAttribute("accommodationList", accommodationList);
        request.setAttribute("accommodationFacilityOptions", accommodationFacilityOptions);

        request.getRequestDispatcher("/views/staff/accommodation-management.jsp")
                .forward(request, response);
    }

    private void showAccommodationDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer serviceID = parsePositiveInt(request.getParameter("id"));

        if (serviceID == null) {
            response.sendRedirect(request.getContextPath()
                    + "/staff/accommodation?action=list&status=notFound");
            return;
        }

        Accommodation accommodation = accommodationDAO.getAccommodationById(serviceID);

        if (accommodation == null) {
            response.sendRedirect(request.getContextPath()
                    + "/staff/accommodation?action=list&status=notFound");
            return;
        }

        List<Room> roomList = roomDAO.getRoomsByAccommodation(serviceID);

        for (Room room : roomList) {
            room.setFacilityList(facilityDAO.getFacilitiesByRoom(room.getRoomID()));
        }

        accommodation.setRoomList(roomList);
        accommodation.setFacilityList(facilityDAO.getFacilitiesByAccommodation(serviceID));

        request.setAttribute("accommodation", accommodation);
        request.setAttribute("roomList", roomList);
        request.setAttribute("roomBookingList", roomBookingDAO.getRoomBookingsByAccommodation(serviceID));
        request.setAttribute("accommodationFacilityOptions", facilityDAO.getAccommodationFacilityOptions());
        request.setAttribute("roomFacilityOptions", facilityDAO.getRoomFacilityOptions());

        request.getRequestDispatcher("/views/staff/accommodation-detail.jsp")
                .forward(request, response);
    }

    private void addAccommodation(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        AccommodationData data = readAccommodationData(request);
        List<String> errors = validateAccommodationInput(data);

        if (!errors.isEmpty()) {
            saveErrors(request, errors);

            response.sendRedirect(request.getContextPath()
                    + "/staff/accommodation?action=list&status=validationFail");
            return;
        }

        Accommodation accommodation = buildAccommodation(0, data);

        int newServiceID = accommodationDAO.addAccommodationAndReturnId(accommodation);

        if (newServiceID > 0) {
            int[] facilityIDs = facilityDAO.parseFacilityIDs(request.getParameterValues("facilityIDs"));
            facilityDAO.updateAccommodationFacilities(newServiceID, facilityIDs);
        }

        response.sendRedirect(request.getContextPath()
                + "/staff/accommodation?action=list&status="
                + (newServiceID > 0 ? "addSuccess" : "addFail"));
    }

    private void updateAccommodation(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        AccommodationData data = readAccommodationData(request);
        List<String> errors = validateAccommodationInput(data);

        Integer serviceID = parsePositiveInt(data.serviceIDRaw);

        if (serviceID == null) {
            errors.add("Mã nơi lưu trú không hợp lệ.");
        }

        if (!errors.isEmpty()) {
            saveErrors(request, errors);

            response.sendRedirect(request.getContextPath()
                    + "/staff/accommodation?action=list&status=validationFail");
            return;
        }

        Accommodation accommodation = buildAccommodation(serviceID, data);

        boolean success = accommodationDAO.updateAccommodation(accommodation);

        if (success) {
            int[] facilityIDs = facilityDAO.parseFacilityIDs(request.getParameterValues("facilityIDs"));
            facilityDAO.updateAccommodationFacilities(serviceID, facilityIDs);
        }

        response.sendRedirect(request.getContextPath()
                + "/staff/accommodation?action=list&status="
                + (success ? "updateSuccess" : "updateFail"));
    }

    private void deleteAccommodation(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        Integer serviceID = parsePositiveInt(request.getParameter("id"));

        if (serviceID == null) {
            response.sendRedirect(request.getContextPath()
                    + "/staff/accommodation?action=list&status=deleteFail");
            return;
        }

        boolean success = accommodationDAO.deleteAccommodation(serviceID);

        response.sendRedirect(request.getContextPath()
                + "/staff/accommodation?action=list&status="
                + (success ? "deleteSuccess" : "deleteFail"));
    }

    private void addRoom(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        RoomData data = readRoomData(request);
        List<String> errors = validateRoomInput(data);

        Integer serviceID = parsePositiveInt(data.serviceIDRaw);

        if (serviceID == null) {
            errors.add("Mã nơi lưu trú không hợp lệ.");
        }

        if (!errors.isEmpty()) {
            saveErrors(request, errors);

            response.sendRedirect(request.getContextPath()
                    + "/staff/accommodation?action=detail&id=" + encode(data.serviceIDRaw)
                    + "&status=validationFail");
            return;
        }

        Room room = buildRoom(0, serviceID, data);
        boolean success = roomDAO.addRoom(room);

        response.sendRedirect(request.getContextPath()
                + "/staff/accommodation?action=detail&id=" + serviceID
                + "&status=" + (success ? "addRoomSuccess" : "addRoomFail"));
    }

    private void updateRoom(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        RoomData data = readRoomData(request);
        List<String> errors = validateRoomInput(data);

        Integer roomID = parsePositiveInt(data.roomIDRaw);
        Integer serviceID = parsePositiveInt(data.serviceIDRaw);

        if (roomID == null) {
            errors.add("Mã phòng không hợp lệ.");
        }

        if (serviceID == null) {
            errors.add("Mã nơi lưu trú không hợp lệ.");
        }

        if (!errors.isEmpty()) {
            saveErrors(request, errors);

            response.sendRedirect(request.getContextPath()
                    + "/staff/accommodation?action=detail&id=" + encode(data.serviceIDRaw)
                    + "&status=validationFail");
            return;
        }

        Room room = buildRoom(roomID, serviceID, data);
        boolean success = roomDAO.updateRoom(room);

        response.sendRedirect(request.getContextPath()
                + "/staff/accommodation?action=detail&id=" + serviceID
                + "&status=" + (success ? "updateRoomSuccess" : "updateRoomFail"));
    }

    private void deleteRoom(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        Integer roomID = parsePositiveInt(request.getParameter("roomID"));
        Integer serviceID = parsePositiveInt(request.getParameter("serviceID"));

        if (roomID == null || serviceID == null) {
            response.sendRedirect(request.getContextPath()
                    + "/staff/accommodation?action=list&status=deleteRoomFail");
            return;
        }

        boolean success = roomDAO.deleteRoom(roomID);

        response.sendRedirect(request.getContextPath()
                + "/staff/accommodation?action=detail&id=" + serviceID
                + "&status=" + (success ? "deleteRoomSuccess" : "deleteRoomFail"));
    }

    private void updateAccommodationFacilities(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        Integer serviceID = parsePositiveInt(request.getParameter("serviceID"));

        if (serviceID == null) {
            response.sendRedirect(request.getContextPath()
                    + "/staff/accommodation?action=list&status=facilityFail");
            return;
        }

        int[] facilityIDs = facilityDAO.parseFacilityIDs(request.getParameterValues("facilityIDs"));
        boolean success = facilityDAO.updateAccommodationFacilities(serviceID, facilityIDs);

        response.sendRedirect(request.getContextPath()
                + "/staff/accommodation?action=detail&id=" + serviceID
                + "&status=" + (success ? "facilitySuccess" : "facilityFail"));
    }

    private void updateRoomFacilities(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        Integer roomID = parsePositiveInt(request.getParameter("roomID"));
        Integer serviceID = parsePositiveInt(request.getParameter("serviceID"));

        if (roomID == null || serviceID == null) {
            response.sendRedirect(request.getContextPath()
                    + "/staff/accommodation?action=list&status=roomFacilityFail");
            return;
        }

        int[] facilityIDs = facilityDAO.parseFacilityIDs(request.getParameterValues("facilityIDs"));
        boolean success = facilityDAO.updateRoomFacilities(roomID, facilityIDs);

        response.sendRedirect(request.getContextPath()
                + "/staff/accommodation?action=detail&id=" + serviceID
                + "&status=" + (success ? "roomFacilitySuccess" : "roomFacilityFail"));
    }

    private AccommodationData readAccommodationData(HttpServletRequest request) {
        AccommodationData data = new AccommodationData();

        data.serviceIDRaw = request.getParameter("serviceID");
        data.name = safeTrim(request.getParameter("name"));
        data.image = safeTrim(request.getParameter("image"));
        data.address = safeTrim(request.getParameter("address"));
        data.phone = safeTrim(request.getParameter("phone"));
        data.description = safeTrim(request.getParameter("description"));
        data.rateRaw = request.getParameter("rate");
        data.type = safeTrim(request.getParameter("type"));
        data.status = safeTrim(request.getParameter("status"));
        data.checkInTimeRaw = request.getParameter("checkInTime");
        data.checkOutTimeRaw = request.getParameter("checkOutTime");
        data.province = safeTrim(request.getParameter("province"));
        data.district = safeTrim(request.getParameter("district"));
        data.ward = safeTrim(request.getParameter("ward"));

        return data;
    }

    private RoomData readRoomData(HttpServletRequest request) {
        RoomData data = new RoomData();

        data.roomIDRaw = request.getParameter("roomID");
        data.serviceIDRaw = request.getParameter("serviceID");
        data.roomType = safeTrim(request.getParameter("roomType"));
        data.numberOfRoomsRaw = request.getParameter("numberOfRooms");
        data.priceOfRoomRaw = request.getParameter("priceOfRoom");
        data.status = safeTrim(request.getParameter("status"));
        data.roomAvailabilityRaw = request.getParameter("roomAvailability");
        data.image = safeTrim(request.getParameter("image"));
        data.description = safeTrim(request.getParameter("description"));
        data.bedCountRaw = request.getParameter("bedCount");
        data.bedType = safeTrim(request.getParameter("bedType"));
        data.maxAdultsRaw = request.getParameter("maxAdults");
        data.maxChildrenRaw = request.getParameter("maxChildren");
        data.roomSizeRaw = request.getParameter("roomSize");

        return data;
    }

    private Accommodation buildAccommodation(int serviceID, AccommodationData data) {
        Accommodation accommodation = new Accommodation();

        accommodation.setServiceID(serviceID);
        accommodation.setName(data.name);
        accommodation.setImage(data.image);
        accommodation.setAddress(data.address);
        accommodation.setPhone(data.phone);
        accommodation.setDescription(data.description);
        accommodation.setRate(Double.parseDouble(normalizeDecimal(data.rateRaw)));
        accommodation.setType(data.type);
        accommodation.setStatus(data.status);
        accommodation.setCheckInTime(parseTime(data.checkInTimeRaw));
        accommodation.setCheckOutTime(parseTime(data.checkOutTimeRaw));
        accommodation.setProvince(data.province);
        accommodation.setDistrict(data.district);
        accommodation.setWard(data.ward);

        Service service = new Service();
        service.setServiceID(serviceID);
        service.setServiceCategoryID(1);
        service.setServiceName(data.name);
        service.setStatus("Active");
        service.setServiceType("Accommodation");
        service.setFulfillmentType("Booking");

        accommodation.setServiceDetails(service);

        return accommodation;
    }

    private Room buildRoom(int roomID, int serviceID, RoomData data) {
        Room room = new Room();

        room.setRoomID(roomID);
        room.setServiceID(serviceID);
        room.setRoomType(data.roomType);
        room.setNumberOfRooms(Integer.parseInt(data.numberOfRoomsRaw.trim()));
        room.setPriceOfRoom(new BigDecimal(normalizeDecimal(data.priceOfRoomRaw)));
        room.setStatus(data.status);
        room.setRoomAvailability(Integer.parseInt(data.roomAvailabilityRaw.trim()));
        room.setImage(data.image);
        room.setDescription(data.description);
        room.setBedCount(Integer.parseInt(data.bedCountRaw.trim()));
        room.setBedType(data.bedType);
        room.setMaxAdults(Integer.parseInt(data.maxAdultsRaw.trim()));
        room.setMaxChildren(Integer.parseInt(data.maxChildrenRaw.trim()));
        room.setRoomSize(new BigDecimal(normalizeDecimal(data.roomSizeRaw)));

        return room;
    }

    private List<String> validateAccommodationInput(AccommodationData data) {
        List<String> errors = new ArrayList<>();

        if (isBlank(data.name) || data.name.length() < 2 || data.name.length() > 255) {
            errors.add("Tên nơi lưu trú phải từ 2 đến 255 ký tự.");
        }

        if (isBlank(data.image)) {
            errors.add("Ảnh nơi lưu trú không được để trống.");
        } else if (!isValidUrl(data.image)) {
            errors.add("Ảnh nơi lưu trú phải bắt đầu bằng http:// hoặc https://.");
        }

        if (isBlank(data.address) || data.address.length() < 3 || data.address.length() > 255) {
            errors.add("Địa chỉ cụ thể phải từ 3 đến 255 ký tự.");
        }

        if (isBlank(data.phone)) {
            errors.add("Số điện thoại không được để trống.");
        } else if (!data.phone.matches("^[0-9]{8,15}$")) {
            errors.add("Số điện thoại phải gồm 8 đến 15 chữ số.");
        }

        if (isBlank(data.description) || data.description.length() < 10 || data.description.length() > 2000) {
            errors.add("Mô tả nơi lưu trú phải từ 10 đến 2000 ký tự.");
        }

        Double rate = parseDouble(data.rateRaw);
        if (rate == null || rate < 0 || rate > 5) {
            errors.add("Đánh giá phải từ 0 đến 5.");
        }

        if (!isValidAccommodationType(data.type)) {
            errors.add("Loại lưu trú không hợp lệ.");
        }

        if (!isValidAccommodationStatus(data.status)) {
            errors.add("Trạng thái lưu trú không hợp lệ.");
        }

        if (parseTime(data.checkInTimeRaw) == null) {
            errors.add("Giờ nhận phòng không hợp lệ.");
        }

        if (parseTime(data.checkOutTimeRaw) == null) {
            errors.add("Giờ trả phòng không hợp lệ.");
        }

        if (isBlank(data.province) || data.province.length() < 2 || data.province.length() > 100) {
            errors.add("Tỉnh/thành phải từ 2 đến 100 ký tự.");
        }

        if (isBlank(data.district) || data.district.length() < 2 || data.district.length() > 100) {
            errors.add("Quận/huyện phải từ 2 đến 100 ký tự.");
        }

        if (!isBlank(data.ward) && (data.ward.length() < 2 || data.ward.length() > 100)) {
            errors.add("Phường/xã phải từ 2 đến 100 ký tự nếu có nhập.");
        }

        return errors;
    }

    private List<String> validateRoomInput(RoomData data) {
        List<String> errors = new ArrayList<>();

        if (isBlank(data.roomType) || data.roomType.length() < 2 || data.roomType.length() > 100) {
            errors.add("Loại phòng phải từ 2 đến 100 ký tự.");
        }

        Integer numberOfRooms = parsePositiveInt(data.numberOfRoomsRaw);
        if (numberOfRooms == null || numberOfRooms > 1000) {
            errors.add("Tổng số phòng phải từ 1 đến 1000.");
        }

        BigDecimal price = parseBigDecimal(data.priceOfRoomRaw);
        if (price == null || price.compareTo(BigDecimal.ZERO) <= 0
                || price.compareTo(new BigDecimal("1000000000")) > 0) {
            errors.add("Giá phòng phải lớn hơn 0 và không vượt quá 1.000.000.000.");
        }

        if (!isValidRoomStatus(data.status)) {
            errors.add("Trạng thái phòng không hợp lệ.");
        }

        Integer roomAvailability = parseNonNegativeInt(data.roomAvailabilityRaw);
        if (roomAvailability == null || roomAvailability > 1000) {
            errors.add("Số phòng còn trống phải từ 0 đến 1000.");
        }

        if (numberOfRooms != null && roomAvailability != null && roomAvailability > numberOfRooms) {
            errors.add("Số phòng còn trống không được lớn hơn tổng số phòng.");
        }

        if (isBlank(data.image)) {
            errors.add("Ảnh phòng không được để trống.");
        } else if (!isValidUrl(data.image)) {
            errors.add("Ảnh phòng phải bắt đầu bằng http:// hoặc https://.");
        }

        if (isBlank(data.description) || data.description.length() < 10 || data.description.length() > 2000) {
            errors.add("Mô tả phòng phải từ 10 đến 2000 ký tự.");
        }

        Integer bedCount = parsePositiveInt(data.bedCountRaw);
        if (bedCount == null || bedCount > 20) {
            errors.add("Số giường phải từ 1 đến 20.");
        }

        if (isBlank(data.bedType) || data.bedType.length() < 2 || data.bedType.length() > 50) {
            errors.add("Loại giường phải từ 2 đến 50 ký tự.");
        }

        Integer maxAdults = parsePositiveInt(data.maxAdultsRaw);
        if (maxAdults == null || maxAdults > 50) {
            errors.add("Số người lớn tối đa phải từ 1 đến 50.");
        }

        Integer maxChildren = parseNonNegativeInt(data.maxChildrenRaw);
        if (maxChildren == null || maxChildren > 50) {
            errors.add("Số trẻ em tối đa phải từ 0 đến 50.");
        }

        if (bedCount != null && maxAdults != null && maxChildren != null) {
            int totalGuests = maxAdults + maxChildren;

            if (bedCount == 1 && totalGuests > 4) {
                errors.add("1 giường không nên vượt quá 4 khách. Hãy tăng số giường hoặc giảm sức chứa.");
            }

            if (bedCount == 2 && totalGuests > 6) {
                errors.add("2 giường không nên vượt quá 6 khách. Hãy kiểm tra lại sức chứa.");
            }
        }

        BigDecimal roomSize = parseBigDecimal(data.roomSizeRaw);
        if (roomSize == null || roomSize.compareTo(BigDecimal.ZERO) <= 0
                || roomSize.compareTo(new BigDecimal("1000")) > 0) {
            errors.add("Diện tích phòng phải lớn hơn 0 và không vượt quá 1000 m².");
        }

        return errors;
    }

    private boolean isValidAccommodationType(String type) {
        return "Hotel".equals(type)
                || "Khách sạn".equals(type)
                || "Homestay".equals(type)
                || "Resort".equals(type)
                || "Apartment".equals(type)
                || "Căn hộ".equals(type)
                || "Villa".equals(type);
    }

    private boolean isValidAccommodationStatus(String status) {
        return "Available".equals(status)
                || "Active".equals(status)
                || "Unavailable".equals(status)
                || "Inactive".equals(status)
                || "Maintenance".equals(status);
    }

    private boolean isValidRoomStatus(String status) {
        return "Available".equals(status)
                || "Unavailable".equals(status)
                || "Maintenance".equals(status);
    }

    private boolean isValidUrl(String value) {
        return value != null && value.matches("^https?://.+");
    }

    private Time parseTime(String value) {
        try {
            if (value == null || value.trim().isEmpty()) {
                return null;
            }

            String normalized = value.trim();

            if (normalized.length() == 5) {
                normalized += ":00";
            }

            return Time.valueOf(normalized);
        } catch (Exception e) {
            return null;
        }
    }

    private Integer parsePositiveInt(String value) {
        try {
            if (value == null || value.trim().isEmpty()) {
                return null;
            }

            int number = Integer.parseInt(value.trim());
            return number > 0 ? number : null;
        } catch (Exception e) {
            return null;
        }
    }

    private Integer parseNonNegativeInt(String value) {
        try {
            if (value == null || value.trim().isEmpty()) {
                return null;
            }

            int number = Integer.parseInt(value.trim());
            return number >= 0 ? number : null;
        } catch (Exception e) {
            return null;
        }
    }

    private Double parseDouble(String value) {
        try {
            if (value == null || value.trim().isEmpty()) {
                return null;
            }

            return Double.parseDouble(normalizeDecimal(value));
        } catch (Exception e) {
            return null;
        }
    }

    private BigDecimal parseBigDecimal(String value) {
        try {
            if (value == null || value.trim().isEmpty()) {
                return null;
            }

            return new BigDecimal(normalizeDecimal(value));
        } catch (Exception e) {
            return null;
        }
    }

    private String normalizeDecimal(String value) {
        return value == null ? "" : value.trim().replace(",", ".");
    }

    private void saveErrors(HttpServletRequest request, List<String> errors) {
        request.getSession().setAttribute("errors", errors);
    }

    private String safeTrim(String value) {
        return value == null ? "" : value.trim();
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    private String encode(String value) {
        if (value == null) {
            return "";
        }

        return URLEncoder.encode(value, StandardCharsets.UTF_8);
    }

    private static class AccommodationData {
        String serviceIDRaw;
        String name;
        String image;
        String address;
        String phone;
        String description;
        String rateRaw;
        String type;
        String status;
        String checkInTimeRaw;
        String checkOutTimeRaw;
        String province;
        String district;
        String ward;
    }

    private static class RoomData {
        String roomIDRaw;
        String serviceIDRaw;
        String roomType;
        String numberOfRoomsRaw;
        String priceOfRoomRaw;
        String status;
        String roomAvailabilityRaw;
        String image;
        String description;
        String bedCountRaw;
        String bedType;
        String maxAdultsRaw;
        String maxChildrenRaw;
        String roomSizeRaw;
    }
}

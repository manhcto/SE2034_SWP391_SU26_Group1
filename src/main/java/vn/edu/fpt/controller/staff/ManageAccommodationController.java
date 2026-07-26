package vn.edu.fpt.controller.staff;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import vn.edu.fpt.DAO.AccommodationDAO;
import vn.edu.fpt.DAO.AdministrativeUnitDAO;
import vn.edu.fpt.DAO.FacilityDAO;
import vn.edu.fpt.DAO.RoomDAO;
import vn.edu.fpt.model.Accommodation;
import vn.edu.fpt.model.Facility;
import vn.edu.fpt.model.Room;
import vn.edu.fpt.model.User;

import java.io.IOException;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.Time;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "ManageAccommodationController", urlPatterns = {
        "/staff/accommodation",
        "/admin/accommodation"
})
public class ManageAccommodationController extends HttpServlet {

    private final AccommodationDAO accommodationDAO = new AccommodationDAO();
    private final AdministrativeUnitDAO administrativeUnitDAO = new AdministrativeUnitDAO();
    private final RoomDAO roomDAO = new RoomDAO();
    private final FacilityDAO facilityDAO = new FacilityDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        boolean adminReadOnly = "/admin/accommodation".equals(request.getServletPath());
        request.setAttribute("adminReadOnly", adminReadOnly);
        request.setAttribute("accommodationPath",
                request.getContextPath() + request.getServletPath());

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

            default:
                response.sendRedirect(basePath(request) + "?action=list");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        if ("/admin/accommodation".equals(request.getServletPath())) {
            response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
            return;
        }

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

    private void showAccommodationList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Accommodation> accommodationList = accommodationDAO.getAllAccommodations();
        List<Facility> accommodationFacilityOptions = facilityDAO.getAccommodationFacilityOptions();
        Map<Integer, List<Room>> roomsByAccommodation = new HashMap<>();
        Map<Integer, List<Facility>> facilitiesByAccommodation =
                facilityDAO.getAccommodationFacilitiesGroupedForEdit();

        for (Room room : roomDAO.getAllRooms()) {
            roomsByAccommodation
                    .computeIfAbsent(room.getAccommodationID(), ignored -> new ArrayList<>())
                    .add(room);
        }

        for (Accommodation accommodation : accommodationList) {
            int accommodationID = accommodation.getAccommodationID();
            accommodation.setRoomList(
                    roomsByAccommodation.getOrDefault(accommodationID, List.of()));
            accommodation.setFacilityList(
                    facilitiesByAccommodation.getOrDefault(accommodationID, List.of()));
        }

        request.setAttribute("accommodationList", accommodationList);
        request.setAttribute("accommodationFacilityOptions", accommodationFacilityOptions);
        request.setAttribute("accommodationFacilityEditOptions",
                facilityDAO.getAccommodationFacilityEditOptions());
        request.setAttribute("administrativeUnitList", administrativeUnitDAO.getActiveUnits());

        request.getRequestDispatcher("/views/staff/accommodation-management.jsp")
                .forward(request, response);
    }

    private void showAccommodationDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer accommodationID = parsePositiveInt(request.getParameter("id"));

        if (accommodationID == null) {
            response.sendRedirect(basePath(request) + "?action=list&status=notFound");
            return;
        }

        Accommodation accommodation = accommodationDAO.getAccommodationById(accommodationID);

        if (accommodation == null) {
            response.sendRedirect(basePath(request) + "?action=list&status=notFound");
            return;
        }

        List<Room> roomList = roomDAO.getRoomsByAccommodation(accommodationID);
        Map<Integer, List<Facility>> facilitiesByRoom =
                facilityDAO.getRoomFacilitiesGroupedForEdit();
        for (Room room : roomList) {
            room.setFacilityList(
                    facilitiesByRoom.getOrDefault(room.getRoomID(), List.of()));
        }

        accommodation.setRoomList(roomList);
        accommodation.setFacilityList(
                facilityDAO.getAccommodationFacilitiesGroupedForEdit()
                        .getOrDefault(accommodationID, List.of()));

        request.setAttribute("accommodation", accommodation);
        request.setAttribute("roomList", roomList);
        request.setAttribute("accommodationFacilityOptions", facilityDAO.getAccommodationFacilityOptions());
        request.setAttribute("accommodationFacilityEditOptions",
                facilityDAO.getAccommodationFacilityEditOptions());
        request.setAttribute("roomFacilityOptions", facilityDAO.getRoomFacilityOptions());
        request.setAttribute("roomFacilityEditOptions", facilityDAO.getRoomFacilityEditOptions());

        request.getRequestDispatcher("/views/staff/accommodation-detail.jsp")
                .forward(request, response);
    }

    private void addAccommodation(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        AccommodationData data = readAccommodationData(request);
        Map<String, String> errors = validateAccommodationInput(data);

        if (!errors.isEmpty()) {
            saveErrors(request, errors);

            response.sendRedirect(request.getContextPath()
                    + "/staff/accommodation?action=list&status=validationFail");
            return;
        }

        Accommodation accommodation = buildAccommodation(0, data);
        HttpSession session = request.getSession(false);
        User currentUser = session == null ? null : (User) session.getAttribute("user");
        accommodation.setCreatedByUserID(currentUser == null ? null : currentUser.getUserID());

        int[] facilityIDs = facilityDAO.parseFacilityIDs(request.getParameterValues("facilityIDs"));
        int newAccommodationID = accommodationDAO.addAccommodationWithFacilities(
                accommodation, facilityIDs);

        response.sendRedirect(request.getContextPath()
                + "/staff/accommodation?action=list&status="
                + (newAccommodationID > 0 ? "addSuccess" : "addFail"));
    }

    private void updateAccommodation(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        AccommodationData data = readAccommodationData(request);
        Map<String, String> errors = validateAccommodationInput(data);

        Integer accommodationID = parsePositiveInt(data.accommodationIDRaw);

        if (accommodationID == null) {
            errors.put("accommodationID", "Mã nơi lưu trú không hợp lệ.");
        } else if (accommodationDAO.getAccommodationById(accommodationID) == null) {
            errors.put("accommodationID", "Nơi lưu trú không tồn tại.");
        }

        if (!errors.isEmpty()) {
            saveErrors(request, errors);

            response.sendRedirect(request.getContextPath()
                    + "/staff/accommodation?action=list&status=validationFail");
            return;
        }

        Accommodation accommodation = buildAccommodation(accommodationID, data);

        int[] facilityIDs = facilityDAO.parseFacilityIDs(request.getParameterValues("facilityIDs"));
        boolean success = accommodationDAO.updateAccommodationWithFacilities(
                accommodation, facilityIDs);

        response.sendRedirect(request.getContextPath()
                + "/staff/accommodation?action=list&status="
                + (success ? "updateSuccess" : "updateFail"));
    }

    private void deleteAccommodation(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        Integer accommodationID = parsePositiveInt(request.getParameter("id"));

        if (accommodationID == null) {
            response.sendRedirect(request.getContextPath()
                    + "/staff/accommodation?action=list&status=deleteFail");
            return;
        }

        if (accommodationDAO.getAccommodationById(accommodationID) == null) {
            response.sendRedirect(request.getContextPath()
                    + "/staff/accommodation?action=list&status=notFound");
            return;
        }

        boolean referenced = accommodationDAO.hasBookingReferences(accommodationID);
        boolean success = referenced
                ? accommodationDAO.deactivateAccommodation(accommodationID)
                : accommodationDAO.deleteAccommodation(accommodationID);

        response.sendRedirect(request.getContextPath()
                + "/staff/accommodation?action=list&status="
                + (success
                ? (referenced ? "deactivateSuccess" : "deleteSuccess")
                : "deleteFail"));
    }

    private void addRoom(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        RoomData data = readRoomData(request);
        Map<String, String> errors = validateRoomInput(data);

        Integer accommodationID = parsePositiveInt(data.accommodationIDRaw);

        if (accommodationID == null) {
            errors.put("accommodationID", "Mã nơi lưu trú không hợp lệ.");
        } else if (accommodationDAO.getAccommodationById(accommodationID) == null) {
            errors.put("accommodationID", "Nơi lưu trú không tồn tại.");
        }

        if (!errors.isEmpty()) {
            saveErrors(request, errors);

            response.sendRedirect(request.getContextPath()
                    + "/staff/accommodation?action=detail&id=" + encode(data.accommodationIDRaw)
                    + "&status=validationFail");
            return;
        }

        Room room = buildRoom(0, accommodationID, data);
        int[] facilityIDs = facilityDAO.parseFacilityIDs(request.getParameterValues("facilityIDs"));
        boolean success = roomDAO.addRoomWithFacilities(room, facilityIDs) > 0;

        response.sendRedirect(request.getContextPath()
                + "/staff/accommodation?action=detail&id=" + accommodationID
                + "&status=" + (success ? "addRoomSuccess" : "addRoomFail"));
    }

    private void updateRoom(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        RoomData data = readRoomData(request);
        Map<String, String> errors = validateRoomInput(data);

        Integer roomID = parsePositiveInt(data.roomIDRaw);
        Integer accommodationID = parsePositiveInt(data.accommodationIDRaw);

        if (roomID == null) {
            errors.put("roomID", "Mã phòng không hợp lệ.");
        }

        if (accommodationID == null) {
            errors.put("accommodationID", "Mã nơi lưu trú không hợp lệ.");
        }

        if (roomID != null && accommodationID != null
                && roomDAO.getRoomByIdAndAccommodation(roomID, accommodationID) == null) {
            errors.put("roomID", "Phòng không thuộc nơi lưu trú này hoặc không tồn tại.");
        }

        if (!errors.isEmpty()) {
            saveErrors(request, errors);

            response.sendRedirect(request.getContextPath()
                    + "/staff/accommodation?action=detail&id=" + encode(data.accommodationIDRaw)
                    + "&status=validationFail");
            return;
        }

        Room room = buildRoom(roomID, accommodationID, data);
        int[] facilityIDs = facilityDAO.parseFacilityIDs(request.getParameterValues("facilityIDs"));
        boolean success = roomDAO.updateRoomWithFacilities(room, facilityIDs);

        response.sendRedirect(request.getContextPath()
                + "/staff/accommodation?action=detail&id=" + accommodationID
                + "&status=" + (success ? "updateRoomSuccess" : "updateRoomFail"));
    }

    private void deleteRoom(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        Integer roomID = parsePositiveInt(request.getParameter("roomID"));
        Integer accommodationID = parsePositiveInt(request.getParameter("accommodationID"));

        if (roomID == null || accommodationID == null) {
            response.sendRedirect(request.getContextPath()
                    + "/staff/accommodation?action=list&status=deleteRoomFail");
            return;
        }

        boolean referenced = roomDAO.hasBookingReferences(roomID, accommodationID);
        boolean success = referenced
                ? roomDAO.deactivateRoom(roomID, accommodationID)
                : roomDAO.deleteRoom(roomID, accommodationID);

        response.sendRedirect(request.getContextPath()
                + "/staff/accommodation?action=detail&id=" + accommodationID
                + "&status=" + (success
                ? (referenced ? "deactivateRoomSuccess" : "deleteRoomSuccess")
                : "deleteRoomFail"));
    }

    private void updateAccommodationFacilities(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        Integer accommodationID = parsePositiveInt(request.getParameter("accommodationID"));

        if (accommodationID == null) {
            response.sendRedirect(request.getContextPath()
                    + "/staff/accommodation?action=list&status=facilityFail");
            return;
        }

        if (accommodationDAO.getAccommodationById(accommodationID) == null) {
            response.sendRedirect(request.getContextPath()
                    + "/staff/accommodation?action=list&status=facilityFail");
            return;
        }

        int[] facilityIDs = facilityDAO.parseFacilityIDs(request.getParameterValues("facilityIDs"));
        boolean success = facilityDAO.updateAccommodationFacilities(accommodationID, facilityIDs);

        response.sendRedirect(request.getContextPath()
                + "/staff/accommodation?action=detail&id=" + accommodationID
                + "&status=" + (success ? "facilitySuccess" : "facilityFail"));
    }

    private void updateRoomFacilities(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        Integer roomID = parsePositiveInt(request.getParameter("roomID"));
        Integer accommodationID = parsePositiveInt(request.getParameter("accommodationID"));

        if (roomID == null || accommodationID == null) {
            response.sendRedirect(request.getContextPath()
                    + "/staff/accommodation?action=list&status=roomFacilityFail");
            return;
        }

        if (roomDAO.getRoomByIdAndAccommodation(roomID, accommodationID) == null) {
            response.sendRedirect(request.getContextPath()
                    + "/staff/accommodation?action=detail&id=" + accommodationID
                    + "&status=roomFacilityFail");
            return;
        }

        int[] facilityIDs = facilityDAO.parseFacilityIDs(request.getParameterValues("facilityIDs"));
        boolean success = facilityDAO.updateRoomFacilities(roomID, facilityIDs);

        response.sendRedirect(request.getContextPath()
                + "/staff/accommodation?action=detail&id=" + accommodationID
                + "&status=" + (success ? "roomFacilitySuccess" : "roomFacilityFail"));
    }

    private AccommodationData readAccommodationData(HttpServletRequest request) {
        AccommodationData data = new AccommodationData();

        data.accommodationIDRaw = request.getParameter("accommodationID");
        data.name = safeTrim(request.getParameter("name"));
        data.image = safeTrim(request.getParameter("image"));
        data.address = safeTrim(request.getParameter("address"));
        data.phone = safeTrim(request.getParameter("phone"));
        data.description = safeTrim(request.getParameter("description"));
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
        data.accommodationIDRaw = request.getParameter("accommodationID");
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

    private Accommodation buildAccommodation(int accommodationID, AccommodationData data) {
        Accommodation accommodation = new Accommodation();

        accommodation.setAccommodationID(accommodationID);
        accommodation.setName(data.name);
        accommodation.setImage(data.image);
        accommodation.setAddress(data.address);
        accommodation.setPhone(data.phone);
        accommodation.setDescription(data.description);
        accommodation.setType(data.type);
        accommodation.setStatus(data.status);
        accommodation.setCheckInTime(parseTime(data.checkInTimeRaw));
        accommodation.setCheckOutTime(parseTime(data.checkOutTimeRaw));
        accommodation.setProvince(data.province);
        accommodation.setDistrict(data.district);
        accommodation.setWard(data.ward);

        return accommodation;
    }

    private Room buildRoom(int roomID, int accommodationID, RoomData data) {
        Room room = new Room();

        room.setRoomID(roomID);
        room.setAccommodationID(accommodationID);
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
        room.setRoomSize(parseBigDecimal(data.roomSizeRaw));

        return room;
    }

    private Map<String, String> validateAccommodationInput(AccommodationData data) {
        Map<String, String> errors = new LinkedHashMap<>();

        if (isBlank(data.name) || data.name.length() < 2 || data.name.length() > 255) {
            errors.put("name", "Tên nơi lưu trú phải từ 2 đến 255 ký tự.");
        }

        if (!isBlank(data.image) && !isValidUrl(data.image)) {
            errors.put("image", "Ảnh nơi lưu trú phải bắt đầu bằng http:// hoặc https://.");
        }

        if (isBlank(data.address) || data.address.length() < 3 || data.address.length() > 255) {
            errors.put("address", "Địa chỉ cụ thể phải từ 3 đến 255 ký tự.");
        }

        if (!isBlank(data.phone) && !data.phone.matches("^[0-9]{10,11}$")) {
            errors.put("phone", "Số điện thoại phải gồm 10 đến 11 chữ số.");
        }

        if (data.description.length() > 1000) {
            errors.put("description", "Mô tả nơi lưu trú không được vượt quá 1000 ký tự.");
        }

        if (!isValidAccommodationType(data.type)) {
            errors.put("type", "Loại lưu trú không hợp lệ.");
        }

        if (!isValidAccommodationStatus(data.status)) {
            errors.put("status", "Trạng thái lưu trú không hợp lệ.");
        }

        if (!isBlank(data.checkInTimeRaw) && parseTime(data.checkInTimeRaw) == null) {
            errors.put("checkInTime", "Giờ nhận phòng không hợp lệ.");
        }

        if (!isBlank(data.checkOutTimeRaw) && parseTime(data.checkOutTimeRaw) == null) {
            errors.put("checkOutTime", "Giờ trả phòng không hợp lệ.");
        }

        if (!administrativeUnitDAO.isValidProvinceWard(data.province, data.ward)) {
            errors.put("ward", "Tỉnh/thành và phường/xã không hợp lệ theo danh mục hành chính.");
        }

        return errors;
    }

    private Map<String, String> validateRoomInput(RoomData data) {
        Map<String, String> errors = new LinkedHashMap<>();

        if (isBlank(data.roomType) || data.roomType.length() > 100) {
            errors.put("roomType", "Loại phòng là bắt buộc và không được vượt quá 100 ký tự.");
        }

        Integer numberOfRooms = parseNonNegativeInt(data.numberOfRoomsRaw);
        if (numberOfRooms == null || numberOfRooms > 1000) {
            errors.put("numberOfRooms", "Tổng số phòng phải từ 0 đến 1000.");
        }

        BigDecimal price = parseBigDecimal(data.priceOfRoomRaw);
        if (price == null || price.compareTo(BigDecimal.ZERO) <= 0
                || price.compareTo(new BigDecimal("1000000000")) > 0) {
            errors.put("priceOfRoom", "Giá phòng phải lớn hơn 0 và không vượt quá 1.000.000.000.");
        }

        if (!isValidRoomStatus(data.status)) {
            errors.put("status", "Trạng thái phòng không hợp lệ.");
        }

        Integer roomAvailability = parseNonNegativeInt(data.roomAvailabilityRaw);
        if (roomAvailability == null || roomAvailability > 1000) {
            errors.put("roomAvailability", "Số phòng còn trống phải từ 0 đến 1000.");
        }

        if (numberOfRooms != null && roomAvailability != null && roomAvailability > numberOfRooms) {
            errors.put("roomAvailability", "Số phòng còn trống không được lớn hơn tổng số phòng.");
        }

        if (!isBlank(data.image) && !isValidUrl(data.image)) {
            errors.put("image", "Ảnh phòng phải bắt đầu bằng http:// hoặc https://.");
        }

        if (data.description.length() > 2000) {
            errors.put("description", "Mô tả phòng không được vượt quá 2000 ký tự.");
        }

        Integer bedCount = parsePositiveInt(data.bedCountRaw);
        if (bedCount == null || bedCount > 20) {
            errors.put("bedCount", "Số giường phải từ 1 đến 20.");
        }

        if (data.bedType.length() > 50) {
            errors.put("bedType", "Loại giường không được vượt quá 50 ký tự.");
        }

        Integer maxAdults = parsePositiveInt(data.maxAdultsRaw);
        if (maxAdults == null || maxAdults > 50) {
            errors.put("maxAdults", "Số người lớn tối đa phải từ 1 đến 50.");
        }

        Integer maxChildren = parseNonNegativeInt(data.maxChildrenRaw);
        if (maxChildren == null || maxChildren > 50) {
            errors.put("maxChildren", "Số trẻ em tối đa phải từ 0 đến 50.");
        }

        BigDecimal roomSize = parseBigDecimal(data.roomSizeRaw);
        if (!isBlank(data.roomSizeRaw) && (roomSize == null
                || roomSize.compareTo(BigDecimal.ZERO) <= 0
                || roomSize.compareTo(new BigDecimal("1000")) > 0)) {
            errors.put("roomSize", "Diện tích phòng phải lớn hơn 0 và không vượt quá 1000 m².");
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

    private void saveErrors(HttpServletRequest request, Map<String, String> errors) {
        HttpSession session = request.getSession();
        session.setAttribute("errors", new ArrayList<>(errors.values()));
        session.setAttribute("fieldErrors", errors);

        Map<String, String> formValues = new HashMap<>();
        request.getParameterMap().forEach((name, values) -> {
            if (values != null && values.length > 0) {
                formValues.put(name, values[0]);
            }
        });
        session.setAttribute("formValues", formValues);
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

    private String basePath(HttpServletRequest request) {
        return request.getContextPath() + request.getServletPath();
    }

    private static class AccommodationData {
        String accommodationIDRaw;
        String name;
        String image;
        String address;
        String phone;
        String description;
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
        String accommodationIDRaw;
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

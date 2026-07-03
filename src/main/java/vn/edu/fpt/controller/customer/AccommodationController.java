package vn.edu.fpt.controller.customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import vn.edu.fpt.DAO.AccommodationDAO;
import vn.edu.fpt.DAO.FacilityDAO;
import vn.edu.fpt.DAO.RoomBookingDAO;
import vn.edu.fpt.DAO.RoomDAO;
import vn.edu.fpt.model.Accommodation;
import vn.edu.fpt.model.Facility;
import vn.edu.fpt.model.Room;
import vn.edu.fpt.model.User;

import java.io.IOException;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.Date;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.UUID;

@WebServlet(name = "CustomerAccommodationController", urlPatterns = {
        "/accommodation",
        "/accommodation/detail",
        "/accommodation/room/detail",
        "/booking/accommodation/form",
        "/booking/accommodation"
})
@MultipartConfig(
        maxFileSize = 5 * 1024 * 1024,
        maxRequestSize = 6 * 1024 * 1024
)
public class AccommodationController extends HttpServlet {

    private final AccommodationDAO accommodationDAO = new AccommodationDAO();
    private final RoomDAO roomDAO = new RoomDAO();
    private final FacilityDAO facilityDAO = new FacilityDAO();
    private final RoomBookingDAO roomBookingDAO = new RoomBookingDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String path = request.getServletPath();

        if ("/booking/accommodation/form".equals(path)) {
            showAccommodationBookingForm(request, response);
            return;
        }

        if ("/accommodation/detail".equals(path)) {
            showAccommodationDetail(request, response);
            return;
        }

        if ("/accommodation/room/detail".equals(path)) {
            showRoomDetail(request, response);
            return;
        }

        showAccommodationList(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        if ("/booking/accommodation".equals(request.getServletPath())) {
            handleAccommodationBooking(request, response);
            return;
        }

        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
    }

    private void showAccommodationList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = safeLower(request.getParameter("keyword"));
        String province = safeTrim(request.getParameter("province"));
        String district = safeTrim(request.getParameter("district"));
        String type = safeTrim(request.getParameter("type"));

        String checkIn = safeTrim(request.getParameter("checkIn"));
        String checkOut = safeTrim(request.getParameter("checkOut"));

        Integer adults = parsePositiveInt(request.getParameter("adults"));
        Integer children = parseNonNegativeInt(request.getParameter("children"));
        Integer rooms = parsePositiveInt(request.getParameter("rooms"));
        Integer guests = parsePositiveInt(request.getParameter("guests"));

        if (adults == null) {
            adults = 2;
        }

        if (children == null) {
            children = 0;
        }

        if (rooms == null) {
            rooms = 1;
        }

        if (guests == null) {
            guests = adults + children;
        }

        Integer facilityId = parsePositiveInt(request.getParameter("facilityId"));
        String facilityName = safeTrim(request.getParameter("facilityName"));

        Double minRate = parseNonNegativeDouble(request.getParameter("minRate"));
        BigDecimal minPrice = parseNonNegativeBigDecimal(request.getParameter("minPrice"));
        BigDecimal maxPrice = parseNonNegativeBigDecimal(request.getParameter("maxPrice"));

        List<Accommodation> allAccommodations = accommodationDAO.getAvailableAccommodationsForCustomer();
        List<Accommodation> filteredAccommodations = new ArrayList<>();

        for (Accommodation accommodation : allAccommodations) {
            int accommodationID = accommodation.getAccommodationID();

            /*
             * Hiện tại vẫn dùng hàm cũ getAvailableRoomsByAccommodation(accommodationID).
             *
             * Sau này khi nhóm code booking theo ngày, thay dòng này bằng:
             * roomDAO.getAvailableRoomsByAccommodationAndDate(accommodationID, checkIn, checkOut, rooms);
             */
            List<Room> availableRooms = hasDateRange(checkIn, checkOut)
                    ? roomDAO.getAvailableRoomsByAccommodationAndDate(accommodationID, checkIn, checkOut)
                    : roomDAO.getAvailableRoomsByAccommodation(accommodationID);

            for (Room room : availableRooms) {
                room.setFacilityList(facilityDAO.getFacilitiesByRoom(room.getRoomID()));
            }

            List<Facility> accommodationFacilities = facilityDAO.getFacilitiesByAccommodation(accommodationID);

            accommodation.setRoomList(availableRooms);
            accommodation.setFacilityList(accommodationFacilities);

            if (!matchesKeyword(accommodation, keyword)) {
                continue;
            }

            if (!isBlank(province)
                    && !safeLower(accommodation.getProvince()).contains(safeLower(province))) {
                continue;
            }

            if (!isBlank(district)
                    && !safeLower(accommodation.getDistrict()).contains(safeLower(district))
                    && !safeLower(accommodation.getFullAddress()).contains(safeLower(district))) {
                continue;
            }

            if (!isBlank(type)
                    && !safeLower(accommodation.getType()).contains(safeLower(type))
                    && !safeLower(accommodation.getDisplayType()).contains(safeLower(type))) {
                continue;
            }

            if (minRate != null && accommodation.getRate() < minRate) {
                continue;
            }

            if (guests != null && !hasRoomForGuests(availableRooms, guests)) {
                continue;
            }

            if (rooms != null && !hasEnoughRoomQuantity(availableRooms, rooms)) {
                continue;
            }

            if (minPrice != null && !hasRoomPriceAtLeast(availableRooms, minPrice)) {
                continue;
            }

            if (maxPrice != null && !hasRoomPriceAtMost(availableRooms, maxPrice)) {
                continue;
            }

            if (facilityId != null && !hasFacilityById(accommodationFacilities, facilityId)) {
                continue;
            }

            if (!isBlank(facilityName) && !hasFacilityByName(accommodationFacilities, facilityName)) {
                continue;
            }

            filteredAccommodations.add(accommodation);
        }

        request.setAttribute("accommodationList", filteredAccommodations);
        request.setAttribute("accommodationFacilityOptions", facilityDAO.getAccommodationFacilityOptions());

        request.setAttribute("keyword", request.getParameter("keyword"));
        request.setAttribute("selectedProvince", province);
        request.setAttribute("selectedDistrict", district);
        request.setAttribute("selectedType", type);
        request.setAttribute("selectedGuests", guests);
        request.setAttribute("selectedAdults", adults);
        request.setAttribute("selectedChildren", children);
        request.setAttribute("selectedRooms", rooms);
        request.setAttribute("selectedCheckIn", checkIn);
        request.setAttribute("selectedCheckOut", checkOut);
        request.setAttribute("selectedFacilityId", facilityId);
        request.setAttribute("selectedFacilityName", facilityName);
        request.setAttribute("selectedMinRate", request.getParameter("minRate"));
        request.setAttribute("selectedMinPrice", request.getParameter("minPrice"));
        request.setAttribute("selectedMaxPrice", request.getParameter("maxPrice"));

        request.getRequestDispatcher("/views/customer/accommodation-list.jsp")
                .forward(request, response);
    }

    private void showAccommodationDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer accommodationID = parsePositiveInt(request.getParameter("id"));

        String checkIn = safeTrim(request.getParameter("checkIn"));
        String checkOut = safeTrim(request.getParameter("checkOut"));

        Integer adults = parsePositiveInt(request.getParameter("adults"));
        Integer children = parseNonNegativeInt(request.getParameter("children"));
        Integer rooms = parsePositiveInt(request.getParameter("rooms"));
        Integer guests = parsePositiveInt(request.getParameter("guests"));

        if (adults == null) {
            adults = 2;
        }

        if (children == null) {
            children = 0;
        }

        if (rooms == null) {
            rooms = 1;
        }

        if (guests == null) {
            guests = adults + children;
        }

        if (accommodationID == null) {
            response.sendRedirect(request.getContextPath() + "/accommodation");
            return;
        }

        Accommodation accommodation = accommodationDAO.getAccommodationByIdForCustomer(accommodationID);

        if (accommodation == null) {
            response.sendRedirect(request.getContextPath() + "/accommodation?status=notFound");
            return;
        }

        /*
         * Hiện tại vẫn lấy room theo accommodation.
         * Sau này khi có bảng booking theo ngày, thay bằng hàm lọc theo checkIn/checkOut.
         */
        List<Room> roomList = hasDateRange(checkIn, checkOut)
                ? roomDAO.getAvailableRoomsByAccommodationAndDate(accommodationID, checkIn, checkOut)
                : roomDAO.getAvailableRoomsByAccommodation(accommodationID);

        List<Room> filteredRooms = new ArrayList<>();

        for (Room room : roomList) {
            room.setFacilityList(facilityDAO.getFacilitiesByRoom(room.getRoomID()));

            boolean matchGuest = guests == null
                    || room.getMaxAdults() + room.getMaxChildren() >= guests;

            boolean matchQuantity = rooms == null
                    || room.getRoomAvailability() >= rooms;

            if (matchGuest && matchQuantity) {
                filteredRooms.add(room);
            }
        }

        accommodation.setRoomList(filteredRooms);
        accommodation.setFacilityList(facilityDAO.getFacilitiesByAccommodation(accommodationID));

        request.setAttribute("accommodation", accommodation);
        request.setAttribute("roomList", filteredRooms);

        request.setAttribute("checkIn", checkIn);
        request.setAttribute("checkOut", checkOut);
        request.setAttribute("adults", adults);
        request.setAttribute("children", children);
        request.setAttribute("rooms", rooms);
        request.setAttribute("guests", guests);

        request.getRequestDispatcher("/views/customer/accommodation-detail.jsp")
                .forward(request, response);
    }

    private void showRoomDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer roomID = parsePositiveInt(request.getParameter("id"));
        Integer accommodationID = parsePositiveInt(request.getParameter("accommodationID"));

        String checkIn = safeTrim(request.getParameter("checkIn"));
        String checkOut = safeTrim(request.getParameter("checkOut"));

        Integer adults = parsePositiveInt(request.getParameter("adults"));
        Integer children = parseNonNegativeInt(request.getParameter("children"));
        Integer rooms = parsePositiveInt(request.getParameter("rooms"));
        Integer guests = parsePositiveInt(request.getParameter("guests"));

        if (adults == null) {
            adults = 2;
        }

        if (children == null) {
            children = 0;
        }

        if (rooms == null) {
            rooms = 1;
        }

        if (guests == null) {
            guests = adults + children;
        }

        if (roomID == null || accommodationID == null) {
            response.sendRedirect(request.getContextPath() + "/accommodation");
            return;
        }

        Accommodation accommodation = accommodationDAO.getAccommodationByIdForCustomer(accommodationID);

        if (accommodation == null) {
            response.sendRedirect(request.getContextPath() + "/accommodation?status=notFound");
            return;
        }

        List<Room> roomList = hasDateRange(checkIn, checkOut)
                ? roomDAO.getAvailableRoomsByAccommodationAndDate(accommodationID, checkIn, checkOut)
                : roomDAO.getAvailableRoomsByAccommodation(accommodationID);
        Room selectedRoom = null;

        for (Room room : roomList) {
            if (room.getRoomID() == roomID) {
                selectedRoom = room;
                break;
            }
        }

        if (selectedRoom == null) {
            response.sendRedirect(request.getContextPath()
                    + "/accommodation/detail?id=" + accommodationID
                    + "&checkIn=" + checkIn
                    + "&checkOut=" + checkOut
                    + "&adults=" + adults
                    + "&children=" + children
                    + "&rooms=" + rooms
                    + "&guests=" + guests
                    + "&status=roomNotFound");
            return;
        }

        selectedRoom.setFacilityList(facilityDAO.getFacilitiesByRoom(roomID));
        accommodation.setFacilityList(facilityDAO.getFacilitiesByAccommodation(accommodationID));

        long nights = calculateNights(checkIn, checkOut);
        BigDecimal totalPrice = calculateTotalPrice(selectedRoom.getPriceOfRoom(), rooms, nights);

        request.setAttribute("accommodation", accommodation);
        request.setAttribute("room", selectedRoom);

        request.setAttribute("roomId", roomID);
        request.setAttribute("accommodationID", accommodationID);

        request.setAttribute("checkIn", checkIn);
        request.setAttribute("checkOut", checkOut);
        request.setAttribute("adults", adults);
        request.setAttribute("children", children);
        request.setAttribute("rooms", rooms);
        request.setAttribute("guests", guests);
        request.setAttribute("nights", nights);
        request.setAttribute("totalPrice", totalPrice);

        request.getRequestDispatcher("/views/customer/room-detail.jsp")
                .forward(request, response);
    }

    private void showAccommodationBookingForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = session == null ? null : (User) session.getAttribute("user");

        if (user == null) {
            request.getSession().setAttribute("redirectAfterLogin", currentPathWithQuery(request));
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Integer accommodationID = parsePositiveInt(request.getParameter("accommodationID"));
        Integer roomID = parsePositiveInt(request.getParameter("roomID"));
        Integer adults = parsePositiveInt(request.getParameter("adults"));
        Integer children = parseNonNegativeInt(request.getParameter("children"));
        Integer rooms = parsePositiveInt(request.getParameter("rooms"));
        String checkIn = safeTrim(request.getParameter("checkIn"));
        String checkOut = safeTrim(request.getParameter("checkOut"));

        String detailUrl = buildRoomDetailUrl(request, accommodationID, roomID, checkIn, checkOut,
                adults, children, rooms);

        if (accommodationID == null || roomID == null || adults == null || children == null || rooms == null
                || !hasDateRange(checkIn, checkOut)) {
            response.sendRedirect(detailUrl + "&status=invalidBooking");
            return;
        }

        Accommodation accommodation = accommodationDAO.getAccommodationByIdForCustomer(accommodationID);
        Room selectedRoom = findSelectedAvailableRoom(accommodationID, roomID, checkIn, checkOut);

        if (accommodation == null || selectedRoom == null || selectedRoom.getRoomAvailability() < rooms) {
            response.sendRedirect(detailUrl + "&status=roomUnavailable");
            return;
        }

        long nights = calculateNights(checkIn, checkOut);
        BigDecimal totalPrice = calculateTotalPrice(selectedRoom.getPriceOfRoom(), rooms, nights);

        request.setAttribute("user", user);
        request.setAttribute("accommodation", accommodation);
        request.setAttribute("room", selectedRoom);
        request.setAttribute("checkIn", checkIn);
        request.setAttribute("checkOut", checkOut);
        request.setAttribute("adults", adults);
        request.setAttribute("children", children);
        request.setAttribute("rooms", rooms);
        request.setAttribute("guests", adults + children);
        request.setAttribute("nights", nights);
        request.setAttribute("totalPrice", totalPrice);
        request.setAttribute("detailUrl", detailUrl);

        request.getRequestDispatcher("/views/customer/accommodation-booking-form.jsp")
                .forward(request, response);
    }

    private void handleAccommodationBooking(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        HttpSession session = request.getSession(false);
        User user = session == null ? null : (User) session.getAttribute("user");

        Integer accommodationID = parsePositiveInt(request.getParameter("accommodationID"));
        Integer roomID = parsePositiveInt(request.getParameter("roomID"));
        Integer adults = parsePositiveInt(request.getParameter("adults"));
        Integer children = parseNonNegativeInt(request.getParameter("children"));
        Integer rooms = parsePositiveInt(request.getParameter("rooms"));
        String checkIn = safeTrim(request.getParameter("checkIn"));
        String checkOut = safeTrim(request.getParameter("checkOut"));
        String firstName = safeTrim(request.getParameter("firstName"));
        String lastName = safeTrim(request.getParameter("lastName"));
        String email = safeTrim(request.getParameter("email"));
        String phone = safeTrim(request.getParameter("phone"));
        String address = safeTrim(request.getParameter("address"));
        String identityNumber = normalizeIdentityNumber(request.getParameter("identityNumber"));
        Part identityImagePart = request.getPart("identityImage");
        String note = safeTrim(request.getParameter("note"));

        String detailUrl = buildRoomDetailUrl(request, accommodationID, roomID, checkIn, checkOut,
                adults, children, rooms);

        if (user == null) {
            request.getSession().setAttribute("redirectAfterLogin", stripContextPath(detailUrl, request));
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        if (accommodationID == null || roomID == null || adults == null || children == null || rooms == null
                || !hasDateRange(checkIn, checkOut)) {
            response.sendRedirect(detailUrl + "&status=invalidBooking");
            return;
        }

        if (isBlank(firstName) || isBlank(lastName) || isBlank(email) || isBlank(phone)
                || isBlank(address) || !isValidIdentityNumber(identityNumber)
                || !isValidIdentityImage(identityImagePart)) {
            response.sendRedirect(buildBookingFormUrl(request, accommodationID, roomID, checkIn, checkOut,
                    adults, children, rooms) + "&status=invalidCustomerInfo");
            return;
        }

        Room selectedRoom = findSelectedAvailableRoom(accommodationID, roomID, checkIn, checkOut);

        if (selectedRoom == null || selectedRoom.getRoomAvailability() < rooms) {
            response.sendRedirect(detailUrl + "&status=roomUnavailable");
            return;
        }

        long nights = calculateNights(checkIn, checkOut);
        BigDecimal unitPrice = selectedRoom.getPriceOfRoom();
        BigDecimal totalPrice = calculateTotalPrice(unitPrice, rooms, nights);
        String identityImageUrl = saveIdentityImage(request, identityImagePart, user.getUserID());

        if (identityImageUrl == null) {
            response.sendRedirect(buildBookingFormUrl(request, accommodationID, roomID, checkIn, checkOut,
                    adults, children, rooms) + "&status=invalidCustomerInfo");
            return;
        }

        int bookingID = roomBookingDAO.createAccommodationBooking(
                user.getUserID(),
                firstName,
                lastName,
                email,
                phone,
                accommodationID,
                roomID,
                Date.valueOf(checkIn),
                Date.valueOf(checkOut),
                adults,
                children,
                rooms,
                unitPrice,
                totalPrice,
                address,
                identityNumber,
                identityImageUrl,
                note);

        if (bookingID <= 0) {
            response.sendRedirect(detailUrl + "&status=bookingFail");
            return;
        }

        session.setAttribute("successMessage", "Dat phong thanh cong. Ma don: #" + bookingID);
        response.sendRedirect(detailUrl + "&status=bookingSuccess");
    }

    private boolean matchesKeyword(Accommodation accommodation, String keyword) {
        if (isBlank(keyword)) {
            return true;
        }

        String name = safeLower(accommodation.getName());
        String address = safeLower(accommodation.getAddress());
        String fullAddress = safeLower(accommodation.getFullAddress());
        String description = safeLower(accommodation.getDescription());
        String province = safeLower(accommodation.getProvince());
        String district = safeLower(accommodation.getDistrict());
        String ward = safeLower(accommodation.getWard());
        String type = safeLower(accommodation.getType());
        String displayType = safeLower(accommodation.getDisplayType());

        boolean matchAccommodationInfo = name.contains(keyword)
                || address.contains(keyword)
                || fullAddress.contains(keyword)
                || description.contains(keyword)
                || province.contains(keyword)
                || district.contains(keyword)
                || ward.contains(keyword)
                || type.contains(keyword)
                || displayType.contains(keyword);

        if (matchAccommodationInfo) {
            return true;
        }

        if (accommodation.getFacilityList() != null) {
            for (Facility facility : accommodation.getFacilityList()) {
                if (safeLower(facility.getFacilityName()).contains(keyword)) {
                    return true;
                }
            }
        }

        return false;
    }

    private boolean hasRoomForGuests(List<Room> roomList, int guests) {
        if (roomList == null || roomList.isEmpty()) {
            return false;
        }

        for (Room room : roomList) {
            int capacity = room.getMaxAdults() + room.getMaxChildren();

            if (capacity >= guests) {
                return true;
            }
        }

        return false;
    }

    private boolean hasEnoughRoomQuantity(List<Room> roomList, int requestedRooms) {
        if (roomList == null || roomList.isEmpty()) {
            return false;
        }

        for (Room room : roomList) {
            if (room.getRoomAvailability() >= requestedRooms) {
                return true;
            }
        }

        return false;
    }

    private boolean hasRoomPriceAtLeast(List<Room> roomList, BigDecimal minPrice) {
        if (roomList == null || roomList.isEmpty()) {
            return false;
        }

        for (Room room : roomList) {
            if (room.getPriceOfRoom() != null
                    && room.getPriceOfRoom().compareTo(minPrice) >= 0) {
                return true;
            }
        }

        return false;
    }

    private boolean hasRoomPriceAtMost(List<Room> roomList, BigDecimal maxPrice) {
        if (roomList == null || roomList.isEmpty()) {
            return false;
        }

        for (Room room : roomList) {
            if (room.getPriceOfRoom() != null
                    && room.getPriceOfRoom().compareTo(maxPrice) <= 0) {
                return true;
            }
        }

        return false;
    }

    private boolean hasFacilityById(List<Facility> facilityList, int facilityId) {
        if (facilityList == null || facilityList.isEmpty()) {
            return false;
        }

        for (Facility facility : facilityList) {
            if (facility.getFacilityID() == facilityId) {
                return true;
            }
        }

        return false;
    }

    private boolean hasFacilityByName(List<Facility> facilityList, String facilityName) {
        if (facilityList == null || facilityList.isEmpty() || isBlank(facilityName)) {
            return false;
        }

        String selectedName = safeLower(facilityName);

        for (Facility facility : facilityList) {
            if (safeLower(facility.getFacilityName()).contains(selectedName)) {
                return true;
            }
        }

        return false;
    }

    private long calculateNights(String checkIn, String checkOut) {
        try {
            if (isBlank(checkIn) || isBlank(checkOut)) {
                return 1;
            }

            LocalDate inDate = LocalDate.parse(checkIn);
            LocalDate outDate = LocalDate.parse(checkOut);

            long nights = ChronoUnit.DAYS.between(inDate, outDate);

            return nights > 0 ? nights : 1;
        } catch (Exception e) {
            return 1;
        }
    }

    private boolean hasDateRange(String checkIn, String checkOut) {
        if (isBlank(checkIn) || isBlank(checkOut)) {
            return false;
        }

        try {
            LocalDate inDate = LocalDate.parse(checkIn);
            LocalDate outDate = LocalDate.parse(checkOut);
            return outDate.isAfter(inDate);
        } catch (Exception e) {
            return false;
        }
    }

    private Room findSelectedAvailableRoom(int accommodationID, int roomID, String checkIn, String checkOut) {
        List<Room> availableRooms = roomDAO.getAvailableRoomsByAccommodationAndDate(accommodationID, checkIn, checkOut);

        for (Room room : availableRooms) {
            if (room.getRoomID() == roomID) {
                return room;
            }
        }

        return null;
    }

    private BigDecimal calculateTotalPrice(BigDecimal pricePerNight, Integer rooms, long nights) {
        if (pricePerNight == null) {
            return BigDecimal.ZERO;
        }

        int roomQuantity = rooms == null || rooms <= 0 ? 1 : rooms;
        long nightQuantity = nights <= 0 ? 1 : nights;

        return pricePerNight
                .multiply(BigDecimal.valueOf(roomQuantity))
                .multiply(BigDecimal.valueOf(nightQuantity));
    }

    private boolean isValidIdentityNumber(String identityNumber) {
        String normalizedIdentityNumber = normalizeIdentityNumber(identityNumber);
        return normalizedIdentityNumber.matches("^[0-9]{9}$|^[0-9]{12}$");
    }

    private String buildBookingFormUrl(HttpServletRequest request, int accommodationID, int roomID,
                                       String checkIn, String checkOut, int adults, int children, int rooms) {
        return request.getContextPath()
                + "/booking/accommodation/form?accommodationID=" + accommodationID
                + "&roomID=" + roomID
                + "&checkIn=" + checkIn
                + "&checkOut=" + checkOut
                + "&adults=" + adults
                + "&children=" + children
                + "&rooms=" + rooms
                + "&guests=" + (adults + children);
    }

    private String buildRoomDetailUrl(HttpServletRequest request, Integer accommodationID, Integer roomID,
                                      String checkIn, String checkOut,
                                      Integer adults, Integer children, Integer rooms) {
        int safeAccommodationID = accommodationID == null ? 0 : accommodationID;
        int safeRoomID = roomID == null ? 0 : roomID;
        int safeAdults = adults == null ? 0 : adults;
        int safeChildren = children == null ? 0 : children;
        int safeRooms = rooms == null ? 0 : rooms;

        return request.getContextPath()
                + "/accommodation/room/detail?id=" + safeRoomID
                + "&accommodationID=" + safeAccommodationID
                + "&checkIn=" + checkIn
                + "&checkOut=" + checkOut
                + "&adults=" + safeAdults
                + "&children=" + safeChildren
                + "&rooms=" + safeRooms
                + "&guests=" + (safeAdults + safeChildren);
    }

    private String currentPathWithQuery(HttpServletRequest request) {
        String path = request.getServletPath();
        String query = request.getQueryString();
        return query == null || query.isBlank() ? path : path + "?" + query;
    }

    private String stripContextPath(String url, HttpServletRequest request) {
        String contextPath = request.getContextPath();

        if (contextPath != null && !contextPath.isEmpty() && url.startsWith(contextPath)) {
            return url.substring(contextPath.length());
        }

        return url;
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

    private Double parseNonNegativeDouble(String value) {
        try {
            if (value == null || value.trim().isEmpty()) {
                return null;
            }

            double number = Double.parseDouble(value.trim());
            return number >= 0 ? number : null;
        } catch (Exception e) {
            return null;
        }
    }

    private BigDecimal parseNonNegativeBigDecimal(String value) {
        try {
            if (value == null || value.trim().isEmpty()) {
                return null;
            }

            BigDecimal number = new BigDecimal(value.trim());
            return number.compareTo(BigDecimal.ZERO) >= 0 ? number : null;
        } catch (Exception e) {
            return null;
        }
    }

    private String safeLower(String value) {
        return value == null ? "" : value.trim().toLowerCase();
    }

    private String safeTrim(String value) {
        return value == null ? "" : value.trim();
    }

    private String normalizeIdentityNumber(String value) {
        return value == null ? "" : value.replaceAll("[\\s.-]", "").trim();
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    private boolean isValidIdentityImage(Part part) {
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

    private String saveIdentityImage(HttpServletRequest request, Part part, int userID) throws IOException {
        if (!isValidIdentityImage(part)) {
            return null;
        }

        String uploadRoot = getServletContext().getRealPath("/uploads/identity");
        if (uploadRoot == null) {
            return null;
        }

        Path uploadDir = Paths.get(uploadRoot);
        Files.createDirectories(uploadDir);

        String extension = getIdentityImageExtension(part);
        String fileName = "identity_" + userID + "_" + UUID.randomUUID() + extension;
        Path target = uploadDir.resolve(fileName).normalize();

        if (!target.startsWith(uploadDir)) {
            return null;
        }

        part.write(target.toString());
        return "uploads/identity/" + fileName;
    }

    private String getIdentityImageExtension(Part part) {
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

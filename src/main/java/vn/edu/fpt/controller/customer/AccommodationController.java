package vn.edu.fpt.controller.customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import vn.edu.fpt.DAO.AccommodationDAO;
import vn.edu.fpt.DAO.FacilityDAO;
import vn.edu.fpt.DAO.RoomDAO;
import vn.edu.fpt.model.Accommodation;
import vn.edu.fpt.model.Facility;
import vn.edu.fpt.model.Room;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "CustomerAccommodationController", urlPatterns = {
        "/accommodation",
        "/accommodation/detail",
        "/accommodation/room/detail"
})
public class AccommodationController extends HttpServlet {

    private final AccommodationDAO accommodationDAO = new AccommodationDAO();
    private final RoomDAO roomDAO = new RoomDAO();
    private final FacilityDAO facilityDAO = new FacilityDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String path = request.getServletPath();

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
            int serviceID = accommodation.getServiceID();

            /*
             * Hiện tại vẫn dùng hàm cũ getAvailableRoomsByAccommodation(serviceID).
             *
             * Sau này khi nhóm code booking theo ngày, thay dòng này bằng:
             * roomDAO.getAvailableRoomsByAccommodationAndDate(serviceID, checkIn, checkOut, rooms);
             */
            List<Room> availableRooms = roomDAO.getAvailableRoomsByAccommodation(serviceID);

            for (Room room : availableRooms) {
                room.setFacilityList(facilityDAO.getFacilitiesByRoom(room.getRoomID()));
            }

            List<Facility> accommodationFacilities = facilityDAO.getFacilitiesByAccommodation(serviceID);

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

        Integer serviceID = parsePositiveInt(request.getParameter("id"));

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

        if (serviceID == null) {
            response.sendRedirect(request.getContextPath() + "/accommodation");
            return;
        }

        Accommodation accommodation = accommodationDAO.getAccommodationByIdForCustomer(serviceID);

        if (accommodation == null) {
            response.sendRedirect(request.getContextPath() + "/accommodation?status=notFound");
            return;
        }

        /*
         * Hiện tại vẫn lấy room theo accommodation.
         * Sau này khi có bảng booking theo ngày, thay bằng hàm lọc theo checkIn/checkOut.
         */
        List<Room> roomList = roomDAO.getAvailableRoomsByAccommodation(serviceID);

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
        accommodation.setFacilityList(facilityDAO.getFacilitiesByAccommodation(serviceID));

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
        Integer accommodationID = parsePositiveInt(request.getParameter("accommodationId"));

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

        List<Room> roomList = roomDAO.getAvailableRoomsByAccommodation(accommodationID);
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
        request.setAttribute("accommodationId", accommodationID);

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

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}
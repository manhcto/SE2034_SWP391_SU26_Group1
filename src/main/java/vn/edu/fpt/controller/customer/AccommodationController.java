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
import vn.edu.fpt.model.Room;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "CustomerAccommodationController", urlPatterns = {
        "/accommodation",
        "/accommodation/detail"
})
public class AccommodationController extends HttpServlet {

    private final AccommodationDAO accommodationDAO = new AccommodationDAO();
    private final RoomDAO roomDAO = new RoomDAO();
    private final FacilityDAO facilityDAO = new FacilityDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        if ("/accommodation/detail".equals(request.getServletPath())) {
            showAccommodationDetail(request, response);
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
        Integer guests = parsePositiveInt(request.getParameter("guests"));
        Double minRate = parseNonNegativeDouble(request.getParameter("minRate"));
        BigDecimal minPrice = parseNonNegativeBigDecimal(request.getParameter("minPrice"));
        BigDecimal maxPrice = parseNonNegativeBigDecimal(request.getParameter("maxPrice"));

        List<Accommodation> allAccommodations = accommodationDAO.getAvailableAccommodationsForCustomer();
        List<Accommodation> filteredAccommodations = new ArrayList<>();

        for (Accommodation accommodation : allAccommodations) {
            int serviceID = accommodation.getServiceID();

            List<Room> availableRooms = roomDAO.getAvailableRoomsByAccommodation(serviceID);

            for (Room room : availableRooms) {
                room.setFacilityList(facilityDAO.getFacilitiesByRoom(room.getRoomID()));
            }

            accommodation.setRoomList(availableRooms);
            accommodation.setFacilityList(facilityDAO.getFacilitiesByAccommodation(serviceID));

            if (!matchesKeyword(accommodation, keyword)) {
                continue;
            }

            if (!isBlank(province)
                    && !province.equalsIgnoreCase(accommodation.getProvince())) {
                continue;
            }

            if (!isBlank(district)
                    && !safeLower(accommodation.getDistrict()).contains(district.toLowerCase())) {
                continue;
            }

            if (!isBlank(type)
                    && !type.equalsIgnoreCase(accommodation.getType())) {
                continue;
            }

            if (minRate != null && accommodation.getRate() < minRate) {
                continue;
            }

            if (guests != null && !hasRoomForGuests(availableRooms, guests)) {
                continue;
            }

            if (minPrice != null && !hasRoomPriceAtLeast(availableRooms, minPrice)) {
                continue;
            }

            if (maxPrice != null && !hasRoomPriceAtMost(availableRooms, maxPrice)) {
                continue;
            }

            filteredAccommodations.add(accommodation);
        }

        request.setAttribute("accommodationList", filteredAccommodations);

        request.setAttribute("keyword", request.getParameter("keyword"));
        request.setAttribute("selectedProvince", province);
        request.setAttribute("selectedDistrict", district);
        request.setAttribute("selectedType", type);
        request.setAttribute("selectedGuests", guests);
        request.setAttribute("selectedMinRate", request.getParameter("minRate"));
        request.setAttribute("selectedMinPrice", request.getParameter("minPrice"));
        request.setAttribute("selectedMaxPrice", request.getParameter("maxPrice"));

        request.getRequestDispatcher("/views/customer/accommodation-list.jsp")
                .forward(request, response);
    }

    private void showAccommodationDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer serviceID = parsePositiveInt(request.getParameter("id"));

        if (serviceID == null) {
            response.sendRedirect(request.getContextPath() + "/accommodation");
            return;
        }

        Accommodation accommodation = accommodationDAO.getAccommodationByIdForCustomer(serviceID);

        if (accommodation == null) {
            response.sendRedirect(request.getContextPath() + "/accommodation?status=notFound");
            return;
        }

        List<Room> roomList = roomDAO.getAvailableRoomsByAccommodation(serviceID);

        for (Room room : roomList) {
            room.setFacilityList(facilityDAO.getFacilitiesByRoom(room.getRoomID()));
        }

        accommodation.setRoomList(roomList);
        accommodation.setFacilityList(facilityDAO.getFacilitiesByAccommodation(serviceID));

        request.setAttribute("accommodation", accommodation);
        request.setAttribute("roomList", roomList);

        request.getRequestDispatcher("/views/customer/accommodation-detail.jsp")
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

        return name.contains(keyword)
                || address.contains(keyword)
                || fullAddress.contains(keyword)
                || description.contains(keyword)
                || province.contains(keyword)
                || district.contains(keyword)
                || ward.contains(keyword)
                || type.contains(keyword);
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

    private boolean hasRoomPriceAtLeast(List<Room> roomList, BigDecimal minPrice) {
        if (roomList == null || roomList.isEmpty()) {
            return false;
        }

        for (Room room : roomList) {
            if (room.getPriceOfRoom().compareTo(minPrice) >= 0) {
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
            if (room.getPriceOfRoom().compareTo(maxPrice) <= 0) {
                return true;
            }
        }

        return false;
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
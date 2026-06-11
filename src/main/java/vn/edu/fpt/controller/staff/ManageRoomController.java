package vn.edu.fpt.controller.staff;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import vn.edu.fpt.DAO.RoomDAO;
import vn.edu.fpt.model.Facility;
import vn.edu.fpt.model.Room;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "ManageRoomController", urlPatterns = {"/staff/room"})
public class ManageRoomController extends HttpServlet {

    private final RoomDAO roomDAO = new RoomDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            deleteRoom(request, response);
            return;
        }

        response.sendRedirect(
                request.getContextPath() + "/staff/accommodation?action=list"
        );
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        if ("add".equals(action)) {
            addRoom(request, response);
            return;
        }

        if ("update".equals(action)) {
            updateRoom(request, response);
            return;
        }

        response.sendRedirect(
                request.getContextPath() + "/staff/accommodation?action=list"
        );
    }

    private void addRoom(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String serviceIDRaw = request.getParameter("serviceID");
        String roomType = safeTrim(request.getParameter("roomType"));
        String numberOfRoomsRaw = request.getParameter("numberOfRooms");
        String priceRaw = request.getParameter("priceOfRoom");
        String status = safeTrim(request.getParameter("status"));
        String roomAvailabilityRaw = request.getParameter("roomAvailability");

        String image = safeTrim(request.getParameter("image"));
        String description = safeTrim(request.getParameter("description"));
        String bedCountRaw = request.getParameter("bedCount");
        String bedType = safeTrim(request.getParameter("bedType"));
        String maxAdultsRaw = request.getParameter("maxAdults");
        String maxChildrenRaw = request.getParameter("maxChildren");
        String roomSizeRaw = request.getParameter("roomSize");

        List<String> errors = validateRoomInput(
                serviceIDRaw,
                roomType,
                numberOfRoomsRaw,
                priceRaw,
                status,
                roomAvailabilityRaw,
                image,
                description,
                bedCountRaw,
                bedType,
                maxAdultsRaw,
                maxChildrenRaw,
                roomSizeRaw
        );

        Integer serviceID = parsePositiveInt(serviceIDRaw);

        if (!errors.isEmpty()) {
            request.getSession().setAttribute("errors", errors);

            response.sendRedirect(
                    request.getContextPath()
                            + "/staff/accommodation?action=view&id="
                            + safeRedirectID(serviceIDRaw)
                            + "&status=validationFail"
            );
            return;
        }

        Room room = buildRoom(
                0,
                serviceID,
                roomType,
                Integer.parseInt(numberOfRoomsRaw.trim()),
                Double.parseDouble(priceRaw.trim()),
                status,
                Integer.parseInt(roomAvailabilityRaw.trim()),
                image,
                description,
                Integer.parseInt(bedCountRaw.trim()),
                bedType,
                Integer.parseInt(maxAdultsRaw.trim()),
                Integer.parseInt(maxChildrenRaw.trim()),
                Double.parseDouble(roomSizeRaw.trim()),
                parseFacilities(request.getParameterValues("facilityIDs"))
        );

        boolean success = roomDAO.addRoom(room);

        response.sendRedirect(
                request.getContextPath()
                        + "/staff/accommodation?action=view&id="
                        + serviceID
                        + "&status="
                        + (success ? "roomAddSuccess" : "roomAddFail")
        );
    }

    private void updateRoom(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String roomIDRaw = request.getParameter("roomID");
        String serviceIDRaw = request.getParameter("serviceID");
        String roomType = safeTrim(request.getParameter("roomType"));
        String numberOfRoomsRaw = request.getParameter("numberOfRooms");
        String priceRaw = request.getParameter("priceOfRoom");
        String status = safeTrim(request.getParameter("status"));
        String roomAvailabilityRaw = request.getParameter("roomAvailability");

        String image = safeTrim(request.getParameter("image"));
        String description = safeTrim(request.getParameter("description"));
        String bedCountRaw = request.getParameter("bedCount");
        String bedType = safeTrim(request.getParameter("bedType"));
        String maxAdultsRaw = request.getParameter("maxAdults");
        String maxChildrenRaw = request.getParameter("maxChildren");
        String roomSizeRaw = request.getParameter("roomSize");

        List<String> errors = validateRoomInput(
                serviceIDRaw,
                roomType,
                numberOfRoomsRaw,
                priceRaw,
                status,
                roomAvailabilityRaw,
                image,
                description,
                bedCountRaw,
                bedType,
                maxAdultsRaw,
                maxChildrenRaw,
                roomSizeRaw
        );

        Integer roomID = parsePositiveInt(roomIDRaw);
        Integer serviceID = parsePositiveInt(serviceIDRaw);

        if (roomID == null) {
            errors.add("Mã phòng không hợp lệ.");
        }

        if (!errors.isEmpty()) {
            request.getSession().setAttribute("errors", errors);

            response.sendRedirect(
                    request.getContextPath()
                            + "/staff/accommodation?action=view&id="
                            + safeRedirectID(serviceIDRaw)
                            + "&status=validationFail"
            );
            return;
        }

        Room room = buildRoom(
                roomID,
                serviceID,
                roomType,
                Integer.parseInt(numberOfRoomsRaw.trim()),
                Double.parseDouble(priceRaw.trim()),
                status,
                Integer.parseInt(roomAvailabilityRaw.trim()),
                image,
                description,
                Integer.parseInt(bedCountRaw.trim()),
                bedType,
                Integer.parseInt(maxAdultsRaw.trim()),
                Integer.parseInt(maxChildrenRaw.trim()),
                Double.parseDouble(roomSizeRaw.trim()),
                parseFacilities(request.getParameterValues("facilityIDs"))
        );

        boolean success = roomDAO.updateRoom(room);

        response.sendRedirect(
                request.getContextPath()
                        + "/staff/accommodation?action=view&id="
                        + serviceID
                        + "&status="
                        + (success ? "roomUpdateSuccess" : "roomUpdateFail")
        );
    }

    private void deleteRoom(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        Integer roomID = parsePositiveInt(request.getParameter("roomID"));
        Integer serviceID = parsePositiveInt(request.getParameter("serviceID"));

        if (roomID == null || serviceID == null) {
            response.sendRedirect(
                    request.getContextPath()
                            + "/staff/accommodation?action=list&status=roomDeleteFail"
            );
            return;
        }

        boolean success = roomDAO.deleteRoom(roomID);

        response.sendRedirect(
                request.getContextPath()
                        + "/staff/accommodation?action=view&id="
                        + serviceID
                        + "&status="
                        + (success ? "roomDeleteSuccess" : "roomDeleteFail")
        );
    }

    private Room buildRoom(
            int roomID,
            int serviceID,
            String roomType,
            int numberOfRooms,
            double priceOfRoom,
            String status,
            int roomAvailability,
            String image,
            String description,
            int bedCount,
            String bedType,
            int maxAdults,
            int maxChildren,
            double roomSize,
            List<Facility> facilities
    ) {

        Room room = new Room();

        room.setRoomID(roomID);
        room.setServiceID(serviceID);
        room.setRoomType(roomType);
        room.setNumberOfRooms(numberOfRooms);
        room.setPriceOfRoom(priceOfRoom);
        room.setStatus(status);
        room.setRoomAvailability(roomAvailability);
        room.setImage(image);
        room.setDescription(description);
        room.setBedCount(bedCount);
        room.setBedType(bedType);
        room.setMaxAdults(maxAdults);
        room.setMaxChildren(maxChildren);
        room.setRoomSize(roomSize);
        room.setFacilities(facilities);

        return room;
    }

    private List<String> validateRoomInput(
            String serviceIDRaw,
            String roomType,
            String numberOfRoomsRaw,
            String priceRaw,
            String status,
            String roomAvailabilityRaw,
            String image,
            String description,
            String bedCountRaw,
            String bedType,
            String maxAdultsRaw,
            String maxChildrenRaw,
            String roomSizeRaw
    ) {

        List<String> errors = new ArrayList<>();

        if (parsePositiveInt(serviceIDRaw) == null) {
            errors.add("Mã nơi lưu trú không hợp lệ.");
        }

        if (isBlank(roomType) || roomType.length() > 100) {
            errors.add("Loại phòng không hợp lệ.");
        }

        Integer numberOfRooms = parsePositiveInt(numberOfRoomsRaw);

        if (numberOfRooms == null) {
            errors.add("Tổng số phòng phải lớn hơn 0.");
        }

        validatePositiveMoney(priceRaw, "Giá phòng", 1_000_000_000, errors);

        if (!isValidRoomStatus(status)) {
            errors.add("Trạng thái phòng không hợp lệ.");
        }

        Integer roomAvailability = parseNonNegativeInt(roomAvailabilityRaw);

        if (roomAvailability == null) {
            errors.add("Số phòng còn trống phải là số nguyên không âm.");
        } else if (numberOfRooms != null && roomAvailability > numberOfRooms) {
            errors.add("Số phòng còn trống không được lớn hơn tổng số phòng.");
        }

        if (isBlank(image) || !isValidUrl(image)) {
            errors.add("Ảnh phòng phải là URL hợp lệ.");
        }

        if (isBlank(description)) {
            errors.add("Mô tả phòng không được để trống.");
        }

        Integer bedCount = parsePositiveInt(bedCountRaw);

        if (bedCount == null || bedCount > 20) {
            errors.add("Số giường phải từ 1 đến 20.");
        }

        if (isBlank(bedType) || bedType.length() > 100) {
            errors.add("Loại giường không hợp lệ.");
        }

        Integer maxAdults = parsePositiveInt(maxAdultsRaw);

        if (maxAdults == null || maxAdults > 50) {
            errors.add("Số người lớn tối đa phải từ 1 đến 50.");
        }

        Integer maxChildren = parseNonNegativeInt(maxChildrenRaw);

        if (maxChildren == null || maxChildren > 50) {
            errors.add("Số trẻ em tối đa phải từ 0 đến 50.");
        }

        try {
            double roomSize = Double.parseDouble(roomSizeRaw);

            if (roomSize <= 0 || roomSize > 1000) {
                errors.add("Diện tích phòng phải lớn hơn 0 và không vượt quá 1000 m².");
            }

        } catch (Exception e) {
            errors.add("Diện tích phòng phải là số hợp lệ.");
        }

        return errors;
    }

    private List<Facility> parseFacilities(String[] facilityIDValues) {
        List<Facility> facilities = new ArrayList<>();

        if (facilityIDValues == null) {
            return facilities;
        }

        for (String value : facilityIDValues) {
            Integer facilityID = parsePositiveInt(value);

            if (facilityID != null) {
                Facility facility = new Facility();
                facility.setFacilityID(facilityID);

                facilities.add(facility);
            }
        }

        return facilities;
    }

    private boolean isValidRoomStatus(String status) {
        return "Available".equals(status)
                || "Unavailable".equals(status)
                || "Maintenance".equals(status);
    }

    private void validatePositiveMoney(
            String raw,
            String fieldName,
            double maximum,
            List<String> errors
    ) {

        try {
            double value = Double.parseDouble(raw);

            if (value <= 0 || value > maximum) {
                errors.add(fieldName + " phải lớn hơn 0 và không vượt quá " + maximum + ".");
            }

        } catch (Exception e) {
            errors.add(fieldName + " phải là số hợp lệ.");
        }
    }

    private boolean isValidUrl(String value) {
        return value != null && value.matches("^https?://.+");
    }

    private Integer parsePositiveInt(String value) {
        try {
            int number = Integer.parseInt(value);

            return number > 0 ? number : null;

        } catch (Exception e) {
            return null;
        }
    }

    private Integer parseNonNegativeInt(String value) {
        try {
            int number = Integer.parseInt(value);

            return number >= 0 ? number : null;

        } catch (Exception e) {
            return null;
        }
    }

    private String safeRedirectID(String value) {
        Integer id = parsePositiveInt(value);

        return id == null ? "0" : String.valueOf(id);
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    private String safeTrim(String value) {
        return value == null ? "" : value.trim();
    }
}
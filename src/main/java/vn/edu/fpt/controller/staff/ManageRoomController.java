package vn.edu.fpt.controller.staff;

import vn.edu.fpt.DAO.RoomDAO;
import vn.edu.fpt.model.Room;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

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
        String serviceIDRaw = request.getParameter("serviceID");

        if (isBlank(serviceIDRaw)) {
            response.sendRedirect(request.getContextPath()
                    + "/staff/accommodation?action=list&status=missingServiceID");
            return;
        }

        int serviceID = Integer.parseInt(serviceIDRaw);

        if ("delete".equals(action)) {
            String roomIDRaw = request.getParameter("id");

            if (isBlank(roomIDRaw)) {
                response.sendRedirect(request.getContextPath()
                        + "/staff/accommodation?action=view&id=" + serviceID
                        + "&status=missingRoomID");
                return;
            }

            int roomID = Integer.parseInt(roomIDRaw);
            boolean success = roomDAO.deleteRoom(roomID);

            String status = success ? "deleteRoomSuccess" : "deleteRoomFail";

            response.sendRedirect(request.getContextPath()
                    + "/staff/accommodation?action=view&id=" + serviceID
                    + "&status=" + status);
            return;
        }

        response.sendRedirect(request.getContextPath()
                + "/staff/accommodation?action=view&id=" + serviceID);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        String serviceIDRaw = request.getParameter("serviceID");

        if (isBlank(serviceIDRaw)) {
            response.sendRedirect(request.getContextPath()
                    + "/staff/accommodation?action=list&status=missingServiceID");
            return;
        }

        int serviceID = Integer.parseInt(serviceIDRaw);

        if ("add".equals(action)) {
            addRoom(request, response, serviceID);
            return;
        }

        if ("update".equals(action)) {
            updateRoom(request, response, serviceID);
            return;
        }

        response.sendRedirect(request.getContextPath()
                + "/staff/accommodation?action=view&id=" + serviceID);
    }

    private void addRoom(HttpServletRequest request, HttpServletResponse response, int serviceID)
            throws IOException {

        String statusParam = "addRoomFail";

        try {
            String roomType = request.getParameter("roomType");
            String numberOfRoomsRaw = request.getParameter("numberOfRooms");
            String priceOfRoomRaw = request.getParameter("priceOfRoom");
            String status = request.getParameter("status");
            String roomAvailabilityRaw = request.getParameter("roomAvailability");

            List<String> errors = validateRoomInput(
                    roomType,
                    numberOfRoomsRaw,
                    priceOfRoomRaw,
                    status,
                    roomAvailabilityRaw
            );

            if (!errors.isEmpty()) {
                request.getSession().setAttribute("errors", errors);
                response.sendRedirect(request.getContextPath()
                        + "/staff/accommodation?action=view&id=" + serviceID
                        + "&status=validationFail");
                return;
            }

            Room r = new Room();

            r.setRoomType(safeTrim(roomType));
            r.setNumberOfRooms(Integer.parseInt(numberOfRoomsRaw.trim()));
            r.setPriceOfRoom(Double.parseDouble(priceOfRoomRaw.trim()));
            r.setStatus(safeTrim(status));
            r.setRoomAvailability(Integer.parseInt(roomAvailabilityRaw.trim()));
            r.setServiceID(serviceID);

            boolean success = roomDAO.addRoom(r);

            if (success) {
                statusParam = "addRoomSuccess";
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath()
                + "/staff/accommodation?action=view&id=" + serviceID
                + "&status=" + statusParam);
    }

    private void updateRoom(HttpServletRequest request, HttpServletResponse response, int serviceID)
            throws IOException {

        String statusParam = "updateRoomFail";

        try {
            String roomIDRaw = request.getParameter("roomID");
            String roomType = request.getParameter("roomType");
            String numberOfRoomsRaw = request.getParameter("numberOfRooms");
            String priceOfRoomRaw = request.getParameter("priceOfRoom");
            String status = request.getParameter("status");
            String roomAvailabilityRaw = request.getParameter("roomAvailability");

            List<String> errors = validateRoomInput(
                    roomType,
                    numberOfRoomsRaw,
                    priceOfRoomRaw,
                    status,
                    roomAvailabilityRaw
            );

            if (isBlank(roomIDRaw)) {
                errors.add("Thiếu mã phòng cần cập nhật.");
            }

            if (!errors.isEmpty()) {
                request.getSession().setAttribute("errors", errors);
                response.sendRedirect(request.getContextPath()
                        + "/staff/accommodation?action=view&id=" + serviceID
                        + "&status=validationFail");
                return;
            }

            Room r = new Room();

            r.setRoomID(Integer.parseInt(roomIDRaw));
            r.setRoomType(safeTrim(roomType));
            r.setNumberOfRooms(Integer.parseInt(numberOfRoomsRaw.trim()));
            r.setPriceOfRoom(Double.parseDouble(priceOfRoomRaw.trim()));
            r.setStatus(safeTrim(status));
            r.setRoomAvailability(Integer.parseInt(roomAvailabilityRaw.trim()));
            r.setServiceID(serviceID);

            boolean success = roomDAO.updateRoom(r);

            if (success) {
                statusParam = "updateRoomSuccess";
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath()
                + "/staff/accommodation?action=view&id=" + serviceID
                + "&status=" + statusParam);
    }

    private List<String> validateRoomInput(String roomType, String numberOfRoomsRaw,
                                           String priceOfRoomRaw, String status,
                                           String roomAvailabilityRaw) {
        List<String> errors = new ArrayList<>();

        roomType = safeTrim(roomType);
        status = safeTrim(status);

        if (isBlank(roomType)) {
            errors.add("Loại phòng không được để trống.");
        } else if (roomType.length() < 2 || roomType.length() > 100) {
            errors.add("Loại phòng phải từ 2 đến 100 ký tự.");
        }

        Integer numberOfRooms = parseInteger(numberOfRoomsRaw, "Số lượng phòng", errors);
        Integer roomAvailability = parseInteger(roomAvailabilityRaw, "Số phòng còn trống", errors);
        Double priceOfRoom = parseDouble(priceOfRoomRaw, "Giá phòng", errors);

        if (numberOfRooms != null && numberOfRooms <= 0) {
            errors.add("Số lượng phòng phải lớn hơn 0.");
        }

        if (roomAvailability != null && roomAvailability < 0) {
            errors.add("Số phòng còn trống không được nhỏ hơn 0.");
        }

        if (numberOfRooms != null && roomAvailability != null
                && numberOfRooms > 0
                && roomAvailability > numberOfRooms) {
            errors.add("Số phòng còn trống không được lớn hơn tổng số phòng.");
        }

        if (priceOfRoom != null) {
            if (priceOfRoom <= 0) {
                errors.add("Giá phòng phải lớn hơn 0.");
            }

            if (priceOfRoom > 100_000_000) {
                errors.add("Giá phòng không được vượt quá 100,000,000 VND/đêm.");
            }
        }

        if (!isValidStatus(status)) {
            errors.add("Trạng thái phòng không hợp lệ.");
        }

        return errors;
    }

    private Integer parseInteger(String raw, String fieldName, List<String> errors) {
        if (isBlank(raw)) {
            errors.add(fieldName + " không được để trống.");
            return null;
        }

        try {
            return Integer.parseInt(raw.trim());
        } catch (NumberFormatException e) {
            errors.add(fieldName + " phải là số nguyên hợp lệ.");
            return null;
        }
    }

    private Double parseDouble(String raw, String fieldName, List<String> errors) {
        if (isBlank(raw)) {
            errors.add(fieldName + " không được để trống.");
            return null;
        }

        try {
            return Double.parseDouble(raw.trim());
        } catch (NumberFormatException e) {
            errors.add(fieldName + " phải là số hợp lệ.");
            return null;
        }
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
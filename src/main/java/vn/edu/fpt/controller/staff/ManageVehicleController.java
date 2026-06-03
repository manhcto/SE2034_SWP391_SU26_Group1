package vn.edu.fpt.controller.staff;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import vn.edu.fpt.DAO.VehicleDAO;
import vn.edu.fpt.model.Vehicle;
import vn.edu.fpt.model.Service;

@WebServlet(name = "ManageVehicleController", urlPatterns = {"/staff/vehicle"})
public class ManageVehicleController extends HttpServlet {

    private final VehicleDAO vehicleDAO = new VehicleDAO();

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
                listVehicles(request, response);
                break;

            case "delete":
                deleteVehicle(request, response);
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/staff/vehicle?action=list");
                break;
        }
    }

    private void listVehicles(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Vehicle> list = vehicleDAO.getAllVehicles();
        request.setAttribute("vehicleList", list);

        request.getRequestDispatcher("/views/admin/vehicle-management.jsp")
                .forward(request, response);
    }

    private void deleteVehicle(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String statusParam = "deleteFail";

        try {
            String idRaw = request.getParameter("id");

            if (idRaw != null && !idRaw.trim().isEmpty()) {
                int serviceID = Integer.parseInt(idRaw);
                boolean success = vehicleDAO.deleteVehicle(serviceID);

                if (success) {
                    statusParam = "deleteSuccess";
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath()
                + "/staff/vehicle?action=list&status=" + statusParam);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        if ("add".equals(action)) {
            addVehicle(request, response);
            return;
        }

        if ("update".equals(action)) {
            updateVehicle(request, response);
            return;
        }

        response.sendRedirect(request.getContextPath() + "/staff/vehicle?action=list");
    }

    private void addVehicle(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String statusParam = "addFail";

        try {
            String vehicleBrand = request.getParameter("vBrand");
            String licensePlate = request.getParameter("vPlate");
            String priceRaw = request.getParameter("vPrice");
            String vehicleStatus = request.getParameter("vStatus");

            List<String> errors = validateVehicleInput(
                    vehicleBrand,
                    licensePlate,
                    priceRaw,
                    vehicleStatus
            );

            if (!errors.isEmpty()) {
                request.getSession().setAttribute("errors", errors);
                response.sendRedirect(request.getContextPath()
                        + "/staff/vehicle?action=list&status=validationFail");
                return;
            }

            Vehicle v = new Vehicle();

            vehicleBrand = safeTrim(vehicleBrand);
            licensePlate = safeTrim(licensePlate).toUpperCase();
            vehicleStatus = safeTrim(vehicleStatus);

            double pricePerDay = Double.parseDouble(priceRaw.trim());

            v.setVehicleBrand(vehicleBrand);
            v.setLicensePlate(licensePlate);
            v.setPricePerDay(pricePerDay);
            v.setStatus(vehicleStatus);

            Service s = new Service();
            s.setServiceCategoryID(2);
            s.setServiceName(vehicleBrand);
            s.setStatus("Active");
            s.setServiceType("Vehicle");
            s.setFulfillmentType("Rental");

            v.setServiceDetails(s);

            boolean success = vehicleDAO.addVehicle(v);

            if (success) {
                statusParam = "addSuccess";
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath()
                + "/staff/vehicle?action=list&status=" + statusParam);
    }

    private void updateVehicle(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String statusParam = "updateFail";

        try {
            String serviceIDRaw = request.getParameter("serviceID");
            String vehicleBrand = request.getParameter("vBrand");
            String licensePlate = request.getParameter("vPlate");
            String priceRaw = request.getParameter("vPrice");
            String vehicleStatus = request.getParameter("vStatus");

            List<String> errors = validateVehicleInput(
                    vehicleBrand,
                    licensePlate,
                    priceRaw,
                    vehicleStatus
            );

            if (isBlank(serviceIDRaw)) {
                errors.add("Thiếu mã dịch vụ của phương tiện.");
            }

            if (!errors.isEmpty()) {
                request.getSession().setAttribute("errors", errors);
                response.sendRedirect(request.getContextPath()
                        + "/staff/vehicle?action=list&status=validationFail");
                return;
            }

            int serviceID = Integer.parseInt(serviceIDRaw);
            double pricePerDay = Double.parseDouble(priceRaw.trim());

            vehicleBrand = safeTrim(vehicleBrand);
            licensePlate = safeTrim(licensePlate).toUpperCase();
            vehicleStatus = safeTrim(vehicleStatus);

            Vehicle v = new Vehicle();
            v.setServiceID(serviceID);
            v.setVehicleBrand(vehicleBrand);
            v.setLicensePlate(licensePlate);
            v.setPricePerDay(pricePerDay);
            v.setStatus(vehicleStatus);

            Service s = new Service();
            s.setServiceID(serviceID);
            s.setServiceCategoryID(2);
            s.setServiceName(vehicleBrand);
            s.setStatus("Active");
            s.setServiceType("Vehicle");
            s.setFulfillmentType("Rental");

            v.setServiceDetails(s);

            boolean success = vehicleDAO.updateVehicle(v);

            if (success) {
                statusParam = "updateSuccess";
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath()
                + "/staff/vehicle?action=list&status=" + statusParam);
    }

    private List<String> validateVehicleInput(String brand, String plate, String priceRaw, String status) {
        List<String> errors = new ArrayList<>();

        brand = safeTrim(brand);
        plate = safeTrim(plate).toUpperCase();
        status = safeTrim(status);

        if (isBlank(brand)) {
            errors.add("Tên xe không được để trống.");
        } else if (brand.length() < 2 || brand.length() > 255) {
            errors.add("Tên xe phải từ 2 đến 255 ký tự.");
        }

        if (isBlank(plate)) {
            errors.add("Biển số xe không được để trống.");
        } else if (!plate.matches("^[0-9]{2}[A-Z][0-9A-Z]?-[0-9]{4,5}$")) {
            errors.add("Biển số xe không đúng định dạng. Ví dụ hợp lệ: 29F-1892 hoặc 29K1-9123.");
        }

        if (isBlank(priceRaw)) {
            errors.add("Giá thuê xe không được để trống.");
        } else {
            try {
                double price = Double.parseDouble(priceRaw.trim());

                if (price <= 0) {
                    errors.add("Giá thuê xe phải lớn hơn 0.");
                }

                if (price > 100_000_000) {
                    errors.add("Giá thuê xe không được vượt quá 100,000,000 VND/ngày.");
                }

            } catch (NumberFormatException e) {
                errors.add("Giá thuê xe phải là số hợp lệ.");
            }
        }

        if (!isValidStatus(status)) {
            errors.add("Trạng thái xe không hợp lệ.");
        }

        return errors;
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
package vn.edu.fpt.controller.staff;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import vn.edu.fpt.DAO.VehicleBrandDAO;
import vn.edu.fpt.DAO.VehicleDAO;
import vn.edu.fpt.model.Service;
import vn.edu.fpt.model.Vehicle;
import vn.edu.fpt.model.VehicleBrand;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "ManageVehicleController", urlPatterns = {"/staff/vehicle"})
public class ManageVehicleController extends HttpServlet {

    private final VehicleDAO vehicleDAO = new VehicleDAO();
    private final VehicleBrandDAO vehicleBrandDAO = new VehicleBrandDAO();

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
                showVehicleList(request, response);
                break;

            case "delete":
                deleteVehicle(request, response);
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/staff/vehicle?action=list");
                break;
        }
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

    private void showVehicleList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Vehicle> vehicleList = vehicleDAO.getAllVehicles();
        List<VehicleBrand> brandList = vehicleBrandDAO.getActiveBrands();

        request.setAttribute("vehicleList", vehicleList);
        request.setAttribute("brandList", brandList);

        request.getRequestDispatcher("/views/staff/vehicle-management.jsp")
                .forward(request, response);
    }

    private void addVehicle(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        VehicleData data = readVehicleData(request);

        List<String> errors = validateVehicleInput(data, false);

        if (!errors.isEmpty()) {
            request.getSession().setAttribute("errors", errors);
            request.getSession().setAttribute("openModal", "addVehicle");

            response.sendRedirect(request.getContextPath()
                    + "/staff/vehicle?action=list&status=validationFail");
            return;
        }

        Vehicle vehicle = buildVehicle(0, data);

        boolean success = vehicleDAO.addVehicle(vehicle);

        response.sendRedirect(request.getContextPath()
                + "/staff/vehicle?action=list&status="
                + (success ? "addSuccess" : "addFail"));
    }

    private void updateVehicle(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        VehicleData data = readVehicleData(request);

        List<String> errors = validateVehicleInput(data, true);

        Integer serviceID = parsePositiveInt(data.serviceIDRaw);

        if (serviceID == null) {
            errors.add("Mã phương tiện không hợp lệ.");
        }

        if (!errors.isEmpty()) {
            request.getSession().setAttribute("errors", errors);
            request.getSession().setAttribute("openModal", "editVehicle");
            request.getSession().setAttribute("editServiceID", data.serviceIDRaw);

            response.sendRedirect(request.getContextPath()
                    + "/staff/vehicle?action=list&status=validationFail");
            return;
        }

        Vehicle vehicle = buildVehicle(serviceID, data);

        boolean success = vehicleDAO.updateVehicle(vehicle);

        response.sendRedirect(request.getContextPath()
                + "/staff/vehicle?action=list&status="
                + (success ? "updateSuccess" : "updateFail"));
    }

    private void deleteVehicle(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Integer serviceID = parsePositiveInt(request.getParameter("id"));

        if (serviceID == null) {
            response.sendRedirect(request.getContextPath()
                    + "/staff/vehicle?action=list&status=deleteFail");
            return;
        }

        boolean success = vehicleDAO.deleteVehicle(serviceID);

        response.sendRedirect(request.getContextPath()
                + "/staff/vehicle?action=list&status="
                + (success ? "deleteSuccess" : "deleteFail"));
    }

    private VehicleData readVehicleData(HttpServletRequest request) {
        VehicleData data = new VehicleData();

        data.serviceIDRaw = request.getParameter("serviceID");
        data.brandIDRaw = request.getParameter("brandID");
        data.vehicleModel = safeTrim(request.getParameter("vehicleModel"));
        data.licensePlate = safeTrim(request.getParameter("licensePlate")).toUpperCase();
        data.priceRaw = request.getParameter("pricePerDay");
        data.status = safeTrim(request.getParameter("status"));

        data.image = safeTrim(request.getParameter("image"));
        data.seatCountRaw = request.getParameter("seatCount");
        data.vehicleType = safeTrim(request.getParameter("vehicleType"));
        data.transmission = safeTrim(request.getParameter("transmission"));
        data.fuelType = safeTrim(request.getParameter("fuelType"));

        data.pickupProvince = safeTrim(request.getParameter("pickupProvince"));
        data.pickupDistrict = safeTrim(request.getParameter("pickupDistrict"));
        data.pickupWard = safeTrim(request.getParameter("pickupWard"));
        data.pickupAddress = safeTrim(request.getParameter("pickupAddress"));

        data.description = safeTrim(request.getParameter("description"));
        data.usageNotes = safeTrim(request.getParameter("usageNotes"));
        data.depositRaw = request.getParameter("depositAmount");

        return data;
    }

    private Vehicle buildVehicle(int serviceID, VehicleData data) {
        int brandID = Integer.parseInt(data.brandIDRaw.trim());
        double pricePerDay = Double.parseDouble(data.priceRaw.trim());
        int seatCount = Integer.parseInt(data.seatCountRaw.trim());
        double depositAmount = Double.parseDouble(data.depositRaw.trim());

        Vehicle vehicle = new Vehicle();

        vehicle.setServiceID(serviceID);
        vehicle.setBrandID(brandID);
        vehicle.setVehicleModel(data.vehicleModel);
        vehicle.setLicensePlate(data.licensePlate);
        vehicle.setPricePerDay(pricePerDay);
        vehicle.setStatus(data.status);

        vehicle.setImage(data.image);
        vehicle.setSeatCount(seatCount);
        vehicle.setVehicleType(data.vehicleType);
        vehicle.setTransmission(data.transmission);
        vehicle.setFuelType(data.fuelType);

        vehicle.setPickupProvince(data.pickupProvince);
        vehicle.setPickupDistrict(data.pickupDistrict);
        vehicle.setPickupWard(data.pickupWard);
        vehicle.setPickupAddress(data.pickupAddress);

        vehicle.setDescription(data.description);
        vehicle.setUsageNotes(data.usageNotes);
        vehicle.setDepositAmount(depositAmount);

        Service service = new Service();
        service.setServiceID(serviceID);
        service.setServiceCategoryID(2);
        service.setStatus("Active");
        service.setServiceType("Vehicle");
        service.setFulfillmentType("Rental");

        vehicle.setServiceDetails(service);

        return vehicle;
    }

    private List<String> validateVehicleInput(VehicleData data, boolean isUpdate) {
        List<String> errors = new ArrayList<>();

        if (parsePositiveInt(data.brandIDRaw) == null) {
            errors.add("Hãng xe không hợp lệ.");
        }

        if (isBlank(data.vehicleModel)) {
            errors.add("Model xe không được để trống.");
        } else if (data.vehicleModel.length() < 2 || data.vehicleModel.length() > 255) {
            errors.add("Model xe phải từ 2 đến 255 ký tự.");
        }

        if (isBlank(data.licensePlate)) {
            errors.add("Biển số xe không được để trống.");
        } else if (!data.licensePlate.matches("^[0-9]{2}[A-Z][0-9A-Z]?-[0-9]{4,5}$")) {
            errors.add("Biển số xe không đúng định dạng. Ví dụ: 29F-1892 hoặc 29K1-9123.");
        }

        validatePositiveMoney(data.priceRaw, "Giá thuê xe", 100_000_000, errors);

        if (!isValidVehicleStatus(data.status)) {
            errors.add("Trạng thái xe không hợp lệ.");
        }

        if (isBlank(data.image)) {
            errors.add("Ảnh xe không được để trống.");
        } else if (!isValidUrl(data.image)) {
            errors.add("Ảnh xe phải là URL bắt đầu bằng http:// hoặc https://.");
        } else if (data.image.length() > 500) {
            errors.add("Link ảnh xe không được vượt quá 500 ký tự.");
        }

        Integer seatCount = parsePositiveInt(data.seatCountRaw);

        if (seatCount == null) {
            errors.add("Số chỗ ngồi phải là số nguyên lớn hơn 0.");
        } else if (!isValidSeatCountByVehicleType(data.vehicleType, seatCount)) {
            errors.add(getSeatCountErrorMessage(data.vehicleType));
        }

        if (isBlank(data.vehicleType) || data.vehicleType.length() > 50) {
            errors.add("Loại xe không hợp lệ.");
        }

        if (isBlank(data.transmission) || data.transmission.length() > 50) {
            errors.add("Hộp số không hợp lệ.");
        }

        if (isBlank(data.fuelType) || data.fuelType.length() > 50) {
            errors.add("Loại nhiên liệu không hợp lệ.");
        }

        if (isBlank(data.pickupProvince) || data.pickupProvince.length() > 100) {
            errors.add("Tỉnh/thành nhận xe không hợp lệ.");
        }

        if (isBlank(data.pickupDistrict) || data.pickupDistrict.length() > 100) {
            errors.add("Quận/huyện nhận xe không hợp lệ.");
        }

        if (data.pickupWard.length() > 100) {
            errors.add("Phường/xã nhận xe không được vượt quá 100 ký tự.");
        }

        if (isBlank(data.pickupAddress) || data.pickupAddress.length() < 5 || data.pickupAddress.length() > 255) {
            errors.add("Địa chỉ nhận xe phải từ 5 đến 255 ký tự.");
        }

        if (isBlank(data.description) || data.description.length() < 10) {
            errors.add("Mô tả xe phải có ít nhất 10 ký tự.");
        }

        if (isBlank(data.usageNotes) || data.usageNotes.length() < 10) {
            errors.add("Lưu ý sử dụng xe phải có ít nhất 10 ký tự.");
        }

        validateNonNegativeMoney(data.depositRaw, "Tiền đặt cọc", 1_000_000_000, errors);

        return errors;
    }

    private boolean isValidSeatCountByVehicleType(String vehicleType, int seatCount) {
        if ("Motorbike".equals(vehicleType)) {
            return seatCount >= 1 && seatCount <= 2;
        }

        if ("Sedan".equals(vehicleType)) {
            return seatCount >= 4 && seatCount <= 5;
        }

        if ("SUV".equals(vehicleType)) {
            return seatCount >= 5 && seatCount <= 8;
        }

        if ("Luxury Sedan".equals(vehicleType)) {
            return seatCount >= 4 && seatCount <= 5;
        }

        if ("Bus".equals(vehicleType)) {
            return seatCount >= 16 && seatCount <= 60;
        }

        if ("Limousine".equals(vehicleType)) {
            return seatCount >= 9 && seatCount <= 16;
        }

        return false;
    }

    private String getSeatCountErrorMessage(String vehicleType) {
        if ("Motorbike".equals(vehicleType)) {
            return "Xe máy chỉ được nhập từ 1 đến 2 chỗ.";
        }

        if ("Sedan".equals(vehicleType)) {
            return "Xe Sedan chỉ được nhập từ 4 đến 5 chỗ.";
        }

        if ("SUV".equals(vehicleType)) {
            return "Xe SUV chỉ được nhập từ 5 đến 8 chỗ.";
        }

        if ("Luxury Sedan".equals(vehicleType)) {
            return "Xe Luxury Sedan chỉ được nhập từ 4 đến 5 chỗ.";
        }

        if ("Bus".equals(vehicleType)) {
            return "Xe Bus chỉ được nhập từ 16 đến 60 chỗ.";
        }

        if ("Limousine".equals(vehicleType)) {
            return "Xe Limousine chỉ được nhập từ 9 đến 16 chỗ.";
        }

        return "Số chỗ ngồi không phù hợp với loại xe.";
    }

    private boolean isValidVehicleStatus(String status) {
        return "Available".equals(status)
                || "Rented".equals(status)
                || "Unavailable".equals(status)
                || "Maintenance".equals(status);
    }

    private void validatePositiveMoney(String raw, String fieldName, double maximum, List<String> errors) {
        try {
            double value = Double.parseDouble(raw);

            if (value <= 0 || value > maximum) {
                errors.add(fieldName + " phải lớn hơn 0 và không vượt quá " + maximum + ".");
            }

        } catch (Exception e) {
            errors.add(fieldName + " phải là số hợp lệ.");
        }
    }

    private void validateNonNegativeMoney(String raw, String fieldName, double maximum, List<String> errors) {
        try {
            double value = Double.parseDouble(raw);

            if (value < 0 || value > maximum) {
                errors.add(fieldName + " không được âm và khô ng vượt quá " + maximum + ".");
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

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    private String safeTrim(String value) {
        return value == null ? "" : value.trim();
    }

    private static class VehicleData {
        String serviceIDRaw;
        String brandIDRaw;
        String vehicleModel;
        String licensePlate;
        String priceRaw;
        String status;
        String image;
        String seatCountRaw;
        String vehicleType;
        String transmission;
        String fuelType;
        String pickupProvince;
        String pickupDistrict;
        String pickupWard;
        String pickupAddress;
        String description;
        String usageNotes;
        String depositRaw;
    }
}

package vn.edu.fpt.controller.customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import vn.edu.fpt.DAO.VehicleBrandDAO;
import vn.edu.fpt.DAO.VehicleDAO;
import vn.edu.fpt.model.Vehicle;
import vn.edu.fpt.model.VehicleBrand;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "CustomerVehicleController", urlPatterns = {
        "/vehicle",
        "/vehicle/detail"
})
public class VehicleController extends HttpServlet {

    private final VehicleDAO vehicleDAO = new VehicleDAO();
    private final VehicleBrandDAO vehicleBrandDAO = new VehicleBrandDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        if ("/vehicle/detail".equals(request.getServletPath())) {
            showVehicleDetail(request, response);
            return;
        }

        showVehicleList(request, response);
    }

    private void showVehicleList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = safeLower(request.getParameter("keyword"));
        String province = safeTrim(request.getParameter("province"));
        String district = safeTrim(request.getParameter("district"));
        Integer brandID = parsePositiveInt(request.getParameter("brandID"));
        String vehicleType = safeTrim(request.getParameter("vehicleType"));
        Integer seatCount = parsePositiveInt(request.getParameter("seatCount"));
        String transmission = safeTrim(request.getParameter("transmission"));
        String fuelType = safeTrim(request.getParameter("fuelType"));
        Double minPrice = parseNonNegativeDouble(request.getParameter("minPrice"));
        Double maxPrice = parseNonNegativeDouble(request.getParameter("maxPrice"));

        List<Vehicle> allVehicles = vehicleDAO.getAvailableVehiclesForCustomer();
        List<Vehicle> filteredVehicles = new ArrayList<>();

        for (Vehicle vehicle : allVehicles) {
            if (!matchesKeyword(vehicle, keyword)) {
                continue;
            }

            if (!isBlank(province)
                    && !province.equalsIgnoreCase(vehicle.getPickupProvince())) {
                continue;
            }

            if (!isBlank(district)
                    && !safeLower(vehicle.getPickupDistrict()).contains(district.toLowerCase())) {
                continue;
            }

            if (brandID != null && brandID != vehicle.getBrandID()) {
                continue;
            }

            if (!isBlank(vehicleType)
                    && !vehicleType.equalsIgnoreCase(vehicle.getVehicleType())) {
                continue;
            }

            if (seatCount != null && vehicle.getSeatCount() < seatCount) {
                continue;
            }

            if (!isBlank(transmission)
                    && !transmission.equalsIgnoreCase(vehicle.getTransmission())) {
                continue;
            }

            if (!isBlank(fuelType)
                    && !fuelType.equalsIgnoreCase(vehicle.getFuelType())) {
                continue;
            }

            if (minPrice != null && vehicle.getPricePerDay() < minPrice) {
                continue;
            }

            if (maxPrice != null && vehicle.getPricePerDay() > maxPrice) {
                continue;
            }

            filteredVehicles.add(vehicle);
        }

        List<VehicleBrand> brandList = vehicleBrandDAO.getActiveBrands();

        request.setAttribute("vehicleList", filteredVehicles);
        request.setAttribute("brandList", brandList);

        request.setAttribute("keyword", request.getParameter("keyword"));
        request.setAttribute("selectedProvince", province);
        request.setAttribute("selectedDistrict", district);
        request.setAttribute("selectedBrandID", brandID);
        request.setAttribute("selectedVehicleType", vehicleType);
        request.setAttribute("selectedSeatCount", seatCount);
        request.setAttribute("selectedTransmission", transmission);
        request.setAttribute("selectedFuelType", fuelType);
        request.setAttribute("selectedMinPrice", request.getParameter("minPrice"));
        request.setAttribute("selectedMaxPrice", request.getParameter("maxPrice"));

        request.getRequestDispatcher("/views/customer/vehicle-list.jsp")
                .forward(request, response);
    }

    private void showVehicleDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer serviceID = parsePositiveInt(request.getParameter("id"));

        if (serviceID == null) {
            response.sendRedirect(request.getContextPath() + "/vehicle");
            return;
        }

        Vehicle vehicle = vehicleDAO.getVehicleByIdForCustomer(serviceID);

        if (vehicle == null) {
            response.sendRedirect(request.getContextPath() + "/vehicle?status=notFound");
            return;
        }

        request.setAttribute("vehicle", vehicle);

        request.getRequestDispatcher("/views/customer/vehicle-detail.jsp")
                .forward(request, response);
    }

    private boolean matchesKeyword(Vehicle vehicle, String keyword) {
        if (isBlank(keyword)) {
            return true;
        }

        String displayName = safeLower(vehicle.getDisplayName());
        String model = safeLower(vehicle.getVehicleModel());
        String plate = safeLower(vehicle.getLicensePlate());
        String type = safeLower(vehicle.getVehicleType());
        String province = safeLower(vehicle.getPickupProvince());
        String district = safeLower(vehicle.getPickupDistrict());
        String address = safeLower(vehicle.getPickupAddress());

        return displayName.contains(keyword)
                || model.contains(keyword)
                || plate.contains(keyword)
                || type.contains(keyword)
                || province.contains(keyword)
                || district.contains(keyword)
                || address.contains(keyword);
    }

    private Integer parsePositiveInt(String value) {
        try {
            int number = Integer.parseInt(value);
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
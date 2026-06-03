package vn.edu.fpt.controller.customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.fpt.DAO.VehicleDAO;
import vn.edu.fpt.model.Vehicle;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "CustomerVehicleController", urlPatterns = {"/vehicle", "/vehicle/detail"})
public class VehicleController extends HttpServlet {

    private final VehicleDAO vehicleDAO = new VehicleDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String servletPath = request.getServletPath();

        if ("/vehicle/detail".equals(servletPath)) {
            showDetail(request, response);
        } else {
            showList(request, response);
        }
    }

    private void showList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("keyword");
        String type = request.getParameter("type");

        List<Vehicle> allList = vehicleDAO.getAvailableVehiclesForCustomer();
        List<Vehicle> filteredList = new ArrayList<>();

        for (Vehicle v : allList) {
            boolean matchKeyword = true;
            boolean matchType = true;

            if (keyword != null && !keyword.trim().isEmpty()) {
                String key = keyword.trim().toLowerCase();

                String brand = v.getVehicleBrand() == null ? "" : v.getVehicleBrand().toLowerCase();
                String plate = v.getLicensePlate() == null ? "" : v.getLicensePlate().toLowerCase();
                String vehicleType = v.getVehicleType() == null ? "" : v.getVehicleType().toLowerCase();
                String transmission = v.getTransmission() == null ? "" : v.getTransmission().toLowerCase();
                String fuelType = v.getFuelType() == null ? "" : v.getFuelType().toLowerCase();

                matchKeyword = brand.contains(key)
                        || plate.contains(key)
                        || vehicleType.contains(key)
                        || transmission.contains(key)
                        || fuelType.contains(key);
            }

            if (type != null && !type.trim().isEmpty() && !"all".equalsIgnoreCase(type)) {
                matchType = type.equalsIgnoreCase(v.getVehicleType());
            }

            if (matchKeyword && matchType) {
                filteredList.add(v);
            }
        }

        request.setAttribute("vehicleList", filteredList);
        request.setAttribute("keyword", keyword);
        request.setAttribute("selectedType", type);

        request.getRequestDispatcher("/views/customer/vehicle-list.jsp")
                .forward(request, response);
    }

    private void showDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idRaw = request.getParameter("id");

        if (idRaw == null || idRaw.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/vehicle");
            return;
        }

        try {
            int serviceID = Integer.parseInt(idRaw);

            Vehicle vehicle = vehicleDAO.getVehicleByIdForCustomer(serviceID);

            if (vehicle == null) {
                response.sendRedirect(request.getContextPath() + "/vehicle");
                return;
            }

            request.setAttribute("vehicle", vehicle);

            request.getRequestDispatcher("/views/customer/vehicle-detail.jsp")
                    .forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/vehicle");
        }
    }
}
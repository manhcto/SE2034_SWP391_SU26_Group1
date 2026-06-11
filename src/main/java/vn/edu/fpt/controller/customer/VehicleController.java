package vn.edu.fpt.controller.customer;

import vn.edu.fpt.DAO.VehicleDAO;
import vn.edu.fpt.model.Vehicle;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

// Đặt tên servlet độc nhất, chịu trách nhiệm đón đường dẫn /vehicles của Khách hàng
@WebServlet(name = "CustomerVehicleController", urlPatterns = {"/vehicles", "/vehicle-detail"})
public class VehicleController extends HttpServlet { // Đổi lại tên Class này cho trùng với tên file .java thực tế của bạn nếu cần

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String servletPath = request.getServletPath();
        VehicleDAO dao = new VehicleDAO();

        // 1. Xem danh sách xe phía khách hàng
        if (servletPath.equals("/vehicles")) {
            List<Vehicle> list = dao.getAllVehicles();
            request.setAttribute("vehicleList", list);
            request.getRequestDispatcher("/views/customer/vehicle-rent.jsp").forward(request, response);
        }
        // 2. Xem chi tiết 1 chiếc xe
        else if (servletPath.equals("/vehicle-detail")) {
            String idParam = request.getParameter("id");
            if (idParam != null && !idParam.isEmpty()) {
                int id = Integer.parseInt(idParam);
                Vehicle vehicle = dao.getVehicleById(id);
                request.setAttribute("vehicle", vehicle);
            }
            request.getRequestDispatcher("/views/customer/vehicle-detail.jsp").forward(request, response);
        }
    }
}
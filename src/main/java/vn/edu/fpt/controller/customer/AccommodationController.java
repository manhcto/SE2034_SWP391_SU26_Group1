package vn.edu.fpt.controller.customer;

import vn.edu.fpt.DAO.AccommodationDAO;
import vn.edu.fpt.model.Accommodation;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

// Đặt name độc nhất để tránh trùng cấu hình servlet với file quản lý bên staff
@WebServlet(name = "CustomerAccommodationController", urlPatterns = {"/accommodations", "/accommodation-detail"})
public class AccommodationController extends HttpServlet { // GIỮ NGUYÊN TÊN CLASS CỦA BẠN

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String servletPath = request.getServletPath();
        AccommodationDAO dao = new AccommodationDAO();

        // 1. Luồng xem danh sách khách sạn phía Khách hàng
        if (servletPath.equals("/accommodations")) {
            List<Accommodation> list = dao.getAllAccommodations();
            request.setAttribute("accommodationList", list);
            request.getRequestDispatcher("/views/customer/accommodation-list.jsp").forward(request, response);
        }
        // 2. Luồng xem chi tiết một khách sạn
        else if (servletPath.equals("/accommodation-detail")) {
            String idParam = request.getParameter("id");
            if (idParam != null && !idParam.isEmpty()) {
                int id = Integer.parseInt(idParam);
                Accommodation acc = dao.getAccommodationById(id);
                request.setAttribute("accommodation", acc);
            }
            request.getRequestDispatcher("/views/customer/accommodation-detail.jsp").forward(request, response);
        }
    }
}
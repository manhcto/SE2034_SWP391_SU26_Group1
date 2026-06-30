package vn.edu.fpt.controller.customer; 

import vn.edu.fpt.DAO.ExternalTicketDAO;
import vn.edu.fpt.model.ExternalTicket;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

// Đường dẫn dành cho Khách hàng (Thường không có chữ /staff)
@WebServlet("/external-ticket")
public class ExternalTicketController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. Lấy từ khóa tìm kiếm
        String search = request.getParameter("search");
        if (search == null) {
            search = "";
        }

        // 2. Lấy số trang hiện tại
        String pageStr = request.getParameter("page");
        int pageIndex = 1;
        if (pageStr != null && !pageStr.isEmpty()) {
            pageIndex = Integer.parseInt(pageStr);
        }

        // 3. Gọi DAO
        ExternalTicketDAO dao = new ExternalTicketDAO();
        List<ExternalTicket> list = dao.getTicketsForCustomer(search, pageIndex);

        // 4. Tính toán tổng số trang
        int totalTickets = dao.countTotalTicketsForCustomer(search);
        int maxPage = totalTickets / 9; // Mỗi trang 9 sản phẩm
        if (totalTickets % 9 != 0) {
            maxPage++;
        }

        // 5. Đẩy dữ liệu sang JSP
        request.setAttribute("TICKET_LIST", list);
        request.setAttribute("maxPage", maxPage);
        request.setAttribute("currentPage", pageIndex);
        request.setAttribute("searchKeyword", search);

        // Chuyển hướng sang giao diện hiển thị của Khách hàng
        request.getRequestDispatcher("/views/customer/external-ticket.jsp").forward(request, response);
    }
}
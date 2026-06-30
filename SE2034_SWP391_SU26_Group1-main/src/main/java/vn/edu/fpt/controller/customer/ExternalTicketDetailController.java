package vn.edu.fpt.controller.customer;

import vn.edu.fpt.DAO.ExternalTicketDAO;
import vn.edu.fpt.model.ExternalTicket;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

// Mapping đúng với URL mà bạn thấy trên trình duyệt
@WebServlet("/external-ticket-detail")
public class ExternalTicketDetailController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Lấy ID từ trên thanh URL
            String idStr = request.getParameter("id");
            if (idStr == null || idStr.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/external-ticket");
                return;
            }

            int ticketId = Integer.parseInt(idStr);

            // Gọi DAO (Tận dụng luôn hàm getExternalTicketById đã viết cho màn hình Edit của Staff)
            ExternalTicketDAO dao = new ExternalTicketDAO();
            ExternalTicket ticket = dao.getExternalTicketById(ticketId);

            if (ticket == null) {
                response.sendRedirect(request.getContextPath() + "/external-ticket");
                return;
            }

            // Đẩy dữ liệu vé sang trang JSP
            request.setAttribute("ticket", ticket);
            request.getRequestDispatcher("/views/customer/external-ticket-detail.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/external-ticket");
        }
    }
}
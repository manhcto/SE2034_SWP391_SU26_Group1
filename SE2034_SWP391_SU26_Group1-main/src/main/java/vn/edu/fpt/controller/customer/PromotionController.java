package vn.edu.fpt.controller.customer; // Đổi lại package cho đúng

import vn.edu.fpt.DAO.VoucherDAO;
import vn.edu.fpt.model.Voucher;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/promotions")
public class PromotionController extends HttpServlet {
    private VoucherDAO voucherDAO;

    @Override
    public void init() {
        voucherDAO = new VoucherDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. Kéo toàn bộ danh sách Voucher từ Database (Dữ liệu do Admin nhập)
        List<Voucher> list = voucherDAO.getAllVouchers();

        // 2. Gắn vào request để gửi sang giao diện
        request.setAttribute("VOUCHER_LIST", list);

        // 3. Chuyển hướng sang file JSP của User
        request.getRequestDispatcher("/views/customer/vouchers-user.jsp").forward(request, response);
    }
}